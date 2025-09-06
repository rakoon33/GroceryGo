//
//  CrashReporter.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 6/9/25.
//


import Foundation
import MetricKit
import UIKit

class CrashReporter: NSObject, MXMetricManagerSubscriber {
    static let shared = CrashReporter()
    
    private let webhook = URL(string: "https://discord.com/api/webhooks/1413889068512579696/R6OejIIPOqzDf6m7txPeq_1IM1us3pSPDV_IQOKMNS_D3hFWpMgsYxyiA8WZIMkn71yT")!
    
    func start() {
        MXMetricManager.shared.add(self)
        AppLogger.info("CrashReporter started")
    }
    
    func didReceive(_ payloads: [MXDiagnosticPayload]) {
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

