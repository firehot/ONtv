

#import "AppDelegate_iPad.h"
#import "DatabaseMigrator.h"
#import "AbstractRepository.h"
#import "Channel.h"
#import "SplashScreenViewControler.h"
#import "PasswordSecurity.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UIDevice+IdentifierAddition.h"
#import "DeviceDataModel.h"


#define CURRENT_SCHEMA_VERSION 0

@interface AppDelegate_iPad ()
@property (nonatomic, readwrite, strong) ONTVContainerViewController *containerViewController;
@end

@implementation AppDelegate_iPad

@synthesize loginScreenViewController = _loginScreenViewController;

@synthesize favoriteChannelsViewController = _favoriteChannelsViewController;

@synthesize createNewAccountViewController = _createNewAccountViewController;

@synthesize selectedMenuItem = _selectedMenuItem;

@synthesize rootNavController = _rootNavController;

@synthesize pushProgramId = _pushProgramId;

@synthesize deviceProxy = _deviceProxy;

@synthesize loginProxy = _loginProxy;

@synthesize containerViewController = _containerViewController;



#pragma mark - 
#pragma mark View Controller methods

- (void)addNavigationControllerToWindow {
    NSLog(@"***************************************************************");
    NSLog(@"In addNavigationControllerToWindow Ipad");
    NSLog(@"***************************************************************");  
    
    CATransition * animation = [self getAnimation];	
    
    FavoriteChannelsIPadViewController *vcTemp = [FavoriteChannelsIPadViewController new];
    self.favoriteChannelsViewController = vcTemp;
    
    ONTVContainerViewController *containerViewController = [[ONTVContainerViewController alloc] initWithRootViewController:self.favoriteChannelsViewController];
    
    self.rootNavController = containerViewController.ontvNavigationController;
    self.containerViewController = containerViewController;
    containerViewController = nil;
    
    [self.window insertSubview:self.containerViewController.view atIndex:0];
    
    [self.window exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
	[[self.window layer] addAnimation:animation forKey:@"HideLogin"];	
    
}



#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch
   NSLog(@"***************************************************************");
   NSLog(@"In didFinishLaunchingWithOptions Ipad");
   NSLog(@"***************************************************************");  
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];  
    application.applicationIconBadgeNumber = -1;
    self.pushProgramId = @"-1";
    
//    [self registerforPushNotification:launchOptions];
	[self initializeDatabase];
    [self showSplashScreen];     
    
   [window makeKeyAndVisible];
    return YES;
}

@end
