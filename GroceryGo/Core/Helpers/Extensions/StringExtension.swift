//
//  StringExtensions.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 10/8/25.
//

import Foundation

extension String {

    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
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

