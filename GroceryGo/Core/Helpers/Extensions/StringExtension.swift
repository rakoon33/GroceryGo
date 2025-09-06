//
//  StringExtensions.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 10/8/25.
//

import Foundation

extension String {
    
    var isValidEmail: Bool {
            let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let range = NSRange(location: 0, length: utf16.count)
            let matches = detector?.matches(in: self, options: [], range: range) ?? []
            return matches.contains { match in
                match.url?.scheme == "mailto" && match.range.length == range.length
            }
        }
    
    func stringDateToDate(format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") -> Date? {
        let dataFormat = DateFormatter()
        dataFormat.dateFormat = format
        return dataFormat.date(from: self)
    }
    
    func stringDateChangeFormat(format: String, newFormat: String ) -> String {
        let dataFormat = DateFormatter()
        dataFormat.dateFormat = format
        if let dt = dataFormat.date(from: self) {
            dataFormat.dateFormat = newFormat
            return dataFormat.string(from: dt)
        }else{
            return ""
        }
    }
    
}

