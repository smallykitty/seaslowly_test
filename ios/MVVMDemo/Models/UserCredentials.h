//
//  UserCredentials.h
//  MVVMDemo
//
//  Created by MVVMDemo on 2025-06-17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Represents user login credentials
@interface UserCredentials : NSObject <NSSecureCoding>

/// User's email address
@property (nonatomic, copy, readonly) NSString *email;

/// User's password
@property (nonatomic, copy, readonly) NSString *password;

/// Initialize user credentials
/// @param email User's email address
/// @param password User's password
- (instancetype)initWithEmail:(NSString *)email password:(NSString *)password;

/// Convenience initializer for login credentials
/// @param email User's email address
/// @param password User's password
+ (instancetype)credentialsWithEmail:(NSString *)email password:(NSString *)password;

@end

/// Represents user registration credentials
@interface RegistrationCredentials : NSObject <NSSecureCoding>

/// User's email address
@property (nonatomic, copy, readonly) NSString *email;

/// User's password
@property (nonatomic, copy, readonly) NSString *password;

/// Password confirmation
@property (nonatomic, copy, readonly) NSString *confirmPassword;

/// User's full name
@property (nonatomic, copy, readonly) NSString *fullName;

/// Initialize registration credentials
/// @param email User's email address
/// @param password User's password
/// @param confirmPassword Password confirmation
/// @param fullName User's full name
- (instancetype)initWithEmail:(NSString *)email 
                     password:(NSString *)password 
               confirmPassword:(NSString *)confirmPassword 
                     fullName:(NSString *)fullName;

/// Convenience initializer for registration credentials
/// @param email User's email address
/// @param password User's password
/// @param confirmPassword Password confirmation
/// @param fullName User's full name
+ (instancetype)registrationCredentialsWithEmail:(NSString *)email 
                                        password:(NSString *)password 
                                  confirmPassword:(NSString *)confirmPassword 
                                        fullName:(NSString *)fullName;

@end

NS_ASSUME_NONNULL_END