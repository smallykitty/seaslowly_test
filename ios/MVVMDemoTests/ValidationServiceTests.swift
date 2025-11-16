//
//  ValidationServiceTests.swift
//  MVVMDemoTests
//
//  Created by MVVMDemo on 2025-06-17.
//

import XCTest
@testable import MVVMDemo

final class ValidationServiceTests: XCTestCase {
    
    var validationService: ValidationService!
    
    override func setUp() {
        super.setUp()
        validationService = ValidationService.shared
    }
    
    override func tearDown() {
        validationService = nil
        super.tearDown()
    }
    
    // MARK: - Email Validation Tests
    
    func testValidateEmailSuccess() {
        let validEmails = [
            "test@example.com",
            "user.name@domain.co.uk",
            "user+tag@example.org"
        ]
        
        for email in validEmails {
            let result = validationService.validateEmail(email)
            switch result {
            case .success:
                XCTAssertTrue(true, "Email '\(email)' should be valid")
            case .failure(let error):
                XCTFail("Email '\(email)' should be valid but got error: \(error)")
            }
        }
    }
    
    func testValidateEmailFailure() {
        // Test empty email
        let emptyResult = validationService.validateEmail("")
        switch emptyResult {
        case .success:
            XCTFail("Empty email should fail validation")
        case .failure(let error):
            XCTAssertEqual(error, .emailEmpty)
        }
        
        // Test invalid email format
        let invalidResult = validationService.validateEmail("invalid-email")
        switch invalidResult {
        case .success:
            XCTFail("Invalid email should fail validation")
        case .failure(let error):
            XCTAssertEqual(error, .emailInvalid)
        }
        
        // Test too long email
        let longEmail = String(repeating: "a", count: ValidationHelpers.maximumEmailLength + 1) + "@example.com"
        let longResult = validationService.validateEmail(longEmail)
        switch longResult {
        case .success:
            XCTFail("Too long email should fail validation")
        case .failure(let error):
            XCTAssertEqual(error, .emailTooLong)
        }
    }
    
    // MARK: - Password Validation Tests
    
    func testValidatePasswordSuccess() {
        let validPasswords = [
            "Password1!",
            "StrongPass123@",
            "MySecure#Pass456"
        ]
        
        for password in validPasswords {
            let result = validationService.validatePassword(password)
            switch result {
            case .success:
                XCTAssertTrue(true, "Password should be valid")
            case .failure(let error):
                XCTFail("Password should be valid but got error: \(error)")
            }
        }
    }
    
    func testValidatePasswordFailure() {
        // Test empty password
        let emptyResult = validationService.validatePassword("")
        switch emptyResult {
        case .success:
            XCTFail("Empty password should fail validation")
        case .failure(let error):
            XCTAssertEqual(error, .passwordEmpty)
        }
        
        // Test too short password
        let shortResult = validationService.validatePassword("short")
        switch shortResult {
        case .success:
            XCTFail("Short password should fail validation")
        case .failure(let error):
            XCTAssertEqual(error, .passwordTooShort)
        }
        
        // Test password missing uppercase
        let noUppercaseResult = validationService.validatePassword("password1!")
        switch noUppercaseResult {
        case .success:
            XCTFail("Password without uppercase should fail validation")
        case .failure(let error):
            XCTAssertEqual(error, .passwordMissingUppercase)
        }
        
        // Test password missing lowercase
        let noLowercaseResult = validationService.validatePassword("PASSWORD1!")
        switch noLowercaseResult {
        case .success:
            XCTFail("Password without lowercase should fail validation")
        case .failure(let error):
            XCTAssertEqual(error, .passwordMissingLowercase)
        }
        
        // Test password missing number
        let noNumberResult = validationService.validatePassword("Password!")
        switch noNumberResult {
        case .success:
            XCTFail("Password without number should fail validation")
        case .failure(let error):
            XCTAssertEqual(error, .passwordMissingNumber)
        }
        
        // Test password missing special character
        let noSpecialResult = validationService.validatePassword("Password1")
        switch noSpecialResult {
        case .success:
            XCTFail("Password without special character should fail validation")
        case .failure(let error):
            XCTAssertEqual(error, .passwordMissingSpecialCharacter)
        }
    }
    
    // MARK: - Name Validation Tests
    
    func testValidateNameSuccess() {
        let validNames = [
            "John Doe",
            "Mary-Jane Smith",
            "O'Connor"
        ]
        
        for name in validNames {
            let result = validationService.validateName(name)
            switch result {
            case .success:
                XCTAssertTrue(true, "Name '\(name)' should be valid")
            case .failure(let error):
                XCTFail("Name '\(name)' should be valid but got error: \(error)")
            }
        }
    }
    
    func testValidateNameFailure() {
        // Test empty name
        let emptyResult = validationService.validateName("")
        switch emptyResult {
        case .success:
            XCTFail("Empty name should fail validation")
        case .failure(let error):
            XCTAssertEqual(error, .nameEmpty)
        }
        
        // Test too short name
        let shortResult = validationService.validateName("J")
        switch shortResult {
        case .success:
            XCTFail("Short name should fail validation")
        case .failure(let error):
            XCTAssertEqual(error, .nameTooShort)
        }
        
        // Test name with invalid characters
        let invalidResult = validationService.validateName("John123")
        switch invalidResult {
        case .success:
            XCTFail("Name with invalid characters should fail validation")
        case .failure(let error):
            XCTAssertEqual(error, .nameInvalidCharacters)
        }
    }
    
    // MARK: - Password Confirmation Tests
    
    func testValidatePasswordConfirmationSuccess() {
        let result = validationService.validatePasswordConfirmation("Password1!", confirmPassword: "Password1!")
        switch result {
        case .success:
            XCTAssertTrue(true, "Matching passwords should be valid")
        case .failure(let error):
            XCTFail("Matching passwords should be valid but got error: \(error)")
        }
    }
    
    func testValidatePasswordConfirmationFailure() {
        let result = validationService.validatePasswordConfirmation("Password1!", confirmPassword: "Different1!")
        switch result {
        case .success:
            XCTFail("Non-matching passwords should fail validation")
        case .failure(let error):
            XCTAssertEqual(error, .passwordMismatch)
        }
    }
    
    // MARK: - Registration Credentials Tests
    
    func testValidateRegistrationCredentialsSuccess() {
        let credentials = RegistrationCredentials(
            email: "test@example.com",
            password: "Password1!",
            confirmPassword: "Password1!",
            fullName: "John Doe"
        )
        
        let errors = validationService.validateRegistrationCredentials(credentials)
        XCTAssertTrue(errors.isEmpty, "Valid registration credentials should not have errors")
    }
    
    func testValidateRegistrationCredentialsFailure() {
        let credentials = RegistrationCredentials(
            email: "invalid-email",
            password: "weak",
            confirmPassword: "different",
            fullName: ""
        )
        
        let errors = validationService.validateRegistrationCredentials(credentials)
        XCTAssertFalse(errors.isEmpty, "Invalid registration credentials should have errors")
        
        // Should contain email error, password errors, name error, and password mismatch
        XCTAssertTrue(errors.contains(.emailInvalid))
        XCTAssertTrue(errors.contains(.passwordTooShort) || errors.contains(.passwordMissingUppercase))
        XCTAssertTrue(errors.contains(.nameEmpty))
        XCTAssertTrue(errors.contains(.passwordMismatch))
    }
    
    // MARK: - Login Credentials Tests
    
    func testValidateLoginCredentialsSuccess() {
        let credentials = UserCredentials(email: "test@example.com", password: "password")
        
        let errors = validationService.validateLoginCredentials(credentials)
        XCTAssertTrue(errors.isEmpty, "Valid login credentials should not have errors")
    }
    
    func testValidateLoginCredentialsFailure() {
        let credentials = UserCredentials(email: "invalid-email", password: "")
        
        let errors = validationService.validateLoginCredentials(credentials)
        XCTAssertFalse(errors.isEmpty, "Invalid login credentials should have errors")
        
        XCTAssertTrue(errors.contains(.emailInvalid))
        XCTAssertTrue(errors.contains(.passwordEmpty))
    }
    
    // MARK: - Error Message Tests
    
    func testGetEmailErrorMessage() {
        XCTAssertNil(validationService.getEmailErrorMessage("test@example.com"))
        XCTAssertNotNil(validationService.getEmailErrorMessage(""))
        XCTAssertNotNil(validationService.getEmailErrorMessage("invalid"))
    }
    
    func testGetPasswordErrorMessage() {
        XCTAssertNil(validationService.getPasswordErrorMessage("Password1!"))
        XCTAssertNotNil(validationService.getPasswordErrorMessage(""))
        XCTAssertNotNil(validationService.getPasswordErrorMessage("weak"))
    }
    
    func testGetNameErrorMessage() {
        XCTAssertNil(validationService.getNameErrorMessage("John Doe"))
        XCTAssertNotNil(validationService.getNameErrorMessage(""))
        XCTAssertNotNil(validationService.getNameErrorMessage("J"))
    }
    
    func testGetPasswordConfirmationErrorMessage() {
        XCTAssertNil(validationService.getPasswordConfirmationErrorMessage("Password1!", confirmPassword: "Password1!"))
        XCTAssertNotNil(validationService.getPasswordConfirmationErrorMessage("Password1!", confirmPassword: "Different!"))
    }
}