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
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    
    func stringDateChangeFormat(format: String, newFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = format
        guard let date = formatter.date(from: self) else {
            return ""
        }
        formatter.dateFormat = newFormat
        return formatter.string(from: date)
    }
}

