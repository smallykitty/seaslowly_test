//
//  ValidationService.swift
//  MVVMDemo
//
//  Created by MVVMDemo on 2025-06-17.
//

import Foundation

/// Concrete implementation of ValidationServiceProtocol
@objc public class ValidationService: NSObject, ValidationServiceProtocol {
    
    // MARK: - Singleton
    
    /// Shared instance for easy access
    @objc public static let shared = ValidationService()
    
    // MARK: - ValidationServiceProtocol Implementation
    
    /// Validate email address
    /// - Parameter email: Email address to validate
    /// - Returns: Validation result with error if invalid
    @objc public func validateEmail(_ email: String) -> Result<Void, ValidationError> {
        if ValidationHelpers.isEmailEmpty(email) {
            return .failure(.emailEmpty)
        }
        
        if ValidationHelpers.isEmailTooLong(email) {
            return .failure(.emailTooLong)
        }
        
        if !ValidationHelpers.isValidEmail(email) {
            return .failure(.emailInvalid)
        }
        
        return .success(())
    }
    
    /// Validate password
    /// - Parameter password: Password to validate
    /// - Returns: Validation result with error if invalid
    @objc public func validatePassword(_ password: String) -> Result<Void, ValidationError> {
        if ValidationHelpers.isPasswordEmpty(password) {
            return .failure(.passwordEmpty)
        }
        
        if ValidationHelpers.isPasswordTooShort(password) {
            return .failure(.passwordTooShort)
        }
        
        if ValidationHelpers.isPasswordTooLong(password) {
            return .failure(.passwordTooLong)
        }
        
        if !ValidationHelpers.hasUppercaseLetter(password) {
            return .failure(.passwordMissingUppercase)
        }
        
        if !ValidationHelpers.hasLowercaseLetter(password) {
            return .failure(.passwordMissingLowercase)
        }
        
        if !ValidationHelpers.hasNumber(password) {
            return .failure(.passwordMissingNumber)
        }
        
        if !ValidationHelpers.hasSpecialCharacter(password) {
            return .failure(.passwordMissingSpecialCharacter)
        }
        
        if !ValidationHelpers.isPasswordStrong(password) {
            return .failure(.passwordWeak)
        }
        
        return .success(())
    }
    
    /// Validate name
    /// - Parameter name: Name to validate
    /// - Returns: Validation result with error if invalid
    @objc public func validateName(_ name: String) -> Result<Void, ValidationError> {
        if ValidationHelpers.isNameEmpty(name) {
            return .failure(.nameEmpty)
        }
        
        if ValidationHelpers.isNameTooShort(name) {
            return .failure(.nameTooShort)
        }
        
        if ValidationHelpers.isNameTooLong(name) {
            return .failure(.nameTooLong)
        }
        
        if !ValidationHelpers.hasValidNameCharacters(name) {
            return .failure(.nameInvalidCharacters)
        }
        
        return .success(())
    }
    
    /// Validate password confirmation
    /// - Parameters:
    ///   - password: Original password
    ///   - confirmPassword: Password confirmation
    /// - Returns: Validation result with error if invalid
    @objc public func validatePasswordConfirmation(_ password: String, confirmPassword: String) -> Result<Void, ValidationError> {
        if !ValidationHelpers.stringsMatch(password, confirmPassword) {
            return .failure(.passwordMismatch)
        }
        
        return .success(())
    }
    
    /// Validate complete registration credentials
    /// - Parameter credentials: Registration credentials to validate
    /// - Returns: Array of validation errors (empty if all valid)
    @objc public func validateRegistrationCredentials(_ credentials: RegistrationCredentials) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        // Validate email
        switch validateEmail(credentials.email) {
        case .failure(let error):
            errors.append(error)
        case .success:
            break
        }
        
        // Validate password
        switch validatePassword(credentials.password) {
        case .failure(let error):
            errors.append(error)
        case .success:
            break
        }
        
        // Validate password confirmation
        switch validatePasswordConfirmation(credentials.password, confirmPassword: credentials.confirmPassword) {
        case .failure(let error):
            errors.append(error)
        case .success:
            break
        }
        
        // Validate name
        switch validateName(credentials.fullName) {
        case .failure(let error):
            errors.append(error)
        case .success:
            break
        }
        
        return errors
    }
    
    /// Validate complete login credentials
    /// - Parameter credentials: Login credentials to validate
    /// - Returns: Array of validation errors (empty if all valid)
    @objc public func validateLoginCredentials(_ credentials: UserCredentials) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        // Validate email
        switch validateEmail(credentials.email) {
        case .failure(let error):
            errors.append(error)
        case .success:
            break
        }
        
        // Validate password (basic validation for login)
        if ValidationHelpers.isPasswordEmpty(credentials.password) {
            errors.append(.passwordEmpty)
        }
        
        return errors
    }
    
    // MARK: - Convenience Methods
    
    /// Validate email and return error message
    /// - Parameter email: Email address to validate
    /// - Returns: Error message if invalid, nil if valid
    @objc public func getEmailErrorMessage(_ email: String) -> String? {
        switch validateEmail(email) {
        case .failure(let error):
            return error.localizedDescription
        case .success:
            return nil
        }
    }
    
    /// Validate password and return error message
    /// - Parameter password: Password to validate
    /// - Returns: Error message if invalid, nil if valid
    @objc public func getPasswordErrorMessage(_ password: String) -> String? {
        switch validatePassword(password) {
        case .failure(let error):
            return error.localizedDescription
        case .success:
            return nil
        }
    }
    
    /// Validate name and return error message
    /// - Parameter name: Name to validate
    /// - Returns: Error message if invalid, nil if valid
    @objc public func getNameErrorMessage(_ name: String) -> String? {
        switch validateName(name) {
        case .failure(let error):
            return error.localizedDescription
        case .success:
            return nil
        }
    }
    
    /// Validate password confirmation and return error message
    /// - Parameters:
    ///   - password: Original password
    ///   - confirmPassword: Password confirmation
    /// - Returns: Error message if invalid, nil if valid
    @objc public func getPasswordConfirmationErrorMessage(_ password: String, confirmPassword: String) -> String? {
        switch validatePasswordConfirmation(password, confirmPassword: confirmPassword) {
        case .failure(let error):
            return error.localizedDescription
        case .success:
            return nil
        }
    }
}