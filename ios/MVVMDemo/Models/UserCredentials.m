//
//  UserCredentials.m
//  MVVMDemo
//
//  Created by MVVMDemo on 2025-06-17.
//

#import "UserCredentials.h"

@implementation UserCredentials

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithEmail:(NSString *)email password:(NSString *)password {
    self = [super init];
    if (self) {
        _email = [email copy];
        _password = [password copy];
    }
    return self;
}

+ (instancetype)credentialsWithEmail:(NSString *)email password:(NSString *)password {
    return [[self alloc] initWithEmail:email password:password];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    NSString *email = [coder decodeObjectOfClass:[NSString class] forKey:@"email"];
    NSString *password = [coder decodeObjectOfClass:[NSString class] forKey:@"password"];
    return [self initWithEmail:email password:password];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.email forKey:@"email"];
    [coder encodeObject:self.password forKey:@"password"];
}

@end

@implementation RegistrationCredentials

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithEmail:(NSString *)email 
                     password:(NSString *)password 
               confirmPassword:(NSString *)confirmPassword 
                     fullName:(NSString *)fullName {
    self = [super init];
    if (self) {
        _email = [email copy];
        _password = [password copy];
        _confirmPassword = [confirmPassword copy];
        _fullName = [fullName copy];
    }
    return self;
}

+ (instancetype)registrationCredentialsWithEmail:(NSString *)email 
                                        password:(NSString *)password 
                                  confirmPassword:(NSString *)confirmPassword 
                                        fullName:(NSString *)fullName {
    return [[self alloc] initWithEmail:email 
                               password:password 
                         confirmPassword:confirmPassword 
                               fullName:fullName];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    NSString *email = [coder decodeObjectOfClass:[NSString class] forKey:@"email"];
    NSString *password = [coder decodeObjectOfClass:[NSString class] forKey:@"password"];
    NSString *confirmPassword = [coder decodeObjectOfClass:[NSString class] forKey:@"confirmPassword"];
    NSString *fullName = [coder decodeObjectOfClass:[NSString class] forKey:@"fullName"];
    return [self initWithEmail:email 
                       password:password 
                 confirmPassword:confirmPassword 
                       fullName:fullName];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.email forKey:@"email"];
    [coder encodeObject:self.password forKey:@"password"];
    [coder encodeObject:self.confirmPassword forKey:@"confirmPassword"];
    [coder encodeObject:self.fullName forKey:@"fullName"];
}

@end