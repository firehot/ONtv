


#import "CreateNewAccountViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AnimationUtils.h"
#import "AppDelegate_iPhone.h"
#import "LoginScreenViewController.h"
#import "PasswordSecurity.h"
#import "ChannelRepository.h"
#import "FavoriteChannel.h"
#import "TPKeyboardAvoidingTableView+UITableViewStyle.h"
#import "TextFieldCell.h"


@interface CreateNewAccountViewController() <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) TPKeyboardAvoidingTableView *tableView;

@property (nonatomic, copy) NSString *nameLabelStr;
@property (nonatomic, copy) NSString *mobileLabelStr;
@property (nonatomic, copy) NSString *createPersonalAccountInfo;
@property (nonatomic, copy) NSString *backButtonStr;
@property (nonatomic, copy) NSString *createYourNewAccountButtonStr;
@property (nonatomic, copy) NSString *emailAddressLabelStr;
@property (nonatomic, copy) NSString *passwordLabelStr;
@property (nonatomic, copy) NSString *smsRegistrationLabelInfo;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;


- (void)configureCreateNewAccountView;
- (void)layoutHeaderView;
- (void)layoutFooterView;

- (void)setLocalizedValues;
- (void)fetchDefaultFavoriteChannels;
- (void)createChannelProxy;
- (void)createLoginProxy;

@end


@implementation CreateNewAccountViewController

@synthesize tableView = _tableView;
@synthesize defaultFavoriteChannelArray = _defaultFavoriteChannelArray;
@synthesize loginProxy = _loginProxy;
@synthesize channelProxy = _channelProxy; 

@synthesize nameLabelStr, mobileLabelStr, createPersonalAccountInfo, backButtonStr, createYourNewAccountButtonStr, emailAddressLabelStr, passwordLabelStr, smsRegistrationLabelInfo;

@synthesize name = _name, email = _email, mobile = _mobile, password = _password;

#pragma mark -
#pragma mark Create UI

- (void)setLocalizedValues {
    
    nameLabelStr = NSLocalizedString(@"Name",@"Create New User Screen, Name Label Text");
    emailAddressLabelStr = NSLocalizedString(@"Your Email Address",@"Create New User Screen, Email Address Label Text");
	passwordLabelStr = NSLocalizedString(@"Password",@"Login Screen & Creat New User Screen, Password Label Text");
	mobileLabelStr = NSLocalizedString(@"Mobile",@"Create New User Screen, Mobile Label Text");
	createPersonalAccountInfo = NSLocalizedString(@"Create New User Info",@"Create New User Screen,Create New User Info Label Text");
    backButtonStr = NSLocalizedString(@"Back",@"Back Button Title");
    
    createYourNewAccountButtonStr = NSLocalizedString(@"create Your New Account",@"Create New User Screen, Create Your New Account Button Title");
    
    smsRegistrationLabelInfo = NSLocalizedString(@"Register Mobile for SMS Info",@"Create New User Screen, Register Mobile for SMS Info Label Text");
    
}



#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super loadView];
    [self setLocalizedValues];
    [self configureCreateNewAccountView];
}


- (void)viewDidUnload
{
    self.tableView = nil;
    [super viewDidUnload];
}




#pragma mark -
#pragma mark User defined methods
#pragma mark -

- (void)layoutHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    CGFloat margin = 10.0f;
    
    // back button
    UIButton *backBtn = [UIUtils createBackButtonWithTarget:self action:@selector(backButtonClicked:)];
	
    backBtn.frame = CGRectMake(headerView.bounds.size.width - CGRectGetWidth(backBtn.frame) - margin, margin, CGRectGetWidth(backBtn.frame), CGRectGetHeight(backBtn.frame));
    backBtn.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
    
    
    [headerView addSubview:backBtn];
    backButton = backBtn;
    
    
    // logo
    UIImageView *ivTemp = [[UIImageView alloc] initWithFrame:CGRectMake(floorf(0.5f*(headerView.bounds.size.width - 150)), CGRectGetMaxY(backBtn.frame)+10, 150, 50)];	
	[ivTemp setImage:[UIImage imageNamed:@"loginLogo.png"]];
    ivTemp.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    
	[headerView addSubview:ivTemp];
    
    
    
    // labels
    CGSize suggestedSize = [createPersonalAccountInfo sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12.0f] constrainedToSize:CGSizeMake(headerView.bounds.size.width-50.0f, 60) lineBreakMode:UILineBreakModeWordWrap];  
    
	UILabel *createDetailsLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(ivTemp.frame)+20, headerView.bounds.size.width-50.0f, suggestedSize.height)];
    createDetailsLabel.lineBreakMode = UILineBreakModeWordWrap;
    createDetailsLabel.numberOfLines = 0;
    createDetailsLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
	createDetailsLabel.textColor = [UIColor whiteColor];
	createDetailsLabel.backgroundColor = [UIColor clearColor];
    createDetailsLabel.textAlignment = UITextAlignmentCenter;
    createDetailsLabel.text = createPersonalAccountInfo;
    
    createDetailsLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
	[headerView addSubview:createDetailsLabel];
    
    
    headerView.frame = CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, CGRectGetMaxY(createDetailsLabel.frame)+margin);
    
    self.tableView.tableHeaderView = headerView;
    headerView = nil;
    
}

- (void)layoutFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    
    CGFloat margin = 10.0f;
    
    // button
    createButton = [UIButton buttonWithType:UIButtonTypeCustom];
	createButton.frame = CGRectMake(footerView.bounds.size.width - margin - 180, 0, 180, 30); //70
	createButton.backgroundColor = [UIColor clearColor];
	createButton.userInteractionEnabled = YES;	
	createButton.tag = 2;	
    UIImage *image = [UIImage imageNamed:@"createUserBackground.png"];
    image = [image stretchableImageWithLeftCapWidth: 5 topCapHeight: 5];
	[createButton setBackgroundImage:image forState:UIControlStateNormal];
	[createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];	
    [createButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
	[createButton setTitle:createYourNewAccountButtonStr forState:UIControlStateNormal];
	createButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	[createButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];	
	[createButton addTarget:self action:@selector(createButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    createButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    
	[footerView addSubview:createButton];
    
    
    // mandatory label
    CGSize suggestedSize = [smsRegistrationLabelInfo sizeWithFont:[UIFont fontWithName:@"Helvetica" size:11.0f] constrainedToSize:CGSizeMake(footerView.bounds.size.width-20.0f, 40) lineBreakMode:UILineBreakModeWordWrap];
    
	UILabel *mandatoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(createButton.frame)+10, footerView.bounds.size.width-20.0f, suggestedSize.height)];
    mandatoryLabel.lineBreakMode = UILineBreakModeWordWrap;
    mandatoryLabel.numberOfLines = 0;
    mandatoryLabel.font = [UIFont fontWithName:@"Helvetica" size:11.0f];
	mandatoryLabel.textColor = [UIColor whiteColor];
	mandatoryLabel.backgroundColor = [UIColor clearColor];
    mandatoryLabel.textAlignment = UITextAlignmentCenter;
    mandatoryLabel.text = smsRegistrationLabelInfo;
    mandatoryLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
	[footerView addSubview:mandatoryLabel];
    
    footerView.frame = CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, CGRectGetMaxY(mandatoryLabel.frame)+margin);
    
    self.tableView.tableFooterView = footerView;
    footerView = nil;
}


- (void)configureCreateNewAccountView 
{
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginBackground.png"]];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginBackground.png"]];
    backgroundView.contentMode = UIViewContentModeScaleToFill;
    backgroundView.frame = self.view.bounds;
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:backgroundView];
    backgroundView = nil;
	
    TPKeyboardAvoidingTableView *tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView=nil;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView = nil;
    
    
    [self layoutHeaderView];
    [self layoutFooterView];
    
    
    // OMG!!!!!!
    AppDelegate_iPhone *appDelegate = DELEGATE;
    appDelegate.createNewAccountViewController = self;

    //[self addMandatoryDetailsLabel]; 
}



-(NSDictionary *) createValueDictionary : (NSString *) value {
    
	NSMutableDictionary *valueDict = [[NSMutableDictionary alloc] init];
	[valueDict setValue:value forKey:@"$"];
	return valueDict;
}

-(NSDictionary *) createDictionary {
	
	NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
	
	NSDictionary * nameDict = [self createValueDictionary:self.name];
	[userDict setValue:nameDict forKey:@"name"];    
	
	NSDictionary * phoneDict = [self createValueDictionary:self.mobile];
	[userDict setValue:phoneDict forKey:@"phone"];
	
	NSDictionary * emailDict = [self createValueDictionary:self.email];
	[userDict setValue:emailDict forKey:@"email"];
	
    NSDictionary * passwordDict = [self createValueDictionary:self.password];
    [passwordDict setValue:@"plain" forKey:@"@code"];
    [userDict setValue:passwordDict forKey:@"password"]; 
    
    
	NSMutableArray *channelsArray = [[NSMutableArray alloc] init];
    
	

    for (int i = 0; i < [self.defaultFavoriteChannelArray count]; i++) {
        
        FavoriteChannel *favChannelObj = [self.defaultFavoriteChannelArray  objectAtIndex:i];
        
        NSString *channelID = [[NSString alloc]initWithFormat:@"%d",favChannelObj.channel_id];
        
        NSString *channelOrder = [[NSString alloc]initWithFormat:@"%d",favChannelObj.channel_order];
        
      
        NSDictionary *channelDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   channelID,@"@id",channelOrder,@"@order",nil];
        
        
        [channelsArray addObject:channelDic];
        
        
        
        
    }
    
    
     NSDictionary *settingInnerDic = [[NSDictionary alloc] initWithObjectsAndKeys:
     @"DEVICE_SUMMARY_LISTING",@"@name",
     @"1", @"@value",nil]; 
     
     
     NSDictionary *settingDic = [[NSDictionary alloc]initWithObjectsAndKeys:
                                  settingInnerDic,@"setting",nil];
     
                                 
    [userDict setValue:settingDic forKey:@"settings"];
                                 
    
    
    NSDictionary *channelArrayDic = [[NSDictionary alloc] 
                                     initWithObjectsAndKeys:channelsArray,@"channel",nil];
    
    
	[userDict setValue:channelArrayDic forKey:@"channels"];
    

	
	DLog(@"UserDict : %@",userDict);
	
	return userDict;
	
}


- (void)callCreateUserProxy {
    
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    NSString *password = [PasswordSecurity md5:self.password];
    NSString *token = [self.email stringByAppendingFormat:@":%@",password];
    NSData *tokenData = [token dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Value = [PasswordSecurity base64Encode:tokenData];    
    appDelegate.authenticationToken = base64Value;
    
     [self createLoginProxy];
    
    [self.loginProxy postUserWithKey:base64Value andUsername:self.email andUser:[self createDictionary]];

}

#pragma mark -
#pragma mark Login proxy delegate methods
#pragma mark -

-(void)loginFailed:(NSString *)error {

}

-(void)postDataSuccess : (NSString *) response {
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    NSArray *users = [User getUserFromDB];
	if([users count] != 0) {
		appDelegate.user = [users objectAtIndex:0];
        [User deleteUser:appDelegate.user.name];
	}
    
    appDelegate.user = nil;
    appDelegate.isGuest = NO;
	User *newUser = [[User alloc] init];
    appDelegate.user = newUser;
    appDelegate.user.name = self.name;	
    appDelegate.user.phone = self.mobile;
    appDelegate.user.email = self.email;
	appDelegate.user.password = self.password;
    appDelegate.user.subscription = @"normal";
    
    [appDelegate.user save];
    
    [appDelegate showMainMenu];
        
}

#pragma mark -
#pragma mark Event handling methods
#pragma mark -

-(void) backButtonClicked : (UIButton *) sender 
{
    AppDelegate_iPhone *appDelegate = DELEGATE;

    if ([appDelegate.loginScreenViewController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [appDelegate.loginScreenViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [appDelegate.loginScreenViewController dismissModalViewControllerAnimated:YES];
    }
}

-(void) createButtonClicked : (UIButton *) sender {

    if([self.name isEqualToString:@""] || [self.email isEqualToString:@""]  || [self.password isEqualToString:@""] || self.name == nil || self.email == nil  || self.password == nil || ![self validateEmail:self.email]) {
        NSString *alertMessege;
        
        if (![self validateEmail:self.email]) {
            alertMessege = NSLocalizedString(@"Please provide us with a valid email address", nil);
        } else {
            alertMessege=@" ";
        }
        NSString *emptyFieldsWarning =NSLocalizedString(@"Please fill name, email and password as minimum", nil);
        NSString *resultMessege = [alertMessege stringByAppendingString:emptyFieldsWarning];
        [UIUtils alertView:resultMessege withTitle:@"Info"];
                
        
    } else {
        
        [self fetchDefaultFavoriteChannels];
            }

}
#pragma mark -
#pragma mark Validation

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegEx =@"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    return [emailTest evaluateWithObject:candidate];
}


#pragma mark -
#pragma mark Tableview datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *kCellIdentifier = @"LoginCell";
    
    TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];    
    if (cell == nil) {
        cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                    reuseIdentifier:kCellIdentifier];
        cell.textField.delegate = self;
    }
    
    cell.textField.tag = [indexPath row];
    
    if ([indexPath row] == 0) {
        
       // cell.textLabel.text = nameLabelStr;
        cell.textField.placeholder=nameLabelStr;
        cell.textField.secureTextEntry = NO;
        cell.textField.keyboardType = UIKeyboardTypeASCIICapable;
        cell.textField.text = self.name;
        
        
    } else if ([indexPath row] == 1) {
        
        //cell.textLabel.text = emailAddressLabelStr;
        cell.textField.placeholder=emailAddressLabelStr;
        cell.textField.secureTextEntry = NO;
        cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
        cell.textField.text = self.email;
      
        
    } else if ([indexPath row] == 2) {
        
        //cell.textLabel.text = mobileLabelStr;
        cell.textField.placeholder=mobileLabelStr;
        cell.textField.secureTextEntry = NO;
        cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        cell.textField.text = self.mobile;
    
        
    } else if ([indexPath row] == 3) {
        
        //cell.textLabel.text = passwordLabelStr;
        cell.textField.placeholder=passwordLabelStr;
        cell.textField.secureTextEntry = YES;
        cell.textField.keyboardType = UIKeyboardTypeASCIICapable;
        cell.textField.text = self.password;
        
        
    }
    
    return cell;
}


#pragma mark -
#pragma mark Textfield delegate methods


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{	
    
    if (textField.tag != [self.tableView numberOfRowsInSection:0]-1) {
        
        if (textField.tag>0) {
            [self.tableView adjustOffsetToIdealIfNeeded];
        }
        
        TextFieldCell *cell = (TextFieldCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag+1 inSection:0]];
        [cell.textField becomeFirstResponder];
        
        
    }
    else {
        [textField resignFirstResponder];
    }
    
    
	return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField.tag == 0) {
        self.name = text;
        
    } else if (textField.tag == 1) {
        self.email = text;
    
    } else if (textField.tag == 2) {
        self.mobile = text;
    
    } else if (textField.tag == 3) {
        self.password = text;
    }
    
    return YES;
}




#pragma mark
#pragma mark Channel Proxy Methods and Delgates



// get called when users want to fetch the default fav channels from locally/server.
// if locally not found then call the server request.

-(void)fetchDefaultFavoriteChannels {

    ChannelRepository *channelRepository = [[ChannelRepository alloc] init];
    NSMutableArray *defaultFavArrray = [channelRepository getDefaultFavoriteChannelFromDB];
    
    if ([defaultFavArrray count] > 0) {
        
        self.defaultFavoriteChannelArray = defaultFavArrray;
        [self callCreateUserProxy];
        
    } else {
        
        [self createChannelProxy];
        
        [self.channelProxy getDefaultFavoriteChannels];

    }   

}

// Is called when Default favorite channels request succeeds.
// check if default fav channels is returns from server or not if not then uses the hard coded channels as defaults.
// then register user request is called.


- (void)receivedDefaultFavoriteChannels:(NSMutableArray*)defaultFavoriteChannels {
    
    
    if (!self.defaultFavoriteChannelArray) {
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        self.defaultFavoriteChannelArray = tempArray;
    }
    
    [self.defaultFavoriteChannelArray removeAllObjects];

    
    NSMutableArray *arrIDs;
    
    if ([defaultFavoriteChannels count] > 0) {
        
        arrIDs = defaultFavoriteChannels;
        
    } else {
                
        arrIDs = [[NSMutableArray  alloc] initWithObjects:@"1",@"2",@"3",@"4",@"31",@"5",@"6",@"10093",@"8",@"7",@"10066",@"10111",@"15",@"10155",nil];
        
    } 
    
        for (int i = 0; i < [arrIDs count]; i++) {
            
            FavoriteChannel *favoriteChannel = [[FavoriteChannel alloc] init];
            
            NSNumber *channelID = [arrIDs objectAtIndex:i];
            
            favoriteChannel.channel_id = [channelID intValue];
            
            favoriteChannel.channel_order = i;
            
            [self.defaultFavoriteChannelArray addObject:favoriteChannel];
            
        }
    
    
    [self callCreateUserProxy];

    
}

// called when channel request fails.

-(void)channelDataFailed:(NSString *)error {
    
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


// creates the proxy for Channels requests and assigns delegates. 


- (void)createChannelProxy {
    
    ChannelProxy *tempChannelProxy = [[ChannelProxy alloc] init];
    
    self.channelProxy = tempChannelProxy;
    
    
    [self.channelProxy setChannelProxyDelegate:self];
    
}


@end
