//
//  LocalizationManager.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 18/8/25.
//

import Foundation

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    @Published var currentLanguage: String
    /// Các ngôn ngữ app hỗ trợ
    ///
    let supportedLanguages = ["en", "vi"]
    
    private init() {
        let saved = UserDefaults.standard.string(forKey: "app_language")
        // Nếu system language không nằm trong supported → fallback về "en"
        let system = Locale.preferredLanguages.first?.prefix(2).description ?? "en"
        self.currentLanguage = saved ?? (supportedLanguages.contains(system) ? system : "en")
    }
    
    var bundle: Bundle? {
        if let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
            return Bundle(path: path)
        }
        AppLogger.error("Localization bundle not found for language=\(currentLanguage), fallback to en", category: .general)
        return nil
    }
    
    func localizedString(for key: String) -> String {
        if let bundle = bundle {
            return bundle.localizedString(forKey: key, value: nil, table: nil)
        }
        if let path = Bundle.main.path(forResource: "en", ofType: "lproj"),
           let englishBundle = Bundle(path: path) {
            return englishBundle.localizedString(forKey: key, value: nil, table: nil)
        }
        AppLogger.error("Localization failed: key=\(key) not found in any bundle", category: .general)
        return key
    }
    
    func setLanguage(_ language: String) {
        guard supportedLanguages.contains(language) else {
            AppLogger.error("Unsupported language=\(language)", category: .general)
            return
        }
        guard currentLanguage != language else { return }
        
        currentLanguage = language
        UserDefaults.standard.set(language, forKey: "app_language")
        UserDefaults.standard.synchronize()
    }
}

extension String {
    var localized: String {
        LocalizationManager.shared.localizedString(for: self)
    }
}



