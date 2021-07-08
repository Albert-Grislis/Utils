//
//  RawRepresentableUserDefaultsBacked.swift
//
//
//  Created by Albert Grislis on 13.02.2021.
//

import Foundation

@propertyWrapper
final public class RawRepresentableUserDefaultsBacked<Type>: UserDefaultsBacked<Type> where Type: RawRepresentable {
    
    // MARK: Public properties
    override public var wrappedValue: Type {
        get {
            let value: Type.RawValue? = userDefaults.value(forKey: key) as? Type.RawValue
            return Type(rawValue: value ?? defaultValue.rawValue) ?? defaultValue
        }
        set {
            userDefaults.setValue(newValue.rawValue, forKey: key)
        }
    }
}
