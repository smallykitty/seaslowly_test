//
//  ValidationService.h
//  MVVMDemo
//
//  Created by MVVMDemo on 2025-06-17.
//

#import <Foundation/Foundation.h>
#import "UserCredentials.h"
#import "ValidationError.h"

NS_ASSUME_NONNULL_BEGIN

/// Protocol for validation services
@protocol ValidationServiceProtocol <NSObject>

/// Validate email address
/// @param email Email address to validate
/// @return Validation result with error if invalid
- (BOOL)validateEmail:(NSString *)email error:(NSError * _Nullable * _Nullable)error;

/// Validate password
/// @param password Password to validate
/// @return Validation result with error if invalid
- (BOOL)validatePassword:(NSString *)password error:(NSError * _Nullable * _Nullable)error;

/// Validate name
/// @param name Name to validate
/// @return Validation result with error if invalid
- (BOOL)validateName:(NSString *)name error:(NSError * _Nullable * _Nullable)error;

/// Validate password confirmation
/// @param password Original password
/// @param confirmPassword Password confirmation
/// @return Validation result with error if invalid
- (BOOL)validatePassword:(NSString *)password 
        confirmPassword:(NSString *)confirmPassword 
                  error:(NSError * _Nullable * _Nullable)error;

/// Validate complete registration credentials
/// @param credentials Registration credentials to validate
/// @return Array of validation errors (empty if all valid)
- (NSArray<NSNumber *> *)validateRegistrationCredentials:(RegistrationCredentials *)credentials;

/// Validate complete login credentials
/// @param credentials Login credentials to validate
/// @return Array of validation errors (empty if all valid)
- (NSArray<NSNumber *> *)validateLoginCredentials:(UserCredentials *)credentials;

@end

/// Concrete implementation of ValidationServiceProtocol
@interface ValidationService : NSObject <ValidationServiceProtocol>

/// Shared instance for easy access
@property (class, nonatomic, readonly) ValidationService *shared;

/// Validate email and return error message
/// @param email Email address to validate
/// @return Error message if invalid, nil if valid
- (nullable NSString *)getEmailErrorMessage:(NSString *)email;

/// Validate password and return error message
/// @param password Password to validate
/// @return Error message if invalid, nil if valid
- (nullable NSString *)getPasswordErrorMessage:(NSString *)password;

/// Validate name and return error message
/// @param name Name to validate
/// @return Error message if invalid, nil if valid
- (nullable NSString *)getNameErrorMessage:(NSString *)name;

/// Validate password confirmation and return error message
/// @param password Original password
/// @param confirmPassword Password confirmation
/// @return Error message if invalid, nil if valid
- (nullable NSString *)getPasswordConfirmationErrorMessage:(NSString *)password 
                                          confirmPassword:(NSString *)confirmPassword;

@end

/// Error domain for validation errors
extern NSString * const ValidationErrorDomain;

/// User info key for validation error code
extern NSString * const ValidationErrorCodeKey;

NS_ASSUME_NONNULL_END