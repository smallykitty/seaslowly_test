//
//  ViewModelProtocols.swift
//  MVVMDemo
//
//  Created by MVVMDemo on 2025-06-17.
//

import Foundation
import Combine

/// Base protocol for all view models
@objc public protocol BaseViewModelProtocol: AnyObject {
    
    /// Indicates if the view model is currently loading
    @objc var isLoading: Bool { get }
    
    /// Current error message (if any)
    @objc var errorMessage: String? { get }
    
    /// Clear any current error
    @objc func clearError()
}

/// Protocol for authentication view models
@objc public protocol AuthenticationViewModelProtocol: BaseViewModelProtocol {
    
    /// Current email value
    @objc var email: String { get set }
    
    /// Current password value
    @objc var password: String { get set }
    
    /// Current full name value (for registration)
    @objc var fullName: String { get set }
    
    /// Current password confirmation value (for registration)
    @objc var confirmPassword: String { get set }
    
    /// Email validation error
    @objc var emailError: String? { get }
    
    /// Password validation error
    @objc var passwordError: String? { get }
    
    /// Name validation error
    @objc var nameError: String? { get }
    
    /// Password confirmation error
    @objc var confirmPasswordError: String? { get }
    
    /// Indicates if the form is valid for submission
    @objc var isFormValid: Bool { get }
    
    /// Authenticate user with current credentials
    @objc func login()
    
    /// Register new user with current credentials
    @objc func register()
    
    /// Validate current email field
    @objc func validateEmail()
    
    /// Validate current password field
    @objc func validatePassword()
    
    /// Validate current name field
    @objc func validateName()
    
    /// Validate current password confirmation field
    @objc func validatePasswordConfirmation()
    
    /// Validate all form fields
    @objc func validateForm()
}

/// Protocol for main/content view models
@objc public protocol ContentViewModelProtocol: BaseViewModelProtocol {
    
    /// Current authenticated user
    @objc var currentUser: User? { get }
    
    /// Indicates if user is authenticated
    @objc var isAuthenticated: Bool { get }
    
    /// User's display name
    @objc var displayName: String? { get }
    
    /// Load current user data
    @objc func loadCurrentUser()
    
    /// Logout current user
    @objc func logout()
}

/// Protocol for profile view models
@objc public protocol ProfileViewModelProtocol: ContentViewModelProtocol {
    
    /// Editable full name
    @objc var editableFullName: String { get set }
    
    /// Editable email (if allowed)
    @objc var editableEmail: String { get set }
    
    /// Profile update success flag
    @objc var profileUpdated: Bool { get }
    
    /// Update user profile
    @objc func updateProfile()
    
    /// Delete user account
    @objc func deleteAccount()
    
    /// Reset profile update flag
    @objc func resetProfileUpdateFlag()
}