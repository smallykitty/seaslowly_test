//
//  ServiceProtocols.swift
//  MVVMDemo
//
//  Created by MVVMDemo on 2025-06-17.
//

import Foundation
import Combine

/// Protocol for authentication services
@objc public protocol AuthServiceProtocol {
    
    /// Authenticate user with credentials
    /// - Parameter credentials: User login credentials
    /// - Returns: Publisher that emits authentication response or error
    func authenticate(credentials: UserCredentials) -> AnyPublisher<AuthenticationResponse, Error>
    
    /// Register new user
    /// - Parameter credentials: User registration credentials
    /// - Returns: Publisher that emits authentication response or error
    func register(credentials: RegistrationCredentials) -> AnyPublisher<AuthenticationResponse, Error>
    
    /// Logout current user
    /// - Returns: Publisher that emits success or error
    func logout() -> AnyPublisher<Bool, Error>
    
    /// Refresh authentication token
    /// - Returns: Publisher that emits new authentication response or error
    func refreshToken() -> AnyPublisher<AuthenticationResponse, Error>
    
    /// Check if user is currently authenticated
    /// - Returns: True if user is authenticated, false otherwise
    @objc func isAuthenticated() -> Bool
}

/// Protocol for user services
@objc public protocol UserServiceProtocol {
    
    /// Get current user profile
    /// - Returns: Publisher that emits user information or error
    func getCurrentUser() -> AnyPublisher<User, Error>
    
    /// Update user profile
    /// - Parameter user: Updated user information
    /// - Returns: Publisher that emits updated user or error
    func updateProfile(_ user: User) -> AnyPublisher<User, Error>
    
    /// Delete user account
    /// - Returns: Publisher that emits success or error
    func deleteAccount() -> AnyPublisher<Bool, Error>
}

/// Protocol for token storage services
@objc public protocol TokenStorageProtocol {
    
    /// Save authentication token
    /// - Parameter token: Authentication token to save
    @objc func saveToken(_ token: String)
    
    /// Retrieve stored authentication token
    /// - Returns: Stored token or nil if not found
    @objc func getToken() -> String?
    
    /// Remove stored authentication token
    @objc func removeToken()
    
    /// Check if token exists
    /// - Returns: True if token exists, false otherwise
    @objc func hasToken() -> Bool
}

/// Protocol for validation services
@objc public protocol ValidationServiceProtocol {
    
    /// Validate email address
    /// - Parameter email: Email address to validate
    /// - Returns: Validation result with error if invalid
    @objc func validateEmail(_ email: String) -> Result<Void, ValidationError>
    
    /// Validate password
    /// - Parameter password: Password to validate
    /// - Returns: Validation result with error if invalid
    @objc func validatePassword(_ password: String) -> Result<Void, ValidationError>
    
    /// Validate name
    /// - Parameter name: Name to validate
    /// - Returns: Validation result with error if invalid
    @objc func validateName(_ name: String) -> Result<Void, ValidationError>
    
    /// Validate password confirmation
    /// - Parameters:
    ///   - password: Original password
    ///   - confirmPassword: Password confirmation
    /// - Returns: Validation result with error if invalid
    @objc func validatePasswordConfirmation(_ password: String, confirmPassword: String) -> Result<Void, ValidationError>
    
    /// Validate complete registration credentials
    /// - Parameter credentials: Registration credentials to validate
    /// - Returns: Array of validation errors (empty if all valid)
    @objc func validateRegistrationCredentials(_ credentials: RegistrationCredentials) -> [ValidationError]
    
    /// Validate complete login credentials
    /// - Parameter credentials: Login credentials to validate
    /// - Returns: Array of validation errors (empty if all valid)
    @objc func validateLoginCredentials(_ credentials: UserCredentials) -> [ValidationError]
}