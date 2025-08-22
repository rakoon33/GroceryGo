//
//  DateExtensions.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 10/8/25.
//

import Foundation

extension Date {
    func displayDate(format: String, addMinTime: Int = 0, locale: Locale = .current) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = locale
        let adjustedDate = self.addingTimeInterval(TimeInterval(60 * addMinTime))
        return formatter.string(from: adjustedDate)
    }
}
