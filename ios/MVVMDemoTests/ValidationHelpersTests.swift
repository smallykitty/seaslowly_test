//
//  ValidationHelpersTests.swift
//  MVVMDemoTests
//
//  Created by MVVMDemo on 2025-06-17.
//

import XCTest
@testable import MVVMDemo

final class ValidationHelpersTests: XCTestCase {
    
    // MARK: - Email Validation Tests
    
    func testValidEmail() {
        let validEmails = [
            "test@example.com",
            "user.name@domain.co.uk",
            "user+tag@example.org",
            "user123@test-domain.com",
            "a@b.co"
        ]
        
        for email in validEmails {
            XCTAssertTrue(ValidationHelpers.isValidEmail(email), "Email '\(email)' should be valid")
        }
    }
    
    func testInvalidEmail() {
        let invalidEmails = [
            "invalid",
            "@example.com",
            "test@",
            "test.example.com",
            "test@.com",
            "test@example.",
            "test@example..com",
            "test @example.com",
            "test@exa mple.com"
        ]
        
        for email in invalidEmails {
            XCTAssertFalse(ValidationHelpers.isValidEmail(email), "Email '\(email)' should be invalid")
        }
    }
    
    func testEmailEmpty() {
        XCTAssertTrue(ValidationHelpers.isEmailEmpty(""))
        XCTAssertTrue(ValidationHelpers.isEmailEmpty("   "))
        XCTAssertTrue(ValidationHelpers.isEmailEmpty("\t\n"))
        XCTAssertFalse(ValidationHelpers.isEmailEmpty("test@example.com"))
    }
    
    func testEmailTooLong() {
        let longEmail = String(repeating: "a", count: ValidationHelpers.maximumEmailLength + 1) + "@example.com"
        XCTAssertTrue(ValidationHelpers.isEmailTooLong(longEmail))
        XCTAssertFalse(ValidationHelpers.isEmailTooLong("test@example.com"))
    }
    
    // MARK: - Password Validation Tests
    
    func testPasswordEmpty() {
        XCTAssertTrue(ValidationHelpers.isPasswordEmpty(""))
        XCTAssertFalse(ValidationHelpers.isPasswordEmpty("password"))
    }
    
    func testPasswordTooShort() {
        XCTAssertTrue(ValidationHelpers.isPasswordTooShort("short"))
        XCTAssertFalse(ValidationHelpers.isPasswordTooShort("validpassword"))
    }
    
    func testPasswordTooLong() {
        let longPassword = String(repeating: "a", count: ValidationHelpers.maximumPasswordLength + 1)
        XCTAssertTrue(ValidationHelpers.isPasswordTooLong(longPassword))
        XCTAssertFalse(ValidationHelpers.isPasswordTooLong("validpassword"))
    }
    
    func testPasswordUppercase() {
        XCTAssertTrue(ValidationHelpers.hasUppercaseLetter("Password"))
        XCTAssertTrue(ValidationHelpers.hasUppercaseLetter("PASSword"))
        XCTAssertFalse(ValidationHelpers.hasUppercaseLetter("password"))
    }
    
    func testPasswordLowercase() {
        XCTAssertTrue(ValidationHelpers.hasLowercaseLetter("Password"))
        XCTAssertTrue(ValidationHelpers.hasLowercaseLetter("passWORD"))
        XCTAssertFalse(ValidationHelpers.hasLowercaseLetter("PASSWORD"))
    }
    
    func testPasswordNumber() {
        XCTAssertTrue(ValidationHelpers.hasNumber("Password1"))
        XCTAssertTrue(ValidationHelpers.hasNumber("123Password"))
        XCTAssertFalse(ValidationHelpers.hasNumber("Password"))
    }
    
    func testPasswordSpecialCharacter() {
        let specialChars = ["!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "_", "+", "-"]
        for char in specialChars {
            let password = "Password\(char)1"
            XCTAssertTrue(ValidationHelpers.hasSpecialCharacter(password), "Password with '\(char)' should have special character")
        }
        XCTAssertFalse(ValidationHelpers.hasSpecialCharacter("Password1"))
    }
    
    func testPasswordStrength() {
        XCTAssertEqual(ValidationHelpers.calculatePasswordStrength("weak"), 0)
        XCTAssertEqual(ValidationHelpers.calculatePasswordStrength("password"), 1)
        XCTAssertEqual(ValidationHelpers.calculatePasswordStrength("Password"), 2)
        XCTAssertEqual(ValidationHelpers.calculatePasswordStrength("Password1"), 3)
        XCTAssertEqual(ValidationHelpers.calculatePasswordStrength("Password1!"), 4)
        XCTAssertEqual(ValidationHelpers.calculatePasswordStrength("StrongPassword1!"), 5)
        
        XCTAssertTrue(ValidationHelpers.isPasswordStrong("Password1!"))
        XCTAssertFalse(ValidationHelpers.isPasswordStrong("weak"))
    }
    
    // MARK: - Name Validation Tests
    
    func testNameEmpty() {
        XCTAssertTrue(ValidationHelpers.isNameEmpty(""))
        XCTAssertTrue(ValidationHelpers.isNameEmpty("   "))
        XCTAssertFalse(ValidationHelpers.isNameEmpty("John Doe"))
    }
    
    func testNameTooShort() {
        XCTAssertTrue(ValidationHelpers.isNameTooShort("J"))
        XCTAssertFalse(ValidationHelpers.isNameTooShort("John"))
    }
    
    func testNameTooLong() {
        let longName = String(repeating: "a", count: ValidationHelpers.maximumNameLength + 1)
        XCTAssertTrue(ValidationHelpers.isNameTooLong(longName))
        XCTAssertFalse(ValidationHelpers.isNameTooLong("John Doe"))
    }
    
    func testValidNameCharacters() {
        let validNames = [
            "John Doe",
            "Mary-Jane Smith",
            "O'Connor",
            "Jean-Luc Picard",
            "Álvaro",
            "张三" // Chinese characters - this might fail depending on regex
        ]
        
        for name in validNames {
            XCTAssertTrue(ValidationHelpers.hasValidNameCharacters(name), "Name '\(name)' should have valid characters")
        }
        
        let invalidNames = [
            "John123",
            "John@Doe",
            "John#Doe",
            "John*Doe"
        ]
        
        for name in invalidNames {
            XCTAssertFalse(ValidationHelpers.hasValidNameCharacters(name), "Name '\(name)' should have invalid characters")
        }
    }
    
    // MARK: - General Validation Tests
    
    func testEmptyOrWhitespace() {
        XCTAssertTrue(ValidationHelpers.isEmptyOrWhitespace(""))
        XCTAssertTrue(ValidationHelpers.isEmptyOrWhitespace("   "))
        XCTAssertTrue(ValidationHelpers.isEmptyOrWhitespace("\t\n"))
        XCTAssertFalse(ValidationHelpers.isEmptyOrWhitespace("text"))
    }
    
    func testStringsMatch() {
        XCTAssertTrue(ValidationHelpers.stringsMatch("hello", "hello"))
        XCTAssertTrue(ValidationHelpers.stringsMatch("", ""))
        XCTAssertFalse(ValidationHelpers.stringsMatch("hello", "Hello"))
        XCTAssertFalse(ValidationHelpers.stringsMatch("hello", "world"))
    }
    
    // MARK: - Constants Tests
    
    func testValidationConstants() {
        XCTAssertEqual(ValidationHelpers.minimumPasswordLength, 8)
        XCTAssertEqual(ValidationHelpers.maximumPasswordLength, 128)
        XCTAssertEqual(ValidationHelpers.minimumNameLength, 2)
        XCTAssertEqual(ValidationHelpers.maximumNameLength, 100)
        XCTAssertEqual(ValidationHelpers.maximumEmailLength, 254)
    }
}