//
//  Extension.swift
//  WWSimpleGemini
//
//  Created by William.Weng on 2024/2/29.
//

import UIKit

// MARK: - Data (function)
extension Data {
        
    /// Data => JSON
    /// - 7b2268747470223a2022626f6479227d => {"http": "body"}
    /// - Returns: Any?
    func _jsonObject(options: JSONSerialization.ReadingOptions = .allowFragments) -> Any? {
        let json = try? JSONSerialization.jsonObject(with: self, options: options)
        return json
    }
}
