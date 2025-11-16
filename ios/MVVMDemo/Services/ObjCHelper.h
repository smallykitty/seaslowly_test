#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ObjCHelper : NSObject

- (instancetype)init;
- (NSString *)getWelcomeMessage;
- (NSString *)processData:(NSString *)input;

@end

NS_ASSUME_NONNULL_END
