//
//  WWSimpleGemini.swift
//  WWSimpleGemini
//
//  Created by William.Weng on 2024/2/29.
//

import UIKit
import WWNetworking

// MARK: - WWSimpleGeminiAI
open class WWSimpleGeminiAI {
    
    public static let shared = WWSimpleGeminiAI()
    
    static let baseURL = "https://generativelanguage.googleapis.com"
    
    static var apiKey = "<Key>"
    static var version: WWSimpleGeminiAI.Version = .v1
    static var model: WWSimpleGeminiAI.Model = .pro
    
    private init() {}
}

// MARK: - 初始值設定 (static function)
public extension WWSimpleGeminiAI {
    
    /// [參數設定](https://blog.jiatool.com/posts/gemini_api/)
    /// - Parameters:
    ///   - apiKey: String
    ///   - version: String
    ///   - model: Gemini模型
    static func configure(apiKey: String, version: WWSimpleGeminiAI.Version = .v1, model: WWSimpleGeminiAI.Model = .pro) {
        self.apiKey = apiKey
        self.version = version
        self.model = model
    }
}

// MARK: - WWSimpleGeminiAI
public extension WWSimpleGeminiAI {
    
    /// [執行聊天功能](https://ai.google.dev/tutorials/rest_quickstart)
    /// - Parameter text: String
    /// - Returns: Result<String?, Error>
    func chat(text: String) async -> Result<String?, Error> {
        
        let api = WWSimpleGeminiAI.API.chat
        let header = authorizationHeaders()
        let json = """
        {
            "contents": [{"parts": [{"text": "\(text)"}]}]
        }
        """
        
        let result = await WWNetworking.shared.request(with: .POST, urlString: api.value(), headers: header, httpBody: json._data())
        
        switch result {
        case .failure(let error): return .failure(error)
        case .success(let info): return parseChatInformation(info)
        }
    }
    
    /// [圖片辨識功能](https://www.toolnb.com/tools-lang-zh-TW/ImageToBase64.html)
    /// - Parameters:
    ///   - text: String
    ///   - image: UIImage?
    ///   - compressionQuality: 圖片壓縮比
    /// - Returns: Result<String?, Error>
    func vision(text: String, image: UIImage?, compressionQuality: CGFloat = 0.7) async -> Result<String?, Error> {
        
        guard let image = image,
              let data = image.jpegData(compressionQuality: compressionQuality)
        else {
            return .success(nil)
        }
        
        let api = WWSimpleGeminiAI.API.vision
        let header = authorizationHeaders()
        let json = """
        {
            "contents": [
                {
                    "parts": [
                        {"text": "\(text)"},
                        {"inline_data": {"mime_type": "image/jpeg","data": "\(data.base64EncodedString())"}}
                    ]
                }
            ]
        }
        """
        
        let result = await WWNetworking.shared.request(with: .POST, urlString: api.value(), headers: header, httpBody: json._data())
        
        switch result {
        case .failure(let error): return .failure(error)
        case .success(let info): return parseChatInformation(info)
        }
    }
    
    /// 串流輸出文字功能
    /// - Parameter text: String
    /// - Returns: Result<[String], Error>
    func stream(text: String) async -> Result<[String], Error> {
        
        let api = WWSimpleGeminiAI.API.stream
        let header = authorizationHeaders()
        let json = """
        {
            "contents": [{"parts": [{"text": "\(text)"}]}]
        }
        """
        
        let result = await WWNetworking.shared.request(with: .POST, urlString: api.value(), headers: header, httpBody: json._data())
        var textArray: [String] = []
        
        switch result {
        case .failure(let error): return .failure(error)
        case .success(let info):
            
            guard let jsonObject = info.data?._jsonObject(),
                  let array = jsonObject as? [Any]
            else {
                return .success(textArray)
            }
            
            textArray = array.compactMap { dict -> String? in
                
                guard let dict = dict as? [String: Any],
                      let text = parseCandidatesText(dict)
                else {
                    return nil
                }
                
                return text
            }
        }
        
        return .success(textArray)
    }
}

// MARK: - 小工具
private extension WWSimpleGeminiAI {
    
    /// 解析回傳JSON文字
    /// - Parameter info: WWNetworking.ResponseInformation
    /// - Returns: Result<String?, Error>
    func parseChatInformation(_ info: WWNetworking.ResponseInformation) -> Result<String?, Error> {
        
        guard let jsonObject = info.data?._jsonObject(),
              let dictionary = jsonObject as? [String: Any]
        else {
            return .success(nil)
        }
        
        if let error = dictionary["error"] as? [String: Any] { return .failure(GeminiError.error(error)) }
        let text = parseCandidatesText(dictionary)
        
        return .success(text)
    }
    
    /// 解析回傳內容
    /// => {"candidates":[{"content":{"parts":[{"text":"天氣輕盈如薄紗，漂浮於河水之上。"}]}}]}
    /// - Parameter dictionary: [String: Any]
    /// - Returns: String?
    func parseCandidatesText(_ dictionary: [String: Any]) -> String? {
        
        guard let candidates = dictionary["candidates"] as? [Any],
              let candidate = candidates.first as? [String : Any],
              let content = candidate["content"] as? [String: Any],
              let parts = content["parts"] as? [Any],
              let part = parts.first as? [String: Any],
              let text = part["text"] as? String
        else {
            return nil
        }

        return text
    }
    
    /// 安全認證Header
    /// - Returns: [String: String?]
    func authorizationHeaders() -> [String: String?] {
        let headers: [String: String?] = ["x-goog-api-key": "\(WWSimpleGeminiAI.apiKey)"]
        return headers
    }
}

