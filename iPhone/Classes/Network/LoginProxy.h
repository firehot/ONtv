


#import <Foundation/Foundation.h>
#import "Proxy.h"
#import "User.h"


@protocol LoginProxyDelegate <NSObject>
@required

-(void)loginFailed:(NSString *)error;

@optional

-(void)loginSuccessful :(User *)user;

-(void)postDataSuccess : (NSString *) response;

@end

@interface LoginProxy : Proxy {
    
	id<LoginProxyDelegate>__weak loginProxyDelegate;	
}

@property (nonatomic, weak) id<LoginProxyDelegate>loginProxyDelegate;


- (void)getCredentialsWithUsername:(NSString *)username andBase64Value:(NSString *)password;

- (void)postUserWithKey:(NSString *)tokenKey andUsername : (NSString *)username andUser:(NSDictionary *)user;

- (void)parseUser:(NSString *)responseStr;

- (void)postUser:(NSString *)responseStr;

@end
