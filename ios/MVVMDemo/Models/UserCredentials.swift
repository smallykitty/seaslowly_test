//
//  UserCredentials.swift
//  MVVMDemo
//
//  Created by MVVMDemo on 2025-06-17.
//

import Foundation

/// Represents user login credentials
@objc public class UserCredentials: NSObject, Codable {
    /// User's email address
    @objc public let email: String
    
    /// User's password
    @objc public let password: String
    
    /// Initialize user credentials
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    @objc public init(email: String, password: String) {
        self.email = email
        self.password = password
        super.init()
    }
}

/// Represents user registration credentials
@objc public class RegistrationCredentials: NSObject, Codable {
    /// User's email address
    @objc public let email: String
    
    /// User's password
    @objc public let password: String
    
    /// Password confirmation
    @objc public let confirmPassword: String
    
    /// User's full name
    @objc public let fullName: String
    
    /// Initialize registration credentials
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    ///   - confirmPassword: Password confirmation
    ///   - fullName: User's full name
    @objc public init(email: String, password: String, confirmPassword: String, fullName: String) {
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
        self.fullName = fullName
        super.init()
    }
}