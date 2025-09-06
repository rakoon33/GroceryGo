//
//  DateExtensions.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 10/8/25.
//

import Foundation


extension Date {
    private static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        return formatter
    }()
    
    func displayDate(offsetMinutes: Int = 0) -> String {
        let adjustedDate = addingTimeInterval(TimeInterval(offsetMinutes * 60))
        return Date.displayFormatter.string(from: adjustedDate)
    }
}
