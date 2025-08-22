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
    let supportedLanguages = ["en", "vi"]
    
    private init() {
        let saved = UserDefaults.standard.string(forKey: "app_language")
        let system = Locale.preferredLanguages.first?.prefix(2).description ?? "en"
        
        // Nếu system language không nằm trong supported → fallback về "en"
        self.currentLanguage = saved ?? (supportedLanguages.contains(system) ? system : "en")
    }
    
    var bundle: Bundle? {
        if let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
            return Bundle(path: path)
        }
        return nil
    }
    
    func localizedString(for key: String) -> String {
        if let bundle = bundle {
            return bundle.localizedString(forKey: key, value: nil, table: nil)
        }
        // fallback English
        if let path = Bundle.main.path(forResource: "en", ofType: "lproj"),
           let englishBundle = Bundle(path: path) {
            return englishBundle.localizedString(forKey: key, value: nil, table: nil)
        }
        return key
    }
    
    func setLanguage(_ language: String) {
        guard supportedLanguages.contains(language),
              currentLanguage != language else { return }
        
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
