//
//  DateExtensions.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 10/8/25.
//

import Foundation

extension Date {
    func displayDate(format: String, addMinTime:  Int = 0) -> String {
        let dataFormat = DateFormatter()
        dataFormat.dateFormat = format
        let date = self.addingTimeInterval(TimeInterval(60 * addMinTime))
        return dataFormat.string(from: date)
    }
}
