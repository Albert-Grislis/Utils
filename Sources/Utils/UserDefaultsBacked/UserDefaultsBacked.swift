//
//  UserDefaultsBacked.swift
//  
//
//  Created by Albert Grislis on 13.02.2021.
//

import Foundation

@propertyWrapper
public class UserDefaultsBacked<Type> {
    
    public var wrappedValue: Type {
        get {
            let value: Type? = userDefaults.value(forKey: key) as? Type
            return value ?? defaultValue
        } set {
            userDefaults.setValue(newValue, forKey: key)
        }
    }
    let key: String
    let defaultValue: Type
    let userDefaults: UserDefaults = .standard
    
    // MARK: Initializers & Deinitializers
    public init(key: String, defaultValue: Type) {
        self.key = key
        self.defaultValue = defaultValue
    }
}
