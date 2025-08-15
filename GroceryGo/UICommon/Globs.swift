//
//  Globs.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 9/8/25.
//

import SwiftUI

struct Globs {
    static let AppName = "GroceryGo"
    
    static let userPayload = "user_payload"
    static let userLogin = "user_login"
    
    static let BASE_URL = "http://localhost:3001/api/app/"
    
    static let SV_LOGIN = BASE_URL + "login"
    static let SV_SIGN_UP = BASE_URL + "sign_up"
}

struct KKey {
    static let code = "status"
    static let message = "message"
    static let payload = "payload"
}

class Utils {
    class func UDSET(data: Any, key: String) {
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func UDValue(key: String) -> Any {
        return UserDefaults.standard.value(forKey: key) as Any
    }
    
    
    class func UDBool(key: String) -> Any {
        return UserDefaults.standard.value(forKey: key) as? Bool ?? false
    }
    
    class func UDValueBool(key: String) -> Any {
        return UserDefaults.standard.value(forKey: key) as? Bool ?? true
    }
    
    class func UDRemove(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
}
