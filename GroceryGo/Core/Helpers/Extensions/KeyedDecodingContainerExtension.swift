//
//  KeyedDecodingContainer.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 22/8/25.
//

import Foundation

extension KeyedDecodingContainer {
    func decodeInt(forKey key: K) throws -> Int {
        if let intVal = try? decode(Int.self, forKey: key) {
            return intVal
        }
        if let strVal = try? decode(String.self, forKey: key),
           let intVal = Int(strVal) {
            return intVal
        }
        
        throw DecodingError.dataCorruptedError(
            forKey: key,
            in: self,
            debugDescription: "Expected Int or String convertible to Int"
        )
    }
    
    func decodeDouble(forKey key: K) throws -> Double {
        if let dbl = try? decode(Double.self, forKey: key) {
            return dbl
        }
        if let str = try? decode(String.self, forKey: key),
           let dbl = Double(str) {
            return dbl
        }
        
        throw DecodingError.dataCorruptedError(
            forKey: key,
            in: self,
            debugDescription: "Expected Double or String convertible to Double"
        )
    }
    
    func decodeString(forKey key: K) throws -> String {
        if let str = try? decode(String.self, forKey: key) {
            return str
        }
        
        throw DecodingError.dataCorruptedError(
            forKey: key,
            in: self,
            debugDescription: "Expected String value"
        )
    }
    
    func decodeDate(forKey key: K, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") throws -> Date {
        let str = try decode(String.self, forKey: key)
        if let date = str.stringDateToDate(format: format) {
            return date
        }
        
        throw DecodingError.dataCorruptedError(
            forKey: key,
            in: self,
            debugDescription: "Date string does not match format \(format)"
        )
    }
}
