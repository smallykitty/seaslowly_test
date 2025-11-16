//
//  ValidationError.m
//  MVVMDemo
//
//  Created by MVVMDemo on 2025-06-17.
//

#import "ValidationError.h"

@implementation ValidationErrorHelper

+ (NSString *)localizedDescriptionForError:(ValidationError)error {
    switch (error) {
        // Email errors
        case ValidationErrorEmailEmpty:
            return NSLocalizedString(@"Email address is required", @"Email empty error");
        case ValidationErrorEmailInvalid:
            return NSLocalizedString(@"Please enter a valid email address", @"Email invalid error");
        case ValidationErrorEmailTooLong:
            return NSLocalizedString(@"Email address is too long", @"Email too long error");
            
        // Password errors
        case ValidationErrorPasswordEmpty:
            return NSLocalizedString(@"Password is required", @"Password empty error");
        case ValidationErrorPasswordTooShort:
            return NSLocalizedString(@"Password must be at least 8 characters long", @"Password too short error");
        case ValidationErrorPasswordTooLong:
            return NSLocalizedString(@"Password must be less than 128 characters", @"Password too long error");
        case ValidationErrorPasswordMissingUppercase:
            return NSLocalizedString(@"Password must contain at least one uppercase letter", @"Password missing uppercase error");
        case ValidationErrorPasswordMissingLowercase:
            return NSLocalizedString(@"Password must contain at least one lowercase letter", @"Password missing lowercase error");
        case ValidationErrorPasswordMissingNumber:
            return NSLocalizedString(@"Password must contain at least one number", @"Password missing number error");
        case ValidationErrorPasswordMissingSpecialCharacter:
            return NSLocalizedString(@"Password must contain at least one special character", @"Password missing special character error");
        case ValidationErrorPasswordWeak:
            return NSLocalizedString(@"Password is too weak. Please choose a stronger password", @"Password weak error");
            
        // Name errors
        case ValidationErrorNameEmpty:
            return NSLocalizedString(@"Name is required", @"Name empty error");
        case ValidationErrorNameTooShort:
            return NSLocalizedString(@"Name must be at least 2 characters long", @"Name too short error");
        case ValidationErrorNameTooLong:
            return NSLocalizedString(@"Name must be less than 100 characters", @"Name too long error");
        case ValidationErrorNameInvalidCharacters:
            return NSLocalizedString(@"Name contains invalid characters", @"Name invalid characters error");
            
        // Password confirmation errors
        case ValidationErrorPasswordMismatch:
            return NSLocalizedString(@"Passwords do not match", @"Password mismatch error");
            
        // General errors
        case ValidationErrorInvalidInput:
            return NSLocalizedString(@"Invalid input provided", @"Invalid input error");
    }
}

+ (NSInteger)errorCodeForError:(ValidationError)error {
    return (NSInteger)error;
}

@end