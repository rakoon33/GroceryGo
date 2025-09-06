//
//  AppLogger.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 5/9/25.
//

import Foundation
import os

// MARK: - LogLevel (ít -> nhiều)
enum LogLevel: Int {
    case none = 0   // Tắt hết
    case error      // Chỉ log lỗi
    case info       // Lỗi + thông tin
    case debug      // Log tất cả (bao gồm network, debug trace)
}

// MARK: - Category
enum LogCategory: String {
    case general
    case network
    case ui
    case database
    case session
}

// MARK: - AppLogger
struct AppLogger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "App"

    // Runtime log level
    static var globalLevel: LogLevel = {
        #if DEBUG
        return .debug
        #else
        return .error
        #endif
    }()

    // Cho phép QA/dev bật verbose log trong Release
    static func configureFromDefaults() {
        if UserDefaults.standard.bool(forKey: "enableVerboseLogging") {
            globalLevel = .debug
        }
    }

    // Kiểm tra mức log hiện tại
    private static func shouldLog(_ level: LogLevel) -> Bool {
        return level.rawValue <= globalLevel.rawValue
    }

    // os.Logger cho từng category
    private static func logger(_ category: LogCategory) -> Logger {
        Logger(subsystem: subsystem, category: category.rawValue)
    }

    // MARK: - Redaction helpers
    private static let sensitiveKeys: Set<String> = [
        "password", "token", "refresh_token", "authorization",
        "client_secret", "apikey"
    ]

    private static func redactAny(_ dict: [String: Any]) -> [String: Any] {
        var masked = dict
        for key in dict.keys where sensitiveKeys.contains(key.lowercased()) {
            masked[key] = "REDACTED"
        }
        return masked
    }

    private static func redactRaw(_ text: String) -> String {
        var output = text
        for key in sensitiveKeys {
            let regex = "(?i)\(key)=\\S+"
            output = output.replacingOccurrences(
                of: regex,
                with: "\(key)=REDACTED",
                options: .regularExpression
            )
        }
        return output
    }

    // MARK: - Logging methods
    static func debug(_ message: String, category: LogCategory = .general, sensitive: Bool = false) {
        guard shouldLog(.debug) else { return }
        if sensitive {
            logger(category).debug("\(message, privacy: .private)")
        } else {
            logger(category).debug("\(message, privacy: .public)")
        }
    }

    static func info(_ message: String, category: LogCategory = .general) {
        guard shouldLog(.info) else { return }
        logger(category).info("\(message, privacy: .public)")
    }

    static func error(_ message: String, category: LogCategory = .general) {
        guard shouldLog(.error) else { return }
        logger(category).error("\(message, privacy: .public)")
    }

    static func fault(_ message: String, category: LogCategory = .general) {
        guard shouldLog(.error) else { return } // fault >= error
        logger(category).fault("\(message, privacy: .public)")
    }

    // MARK: - Network logging
    static func logRequest(_ request: URLRequest, parameters: [String: Any]? = nil) {
        guard shouldLog(.debug) else { return }

        var log = "➡️ REQUEST \(request.httpMethod ?? "nil") \(request.url?.absoluteString ?? "nil")"

        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            log += "\nHeaders: \(redactAny(headers))"
        }
        if let params = parameters {
            log += "\nParameters: \(redactAny(params))"
        }
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            log += "\nBody: \(redactRaw(bodyString))"
        }

        logger(.network).debug("\(log, privacy: .public)")
    }

    static func logResponse(_ response: URLResponse?, data: Data?, error: Error?) {
        guard shouldLog(.debug) else { return }

        var log = "⬅️ RESPONSE"

        if let http = response as? HTTPURLResponse {
            let statusSymbol = (200..<300).contains(http.statusCode) ? "✅" : "❌"
            log += " \(statusSymbol) [\(http.statusCode)] \(http.url?.absoluteString ?? "nil")"
            log += "\nHeaders: \(redactAny(http.allHeaderFields as? [String: Any] ?? [:]))"
        }

        if let error = error {
            log += "\nError: \(error.localizedDescription)"
        }

        if let data = data,
           let bodyString = String(data: data, encoding: .utf8) {
            log += "\nBody: \(redactRaw(bodyString))"
        }

        logger(.network).debug("\(log, privacy: .public)")
    }
}
