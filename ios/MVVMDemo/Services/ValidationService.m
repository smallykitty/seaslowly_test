//
//  ValidationService.m
//  MVVMDemo
//
//  Created by MVVMDemo on 2025-06-17.
//

#import "ValidationService.h"
#import "ValidationHelpers.h"
#import "ValidationError.h"

// Error domain and constants
NSString * const ValidationErrorDomain = @"MVVMDemo.ValidationErrorDomain";
NSString * const ValidationErrorCodeKey = @"MVVMDemo.ValidationErrorCodeKey";

@implementation ValidationService

+ (ValidationService *)shared {
    static ValidationService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

// MARK: - ValidationServiceProtocol Implementation

- (BOOL)validateEmail:(NSString *)email error:(NSError **)error {
    if ([ValidationHelpers isEmailEmpty:email]) {
        if (error) {
            *error = [self errorWithValidationError:ValidationErrorEmailEmpty];
        }
        return NO;
    }
    
    if ([ValidationHelpers isEmailTooLong:email]) {
        if (error) {
            *error = [self errorWithValidationError:ValidationErrorEmailTooLong];
        }
        return NO;
    }
    
    if (![ValidationHelpers isValidEmail:email]) {
        if (error) {
            *error = [self errorWithValidationError:ValidationErrorEmailInvalid];
        }
        return NO;
    }
    
    return YES;
}

- (BOOL)validatePassword:(NSString *)password error:(NSError **)error {
    if ([ValidationHelpers isPasswordEmpty:password]) {
        if (error) {
            *error = [self errorWithValidationError:ValidationErrorPasswordEmpty];
        }
        return NO;
    }
    
    if ([ValidationHelpers isPasswordTooShort:password]) {
        if (error) {
            *error = [self errorWithValidationError:ValidationErrorPasswordTooShort];
        }
        return NO;
    }
    
    if ([ValidationHelpers isPasswordTooLong:password]) {
        if (error) {
            *error = [self errorWithValidationError:ValidationErrorPasswordTooLong];
        }
        return NO;
    }
    
    if (![ValidationHelpers hasUppercaseLetter:password]) {
        if (error) {
            *error = [self errorWithValidationError:ValidationErrorPasswordMissingUppercase];
        }
        return NO;
    }
    
    if (![ValidationHelpers hasLowercaseLetter:password]) {
        if (error) {
            *error = [self errorWithValidationError:ValidationErrorPasswordMissingLowercase];
        }
        return NO;
    }
    
    if (![ValidationHelpers hasNumber:password]) {
        if (error) {
            *error = [self errorWithValidationError:ValidationErrorPasswordMissingNumber];
        }
        return NO;
    }
    
    if (![ValidationHelpers hasSpecialCharacter:password]) {
        if (error) {
            *error = [self errorWithValidationError:ValidationErrorPasswordMissingSpecialCharacter];
        }
        return NO;
    }
    
    if (![ValidationHelpers isPasswordStrong:password]) {
        if (error) {
            *error = [self errorWithValidationError:ValidationErrorPasswordWeak];
        }
        return NO;
    }
    
    return YES;
}

- (BOOL)validateName:(NSString *)name error:(NSError **)error {
    if ([ValidationHelpers isNameEmpty:name]) {
        if (error) {
            *error = [self errorWithValidationError:ValidationErrorNameEmpty];
        }
        return NO;
    }
    
    if ([ValidationHelpers isNameTooShort:name]) {
        if (error) {
            *error = [self errorWithValidationError:ValidationErrorNameTooShort];
        }
        return NO;
    }
    
    if ([ValidationHelpers isNameTooLong:name]) {
        if (error) {
            *error = [self errorWithValidationError:ValidationErrorNameTooLong];
        }
        return NO;
    }
    
    if (![ValidationHelpers hasValidNameCharacters:name]) {
        if (error) {
            *error = [self errorWithValidationError:ValidationErrorNameInvalidCharacters];
        }
        return NO;
    }
    
    return YES;
}

- (BOOL)validatePassword:(NSString *)password 
        confirmPassword:(NSString *)confirmPassword 
                  error:(NSError **)error {
    if (![ValidationHelpers stringsMatch:password string2:confirmPassword]) {
        if (error) {
            *error = [self errorWithValidationError:ValidationErrorPasswordMismatch];
        }
        return NO;
    }
    
    return YES;
}

- (NSArray<NSNumber *> *)validateRegistrationCredentials:(RegistrationCredentials *)credentials {
    NSMutableArray<NSNumber *> *errors = [NSMutableArray array];
    
    // Validate email
    NSError *emailError = nil;
    if (![self validateEmail:credentials.email error:&emailError]) {
        [errors addObject:@(emailError.code)];
    }
    
    // Validate password
    NSError *passwordError = nil;
    if (![self validatePassword:credentials.password error:&passwordError]) {
        [errors addObject:@(passwordError.code)];
    }
    
    // Validate password confirmation
    NSError *confirmError = nil;
    if (![self validatePassword:credentials.password 
                confirmPassword:credentials.confirmPassword 
                          error:&confirmError]) {
        [errors addObject:@(confirmError.code)];
    }
    
    // Validate name
    NSError *nameError = nil;
    if (![self validateName:credentials.fullName error:&nameError]) {
        [errors addObject:@(nameError.code)];
    }
    
    return [errors copy];
}

- (NSArray<NSNumber *> *)validateLoginCredentials:(UserCredentials *)credentials {
    NSMutableArray<NSNumber *> *errors = [NSMutableArray array];
    
    // Validate email
    NSError *emailError = nil;
    if (![self validateEmail:credentials.email error:&emailError]) {
        [errors addObject:@(emailError.code)];
    }
    
    // Validate password (basic validation for login)
    if ([ValidationHelpers isPasswordEmpty:credentials.password]) {
        [errors addObject:@(ValidationErrorPasswordEmpty)];
    }
    
    return [errors copy];
}

// MARK: - Convenience Methods

- (NSString *)getEmailErrorMessage:(NSString *)email {
    NSError *error = nil;
    if ([self validateEmail:email error:&error]) {
        return nil;
    }
    return error.localizedDescription;
}

- (NSString *)getPasswordErrorMessage:(NSString *)password {
    NSError *error = nil;
    if ([self validatePassword:password error:&error]) {
        return nil;
    }
    return error.localizedDescription;
}

- (NSString *)getNameErrorMessage:(NSString *)name {
    NSError *error = nil;
    if ([self validateName:name error:&error]) {
        return nil;
    }
    return error.localizedDescription;
}

- (NSString *)getPasswordConfirmationErrorMessage:(NSString *)password 
                                  confirmPassword:(NSString *)confirmPassword {
    NSError *error = nil;
    if ([self validatePassword:password 
                confirmPassword:confirmPassword 
                          error:&error]) {
        return nil;
    }
    return error.localizedDescription;
}

// MARK: - Private Helper Methods

- (NSError *)errorWithValidationError:(ValidationError)validationError {
    NSString *description = [ValidationErrorHelper localizedDescriptionForError:validationError];
    NSInteger code = [ValidationErrorHelper errorCodeForError:validationError];
    
    NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey: description,
        ValidationErrorCodeKey: @(code)
    };
    
    return [NSError errorWithDomain:ValidationErrorDomain code:code userInfo:userInfo];
}

@end