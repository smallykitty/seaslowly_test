//
//  ValidationError.h
//  MVVMDemo
//
//  Created by MVVMDemo on 2025-06-17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Enumeration of validation errors for user input
typedef NS_ENUM(NSInteger, ValidationError) {
    // Email validation errors
    ValidationErrorEmailEmpty = 1001,
    ValidationErrorEmailInvalid = 1002,
    ValidationErrorEmailTooLong = 1003,
    
    // Password validation errors
    ValidationErrorPasswordEmpty = 2001,
    ValidationErrorPasswordTooShort = 2002,
    ValidationErrorPasswordTooLong = 2003,
    ValidationErrorPasswordMissingUppercase = 2004,
    ValidationErrorPasswordMissingLowercase = 2005,
    ValidationErrorPasswordMissingNumber = 2006,
    ValidationErrorPasswordMissingSpecialCharacter = 2007,
    ValidationErrorPasswordWeak = 2008,
    
    // Name validation errors
    ValidationErrorNameEmpty = 3001,
    ValidationErrorNameTooShort = 3002,
    ValidationErrorNameTooLong = 3003,
    ValidationErrorNameInvalidCharacters = 3004,
    
    // Password confirmation errors
    ValidationErrorPasswordMismatch = 4001,
    
    // General validation errors
    ValidationErrorInvalidInput = 5001
};

/// Helper class for ValidationError utilities
@interface ValidationErrorHelper : NSObject

/// Get localized description for validation error
/// @param error The validation error
/// @return Localized error description
+ (NSString *)localizedDescriptionForError:(ValidationError)error;

/// Get error code for validation error
/// @param error The validation error
/// @return Error code
+ (NSInteger)errorCodeForError:(ValidationError)error;

@end

NS_ASSUME_NONNULL_END