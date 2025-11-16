//
//  ValidationHelpers.swift
//  MVVMDemo
//
//  Created by MVVMDemo on 2025-06-17.
//

import Foundation

/// Utility class for validation helpers
@objc public class ValidationHelpers: NSObject {
    
    // MARK: - Constants
    
    /// Minimum password length
    public static let minimumPasswordLength = 8
    
    /// Maximum password length
    public static let maximumPasswordLength = 128
    
    /// Minimum name length
    public static let minimumNameLength = 2
    
    /// Maximum name length
    public static let maximumNameLength = 100
    
    /// Maximum email length
    public static let maximumEmailLength = 254
    
    // MARK: - Email Validation
    
    /// Validate email format using regex
    /// - Parameter email: Email address to validate
    /// - Returns: True if email format is valid, false otherwise
    @objc public static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    /// Check if email is empty
    /// - Parameter email: Email address to check
    /// - Returns: True if email is empty or contains only whitespace, false otherwise
    @objc public static func isEmailEmpty(_ email: String) -> Bool {
        return email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// Check if email is too long
    /// - Parameter email: Email address to check
    /// - Returns: True if email exceeds maximum length, false otherwise
    @objc public static func isEmailTooLong(_ email: String) -> Bool {
        return email.count > maximumEmailLength
    }
    
    // MARK: - Password Validation
    
    /// Check if password is empty
    /// - Parameter password: Password to check
    /// - Returns: True if password is empty, false otherwise
    @objc public static func isPasswordEmpty(_ password: String) -> Bool {
        return password.isEmpty
    }
    
    /// Check if password is too short
    /// - Parameter password: Password to check
    /// - Returns: True if password is shorter than minimum length, false otherwise
    @objc public static func isPasswordTooShort(_ password: String) -> Bool {
        return password.count < minimumPasswordLength
    }
    
    /// Check if password is too long
    /// - Parameter password: Password to check
    /// - Returns: True if password exceeds maximum length, false otherwise
    @objc public static func isPasswordTooLong(_ password: String) -> Bool {
        return password.count > maximumPasswordLength
    }
    
    /// Check if password contains uppercase letter
    /// - Parameter password: Password to check
    /// - Returns: True if password contains at least one uppercase letter, false otherwise
    @objc public static func hasUppercaseLetter(_ password: String) -> Bool {
        return password.range(of: "[A-Z]", options: .regularExpression) != nil
    }
    
    /// Check if password contains lowercase letter
    /// - Parameter password: Password to check
    /// - Returns: True if password contains at least one lowercase letter, false otherwise
    @objc public static func hasLowercaseLetter(_ password: String) -> Bool {
        return password.range(of: "[a-z]", options: .regularExpression) != nil
    }
    
    /// Check if password contains number
    /// - Parameter password: Password to check
    /// - Returns: True if password contains at least one number, false otherwise
    @objc public static func hasNumber(_ password: String) -> Bool {
        return password.range(of: "[0-9]", options: .regularExpression) != nil
    }
    
    /// Check if password contains special character
    /// - Parameter password: Password to check
    /// - Returns: True if password contains at least one special character, false otherwise
    @objc public static func hasSpecialCharacter(_ password: String) -> Bool {
        let specialCharacters = "!@#$%^&*()_+-=[]{}|;:'\",.<>/?`~"
        return password.rangeOfCharacter(from: CharacterSet(charactersIn: specialCharacters)) != nil
    }
    
    /// Calculate password strength score
    /// - Parameter password: Password to evaluate
    /// - Returns: Password strength score from 0 (weak) to 5 (strong)
    @objc public static func calculatePasswordStrength(_ password: String) -> Int {
        var score = 0
        
        if password.count >= minimumPasswordLength { score += 1 }
        if password.count >= 12 { score += 1 }
        if hasUppercaseLetter(password) { score += 1 }
        if hasLowercaseLetter(password) { score += 1 }
        if hasNumber(password) { score += 1 }
        if hasSpecialCharacter(password) { score += 1 }
        
        return min(score, 5)
    }
    
    /// Check if password meets basic strength requirements
    /// - Parameter password: Password to check
    /// - Returns: True if password is considered strong enough, false otherwise
    @objc public static func isPasswordStrong(_ password: String) -> Bool {
        return calculatePasswordStrength(password) >= 3
    }
    
    // MARK: - Name Validation
    
    /// Check if name is empty
    /// - Parameter name: Name to check
    /// - Returns: True if name is empty or contains only whitespace, false otherwise
    @objc public static func isNameEmpty(_ name: String) -> Bool {
        return name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// Check if name is too short
    /// - Parameter name: Name to check
    /// - Returns: True if name is shorter than minimum length, false otherwise
    @objc public static func isNameTooShort(_ name: String) -> Bool {
        return name.trimmingCharacters(in: .whitespacesAndNewlines).count < minimumNameLength
    }
    
    /// Check if name is too long
    /// - Parameter name: Name to check
    /// - Returns: True if name exceeds maximum length, false otherwise
    @objc public static func isNameTooLong(_ name: String) -> Bool {
        return name.count > maximumNameLength
    }
    
    /// Check if name contains only valid characters
    /// - Parameter name: Name to check
    /// - Returns: True if name contains only letters, spaces, hyphens, and apostrophes, false otherwise
    @objc public static func hasValidNameCharacters(_ name: String) -> Bool {
        let nameRegex = #"^[a-zA-Z\s\-'']+$"#
        return NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluate(with: name)
    }
    
    // MARK: - General Validation
    
    /// Check if string is empty or contains only whitespace
    /// - Parameter string: String to check
    /// - Returns: True if string is empty or whitespace only, false otherwise
    @objc public static func isEmptyOrWhitespace(_ string: String) -> Bool {
        return string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// Check if two strings match
    /// - Parameters:
    ///   - string1: First string
    ///   - string2: Second string
    /// - Returns: True if strings are equal, false otherwise
    @objc public static func stringsMatch(_ string1: String, _ string2: String) -> Bool {
        return string1 == string2
    }
}