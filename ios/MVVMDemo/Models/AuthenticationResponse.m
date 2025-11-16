//
//  AuthenticationResponse.m
//  MVVMDemo
//
//  Created by MVVMDemo on 2025-06-17.
//

#import "AuthenticationResponse.h"

@implementation AuthenticationResponse

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithToken:(NSString *)token 
                   expiresAt:(NSDate *)expiresAt 
                        user:(User *)user {
    self = [super init];
    if (self) {
        _token = [token copy];
        _expiresAt = [expiresAt copy];
        _user = user;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    NSString *token = [coder decodeObjectOfClass:[NSString class] forKey:@"token"];
    NSDate *expiresAt = [coder decodeObjectOfClass:[NSDate class] forKey:@"expiresAt"];
    User *user = [coder decodeObjectOfClass:[User class] forKey:@"user"];
    return [self initWithToken:token expiresAt:expiresAt user:user];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.token forKey:@"token"];
    [coder encodeObject:self.expiresAt forKey:@"expiresAt"];
    [coder encodeObject:self.user forKey:@"user"];
}

@end

@implementation User

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithIdentifier:(NSString *)identifier 
                            email:(NSString *)email 
                         fullName:(NSString *)fullName 
                 profileImageURL:(nullable NSURL *)profileImageURL {
    self = [super init];
    if (self) {
        _identifier = [identifier copy];
        _email = [email copy];
        _fullName = [fullName copy];
        _profileImageURL = profileImageURL;
    }
    return self;
}

+ (instancetype)userWithIdentifier:(NSString *)identifier 
                            email:(NSString *)email 
                         fullName:(NSString *)fullName {
    return [[self alloc] initWithIdentifier:identifier 
                                    email:email 
                                 fullName:fullName 
                         profileImageURL:nil];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    NSString *identifier = [coder decodeObjectOfClass:[NSString class] forKey:@"identifier"];
    NSString *email = [coder decodeObjectOfClass:[NSString class] forKey:@"email"];
    NSString *fullName = [coder decodeObjectOfClass:[NSString class] forKey:@"fullName"];
    NSURL *profileImageURL = [coder decodeObjectOfClass:[NSURL class] forKey:@"profileImageURL"];
    return [self initWithIdentifier:identifier 
                            email:email 
                         fullName:fullName 
                 profileImageURL:profileImageURL];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.identifier forKey:@"identifier"];
    [coder encodeObject:self.email forKey:@"email"];
    [coder encodeObject:self.fullName forKey:@"fullName"];
    [coder encodeObject:self.profileImageURL forKey:@"profileImageURL"];
}

@end

@implementation APIResponse

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithSuccess:(BOOL)success message:(nullable NSString *)message {
    self = [super init];
    if (self) {
        _success = success;
        _message = [message copy];
    }
    return self;
}

+ (instancetype)successResponse {
    return [[self alloc] initWithSuccess:YES message:nil];
}

+ (instancetype)errorResponseWithMessage:(NSString *)message {
    return [[self alloc] initWithSuccess:NO message:message];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    BOOL success = [coder decodeBoolForKey:@"success"];
    NSString *message = [coder decodeObjectOfClass:[NSString class] forKey:@"message"];
    return [self initWithSuccess:success message:message];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeBool:self.success forKey:@"success"];
    [coder encodeObject:self.message forKey:@"message"];
}

@end