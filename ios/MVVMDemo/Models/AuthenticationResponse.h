//
//  AuthenticationResponse.h
//  MVVMDemo
//
//  Created by MVVMDemo on 2025-06-17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class User;

/// Represents a successful authentication response
@interface AuthenticationResponse : NSObject <NSSecureCoding>

/// Authentication token
@property (nonatomic, copy, readonly) NSString *token;

/// Token expiration date
@property (nonatomic, copy, readonly) NSDate *expiresAt;

/// User information
@property (nonatomic, strong, readonly) User *user;

/// Initialize authentication response
/// @param token Authentication token
/// @param expiresAt Token expiration date
/// @param user User information
- (instancetype)initWithToken:(NSString *)token 
                   expiresAt:(NSDate *)expiresAt 
                        user:(User *)user;

@end

/// Represents user information
@interface User : NSObject <NSSecureCoding>

/// User's unique identifier
@property (nonatomic, copy, readonly) NSString *identifier;

/// User's email address
@property (nonatomic, copy, readonly) NSString *email;

/// User's full name
@property (nonatomic, copy, readonly) NSString *fullName;

/// User's profile image URL (optional)
@property (nonatomic, strong, readonly, nullable) NSURL *profileImageURL;

/// Initialize user
/// @param identifier User's unique identifier
/// @param email User's email address
/// @param fullName User's full name
/// @param profileImageURL User's profile image URL
- (instancetype)initWithIdentifier:(NSString *)identifier 
                            email:(NSString *)email 
                         fullName:(NSString *)fullName 
                 profileImageURL:(nullable NSURL *)profileImageURL;

/// Convenience initializer without profile image
/// @param identifier User's unique identifier
/// @param email User's email address
/// @param fullName User's full name
+ (instancetype)userWithIdentifier:(NSString *)identifier 
                            email:(NSString *)email 
                         fullName:(NSString *)fullName;

@end

/// Represents API response wrapper
@interface APIResponse : NSObject <NSSecureCoding>

/// Indicates if the request was successful
@property (nonatomic, assign, readonly) BOOL success;

/// Error message (optional)
@property (nonatomic, copy, readonly, nullable) NSString *message;

/// Initialize API response
/// @param success Whether the request was successful
/// @param message Error message
- (instancetype)initWithSuccess:(BOOL)success message:(nullable NSString *)message;

/// Convenience initializer for success
+ (instancetype)successResponse;

/// Convenience initializer for error
/// @param message Error message
+ (instancetype)errorResponseWithMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END