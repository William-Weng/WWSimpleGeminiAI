//
//  Constant.swift
//  WWSimpleGemini
//
//  Created by William.Weng on 2024/2/29.
//

import UIKit

// MARK: - enum
public extension WWSimpleGeminiAI {
    
    /// API功能
    enum API {
        
        case chat           // 聊天問答
        case vision         // 圖片辨識功能
        
        /// 取得url
        /// - Returns: String
        func value() -> String {
            
            let model: String
            
            switch self {
            case .chat: model = "\(WWSimpleGeminiAI.model.value()):generateContent"
            case .vision: model = "\(WWSimpleGeminiAI.model.value())-vision:generateContent"
            }
            
            return "\(WWSimpleGeminiAI.baseURL)/\(WWSimpleGeminiAI.version.value())/models/\(model)"
        }
    }
    
    /// Gemini模型
    enum Model {
        
        case nano
        case pro
        case ultra
        
        /// 取得模型名稱
        /// - Returns: String
        func value() -> String {
            
            let model: String
            
            switch self {
            case .nano: model = "gemini-nano"
            case .pro: model = "gemini-pro"
            case .ultra: model = "gemini-ultra"
            }
            
            return model
        }
    }
    
    /// Gemini模型版本
    enum Version {
        
        case v1
        
        /// 取得模型版本號
        /// - Returns: String
        func value() -> String {
            
            switch self {
            case .v1: return "v1"
            }
        }
    }
    
    /// Gemini錯誤
    enum GeminiError: Error {
        case error(_ error: [String: Any])
    }
}
