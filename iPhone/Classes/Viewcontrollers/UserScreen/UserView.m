
#import "UserView.h"
#import "User.h"
#import "DeviceDataModel.h"
#import "UIDevice+IdentifierAddition.h"
#import "UserRepository.h"
#import "UserCell.h"


@interface UserView ()

- (void)setLocalizedValues;

- (void)createUI;

- (void)createUserTableView;

- (void)logoutButtonClicked;

- (void)fetchDeviceDetails;

- (void)removeDeviceDetails:(NSString*)deviceID;

- (void)addDevicesDetails:(DeviceDataModel*)deviceObject;

- (void)populateShowShortSummaryCell:(UITableViewCell*)summaryCell;

- (void)populateLogoutCell:(UITableViewCell*)LogoutCell;

- (NSMutableDictionary*)createDictionary;

- (void)callCreateUserProxy;

- (void)createLoginProxy;

- (void)createDeviceProxy; 

@end

NSString *logOutButtonStr;
NSString *logOutCellHeaderStr;
NSString *settingsCellHeaderStr;
NSString *pushNotificationCellHeaderStr;

@implementation UserView

@synthesize deviceIdArray = _deviceIdArray;

@synthesize deviceProxy = _deviceProxy;

@synthesize loginProxy = _loginProxy;
@synthesize tvCell;


#pragma mark -
#pragma mark Life Cycle Methods


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        [self createUI];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

    
#pragma mark -
#pragma mark Create UI

- (void)setLocalizedValues {
    
  logOutButtonStr = NSLocalizedString(@"Logout",@"User Screen, Logout Button Title Text");
  
  logOutCellHeaderStr = NSLocalizedString(@"Logout Cell",@"User Screen, Logout Cell Header Text");
    
  settingsCellHeaderStr = NSLocalizedString(@"Settings",@"User Screen, Settings Cell Header Text");
  
  pushNotificationCellHeaderStr = NSLocalizedString(@"Push Notification Cell",@"User Screen, Push Notification Cell Header Text");
}

// creates the UI.
// If user is not logged in the displays the login screen.
// Register for Status Bar Height Change i.e when incomming call
// Register for refresh screen notification when app enters fore ground from back ground.

- (void)createUI 
{
    [UIControls registerRefreshScreenNotificationsFor:self];

    [self setBackgroundColor:[UIColor whiteColor]];
        
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    if (appDelegate.user && !appDelegate.isGuest) {
    

        [self setLocalizedValues];
        
        [self createUserTableView];
        
        [self fetchDeviceDetails];
        
    }  else {
        
        [self logoutButtonClicked];
    }
}  
    

- (void)createUserTableView {
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height)];
    _userTableView = tableView;
        
	[_userTableView setDelegate:self];
	[_userTableView setDataSource:self];
	[_userTableView setBackgroundColor:[UIColor clearColor]];
	[_userTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
	[_userTableView setShowsVerticalScrollIndicator:YES];
    [_userTableView setBounces:YES];
    
    _userTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
	[self addSubview:_userTableView];
    
}


#pragma mark - 
#pragma mark - createTableView 

// returns numbers of rows in each sections of table view.


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    /*
    if (section == 0) {
        
        AppDelegate_iPhone *appDelegate = DELEGATE;	

        if ([appDelegate.user.subscription isEqualToString:PRO_USER] || [appDelegate.user.subscription isEqualToString:PLUS_USER]) {
        
            return 2;
        
        } else {
          
            return 1;
        }
         
    
    } else {
           
        return [self.deviceIdArray count];
    }
    */
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    bool isProOrPlus = [appDelegate.user.subscription isEqualToString:PRO_USER] || [appDelegate.user.subscription isEqualToString:PLUS_USER];
    
    if (isProOrPlus)
    {
        if (section == 0)
        {
            return 2;
        }
        else 
        {
            return [self.deviceIdArray count];
        }
    } 
    else
    {
        if (section == 0)
        {
            return 1;
        }
        else 
        {
            return [self.deviceIdArray count];
        }
    }
}

// returns numbers od sections in table view.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  
{
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    bool isProOrPlus = [appDelegate.user.subscription isEqualToString:PRO_USER] || [appDelegate.user.subscription isEqualToString:PLUS_USER];
   
    if ([self.deviceIdArray count] > 0)
    {
        if(isProOrPlus)
            return 2;
        else
            return 2;
    } 
    else 
    {
        return 1; 
    }
}

// returns which sections are editable in table view.

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    if ([indexPath section] == 0) {
        
        return NO;
        
    } else {
        
        return YES;
    }
    
}


// gets called when user delete the row from the table view.

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        
       DeviceDataModel *deviceObject = [self.deviceIdArray objectAtIndex:[indexPath row]];
        
        [self removeDeviceDetails:deviceObject.deviceToken];
    } 
    
}

// gets called when user toggle between the switch in the table view.

- (void)switchChanged:(UISwitch*)switchControl {

        [self callCreateUserProxy];       
}

// create reusable cell and assign values to it.
// It create short summary cell if the user is pro or plus

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if ([indexPath section] == 0 &&indexPath.row==0)
    {
        UserCell *cell = (UserCell *) [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"UserCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
            
            
        }
        cell.loggedInLabel.text=logOutCellHeaderStr;
        AppDelegate_iPhone *appDelegate = DELEGATE;
        cell.userName.text=appDelegate.user.name;
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:appDelegate.user.img]]];
        [cell.userImage setImage:image];
        cell.logoutButton.titleLabel.text=logOutButtonStr;
        [cell.logoutButton addTarget:self action:@selector(logoutButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell =  (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [cell.textLabel setTextColor:[UIUtils colorFromHexColor:@"000000"]];
    } 
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    bool isProOrPlus = [appDelegate.user.subscription isEqualToString:PRO_USER] || [appDelegate.user.subscription isEqualToString:PLUS_USER];
    
    
    
    if ([indexPath section] == 0 &&indexPath.row==0)
    {
      //  [self populateLogoutCell:cell];
    }
    else
    if ([indexPath section] == 0 && isProOrPlus && indexPath.row==1 )
    {
        
        [self populateShowShortSummaryCell:cell];
    }
    else
    {
        DeviceDataModel *deviceObject = [self.deviceIdArray objectAtIndex:[indexPath row]];
        
        NSLog(@"Device Name: %@", deviceObject.deviceName);
        
        [cell.textLabel setText:deviceObject.deviceName];
        [cell.detailTextLabel setText:deviceObject.deviceType];
        [cell.detailTextLabel setFont:[UIFont fontWithName:HELVETICA size:12]];
    
        UIButton *pushButton = [UIControls  createUIButtonWithFrame:CGRectMake(0, 0, 70, 33)];
        
        if ([deviceObject.pushNotificationStatus isEqualToString:@"true"]) {
            
            [pushButton setImage:[UIImage imageNamed:@"bg_checkbox_checked"] forState:UIControlStateNormal]; 
       
        } else {
            
            [pushButton setImage:[UIImage imageNamed:@"bg_checkbox"] forState:UIControlStateNormal]; 
            
        }
        
        [pushButton addTarget:self action:@selector(pushNotificationStatusButtonClicked:)
            forControlEvents:UIControlEventTouchUpInside];
        
        [pushButton setTag:[indexPath row]];
        
        [cell setAccessoryView:pushButton];
    }
    
    return cell;
}

// assign values to logout cell.

- (void)populateLogoutCell:(UITableViewCell*)LogoutCell {
    
    UIButton *logoutButton = [UIUtils createRedButtonWithTitle: logOutButtonStr addTarget:self action:@selector(logoutButtonClicked)];
    [LogoutCell setAccessoryView:logoutButton];
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    [LogoutCell.textLabel setText:appDelegate.user.name];
}

// assign values to short summary cells.

- (void)populateShowShortSummaryCell:(UITableViewCell*)summaryCell {
    
    [summaryCell.textLabel setText: NSLocalizedString(@"Show short summary in listings", nil)];
    
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    summarySwitch = switchView;
    
    [summarySwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    if ([summarySwitch respondsToSelector:@selector(setOnTintColor:)]) {
        
        [summarySwitch setOnTintColor:[UIUtils colorFromHexColor:@"b00a4f"]];
    }
    

    AppDelegate_iPhone *appDelegate = DELEGATE;

    
    if ([appDelegate.user.deviceSummaryListing isEqualToString:@"1"]) {
        
        [summarySwitch setOn:YES animated:NO];
        
    } else  {
        
        [summarySwitch setOn:NO animated:NO];
    }
    
    [summaryCell setAccessoryView:summarySwitch];
    
}


#pragma mark -
#pragma mark Table view delegate

// returns height of each row.

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath 
{
    if (indexPath.row==0 && indexPath.section==0) {
        return 132;
    }
    return 44;
}

// returns height of each sections.

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section 
{
    if (section==0) {
        return 0;
    }
    return 45;
    
}

// returns view for section header.

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
        
   // UIView *headerView = [UIControls createUIViewWithFrame:CGRectMake(0, 0, self.bounds.size.width, 45) BackGroundColor:LIGHTGRAY];
    UIView *headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 45)];
    UIImageView *back=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_title.png"]];
    [headerView addSubview:back];
    
    UILabel *headerLabel = [UIControls createUILabelWithFrame:CGRectMake(10, 0, self.bounds.size.width - 10, 45) FondSize:15 FontName:SYSTEMBOLD FontHexColor:@"ffffff" LabelText:@""];
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    bool isProOrPlus = [appDelegate.user.subscription isEqualToString:PRO_USER] || [appDelegate.user.subscription isEqualToString:PLUS_USER];
    
    if (section == 0) {
       
      //  [headerLabel setText:logOutCellHeaderStr];
    }
    else
    if (section == 1 && isProOrPlus)
    {
  
        [headerLabel setText:pushNotificationCellHeaderStr];        
    }
    
    [headerView addSubview:headerLabel];
    
    return headerView;
}



#pragma mark -
#pragma mark Button clicked Events 


// events gets called when user click on logout button.

- (void)logoutButtonClicked {
    
    AppDelegate_iPhone *appDelegate = DELEGATE;	

	
    if(appDelegate.user)
    {
        [User deleteUser:appDelegate.user.name];
        appDelegate.user = nil;
    }
        
    if(appDelegate.authenticationToken)
        appDelegate.authenticationToken = nil;
    
    [appDelegate showLoginScreen];

}

// event gets called when users toggle between the send push notification checkmark on row.
// it enable user to select there device which should receive push notification and vise versa.

- (void)pushNotificationStatusButtonClicked:(UIButton*)button {
    
    DeviceDataModel *deviceObject = [self.deviceIdArray objectAtIndex:button.tag];
    
    if ([deviceObject.pushNotificationStatus isEqualToString:@"true"]) {
       
        deviceObject.pushNotificationStatus = @"false";
        
    } else {

        deviceObject.pushNotificationStatus = @"true";        
        
    }
    
    [self addDevicesDetails:deviceObject];
    
}


#pragma mark -
#pragma mark Server Communication Methods 

// fetches all all devices details of user from server.

- (void)fetchDeviceDetails {
    
    [self createDeviceProxy];
    
    
    [self.deviceProxy getDevices];

}


// remove the device details of user from server. 

- (void)removeDeviceDetails:(NSString*)deviceID {
        
    [self createDeviceProxy];

    [self.deviceProxy  deleteDevice:deviceID];
}

// updates device's Push notification status to server.

- (void)addDevicesDetails:(DeviceDataModel*)deviceObject {
        
    [self.deviceProxy addDevice:deviceObject];

}



#pragma mark -
#pragma mark Device Proxy Delegate Method 

// gets called when devices request fails.

- (void)deviceRequestFailed:(NSString *)error {
    
}

// gets called when Device GET Request is successfull.

- (void)receiveddevices:(NSMutableArray*)array {
    
    [self.deviceIdArray removeAllObjects];
    
    self.deviceIdArray = array;
    
    [_userTableView reloadData];
    
}

// gets called when Device details is Deteled Successfully. 

- (void)deviceDeletedSuccesfully {
   
    [self fetchDeviceDetails];

}


// gets called when device push notification status is updatd successfully.

- (void)deviceAddedSuccesfully {
    
    [self fetchDeviceDetails];
}






#pragma mark -
#pragma mark - Refresh Screen Notification Method

// This method is call when application enters to foreground from background state.

- (void)refreshScreen {
    
      [self fetchDeviceDetails];
}



#pragma mark -
#pragma mark - login Proxy method and its Delegate Methods


// This proxy method is called when every user change the Divice Summary listing status 

- (void)callCreateUserProxy {
    
    AppDelegate_iPhone *appDelegate = DELEGATE;

    [self createLoginProxy];
    
    [self.loginProxy postUserWithKey:appDelegate.authenticationToken andUsername:appDelegate.user.email andUser:[self createDictionary]];
    
}

// create dictionary for post request  
// i.e when users want to change the push notification status.

-(NSDictionary *) createValueDictionary : (NSString *) value {
    
	NSMutableDictionary *valueDict = [[NSMutableDictionary alloc] init];
	
    [valueDict setValue:value forKey:@"$"];
	
    return valueDict;
    
}

- (NSMutableDictionary*)createDictionary {
    
    NSString *switchStatus = nil;
    
    if (summarySwitch.on) {
        
        switchStatus = @"1";
        
    } else {

        switchStatus = @"0";        
    }

    
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
    
         
    AppDelegate_iPhone *appDelegate = DELEGATE;

   
    
    NSDictionary *settingInnerDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"DEVICE_SUMMARY_LISTING",@"@name",
                                     switchStatus, @"@value",nil]; 


    NSDictionary *settingDic = [[NSDictionary alloc]initWithObjectsAndKeys:
                                settingInnerDic,@"setting",nil];
    
    
    NSDictionary *userEmailDic = [[NSDictionary alloc]initWithObjectsAndKeys:
                                appDelegate.user.email,@"$",nil];

    
    [userDict setValue:settingDic forKey:@"settings"];
    
    [userDict setValue:userEmailDic forKey:@"email"];
    
    return userDict;
}


// gets called when user post request for show summary screen is successfull.
// after the request is successfully, loacal data base of user is updated.

-(void)postDataSuccess: (NSString *) response {
    
    
    UserRepository *userRepository = [[UserRepository alloc] init];
    
    
    if (summarySwitch.on) {
        
        [userRepository updateUserSummaryListingStatus:@"1"];

      
    } else {
        
        [userRepository updateUserSummaryListingStatus:@"0"];
    }
    
}


// gets called when login request is fails.
// when  post reques for show short summary listing fails.

-(void)loginFailed:(NSString *)error {
    
    
}


#pragma mark -
#pragma mark - Proxy Creation 

// creates the proxy for Login/logout requests and assigns delegates. 


- (void)createLoginProxy {
    
     if (!self.loginProxy) {
    
        LoginProxy *tempLoginProxy = [[LoginProxy alloc] init];
        self.loginProxy = tempLoginProxy;
        
     }
    
    [self.loginProxy setLoginProxyDelegate:self];
}


// creates the proxy for Devices requests and assigns delegates. 

- (void)createDeviceProxy {
    
    if (!self.deviceProxy) {
        
        DeviceProxy *tempDeviceProxy = [[DeviceProxy alloc] init];
        self.deviceProxy = tempDeviceProxy;
    }
    [self.deviceProxy setDeviceProxyDelegate:self];
}

@end
