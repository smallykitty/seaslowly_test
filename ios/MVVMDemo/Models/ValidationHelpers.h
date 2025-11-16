//
//  ValidationHelpers.h
//  MVVMDemo
//
//  Created by MVVMDemo on 2025-06-17.
//

#import <Foundation/Foundation.h>
#import "ValidationError.h"

NS_ASSUME_NONNULL_BEGIN

/// Utility class for validation helpers
@interface ValidationHelpers : NSObject

// MARK: - Constants

/// Minimum password length
@property (class, nonatomic, readonly) NSInteger minimumPasswordLength;

/// Maximum password length
@property (class, nonatomic, readonly) NSInteger maximumPasswordLength;

/// Minimum name length
@property (class, nonatomic, readonly) NSInteger minimumNameLength;

/// Maximum name length
@property (class, nonatomic, readonly) NSInteger maximumNameLength;

/// Maximum email length
@property (class, nonatomic, readonly) NSInteger maximumEmailLength;

// MARK: - Email Validation

/// Validate email format using regex
/// @param email Email address to validate
/// @return True if email format is valid, false otherwise
+ (BOOL)isValidEmail:(NSString *)email;

/// Check if email is empty
/// @param email Email address to check
/// @return True if email is empty or contains only whitespace, false otherwise
+ (BOOL)isEmailEmpty:(NSString *)email;

/// Check if email is too long
/// @param email Email address to check
/// @return True if email exceeds maximum length, false otherwise
+ (BOOL)isEmailTooLong:(NSString *)email;

// MARK: - Password Validation

/// Check if password is empty
/// @param password Password to check
/// @return True if password is empty, false otherwise
+ (BOOL)isPasswordEmpty:(NSString *)password;

/// Check if password is too short
/// @param password Password to check
/// @return True if password is shorter than minimum length, false otherwise
+ (BOOL)isPasswordTooShort:(NSString *)password;

/// Check if password is too long
/// @param password Password to check
/// @return True if password exceeds maximum length, false otherwise
+ (BOOL)isPasswordTooLong:(NSString *)password;

/// Check if password contains uppercase letter
/// @param password Password to check
/// @return True if password contains at least one uppercase letter, false otherwise
+ (BOOL)hasUppercaseLetter:(NSString *)password;

/// Check if password contains lowercase letter
/// @param password Password to check
/// @return True if password contains at least one lowercase letter, false otherwise
+ (BOOL)hasLowercaseLetter:(NSString *)password;

/// Check if password contains number
/// @param password Password to check
/// @return True if password contains at least one number, false otherwise
+ (BOOL)hasNumber:(NSString *)password;

/// Check if password contains special character
/// @param password Password to check
/// @return True if password contains at least one special character, false otherwise
+ (BOOL)hasSpecialCharacter:(NSString *)password;

/// Calculate password strength score
/// @param password Password to evaluate
/// @return Password strength score from 0 (weak) to 5 (strong)
+ (NSInteger)calculatePasswordStrength:(NSString *)password;

/// Check if password meets basic strength requirements
/// @param password Password to check
/// @return True if password is considered strong enough, false otherwise
+ (BOOL)isPasswordStrong:(NSString *)password;

// MARK: - Name Validation

/// Check if name is empty
/// @param name Name to check
/// @return True if name is empty or contains only whitespace, false otherwise
+ (BOOL)isNameEmpty:(NSString *)name;

/// Check if name is too short
/// @param name Name to check
/// @return True if name is shorter than minimum length, false otherwise
+ (BOOL)isNameTooShort:(NSString *)name;

/// Check if name is too long
/// @param name Name to check
/// @return True if name exceeds maximum length, false otherwise
+ (BOOL)isNameTooLong:(NSString *)name;

/// Check if name contains only valid characters
/// @param name Name to check
/// @return True if name contains only letters, spaces, hyphens, and apostrophes, false otherwise
+ (BOOL)hasValidNameCharacters:(NSString *)name;

// MARK: - General Validation

/// Check if string is empty or contains only whitespace
/// @param string String to check
/// @return True if string is empty or whitespace only, false otherwise
+ (BOOL)isEmptyOrWhitespace:(NSString *)string;

/// Check if two strings match
/// @param string1 First string
/// @param string2 Second string
/// @return True if strings are equal, false otherwise
+ (BOOL)stringsMatch:(NSString *)string1 string2:(NSString *)string2;

@end

NS_ASSUME_NONNULL_END