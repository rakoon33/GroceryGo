//
//  NetworkConfig.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 5/9/25.
//


import Foundation

struct NetworkConfig {
    /// Loại session: default, ephemeral, background… Mặc định là .default.
    /// Nó xác định loại session mà URLSession sẽ dùng.
    /// Có các option sẵn của hệ thống
    /// default → session thông thường, cache, cookie mặc định.
    /// .ephemeral → session tạm thời, không lưu cache hay cookie.
    /// .background → session chạy background, upload/download lâu dài.
    let sessionType: URLSessionConfiguration = .default
    
    // MARK: - Timeouts
    /// Thời gian chờ tối đa cho từng request (request timeout) trước khi bị hủy.
    let requestTimeout: TimeInterval
    
    /// Thời gian tối đa để tải toàn bộ dữ liệu (resource timeout).
    let resourceTimeout: TimeInterval
    
    // MARK: - Connectivity & Caching
    /// Nếu true, session sẽ đợi mạng khả dụng thay vì fail ngay.
    let waitsForConnectivity: Bool
    
    /// Cache policy cho request, ví dụ .useProtocolCachePolicy hay .reloadIgnoringCacheData.
    let cachePolicy: URLRequest.CachePolicy
    
    // MARK: - Headers
    /// Headers mặc định gửi kèm tất cả request (ví dụ Accept, Content-Type).
    let defaultHeaders: [String: String]
    
    // MARK: - Retry
    /// Số lần thử lại request khi thất bại do network tạm thời.
    let retryCount: Int
    
    /// Khoảng cách giữa các lần retry (giây).
    let retryInterval: TimeInterval
    
    // MARK: - Logging
    /// Bật/tắt logging request/response.
    let enableLogging: Bool
    
    // Default config for production
    static let `default` = NetworkConfig(
        requestTimeout: 30,                               // 30 giây cho request
        resourceTimeout: 60,                              // 60 giây cho toàn bộ tải resource
        waitsForConnectivity: true,                       // đợi mạng khả dụng
        cachePolicy: .useProtocolCachePolicy,            // theo mặc định của HTTP protocol
        defaultHeaders: ["Accept": "application/json"],  // header mặc định
        retryCount: 1,                                    // thử lại 1 lần nếu lỗi mạng
        retryInterval: 2,                                 // chờ 2 giây giữa các lần retry
        enableLogging: true                               // bật logging debug
    )
}
