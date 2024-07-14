//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2024/1/1.
//

import UIKit
import WWHUD
import WWSimpleGeminiAI

// MARK: - ViewController
final class ViewController: UIViewController {

    private let apiKey = "<API_Key>"
    
    @IBOutlet weak var myTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
    }
    
    @IBAction func chatAction(_ sender: UIButton) {
        
        let text = "What is Google Gemini?"
        chat(text: text)
    }
    
    @IBAction func visionAction(_ sender: UIButton) {
        
        let text = "Explain in detail what do you see in this image?"
        let image = UIImage(named: "Who")
        
        vision(text: text, image: image)
    }
    
    @IBAction func steamAction(_ sender: UIButton) {
        
        let text = "請寫出一首短詩，有風、雨、太陽"
        steam(text: text)
    }
}

// MARK: - 小工具
private extension ViewController {
    
    /// 初始化設定
    func initSetting() {
        WWSimpleGeminiAI.configure(apiKey: apiKey)
    }
    
    /// 聊天功能
    /// - Parameter text: String
    func chat(text: String) {
        
        WWHUD.shared.display(effect: .default, height: 256)
        
        Task {
            
            let result = await WWSimpleGeminiAI.shared.chat(text: text)
            
            switch result {
            case .failure(let error): myTextView.text = "\(error)"
            case .success(let content): myTextView.text = "\(content ?? "")"
            }
            
            WWHUD.shared.dismiss()
        }
    }
    
    /// 以文字解釋圖片
    /// - Parameters:
    ///   - text: String
    ///   - image: UIImage?
    func vision(text: String, image: UIImage?) {
        
        WWHUD.shared.display(effect: .default, height: 256)

        Task {
            
            let result = await WWSimpleGeminiAI.shared.vision(text: text, image: image)
            
            switch result {
            case .failure(let error): myTextView.text = "\(error)"
            case .success(let content): myTextView.text = "\(content ?? "")"
            }
            
            WWHUD.shared.dismiss()
        }
    }
    
    /// 串流文字
    /// - Parameters:
    ///   - text: String
    func steam(text: String) {
        
        WWHUD.shared.display(effect: .default, height: 256)

        Task {
            
            let result = await WWSimpleGeminiAI.shared.stream(text: text)
            
            switch result {
            case .failure(let error): myTextView.text = "\(error)"
            case .success(let content): myTextView.text = "\(content.joined())"
            }
            
            WWHUD.shared.dismiss()
        }
    }
}
