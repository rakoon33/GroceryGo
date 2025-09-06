//
//  DecodingError.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 22/8/25.
//

import Foundation

extension DecodingError {
    var detailedMessage: String {
        switch self {
        case .typeMismatch(_, let context):
            return "Type mismatch at \(context.codingPath.map { $0.stringValue }.joined(separator: ".")): \(context.debugDescription)"
        case .valueNotFound(_, let context):
            return "Value not found at \(context.codingPath.map { $0.stringValue }.joined(separator: ".")): \(context.debugDescription)"
        case .keyNotFound(let key, let context):
            return "Key '\(key.stringValue)' not found at \(context.codingPath.map { $0.stringValue }.joined(separator: ".")): \(context.debugDescription)"
        case .dataCorrupted(let context):
            return "Data corrupted at \(context.codingPath.map { $0.stringValue }.joined(separator: ".")): \(context.debugDescription)"
        @unknown default:
            return "Unknown decoding error"
        }
    }
}
