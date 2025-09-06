import os

struct AppLogger {
    private static let subsystem = "com.yourapp"

    enum Category: String {
        case network, auth, ui, database, session, general
    }

    private static func logger(_ category: Category) -> Logger {
        Logger(subsystem: subsystem, category: category.rawValue)
    }

    static func debug(_ message: String, category: Category = .general) {
        #if DEBUG
        logger(category).debug("\(maskSensitiveInfo(message))")
        #endif
    }

    static func info(_ message: String, category: Category = .general) {
        logger(category).info("\(maskSensitiveInfo(message))")
    }

    static func error(_ message: String, category: Category = .general) {
        logger(category).error("\(maskSensitiveInfo(message))")
    }

    static func fault(_ message: String, category: Category = .general) {
        logger(category).fault("\(maskSensitiveInfo(message))")
    }

    private static func maskSensitiveInfo(_ text: String) -> String {
        let sensitiveKeys = ["password", "token", "refresh_token", "client_secret", "apiKey"]
        var masked = text

        for key in sensitiveKeys {
            let regex = "(?i)\(key)=\\S+"
            masked = masked.replacingOccurrences(of: regex, with: "\(key)=***", options: .regularExpression)
        }
        return masked
    }
}
