//
//  APIResponse.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 7/9/25.
//

import Foundation

/// Empty payload type for APIs that only return status + message
struct EmptyPayload: Decodable {}

/// Generic API response wrapper
struct APIResponse<T: Decodable>: Decodable {
    let code: Int
    let message: String?
    let payload: T?
    
    enum CodingKeys: String, CodingKey {
        case code = "status"   // server trả về key "status" → map vào code
        case message
        case payload
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // decode code (status)
        self.code = try container.decodeInt(forKey: .code)
        
        // decode message an toàn
        self.message = try? container.decode(String.self, forKey: .message)
        
        // decode payload an toàn
        self.payload = try? container.decode(T.self, forKey: .payload)
    }
}
