//
//  ValidationError.swift
//  MVVMDemo
//
//  Created by MVVMDemo on 2025-06-17.
//

import Foundation

/// Enumeration of validation errors for user input
@objc public enum ValidationError: Int, Error, CaseIterable, LocalizedError {
    
    // Email validation errors
    case emailEmpty = 1001
    case emailInvalid = 1002
    case emailTooLong = 1003
    
    // Password validation errors
    case passwordEmpty = 2001
    case passwordTooShort = 2002
    case passwordTooLong = 2003
    case passwordMissingUppercase = 2004
    case passwordMissingLowercase = 2005
    case passwordMissingNumber = 2006
    case passwordMissingSpecialCharacter = 2007
    case passwordWeak = 2008
    
    // Name validation errors
    case nameEmpty = 3001
    case nameTooShort = 3002
    case nameTooLong = 3003
    case nameInvalidCharacters = 3004
    
    // Password confirmation errors
    case passwordMismatch = 4001
    
    // General validation errors
    case invalidInput = 5001
    
    /// Human-readable description of the error
    public var errorDescription: String? {
        switch self {
        // Email errors
        case .emailEmpty:
            return NSLocalizedString("Email address is required", comment: "Email empty error")
        case .emailInvalid:
            return NSLocalizedString("Please enter a valid email address", comment: "Email invalid error")
        case .emailTooLong:
            return NSLocalizedString("Email address is too long", comment: "Email too long error")
            
        // Password errors
        case .passwordEmpty:
            return NSLocalizedString("Password is required", comment: "Password empty error")
        case .passwordTooShort:
            return NSLocalizedString("Password must be at least 8 characters long", comment: "Password too short error")
        case .passwordTooLong:
            return NSLocalizedString("Password must be less than 128 characters", comment: "Password too long error")
        case .passwordMissingUppercase:
            return NSLocalizedString("Password must contain at least one uppercase letter", comment: "Password missing uppercase error")
        case .passwordMissingLowercase:
            return NSLocalizedString("Password must contain at least one lowercase letter", comment: "Password missing lowercase error")
        case .passwordMissingNumber:
            return NSLocalizedString("Password must contain at least one number", comment: "Password missing number error")
        case .passwordMissingSpecialCharacter:
            return NSLocalizedString("Password must contain at least one special character", comment: "Password missing special character error")
        case .passwordWeak:
            return NSLocalizedString("Password is too weak. Please choose a stronger password", comment: "Password weak error")
            
        // Name errors
        case .nameEmpty:
            return NSLocalizedString("Name is required", comment: "Name empty error")
        case .nameTooShort:
            return NSLocalizedString("Name must be at least 2 characters long", comment: "Name too short error")
        case .nameTooLong:
            return NSLocalizedString("Name must be less than 100 characters", comment: "Name too long error")
        case .nameInvalidCharacters:
            return NSLocalizedString("Name contains invalid characters", comment: "Name invalid characters error")
            
        // Password confirmation errors
        case .passwordMismatch:
            return NSLocalizedString("Passwords do not match", comment: "Password mismatch error")
            
        // General errors
        case .invalidInput:
            return NSLocalizedString("Invalid input provided", comment: "Invalid input error")
        }
    }
    
    /// Error code for Objective-C compatibility
    public var errorCode: Int {
        return self.rawValue
    }
}