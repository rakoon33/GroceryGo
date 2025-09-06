//
//  CrashReporter.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 6/9/25.
//


import Foundation
import MetricKit
import UIKit

/// CrashReporter chịu trách nhiệm lắng nghe crash từ MXMetricManager
/// và gửi thông tin crash đến webhook (ví dụ Discord).
class CrashReporter: NSObject, MXMetricManagerSubscriber {
    static let shared = CrashReporter()

    private lazy var webhook: URL? = {
        guard let urlString = Secrets.value(for: "DISCORD_WEBHOOK"),
              let url = URL(string: urlString) else {
            AppLogger.error("Missing/invalid DISCORD_WEBHOOK in Secrets.plist", category: .general)
            return nil
        }
        return url
    }()
    
    private override init() {
        super.init()
    }
    
    func start() {
        MXMetricManager.shared.add(self)
        AppLogger.info("CrashReporter started", category: .general)
    }
    
    func didReceive(_ payloads: [MXDiagnosticPayload]) {
        
        guard webhook != nil else { return } // skip if webhook not configured
        
        for payload in payloads {
            if let crashes = payload.crashDiagnostics {
                for crash in crashes {
                    let exceptionType = crash.exceptionType?.stringValue ?? "Unknown"
                    let exceptionCode = crash.exceptionCode?.stringValue ?? "Unknown"
                    let terminationReason = crash.terminationReason ?? "Unknown"
                    
                    // Lấy thông tin app & OS
                    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
                    let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
                    let osVersion = UIDevice.current.systemVersion
                    
                    // Format message để gửi sang Discord
                    let message = """
                    🚨 **App Crash Detected**
                    • Exception Type: \(exceptionType)
                    • Exception Code: \(exceptionCode)
                    • Termination: \(terminationReason)
                    • App Version: \(appVersion) (\(buildNumber))
                    • iOS: \(osVersion)
                    """
                    
                    // Log crash info
                    AppLogger.error("Crash detected:\n\(message)", category: .general)
                    
                    sendToDiscord(message: message)
                }
            }
        }
    }
    
    private func sendToDiscord(message: String) {
        
        guard let webhook = webhook else { return }

        var req = URLRequest(url: webhook)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json = ["content": String(message.prefix(1900))]
        req.httpBody = try? JSONSerialization.data(withJSONObject: json)
        
        // Log before sending
        AppLogger.debug("Sending crash report to Discord: \(message)", category: .network)
        
        URLSession.shared.dataTask(with: req) { data, response, error in
            AppLogger.logResponse(response, data: data, error: error)
        }.resume()
    }
}

extension CrashReporter {
    func testCrashReport() {
        let message = """
        🚨 **Test Crash Report**
        • Exception Type: Test
        • Exception Code: 0
        • Termination: Simulated
        • App Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown")
        • iOS: \(UIDevice.current.systemVersion)
        """
        AppLogger.debug("Sending simulated crash report", category: .general)
        sendToDiscord(message: message)
    }
}

