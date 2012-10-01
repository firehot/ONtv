

#import "ONTVUIViewController.h"
#import "LoginProxy.h"

@interface LoginScreenViewController : ONTVUIViewController <LoginProxyDelegate> {
    
	__weak UIButton *loginButton;	
	__weak UIButton *continueButton;	
    __weak UIButton *createNewUserButton;
	__weak LoginProxy *loginProxy;
	BOOL isLogin;
	BOOL shouldCallLoginAPI;
	NSString *tokenString;
               
}

@property (nonatomic, weak) UIButton *loginButton;	

@property (nonatomic, assign) BOOL isLogin;

@property (nonatomic, copy) NSString *tokenString;

@property (nonatomic, assign) BOOL fromPlanView;

@property (nonatomic, weak) UILabel *subscriptionLabel;

@property (nonatomic, strong) LoginProxy *loginProxy;


@end
