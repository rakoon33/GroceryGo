//
//  NetworkError.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 11/8/25.
//


import Foundation

// MARK: - Success Code
enum APISuccessCode {
    static let success = 1
}

// MARK: - Error Code Constants
struct NetworkErrorCode {
    struct Client {
        static let invalidURL    = -1001
        static let noData        = -1002
        static let decodingError = -1003
        static let encodingError = -1004
        static let timeout       = -1005
        static let noInternet    = -1006
        static let networkLost   = -1007
        
        static let serverUnreachable = -1008   // cannotConnectToHost, cannotFindHost
        static let dnsFailed         = -1009   // dnsLookupFailed
        static let badResponse       = -1010   // badServerResponse
        static let resourceUnavailable = -1011 // resourceUnavailable
        static let cancelled         = -1012   // request bị cancel
    }
    struct HTTP {
        static let unauthorized  = 401
        static let forbidden     = 403
        static let notFound      = 404
    }
    struct Business {
        static let verificationExpired   = 11000
        static let wrongPasswordOrEmail  = 10001
        static let emailAlreadyExists    = 10002
    }
}

// MARK: - Error Type
enum NetworkErrorType: Error {
    // Client
    case invalidURL
    case noData
    case decodingError(message: String? = nil)
    case encodingError
    case timeout
    case noInternet
    case networkLost
    case serverUnreachable
    case dnsFailed
    case badResponse
    case resourceUnavailable
    case cancelled
    
    // HTTP
    case unauthorized
    case forbidden
    case notFound
    
    // Business
    case verificationExpired
    case wrongPasswordOrEmail
    case emailAlreadyExists
    
    // Unknown
    case unknown(code: Int, message: String)
    
    // MARK: - Init mapping
    init(code: Int, message: String = "") {
        switch code {
            // Client
        case NetworkErrorCode.Client.invalidURL:    self = .invalidURL
        case NetworkErrorCode.Client.noData:        self = .noData
        case NetworkErrorCode.Client.decodingError: self = .decodingError(message: message)
        case NetworkErrorCode.Client.encodingError: self = .encodingError
        case NetworkErrorCode.Client.timeout:       self = .timeout
        case NetworkErrorCode.Client.noInternet:    self = .noInternet
        case NetworkErrorCode.Client.networkLost:   self = .networkLost
        case NetworkErrorCode.Client.serverUnreachable:   self = .serverUnreachable
        case NetworkErrorCode.Client.dnsFailed:           self = .dnsFailed
        case NetworkErrorCode.Client.badResponse:         self = .badResponse
        case NetworkErrorCode.Client.resourceUnavailable: self = .resourceUnavailable
        case NetworkErrorCode.Client.cancelled:           self = .cancelled
            
            // HTTP
        case NetworkErrorCode.HTTP.unauthorized:    self = .unauthorized
        case NetworkErrorCode.HTTP.forbidden:       self = .forbidden
        case NetworkErrorCode.HTTP.notFound:        self = .notFound
            
            // Business
        case NetworkErrorCode.Business.verificationExpired:  self = .verificationExpired
        case NetworkErrorCode.Business.wrongPasswordOrEmail: self = .wrongPasswordOrEmail
        case NetworkErrorCode.Business.emailAlreadyExists:   self = .emailAlreadyExists
            
        default: self = .unknown(code: code, message: message)
        }
    }
    
    // MARK: - Code
    var code: Int {
        switch self {
            // Client
        case .invalidURL:       return NetworkErrorCode.Client.invalidURL
        case .noData:           return NetworkErrorCode.Client.noData
        case .decodingError:    return NetworkErrorCode.Client.decodingError
        case .encodingError:    return NetworkErrorCode.Client.encodingError
        case .timeout:          return NetworkErrorCode.Client.timeout
        case .noInternet:       return NetworkErrorCode.Client.noInternet
        case .networkLost:      return NetworkErrorCode.Client.networkLost
        case .serverUnreachable:   return NetworkErrorCode.Client.serverUnreachable
        case .dnsFailed:           return NetworkErrorCode.Client.dnsFailed
        case .badResponse:         return NetworkErrorCode.Client.badResponse
        case .resourceUnavailable: return NetworkErrorCode.Client.resourceUnavailable
        case .cancelled:           return NetworkErrorCode.Client.cancelled
            
            // HTTP
        case .unauthorized:     return NetworkErrorCode.HTTP.unauthorized
        case .forbidden:        return NetworkErrorCode.HTTP.forbidden
        case .notFound:         return NetworkErrorCode.HTTP.notFound
            
            // Business
        case .verificationExpired:   return NetworkErrorCode.Business.verificationExpired
        case .wrongPasswordOrEmail:  return NetworkErrorCode.Business.wrongPasswordOrEmail
        case .emailAlreadyExists:    return NetworkErrorCode.Business.emailAlreadyExists
            
            // Unknown
        case .unknown(let code, _):  return code
        }
    }
    
    // MARK: - Localization key
    var localizationKey: String {
        switch self {
        case .invalidURL:             return "invalid_URL"
        case .noData:                 return "no_data"
        case .decodingError:          return "decoding_failed"
        case .encodingError:          return "encoding_failed"
        case .timeout:                return "timeout"
        case .networkLost:            return "network_lost"
        case .noInternet:             return "no_internet"
        case .serverUnreachable:   return "server_unreachable"
        case .dnsFailed:           return "dns_failed"
        case .badResponse:         return "bad_response"
        case .resourceUnavailable: return "resource_unavailable"
        case .cancelled:           return "cancelled"
        case .unauthorized:           return "unauthorized"
        case .forbidden:              return "forbidden"
        case .notFound:               return "not_found"
        case .verificationExpired:    return "verification_expired"
        case .wrongPasswordOrEmail:   return "wrong_password_or_email"
        case .emailAlreadyExists:     return "email_already_exists"
        case .unknown:                return "unknown_error"
        }
    }
    
    // MARK: - Message
    // Này để hiện lên UI
    var errorMessage: String {
        switch self {
        case .decodingError(let msg):
            return "decoding_failed".localized + (msg?.isEmpty == false ? " – \(msg!)" : "")
        case .unknown(_, let msg):
            return msg.isEmpty ? localizationKey.localized : msg
        default:
            return localizationKey.localized
        }
    }
    
}

// Này để logger bên AppLogger
extension NetworkErrorType: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .decodingError(let msg):
            return "Decoding error" + (msg.map { ": \($0)" } ?? "")
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data"
        case .encodingError:
            return "Encoding error"
        case .timeout:
            return "Request timeout"
        case .noInternet:
            return "No internet connection"
        case .networkLost:
            return "Network connection lost"
        case .serverUnreachable:
            return "Cannot connect to server"
        case .dnsFailed:
            return "DNS lookup failed"
        case .badResponse:
            return "Bad server response"
        case .resourceUnavailable:
            return "Resource unavailable"
        case .cancelled:
            return "Request cancelled"
        case .unauthorized:
            return "Unauthorized"
        case .forbidden:
            return "Forbidden"
        case .notFound:
            return "Not Found"
        case .verificationExpired:
            return "Verification expired"
        case .wrongPasswordOrEmail:
            return "Wrong password or email"
        case .emailAlreadyExists:
            return "Email already exists"
        case .unknown(let code, let msg):
            return "Unknown error (code: \(code)) \(msg)"
        }
    }
}
