//
//  Atomic.swift
//  
//
//  Created by Albert Grislis on 13.02.2021.
//

import Foundation

@propertyWrapper
final public class Atomic<Type> {
    
    // MARK: Public properties
    public var wrappedValue: Type {
        get {
            pthread_rwlock_wrlock(&lock)
            let value = protectedValue
            pthread_rwlock_unlock(&lock)
            return value
        } set {
            pthread_rwlock_wrlock(&lock)
            protectedValue = newValue
            pthread_rwlock_unlock(&lock)
        }
    }
    
    // MARK: Private properties
    private var lock: pthread_rwlock_t
    private var attribute: pthread_rwlockattr_t
    private var protectedValue: Type
    
    // MARK: Initializers & Deinitializers
    public init(wrappedValue: Type) {
        protectedValue = wrappedValue
        lock = pthread_rwlock_t()
        attribute = pthread_rwlockattr_t()
        
        pthread_rwlockattr_init(&attribute)
        pthread_rwlock_init(&lock, &attribute)
    }
    
    deinit {
        pthread_rwlock_destroy(&lock)
        pthread_rwlockattr_destroy(&attribute)
    }
}
