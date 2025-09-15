//
//  LocationManager.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 25/8/25.
//

//LocationManager hỗ trợ cả 2 mode. Một cho continuous tracking (cập nhật liên tục), một cho one-shot request (lấy 1 lần rồi stop)
//Continuous mode (qua @Published) và async/await one-shot mode (requestLocationOnce).

import CoreLocation

final class LocationManager: NSObject, ObservableObject {
    static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    @Published private(set) var currentLocation: CLLocation?
    @Published private(set) var currentPlacemark: CLPlacemark?
    
    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    func startUpdating() {
        manager.startUpdatingLocation()
    }
    
    func stopUpdating() {
        manager.stopUpdatingLocation()
    }
    
    // One-shot async API trả city + country
    func requestCityAndCountryOnce() async throws -> (city: String, country: String) {
        try await withCheckedThrowingContinuation { continuation in
            manager.requestLocation()
            
            self.onPlacemarkReceived = { placemark in
                let city = placemark.locality ?? ""
                let country = placemark.country ?? ""
                
                // ✅ Dừng GPS sau khi đã lấy xong
                self.manager.stopUpdatingLocation()
                
                continuation.resume(returning: (city, country))
            }
            
            self.onError = { error in
                // ✅ Dừng GPS nếu có lỗi
                self.manager.stopUpdatingLocation()
                
                continuation.resume(throwing: error)
            }
        }
    }
    
    // Private callbacks
    private var onPlacemarkReceived: ((CLPlacemark) -> Void)?
    private var onError: ((Error) -> Void)?
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let last = locations.last else { return }
        self.currentLocation = last
        
        CLGeocoder().reverseGeocodeLocation(last) { placemarks, error in
            if let error = error {
                AppLogger.error("Reverse geocode failed: \(error.localizedDescription)", category: .general)
                self.onError?(error)
                self.onError = nil
                return
            }
            
            if let placemark = placemarks?.first {
                self.currentPlacemark = placemark
                self.onPlacemarkReceived?(placemark)
                self.onPlacemarkReceived = nil
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        AppLogger.error("Location update failed: \(error.localizedDescription)", category: .general)
        self.onError?(error)
        self.onError = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied, .restricted:
            AppLogger.error("Location authorization denied/restricted", category: .general)
        default:
            break
        }
    }
}
