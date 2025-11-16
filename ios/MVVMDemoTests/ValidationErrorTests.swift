//
//  ValidationErrorTests.swift
//  MVVMDemoTests
//
//  Created by MVVMDemo on 2025-06-17.
//

import XCTest
@testable import MVVMDemo

final class ValidationErrorTests: XCTestCase {
    
    // MARK: - Error Description Tests
    
    func testValidationErrorDescriptions() {
        // Test email errors
        XCTAssertEqual(ValidationError.emailEmpty.errorDescription, "Email address is required")
        XCTAssertEqual(ValidationError.emailInvalid.errorDescription, "Please enter a valid email address")
        XCTAssertEqual(ValidationError.emailTooLong.errorDescription, "Email address is too long")
        
        // Test password errors
        XCTAssertEqual(ValidationError.passwordEmpty.errorDescription, "Password is required")
        XCTAssertEqual(ValidationError.passwordTooShort.errorDescription, "Password must be at least 8 characters long")
        XCTAssertEqual(ValidationError.passwordTooLong.errorDescription, "Password must be less than 128 characters")
        XCTAssertEqual(ValidationError.passwordMissingUppercase.errorDescription, "Password must contain at least one uppercase letter")
        XCTAssertEqual(ValidationError.passwordMissingLowercase.errorDescription, "Password must contain at least one lowercase letter")
        XCTAssertEqual(ValidationError.passwordMissingNumber.errorDescription, "Password must contain at least one number")
        XCTAssertEqual(ValidationError.passwordMissingSpecialCharacter.errorDescription, "Password must contain at least one special character")
        XCTAssertEqual(ValidationError.passwordWeak.errorDescription, "Password is too weak. Please choose a stronger password")
        
        // Test name errors
        XCTAssertEqual(ValidationError.nameEmpty.errorDescription, "Name is required")
        XCTAssertEqual(ValidationError.nameTooShort.errorDescription, "Name must be at least 2 characters long")
        XCTAssertEqual(ValidationError.nameTooLong.errorDescription, "Name must be less than 100 characters")
        XCTAssertEqual(ValidationError.nameInvalidCharacters.errorDescription, "Name contains invalid characters")
        
        // Test password confirmation errors
        XCTAssertEqual(ValidationError.passwordMismatch.errorDescription, "Passwords do not match")
        
        // Test general errors
        XCTAssertEqual(ValidationError.invalidInput.errorDescription, "Invalid input provided")
    }
    
    // MARK: - Error Code Tests
    
    func testValidationErrorCodes() {
        // Test email error codes
        XCTAssertEqual(ValidationError.emailEmpty.errorCode, 1001)
        XCTAssertEqual(ValidationError.emailInvalid.errorCode, 1002)
        XCTAssertEqual(ValidationError.emailTooLong.errorCode, 1003)
        
        // Test password error codes
        XCTAssertEqual(ValidationError.passwordEmpty.errorCode, 2001)
        XCTAssertEqual(ValidationError.passwordTooShort.errorCode, 2002)
        XCTAssertEqual(ValidationError.passwordTooLong.errorCode, 2003)
        XCTAssertEqual(ValidationError.passwordMissingUppercase.errorCode, 2004)
        XCTAssertEqual(ValidationError.passwordMissingLowercase.errorCode, 2005)
        XCTAssertEqual(ValidationError.passwordMissingNumber.errorCode, 2006)
        XCTAssertEqual(ValidationError.passwordMissingSpecialCharacter.errorCode, 2007)
        XCTAssertEqual(ValidationError.passwordWeak.errorCode, 2008)
        
        // Test name error codes
        XCTAssertEqual(ValidationError.nameEmpty.errorCode, 3001)
        XCTAssertEqual(ValidationError.nameTooShort.errorCode, 3002)
        XCTAssertEqual(ValidationError.nameTooLong.errorCode, 3003)
        XCTAssertEqual(ValidationError.nameInvalidCharacters.errorCode, 3004)
        
        // Test password confirmation error code
        XCTAssertEqual(ValidationError.passwordMismatch.errorCode, 4001)
        
        // Test general error code
        XCTAssertEqual(ValidationError.invalidInput.errorCode, 5001)
    }
    
    // MARK: - All Cases Test
    
    func testValidationErrorAllCases() {
        let allCases = ValidationError.allCases
        
        // Verify we have the expected number of cases
        XCTAssertEqual(allCases.count, 18)
        
        // Verify all error codes are unique
        let errorCodes = allCases.map { $0.errorCode }
        XCTAssertEqual(Set(errorCodes).count, errorCodes.count, "Error codes should be unique")
        
        // Verify all cases have descriptions
        for errorCase in allCases {
            XCTAssertNotNil(errorCase.errorDescription, "All validation errors should have descriptions")
            XCTAssertFalse(errorCase.errorDescription!.isEmpty, "Error descriptions should not be empty")
        }
    }
    
    // MARK: - Raw Value Tests
    
    func testValidationErrorRawValues() {
        XCTAssertEqual(ValidationError.emailEmpty.rawValue, 1001)
        XCTAssertEqual(ValidationError.emailInvalid.rawValue, 1002)
        XCTAssertEqual(ValidationError.emailTooLong.rawValue, 1003)
        
        // Test that raw values match error codes
        for errorCase in ValidationError.allCases {
            XCTAssertEqual(errorCase.rawValue, errorCase.errorCode, "Raw value should match error code")
        }
    }
}