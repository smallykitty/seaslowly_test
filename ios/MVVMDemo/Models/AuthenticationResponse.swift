//
//  AuthenticationResponse.swift
//  MVVMDemo
//
//  Created by MVVMDemo on 2025-06-17.
//

import Foundation

/// Represents a successful authentication response
@objc public class AuthenticationResponse: NSObject, Codable {
    /// Authentication token
    @objc public let token: String
    
    /// Token expiration date
    @objc public let expiresAt: Date
    
    /// User information
    @objc public let user: User
    
    /// Initialize authentication response
    /// - Parameters:
    ///   - token: Authentication token
    ///   - expiresAt: Token expiration date
    ///   - user: User information
    @objc public init(token: String, expiresAt: Date, user: User) {
        self.token = token
        self.expiresAt = expiresAt
        self.user = user
        super.init()
    }
}

/// Represents user information
@objc public class User: NSObject, Codable {
    /// User's unique identifier
    @objc public let id: String
    
    /// User's email address
    @objc public let email: String
    
    /// User's full name
    @objc public let fullName: String
    
    /// User's profile image URL (optional)
    @objc public let profileImageURL: URL?
    
    /// Initialize user
    /// - Parameters:
    ///   - id: User's unique identifier
    ///   - email: User's email address
    ///   - fullName: User's full name
    ///   - profileImageURL: User's profile image URL
    @objc public init(id: String, email: String, fullName: String, profileImageURL: URL? = nil) {
        self.id = id
        self.email = email
        self.fullName = fullName
        self.profileImageURL = profileImageURL
        super.init()
    }
}

/// Represents API response wrapper
@objc public class APIResponse<T: Codable>: NSObject, Codable where T: NSObject {
    /// Indicates if the request was successful
    @objc public let success: Bool
    
    /// Response data (optional)
    @objc public let data: T?
    
    /// Error message (optional)
    @objc public let message: String?
    
    /// Initialize API response
    /// - Parameters:
    ///   - success: Whether the request was successful
    ///   - data: Response data
    ///   - message: Error message
    @objc public init(success: Bool, data: T? = nil, message: String? = nil) {
        self.success = success
        self.data = data
        self.message = message
        super.init()
    }
}