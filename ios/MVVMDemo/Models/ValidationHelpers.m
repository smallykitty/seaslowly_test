//
//  ValidationHelpers.m
//  MVVMDemo
//
//  Created by MVVMDemo on 2025-06-17.
//

#import "ValidationHelpers.h"

@implementation ValidationHelpers

// MARK: - Constants

+ (NSInteger)minimumPasswordLength {
    return 8;
}

+ (NSInteger)maximumPasswordLength {
    return 128;
}

+ (NSInteger)minimumNameLength {
    return 2;
}

+ (NSInteger)maximumNameLength {
    return 100;
}

+ (NSInteger)maximumEmailLength {
    return 254;
}

// MARK: - Email Validation

+ (BOOL)isValidEmail:(NSString *)email {
    NSString *emailRegex = @"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [predicate evaluateWithObject:email];
}

+ (BOOL)isEmailEmpty:(NSString *)email {
    return [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0;
}

+ (BOOL)isEmailTooLong:(NSString *)email {
    return email.length > self.maximumEmailLength;
}

// MARK: - Password Validation

+ (BOOL)isPasswordEmpty:(NSString *)password {
    return password.length == 0;
}

+ (BOOL)isPasswordTooShort:(NSString *)password {
    return password.length < self.minimumPasswordLength;
}

+ (BOOL)isPasswordTooLong:(NSString *)password {
    return password.length > self.maximumPasswordLength;
}

+ (BOOL)hasUppercaseLetter:(NSString *)password {
    NSRange range = [password rangeOfString:@"[A-Z]" options:NSRegularExpressionSearch];
    return range.location != NSNotFound;
}

+ (BOOL)hasLowercaseLetter:(NSString *)password {
    NSRange range = [password rangeOfString:@"[a-z]" options:NSRegularExpressionSearch];
    return range.location != NSNotFound;
}

+ (BOOL)hasNumber:(NSString *)password {
    NSRange range = [password rangeOfString:@"[0-9]" options:NSRegularExpressionSearch];
    return range.location != NSNotFound;
}

+ (BOOL)hasSpecialCharacter:(NSString *)password {
    NSString *specialCharacters = @"!@#$%^&*()_+-=[]{}|;:'\",.<>/?`~";
    return [password rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:specialCharacters]].location != NSNotFound;
}

+ (NSInteger)calculatePasswordStrength:(NSString *)password {
    NSInteger score = 0;
    
    if (password.length >= self.minimumPasswordLength) score++;
    if (password.length >= 12) score++;
    if ([self hasUppercaseLetter:password]) score++;
    if ([self hasLowercaseLetter:password]) score++;
    if ([self hasNumber:password]) score++;
    if ([self hasSpecialCharacter:password]) score++;
    
    return MIN(score, 5);
}

+ (BOOL)isPasswordStrong:(NSString *)password {
    return [self calculatePasswordStrength:password] >= 3;
}

// MARK: - Name Validation

+ (BOOL)isNameEmpty:(NSString *)name {
    return [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0;
}

+ (BOOL)isNameTooShort:(NSString *)name {
    NSString *trimmedName = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedName.length < self.minimumNameLength;
}

+ (BOOL)isNameTooLong:(NSString *)name {
    return name.length > self.maximumNameLength;
}

+ (BOOL)hasValidNameCharacters:(NSString *)name {
    NSString *nameRegex = @"^[a-zA-Z\\s\\-'']+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    return [predicate evaluateWithObject:name];
}

// MARK: - General Validation

+ (BOOL)isEmptyOrWhitespace:(NSString *)string {
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0;
}

+ (BOOL)stringsMatch:(NSString *)string1 string2:(NSString *)string2 {
    return [string1 isEqualToString:string2];
}

@end