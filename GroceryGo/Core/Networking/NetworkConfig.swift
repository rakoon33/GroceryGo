import Foundation

struct NetworkConfig {
    static let requestTimeout: TimeInterval = 30
    static let resourceTimeout: TimeInterval = 60
    static let waitsForConnectivity: Bool = true
    static let defaultHeaders: [String: String] = [
        "Accept": "application/json"
    ]
}