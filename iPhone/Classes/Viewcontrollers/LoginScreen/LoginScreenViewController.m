


#import "LoginScreenViewController.h"
#import "AppDelegate_iPhone.h"
#import "UIUtils.h"
#import "PasswordSecurity.h"
#import "AnimationUtils.h"
#import "CreateNewAccountViewController.h"
#import "TPKeyboardAvoidingTableView+UITableViewStyle.h"
#import "TextFieldCell.h"



@interface LoginScreenViewController() <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) TPKeyboardAvoidingTableView *tableView;
@property (nonatomic, assign) BOOL enableTextFields;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, copy) NSString *emailAddressLabelStr;
@property (nonatomic, copy) NSString *passwordLabelStr;
@property (nonatomic, copy) NSString *subscriptionLabelStr;
@property (nonatomic, copy) NSString *continueButtonStr;
@property (nonatomic, copy) NSString *loginButtonStr;
@property (nonatomic, copy) NSString *createNewUserButtonStr;

- (void)setLocalizedValues;
- (void)isGuest:(NSString*)guest;
- (void)createLoginProxy;

- (void)configureLoginView;
- (void)layoutHeaderView;
- (void)layoutFooterView;
- (CGRect)tableViewHeaderFrameForCurrentOrientation;

@end



@implementation LoginScreenViewController
@synthesize loginButton;
@synthesize isLogin;
@synthesize tokenString;
@synthesize fromPlanView;
@synthesize subscriptionLabel;
@synthesize enableTextFields = _enableTextFields;
@synthesize username = _username;
@synthesize password = _password;
@synthesize tableView = _tableView;

@synthesize loginProxy = _loginProxy;

@synthesize emailAddressLabelStr, passwordLabelStr, subscriptionLabelStr, continueButtonStr, loginButtonStr, createNewUserButtonStr;

#pragma mark -
#pragma mark Create UI

- (void)setLocalizedValues {
	
    subscriptionLabelStr = NSLocalizedString(@"Login Subscribtion Info",@"Login Screen, Subscribtion Info Label Text");
	emailAddressLabelStr = NSLocalizedString(@"Email Address",@"Login Screen, Email Address Label Text");
	passwordLabelStr = NSLocalizedString(@"Password",@"Login Screen & Creat New User Screen, Password Label Text");
    continueButtonStr = NSLocalizedString(@"Continue",@"Login Screen, Continue  Button Title");
    loginButtonStr = NSLocalizedString(@"Login",@"Login Screen, Login Button Title");
    createNewUserButtonStr = NSLocalizedString(@"create New User",@"Login Screen, create New User Button Title");
    

}


- (void)viewDidLoad 
{    
    [super viewDidLoad];

	shouldCallLoginAPI = YES;
    
    [self setLocalizedValues];
	[self configureLoginView];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    self.tableView = nil;
    [super viewDidUnload];
}



- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    
    self.isLogin = NO;
    
    
    if (fromPlanView) {       
        [self.subscriptionLabel setText:@"You need to Login to use Plan functionality"];
        fromPlanView = NO;
        
    }  else {
        
        [self.subscriptionLabel setText:subscriptionLabelStr];
        
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.tableView beginUpdates];
    
    UIView *headerView = self.tableView.tableHeaderView;
    headerView.frame = [self tableViewHeaderFrameForCurrentOrientation];
    self.tableView.tableHeaderView = headerView;
    
    UIView *footerView = self.tableView.tableFooterView;
    footerView.frame = [self tableViewHeaderFrameForCurrentOrientation];
    self.tableView.tableFooterView = footerView;
    
    [self.tableView endUpdates];
    
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

#pragma mark -
#pragma mark User defined methods
#pragma mark -

- (CGRect)tableViewHeaderFrameForCurrentOrientation
{
    CGFloat tableViewMargin = 10.0f;
    CGFloat tableViewContentHeight = [self.tableView numberOfRowsInSection:0]*self.tableView.rowHeight+2.0f*tableViewMargin;
    CGFloat tableViewHeaderHeight = floorf(0.65f*(self.tableView.bounds.size.height-tableViewContentHeight));
    
    return CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, tableViewHeaderHeight);
}


- (void)layoutHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:[self tableViewHeaderFrameForCurrentOrientation]];
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    
    // container view
    UIView *containerView = [[UIView alloc] initWithFrame:headerView.bounds];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
    
    // addLogoForLoginScreen
    UIImageView *ivTemp = [[UIImageView alloc] initWithFrame:CGRectMake(floorf(0.5f*(headerView.bounds.size.width - 150)), 145, 150, 50)];
    
    ivTemp.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    
	[containerView addSubview:ivTemp];
    
    
    // addSubscriptionLabel
    CGSize suggestedSize = [subscriptionLabelStr sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12.0f] constrainedToSize:CGSizeMake(headerView.bounds.size.width-30.0f, 40) lineBreakMode:UILineBreakModeWordWrap];
    
    UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(ivTemp.frame)+5, headerView.bounds.size.width-30.0f, suggestedSize.height)];
	self.subscriptionLabel = tempLabel;
    
    self.subscriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.subscriptionLabel.numberOfLines = 0;
    self.subscriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
	self.subscriptionLabel.textColor = [UIColor whiteColor];
	self.subscriptionLabel.backgroundColor = [UIColor clearColor];
    subscriptionLabel.textAlignment = UITextAlignmentCenter;
    subscriptionLabel.text = subscriptionLabelStr;
    
    self.subscriptionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
	[containerView addSubview:subscriptionLabel];
    
    
    // set containerView frame
    containerView.frame = CGRectMake(0.0f, 0.0f, headerView.bounds.size.width, CGRectGetMaxY(self.subscriptionLabel.frame));
    containerView.center = headerView.center;
    
    [headerView addSubview:containerView];
    
    self.tableView.tableHeaderView = headerView;
     headerView = nil;
    
}

- (void)layoutFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:[self tableViewHeaderFrameForCurrentOrientation]];
    footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    
    CGFloat buttonMargin = 10.0f;
    CGFloat buttonWidth = 145.0f;//floorf(0.5f*(self.tableView.bounds.size.width-3.0f*buttonWidth));
    
    // createLoginButton
    
    UIButton *login = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginButton = login;
    self.loginButton.frame = CGRectMake(footerView.bounds.size.width-300.0f-buttonMargin, 0.0f, 300, 40);
    self.loginButton.backgroundColor = [UIColor clearColor];
    self.loginButton.userInteractionEnabled = YES;	
    self.loginButton.tag = 0;	
    [self.loginButton setBackgroundImage:[[UIImage imageNamed:@"btn_login.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];	
    [self.loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [self.loginButton setTitle:loginButtonStr forState:UIControlStateNormal];
    self.loginButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.loginButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];	
    [self.loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.loginButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [footerView addSubview:self.loginButton];
    
    
    // createContinueButton
    continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    continueButton.frame = CGRectMake(buttonMargin, footerView.bounds.size.height-buttonMargin-142.5, buttonWidth, 30); //70
    continueButton.backgroundColor = [UIColor clearColor];
    continueButton.userInteractionEnabled = YES;	
    continueButton.tag = 1;	
    [continueButton setBackgroundImage:[[UIImage imageNamed:@"btn_grey.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];	
    [continueButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [continueButton setTitle:continueButtonStr forState:UIControlStateNormal];
    continueButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [continueButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];	
    [continueButton addTarget:self action:@selector(continueButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    continueButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
    [footerView addSubview:continueButton];
    
    
    
    // createNewUserButton
    createNewUserButton = [UIButton buttonWithType:UIButtonTypeCustom];
    createNewUserButton.frame = CGRectMake(footerView.bounds.size.width-buttonWidth-buttonMargin, footerView.bounds.size.height-buttonMargin-142.5, buttonWidth, 30);
    createNewUserButton.backgroundColor = [UIColor clearColor];
    createNewUserButton.userInteractionEnabled = YES;	
    createNewUserButton.tag = 2;	
    [createNewUserButton setBackgroundImage:[[UIImage imageNamed:@"btn_grey.png"] stretchableImageWithLeftCapWidth:40 topCapHeight:10] forState:UIControlStateNormal];
    [createNewUserButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];	
    [createNewUserButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [createNewUserButton setTitle:createNewUserButtonStr forState:UIControlStateNormal];
    createNewUserButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [createNewUserButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];	
    [createNewUserButton addTarget:self action:@selector(createNewAccountButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    createNewUserButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
    [footerView addSubview:createNewUserButton];
    
    
    self.tableView.tableFooterView = footerView;
     footerView = nil;
}

-(void) configureLoginView 
{
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginBackground"]];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_log"]];
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
    tableView.backgroundView = nil;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView = nil;
    
    [self layoutHeaderView];
    [self layoutFooterView];
    
	self.isLogin = NO;
}


- (void)setEnableTextFields:(BOOL)enableTextFields
{
	_enableTextFields = enableTextFields;
    
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];

	self.loginButton.enabled = enableTextFields;
}


#pragma mark -
#pragma mark Event handling methods
#pragma mark -

// get call when users clicks on login button.
// it then autorize the user credential at server side.

-(void) loginButtonClicked : (UIButton *) sender {
    
    NSLog(@"username %@ password %@", self.username, self.password);
    
	if(self.username.length == 0 && self.password.length == 0) {
        
		[UIUtils alertView:@"Please enter valid username/password!" withTitle:@"Login"];				
        
	} else {
        
        [self isGuest:@"NO"];
        
		AppDelegate_iPhone *appDelegate = DELEGATE;		
		appDelegate.isGuest = NO;
        self.enableTextFields = NO;
		NSString *password = [PasswordSecurity md5:self.password];
		NSString *token = [self.username stringByAppendingFormat:@":%@",password];
		NSData *tokenData = [token dataUsingEncoding:NSUTF8StringEncoding];
		NSString *base64Value = [PasswordSecurity base64Encode:tokenData];
		self.tokenString = base64Value;
		appDelegate.authenticationToken = self.tokenString;
		
		if(shouldCallLoginAPI == YES) {
			shouldCallLoginAPI = NO;
                
            [self createLoginProxy];
            
            [self.loginProxy getCredentialsWithUsername:self.username andBase64Value:appDelegate.authenticationToken];
		}
    
	}	
}

// It set the Login type values to yes/no for Guest users, to document directory.
// It is use to remember the user guest login.

- (void)isGuest:(NSString*)guest {
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:guest forKey:@"GUEST"];
    [defaults synchronize];
}

// It is called when user want to skip login. i.e want to user app as Guest.

-(void) continueButtonClicked : (UIButton *) sender {
	
    AppDelegate_iPhone *appDelegate = DELEGATE;
	appDelegate.isGuest = YES;
    
    [self isGuest:@"YES"];
    
    [appDelegate showMainMenu];
}

// It is called when user clicks on create new account button.
// It show user the user the registration form.

-(void) createNewAccountButtonClicked : (UIButton *) sender {
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    if(!appDelegate.createNewAccountViewController) {
        CreateNewAccountViewController *vcTemp = [[CreateNewAccountViewController alloc] init];
        appDelegate.createNewAccountViewController = vcTemp;
    }
    
    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]) {
        [self presentViewController:appDelegate.createNewAccountViewController animated:YES completion:nil];
    } else {
        [self presentModalViewController:appDelegate.createNewAccountViewController animated:YES];
    }
}



#pragma mark -
#pragma mark Login proxy delegate methods
#pragma mark -

// gets called when login fails

-(void)loginFailed:(NSString *)error {

	shouldCallLoginAPI= YES;
    self.enableTextFields = YES;
}


// getts called when login is successfull.
// here we re-direct the user to HOME Screen.

-(void)loginSuccessful:(User *)user {
    
    
	shouldCallLoginAPI = YES;
	self.isLogin = YES;
    self.enableTextFields = YES;
	AppDelegate_iPhone *appDelegate = DELEGATE;
	appDelegate.user = user;	
	appDelegate.user.password = self.password;

    [appDelegate showMainMenu];
    
}




#pragma mark -
#pragma mark Textfield delegate methods


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{	
    
    if(self.isLogin == NO) {
        
        if(textField.tag == 0) {
            
            TextFieldCell *cell = (TextFieldCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            [cell.textField becomeFirstResponder];
            
        } 
        else if (textField.tag == 1 && (self.username.length>0 && self.password.length>0)) {		
            
            [self.loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        else {
            [textField resignFirstResponder];
        }
        
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
        self.username = text;
        
    } else if (textField.tag == 1) {
        self.password = text;
    }
    
    return YES;
}


#pragma mark -
#pragma mark Tableview datasource methods
#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return 2;
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
        
      
        cell.textField.placeholder=emailAddressLabelStr;
        cell.textField.secureTextEntry = NO;
        cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
        cell.textField.text = self.username;
       
        
    } else {
        cell.textField.placeholder=passwordLabelStr;
        cell.textField.secureTextEntry = YES;
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        cell.textField.text = self.password;
      
    }
    
    return cell;
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



@end

