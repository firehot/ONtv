

#import "AppDelegate_iPhone.h"
#import "DatabaseMigrator.h"
#import "AbstractRepository.h"
#import "Channel.h"
#import "SplashScreenViewControler.h"
#import "PasswordSecurity.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UIDevice+IdentifierAddition.h"
#import "DeviceDataModel.h"

#import <FacebookSDK/FacebookSDK.h>

#define CURRENT_SCHEMA_VERSION 0

//NSString *const FBSessionStateChangedNotification = @"com.example.Login:FBSessionStateChangedNotification";

@interface AppDelegate_iPhone ()

@property (nonatomic, readwrite, strong) ONTVContainerViewController *containerViewController;
@end




@implementation AppDelegate_iPhone
NSString *const FBSessionStateChangedNotification = @"com.example.Login:FBSessionStateChangedNotification";

@synthesize window;

@synthesize channelArray;

@synthesize user;

@synthesize authenticationToken;

@synthesize currentViewController;

@synthesize isGuest;

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
#pragma mark Facebook
/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                NSLog(@"User session found");
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"publish_actions", nil];
    return [FBSession openActiveSessionWithPermissions:permissions
                                          allowLoginUI:allowLoginUI
                                     completionHandler:^(FBSession *session,
                                                         FBSessionState state,
                                                         NSError *error) {
                                         [self sessionStateChanged:session
                                                             state:state
                                                             error:error];
                                     }];
}

#pragma mark -


// we initialze the data base.
// If the database is change then we migrate the changes withput loosing the previous data. it is usefull when we launch new version of app to app store with database change.
// As per new iOS 5 guide lines if  we save any file in document directory it will be backed up at icloud by default. To prevent this we can mark the save file in document directory with with skip backup attribute.

-(void)initializeDatabase {
	
	DatabaseMigrator *dbMigrator = [[DatabaseMigrator alloc] initWithDatabaseFile:[AbstractRepository databaseFilename]];
	//for development only - toggle this to force the new database over
	//dbMigrator.overwriteDatabase = YES;
	
	[dbMigrator moveDatabaseToUserDirectoryIfNeeded];
	[dbMigrator migrateToVersion:CURRENT_SCHEMA_VERSION];
	
    
    BOOL marked = [UIControls addSkipBackupAttributeToItemAtURL:[AbstractRepository databasePath]];
    
    if (marked) {
        
        DLog(@"succesfully Marked do not back up");
    } else {
        DLog(@"failed Marked do not back up");
        
    }
}

// It show up the app launch screen.
// assign time to show.

-(void)showSplashScreen {
    
	SplashScreenViewControler *splashScreenViewControler = [[SplashScreenViewControler alloc] init];
    [splashScreenViewControler.view setTag:2001];
    [self.window addSubview:splashScreenViewControler.view];
	[self performSelector:@selector(hideSplashScreen) withObject:nil afterDelay:1];
}

// gets called when splash screen show time completes(expires).
// It check in what state user has left the app previuosly. i.e login, guest, or logout, depending on this it show the login or home screen to user.


- (void)hideSplashScreen {
        
    NSString *guestLogin = [[NSUserDefaults standardUserDefaults] valueForKey:@"GUEST"];

    if ([guestLogin isEqualToString:@"YES"]) {
       
        self.isGuest = YES;
        
        [self addNavigationControllerToWindow];
        
        [[self.window viewWithTag:2001] removeFromSuperview];

        return;
    } 
    
    
	NSArray *users = [User getUserFromDB];
    
	if([users count] != 0) {
	
        self.user = [users objectAtIndex:0];
	
    }
	
	if(self.user) {
				
		NSString *password = self.user.password;
		
        NSString *token = [self.user.email stringByAppendingFormat:@":%@",password];
		
        NSData *tokenData = [token dataUsingEncoding:NSUTF8StringEncoding];
		
        NSString *base64Value = [PasswordSecurity base64Encode:tokenData];
		
        self.authenticationToken = base64Value;
        
        [self createLoginProxy];
        
        [self.loginProxy getCredentialsWithUsername:self.user.email andBase64Value:self.authenticationToken];
		        
        [self addNavigationControllerToWindow];
	
    } else {
        
		self.currentViewController = self.loginScreenViewController;
		
        [self.window insertSubview:self.loginScreenViewController.view atIndex:0];
        
        [self addLoginScreenToWindow];
	}
		
    //remove SplashScreen
    [[self.window viewWithTag:2001] removeFromSuperview];
    
}

- (CATransition *) getAnimation {
	CATransition *animation = [CATransition animation];
	[animation setDelegate:self];
	[animation setType:kCATransitionFade];
	[animation setDuration:0.2f];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	return animation;
}


#pragma mark -
#pragma mark Login proxy delegate methods

-(void)loginFailed:(NSString *)error {
	
}

-(void)loginSuccessful :(User *)getuser {
	
    self.user = getuser;
	[self.favoriteChannelsViewController callFavoriteChannelProxy];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    
    DLog(@"*****************didFinishLaunchingWithOptions*************************");
    
#ifdef TESTFLIGHT
    // testflight sdk debugger
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
    [TestFlight takeOff:TESTFLIGHT_TEAM_ID];
#endif

    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];  
    
    application.applicationIconBadgeNumber = -1;
    self.pushProgramId = @"-1";

    [self registerforPushNotification:launchOptions];
	[self initializeDatabase];
    [self showSplashScreen];
    [window makeKeyAndVisible];
    

    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
    DLog(@"*****************applicationWillResignActive*************************");
    
}

- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)newStatusBarFrame {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    
    DLog(@"*****************applicationDidEnterBackground*************************");

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    
    DLog(@"*****************applicationWillEnterForeground*************************");

}

// methods get called when app come to foreground from background
// here we check. if the app is made active due to push notification if tyes then we do not refresh the screeen. else we post notification to refresh the screens.

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    if (FBSession.activeSession.state == FBSessionStateCreatedOpening) {
        [FBSession.activeSession close]; // so we close our session and start over
    }
    
    
    DLog(@"*****************applicationDidBecomeActive*************************");
    
    
    if([self.pushProgramId isEqualToString:@"-1"]) {
        
        
        DLog(@"*****************applicationDidBecomeActive 1*************************");

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_SCREEN"
                                                        object:self
                                                      userInfo:nil];
        
        DLog(@"*****************applicationDidBecomeActive 2*************************");

    }
    
}


- (void)applicationWillTerminate:(UIApplication *)application {

    [FBSession.activeSession close];
    
    DLog(@"*****************applicationWillTerminate*************************");

}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}




#pragma mark -
#pragma swap view on window.


// It calls method to add login screen to window and remove navigation controller from window.

- (void)showLoginScreen {
    
    [self removeNavigationControllerFromWindow];
    [self addLoginScreenToWindow];
    
}

// It calls method to add navigation controller (i.e main menu) to window and remove login screen from window.


- (void)showMainMenu {
    if (self.createNewAccountViewController)
    {
        [self.loginScreenViewController dismissModalViewControllerAnimated:YES];
    }
    [self removeLoginScreenFromWindow];
    [self addNavigationControllerToWindow];
}


// add navigation controller to windows.

- (void)addNavigationControllerToWindow {
    
    CATransition * animation = [self getAnimation];	
    
    FavoriteChannelsViewController *vcTemp = [[FavoriteChannelsViewController alloc] init];
    self.favoriteChannelsViewController = vcTemp;
    
    ONTVContainerViewController *containerViewController = [[ONTVContainerViewController alloc] initWithRootViewController:self.favoriteChannelsViewController];
    
    self.rootNavController = containerViewController.ontvNavigationController;
    self.containerViewController = containerViewController;
     containerViewController = nil;
    
    [self.window insertSubview:self.containerViewController.view atIndex:0];
    
    [self.window exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
	[[self.window layer] addAnimation:animation forKey:@"HideLogin"];	
    
}

// removes navigation controller to window. 

- (void)removeNavigationControllerFromWindow {
    
    //[self.favoriteChannelsViewController.view removeFromSuperview];
    [self.containerViewController.view removeFromSuperview];
    
}

// adds login screen view controller to window.

- (void)addLoginScreenToWindow {
    
    
    CATransition * animation = [self getAnimation];	
    
    
    if(!self.loginScreenViewController) {
		LoginScreenViewController *vcTemp = [[LoginScreenViewController alloc] initWithNibName:nil bundle:nil];
		self.loginScreenViewController = vcTemp;
	}
    
    [self.window insertSubview:self.loginScreenViewController.view atIndex:0];
    
    [self.window exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
	[[self.window layer] addAnimation:animation forKey:@"HideLogin"];	
    
    
}

// remove login screen view controller from window.

- (void)removeLoginScreenFromWindow {
    
    [self.loginScreenViewController.view removeFromSuperview];
    [self.createNewAccountViewController.view removeFromSuperview];
}



#pragma mark - Push Notification Methods and Its Delegate 

// This method is called to register device to APNS Server to enable Push notfications.

- (void)registerforPushNotification:(NSDictionary*)launchOption {
    
#if !TARGET_IPHONE_SIMULATOR
	
	// Add registration for remote notifications		

	[[UIApplication sharedApplication] 
     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
	NSDictionary *remoteNotif = [launchOption objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (remoteNotif) {	
        
        [self handleRemoteNotification:remoteNotif appState:APP_LAUNCH];
    }   
	
#endif
    
}

// gets called once the app is register to APNS server.
// It return Device token which is use for sending the push Notification.

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
	
    
#if !TARGET_IPHONE_SIMULATOR
    
    DLog(@"*****************didRegisterForRemoteNotificationsWithDeviceToken*************************");

	
	NSString *deviceToken = [[[[devToken description] 
							   stringByReplacingOccurrencesOfString:@"<"withString:@""] 
							  stringByReplacingOccurrencesOfString:@">" withString:@""] 
							 stringByReplacingOccurrencesOfString: @" " withString: @""];
    
     
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:deviceToken forKey:@"DEVICE_TOKEN"];
    [defaults synchronize];
    
    
#endif
    
}

// get called when application fails to register the device to APNS server for push notification.

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	
#if !TARGET_IPHONE_SIMULATOR
	
    DLog(@"*****************didFailToRegisterForRemoteNotificationsWithError*************************");

	NSLog(@"Error in registration. Error: %@", error);
    
#endif    
    
}



// gets called when app receive the push notification.
// it check at the time of notification app was in background or foreground and handle it accordingly.


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	
#if !TARGET_IPHONE_SIMULATOR
    
	application.applicationIconBadgeNumber = -1;
    
    
    DLog(@"*****************didReceiveRemoteNotification*************************");

        
   
    if ( application.applicationState == UIApplicationStateActive ) {
        // app was already in the foreground	
        [self handleRemoteNotification:userInfo appState:APP_RUNNING_FOREGROUND];
    }else {
        // app was just brought from background to foreground
        [self handleRemoteNotification:userInfo appState:APP_RUNNING_BACKGROUND];
    }
        
#endif
    
}


// get the message, and other data from the push notification objects.
// if the app was in fore ground at the time of notification then it first show's the message, and then shows the calls the summary screen detials as per users selection on alert view.
// if the app is in background at the time of notification, it call mehtod to show program detials in summary screen.
// call's the method to show the program details in summary screen.141331302800




- (void)handleRemoteNotification:(NSDictionary*)userInfo appState:(NSString*)state {
    
    
    
    DLog(@"*****************handleRemoteNotification*************************");

    DLog(@"**PUSH NOTIFICATION DICTIONARY *** %@", userInfo);

    
	NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    
	NSString *alert = [apsInfo objectForKey:@"alert"];
    
    NSString *sound = [apsInfo objectForKey:@"sound"];
	//NSLog(@"sound %@",sound);
	NSString *path = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath],sound];
	SystemSoundID soundID;
	NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
	AudioServicesPlaySystemSound(soundID);
    
    
    NSNumber *programId = [userInfo objectForKey:@"programId"];
    
    
    DLog(@"**NSNUMBER *** %@", programId);

    
    self.pushProgramId = [NSString stringWithFormat:@"%@",programId];    
    
    DLog(@"**handleRemoteNotification*** %@", self.pushProgramId);

    
    if ([state isEqualToString:APP_RUNNING_FOREGROUND]) {
        
        UIAlertView *notificationAlert = [[UIAlertView alloc] initWithTitle:@"ONTV" 
                                                                    message:alert
                                                                   delegate:self 
                                                          cancelButtonTitle:@"Close" 
                                                          otherButtonTitles:@"View",nil];	
        
        [notificationAlert show];
        
   
    } else if ([state isEqualToString:APP_RUNNING_BACKGROUND]) {
        
         
        DLog(@"APP_RUNNING_BACKGROUND");
        
        [self showPushMessageDetails];

  
    } else if ([state isEqualToString:APP_LAUNCH]) {
        
        DLog(@"APP_LAUNCH");
        
    }
    
}

#pragma mark 
#pragma mark Device API Methods and Delegate

// This method gets called when user select "show" on push notification alert message. when app is launched or was in foreground.

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
 
    if (buttonIndex == 1) {
        
        [self showPushMessageDetails];
    }
}

// show program detials of push notification message in summary screen.

- (void)showPushMessageDetails {
    

    DLog(@"**********showPushMessageDetails**********");

    [self.rootNavController popToRootViewControllerAnimated:YES];
    
    DLog(@"**********showPushMessageDetails2**********");

    self.selectedMenuItem = Favorite;
    
    [self.favoriteChannelsViewController showSelectedMenu];
    
    DLog(@"**********showPushMessageDetails3**********");

}


#pragma mark 
#pragma mark Device API Methods and Delegate

// It is called  to fetch user all devices from server.

- (void)getAllRegisterDevices {
    
    [self createDeviceProxy];
    
    DLog(@"getAllRegisterDevices*********************");

    [self.deviceProxy getDevices];
    
}

// It is called when device server request is succesfull.
// It checks if current device id is present, if not the registr it at server. 

- (void)receiveddevices:(NSMutableArray*)array {
    
    BOOL present = NO;
    UIDevice *deviceDetails = [UIDevice currentDevice];
    NSString *deviceUDID = deviceDetails.uniqueDeviceIdentifier;

    
    for (int i = 0; i < [array count]; i++) {
        
        DeviceDataModel *deviceDataModel = [array objectAtIndex:i];
        
        if ([deviceDataModel.deviceUDID isEqualToString:deviceUDID]) {
            
            present = YES;
            
            break;
        }        
    }
    
    if (!present) {
        
      [self registerCurrentDeviceTORemoteServer];
        
    }

}

- (void)deviceRequestFailed:(NSString *)error {
    

}


// register current device to server if not present.

- (void)registerCurrentDeviceTORemoteServer {
    

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [defaults valueForKey:@"DEVICE_TOKEN"];
    
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
	NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    
    DeviceDataModel *deviceDataObject = [[DeviceDataModel alloc] init];
    
    UIDevice *dev = [UIDevice currentDevice];
    
    deviceDataObject.notificationType = @"push";
    deviceDataObject.deviceType = dev.model;
    deviceDataObject.deviceName = dev.name;
    deviceDataObject.pushNotificationStatus = @"true";
    deviceDataObject.deviceUDID = dev.uniqueDeviceIdentifier;
    deviceDataObject.deviceToken = deviceToken;
    deviceDataObject.appName = appName;
    deviceDataObject.appVersion = appVersion;
    deviceDataObject.systemVersion = dev.systemVersion;
    
    [self createDeviceProxy];
    
    [self.deviceProxy addDevice:deviceDataObject];
    
    DLog(@"**********registerCurrentDeviceTORemoteServer**********");
    
    
}



#pragma mark -
#pragma mark - Proxy Creation 

// creates the proxy for Login requests and assigns delegates. 


- (void)createLoginProxy {
    

    if (!self.loginProxy) {
        
        LoginProxy *tempLoginProxy = [[LoginProxy alloc] init];
        
        self.loginProxy = tempLoginProxy;
       
        
    }

    [self.loginProxy setLoginProxyDelegate:self];
}

// creates the proxy for Device requests and assigns delegates. 

- (void)createDeviceProxy {
    
    if (!self.deviceProxy) {
        
        DeviceProxy *tempDeviceProxy = [[DeviceProxy alloc] init];
        
        self.deviceProxy = tempDeviceProxy;
        
        
    }
    
    [self.deviceProxy setDeviceProxyDelegate:self];
}


@end
