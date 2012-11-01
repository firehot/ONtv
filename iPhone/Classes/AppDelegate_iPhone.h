


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "LoginScreenViewController.h"
#import "FavoriteChannelsViewController.h"
#import "LoginProxy.h"
#import "CreateNewAccountViewController.h"
#import "DeviceProxy.h"
#import "ONTVContainerViewController.h"
#import "iPadCreateNewAccountViewController.h"

#import <FacebookSDK/FacebookSDK.h>

extern NSString *const FBSessionStateChangedNotification;

@interface AppDelegate_iPhone : NSObject <UIApplicationDelegate,LoginProxyDelegate,DeviceProxyDelegate, UIAlertViewDelegate> {
    
    UIWindow *window;	

	NSMutableArray *channelArray;

	User *user;
	
    NSString *authenticationToken;
	
    UIViewController *currentViewController;
	
    BOOL isGuest;
    
    NSString *pushProgramId;
    
}

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) NSMutableArray *channelArray;

@property (nonatomic, strong) User *user;

@property (nonatomic, copy) NSString *authenticationToken;

@property (nonatomic, strong) UIViewController *currentViewController;

@property (nonatomic, assign) BOOL isGuest;

@property (nonatomic, strong) FavoriteChannelsViewController *favoriteChannelsViewController;

@property (nonatomic, strong) LoginScreenViewController *loginScreenViewController;

@property (nonatomic, strong) CreateNewAccountViewController *createNewAccountViewController;

@property (nonatomic, strong) iPadCreateNewAccountViewController *iPadCreateNewAccountViewControlle;

@property (nonatomic, assign) MenuBarButton selectedMenuItem;  

@property (nonatomic, strong) UINavigationController *rootNavController;

@property (nonatomic, copy) NSString *pushProgramId;

@property (nonatomic, strong) DeviceProxy *deviceProxy;

@property (nonatomic, strong) LoginProxy *loginProxy;

@property (nonatomic, readonly, strong) ONTVContainerViewController *containerViewController;


- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;

- (void)showSplashScreen;

- (void)hideSplashScreen;

- (CATransition *)getAnimation;

- (void)addNavigationControllerToWindow;

- (void)removeNavigationControllerFromWindow;

- (void)addLoginScreenToWindow;

- (void)removeLoginScreenFromWindow;

- (void)showMainMenu;

- (void)showLoginScreen;

- (void)registerforPushNotification:(NSDictionary*)launchOption;

- (void)handleRemoteNotification:(NSDictionary*)userInfo appState:(NSString*)state;

- (void)getAllRegisterDevices;

- (void)registerCurrentDeviceTORemoteServer;

- (void)showPushMessageDetails;

- (void)createLoginProxy;

- (void)createDeviceProxy;

@end

