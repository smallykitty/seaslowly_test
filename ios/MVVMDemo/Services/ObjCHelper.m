#import "ObjCHelper.h"

@implementation ObjCHelper

- (instancetype)init {
    self = [super init];
    if (self) {
        NSLog(@"ObjCHelper initialized");
    }
    return self;
}

- (NSString *)getWelcomeMessage {
    return @"Hello from Objective-C! 🎉";
}

- (NSString *)processData:(NSString *)input {
    return [NSString stringWithFormat:@"Processed: %@", input];
}

@end
