

#import <Foundation/Foundation.h>

@interface PasswordSecurity : NSObject


+ (NSString *)md5:(NSString *)str;
+ (NSString *)base64Encode:(NSData *)data;

@end
