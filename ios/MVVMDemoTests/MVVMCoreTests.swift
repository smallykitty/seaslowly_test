//
//  MVVMCoreTests.swift
//  MVVMDemoTests
//
//  Created by MVVMDemo on 2025-06-17.
//

import XCTest
@testable import MVVMDemo

/// Integration tests for MVVM Core components
final class MVVMCoreTests: XCTestCase {
    
    var validationService: ValidationService!
    
    override func setUp() {
        super.setUp()
        validationService = ValidationService.shared
    }
    
    override func tearDown() {
        validationService = nil
        super.tearDown()
    }
    
    // MARK: - Integration Tests
    
    func testCompleteValidationFlow() {
        // Test successful registration validation flow
        let validCredentials = RegistrationCredentials(
            email: "test@example.com",
            password: "Password1!",
            confirmPassword: "Password1!",
            fullName: "John Doe"
        )
        
        let errors = validationService.validateRegistrationCredentials(validCredentials)
        XCTAssertTrue(errors.isEmpty, "Valid credentials should pass all validations")
        
        // Test failed registration validation flow
        let invalidCredentials = RegistrationCredentials(
            email: "invalid-email",
            password: "weak",
            confirmPassword: "different",
            fullName: ""
        )
        
        let invalidErrors = validationService.validateRegistrationCredentials(invalidCredentials)
        XCTAssertFalse(invalidErrors.isEmpty, "Invalid credentials should fail validation")
        XCTAssertGreaterThanOrEqual(invalidErrors.count, 4, "Should have multiple validation errors")
    }
    
    func testLoginValidationFlow() {
        // Test successful login validation
        let validCredentials = UserCredentials(email: "test@example.com", password: "anypassword")
        let errors = validationService.validateLoginCredentials(validCredentials)
        XCTAssertTrue(errors.isEmpty, "Valid login credentials should pass validation")
        
        // Test failed login validation
        let invalidCredentials = UserCredentials(email: "invalid-email", password: "")
        let invalidErrors = validationService.validateLoginCredentials(invalidCredentials)
        XCTAssertFalse(invalidErrors.isEmpty, "Invalid login credentials should fail validation")
        XCTAssertEqual(invalidErrors.count, 2, "Should have email and password errors")
    }
    
    func testErrorMessagesIntegration() {
        // Test that all validation helpers provide meaningful error messages
        let testCases: [(String, String, ValidationError)] = [
            ("", "Email should be empty error", .emailEmpty),
            ("invalid", "Email should be invalid error", .emailInvalid),
            ("weak", "Password should be weak error", .passwordTooShort),
            ("", "Name should be empty error", .nameEmpty)
        ]
        
        for (input, description, expectedError) in testCases {
            var errorMessage: String?
            
            switch expectedError {
            case .emailEmpty, .emailInvalid:
                errorMessage = validationService.getEmailErrorMessage(input)
            case .passwordTooShort, .passwordWeak:
                errorMessage = validationService.getPasswordErrorMessage(input)
            case .nameEmpty:
                errorMessage = validationService.getNameErrorMessage(input)
            default:
                break
            }
            
            XCTAssertNotNil(errorMessage, "\(description): Should provide error message")
            XCTAssertFalse(errorMessage!.isEmpty, "\(description): Error message should not be empty")
        }
    }
    
    func testModelCreationAndUsage() {
        // Test UserCredentials creation and usage
        let credentials = UserCredentials(email: "test@example.com", password: "password123")
        XCTAssertEqual(credentials.email, "test@example.com")
        XCTAssertEqual(credentials.password, "password123")
        
        // Test RegistrationCredentials creation and usage
        let regCredentials = RegistrationCredentials(
            email: "test@example.com",
            password: "Password1!",
            confirmPassword: "Password1!",
            fullName: "John Doe"
        )
        XCTAssertEqual(regCredentials.email, "test@example.com")
        XCTAssertEqual(regCredentials.password, "Password1!")
        XCTAssertEqual(regCredentials.confirmPassword, "Password1!")
        XCTAssertEqual(regCredentials.fullName, "John Doe")
        
        // Test User creation and usage
        let user = User(id: "12345", email: "test@example.com", fullName: "John Doe")
        XCTAssertEqual(user.id, "12345")
        XCTAssertEqual(user.email, "test@example.com")
        XCTAssertEqual(user.fullName, "John Doe")
        XCTAssertNil(user.profileImageURL)
        
        // Test User with profile image
        let profileURL = URL(string: "https://example.com/profile.jpg")!
        let userWithProfile = User(id: "67890", email: "jane@example.com", fullName: "Jane Smith", profileImageURL: profileURL)
        XCTAssertEqual(userWithProfile.profileImageURL, profileURL)
        
        // Test AuthenticationResponse creation and usage
        let authResponse = AuthenticationResponse(
            token: "sample-token",
            expiresAt: Date().addingTimeInterval(3600), // 1 hour from now
            user: user
        )
        XCTAssertEqual(authResponse.token, "sample-token")
        XCTAssertEqual(authResponse.user, user)
        XCTAssertTrue(authResponse.expiresAt > Date())
    }
    
    func testObjectiveCCompatibility() {
        // Test that Objective-C classes can be instantiated and used
        let objCValidationService = ValidationService.shared
        
        // Test Objective-C validation methods
        var error: NSError?
        let isValidEmail = objCValidationService.validateEmail("test@example.com", error: &error)
        XCTAssertTrue(isValidEmail, "Objective-C validation should work")
        XCTAssertNil(error, "Valid email should not produce error")
        
        let isInvalidEmail = objCValidationService.validateEmail("invalid", error: &error)
        XCTAssertFalse(isInvalidEmail, "Objective-C validation should fail for invalid email")
        XCTAssertNotNil(error, "Invalid email should produce error")
        
        // Test Objective-C error message methods
        let errorMessage = objCValidationService.getEmailErrorMessage("invalid")
        XCTAssertNotNil(errorMessage, "Should provide error message for invalid email")
        XCTAssertFalse(errorMessage!.isEmpty, "Error message should not be empty")
    }
    
    func testPasswordStrengthScenarios() {
        let strengthTestCases: [(String, Int)] = [
            ("", 0),           // Empty
            ("weak", 0),       // Too short
            ("password", 1),   // Only lowercase, meets minimum length
            ("Password", 2),   // Upper + lower, meets minimum length
            ("Password1", 3), // Upper + lower + number
            ("Password1!", 4), // Upper + lower + number + special
            ("StrongPassword1!", 5) // Long + all requirements
        ]
        
        for (password, expectedStrength) in strengthTestCases {
            let actualStrength = ValidationHelpers.calculatePasswordStrength(password)
            XCTAssertEqual(actualStrength, expectedStrength, "Password '\(password)' should have strength \(expectedStrength)")
        }
    }
    
    func testEdgeCases() {
        // Test boundary conditions
        let exactlyMinimumPassword = String(repeating: "a", count: ValidationHelpers.minimumPasswordLength)
        let exactlyMaximumPassword = String(repeating: "a", count: ValidationHelpers.maximumPasswordLength)
        let tooLongPassword = String(repeating: "a", count: ValidationHelpers.maximumPasswordLength + 1)
        
        XCTAssertFalse(ValidationHelpers.isPasswordTooShort(exactlyMinimumPassword))
        XCTAssertFalse(ValidationHelpers.isPasswordTooLong(exactlyMaximumPassword))
        XCTAssertTrue(ValidationHelpers.isPasswordTooLong(tooLongPassword))
        
        let exactlyMinimumName = String(repeating: "a", count: ValidationHelpers.minimumNameLength)
        let exactlyMaximumName = String(repeating: "a", count: ValidationHelpers.maximumNameLength)
        let tooLongName = String(repeating: "a", count: ValidationHelpers.maximumNameLength + 1)
        
        XCTAssertFalse(ValidationHelpers.isNameTooShort(exactlyMinimumName))
        XCTAssertFalse(ValidationHelpers.isNameTooLong(exactlyMaximumName))
        XCTAssertTrue(ValidationHelpers.isNameTooLong(tooLongName))
    }
}