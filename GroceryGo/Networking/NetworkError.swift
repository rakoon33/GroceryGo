//
//  NetworkError.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 11/8/25.
//

import Foundation

enum NetworkErrorCode {
    static let invalidURL          = -1001
    static let noData               = -1002
    static let decodingError        = -1003
    static let encodingError        = -1004
    static let timeout              = -1005
    static let networkLost          = -1006
    
    static let unauthorized         = 401
    static let forbidden            = 403
    static let notFound             = 404
    static let verificationExpired  = 11000
    
}

enum NetworkErrorType: Error {
    case invalidURL
    case noData
    case decodingError
    case encodingError
    case timeout
    case networkLost
    case unauthorized
    case forbidden
    case notFound
    case verificationExpired
    case serverError(code: Int, message: String, data: Any?)
    
    /// Mã lỗi dạng Int
    var code: Int {
        switch self {
        case .invalidURL: return NetworkErrorCode.invalidURL
        case .noData: return NetworkErrorCode.noData
        case .decodingError: return NetworkErrorCode.decodingError
        case .encodingError: return NetworkErrorCode.encodingError
        case .timeout: return NetworkErrorCode.timeout
        case .networkLost: return NetworkErrorCode.networkLost
        case .unauthorized: return NetworkErrorCode.unauthorized
        case .forbidden: return NetworkErrorCode.forbidden
        case .notFound: return NetworkErrorCode.notFound
        case .verificationExpired: return NetworkErrorCode.verificationExpired
        case .serverError(let code, _, _): return code
        }
    }
    
    /// Key để dùng với Localizable.strings
    var localizationKey: String {
        switch self {
        case .invalidURL: return "invalid_URL"
        case .noData: return "no_data"
        case .decodingError: return "decoding_failed"
        case .encodingError: return "encoding_failed"
        case .timeout: return "timeout"
        case .networkLost: return "network_lost"
        case .unauthorized: return "unauthorized"
        case .forbidden: return "forbidden"
        case .notFound: return "not_found"
        case .serverError: return "server_error"
        case .verificationExpired: return "verification_expired"
        }
    }
    
    // Thông điệp hiển thị lỗi ưu tiên lấy message server trả về, nếu không có thì dùng localizationKey
    var errorMessage: String {
        switch self {
        case .serverError(_, let message, _):
            // Nếu server trả message chi tiết, trả về message đó
            print(message)
            if !message.isEmpty {
                return message
            } else {
                // Không có message thì fallback sang key server_error đã localization
                return NSLocalizedString(localizationKey, comment: "")
            }
        default:
            print(localizationKey)
            // Các lỗi rõ ràng trả về chuỗi localization tương ứng
            return NSLocalizedString(localizationKey, comment: "")
        }
    }
}
