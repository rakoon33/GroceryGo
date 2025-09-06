import Foundation
import MetricKit

class CrashReporter: NSObject, MXMetricManagerSubscriber {
    static let shared = CrashReporter()
    
    private let webhook = URL(string: "https://discord.com/api/webhooks/XXX/YYY")! // 🔴 thay webhook của bạn
    
    func start() {
        MXMetricManager.shared.add(self)
    }
    
    func didReceive(_ payloads: [MXDiagnosticPayload]) {
        for payload in payloads {
            if let crashes = payload.crashDiagnostics {
                for crash in crashes {
                    let msg = """
                    📊 Crash Report
                    ▸ Exception: \(crash.exceptionType ?? "Unknown")
                    ▸ Reason: \(crash.terminationReason ?? "N/A")
                    ▸ Signal: \(crash.signal ?? "N/A")
                    ▸ Times: \(crash.callStackTree.callStacks.count)
                    """
                    sendToDiscord(message: msg)
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
        
        URLSession.shared.dataTask(with: req).resume()
    }
}
