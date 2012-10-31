
#import "AddChannelsViewController.h"
#import "Channel.h"
#import "FavoriteChannel.h"
#import "AppDelegate_iPhone.h"
#import "CustomCellForAddChannel.h"
#import "UIUtils.h"
#import "ChannelRepository.h"
#import "MBProgressHUD.h"

NSString *saveButtonStr;
NSString *backButtonStr;
NSString *searchChannelPlaceHolderStr;
NSString *synchingChannelsHUDLabel;
NSString *pleaseSelectChannelsAlertStr;

@implementation UINavigationBar (UINavigationBarCategory)

- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed: @"bg_bartop.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}


@end

@interface AddChannelsViewController()


- (void)configureAddFavoriteChannelView;

- (void)setTopBarImage;

- (void)addSearchBar;

- (void)createTableView;

- (void)getChannelsFromDatabase;

- (void)hideHUD;

- (void)showHUDWithLabel:(NSString *)strLabelText;

- (void)setLocalizedValues;

- (void)showProUserRequiredScreen;

- (void)changeTableViewHeight:(BOOL)increased;

- (void)saveAddedChannelsLocally;

- (void)createChannelProxy;


@end

@implementation AddChannelsViewController

@synthesize channelsTableView;

@synthesize channelArray;

@synthesize addChannelsArray;

@synthesize searchBarForChannels;

@synthesize searchArray;

@synthesize channelNamesArray;

@synthesize displayArray;

@synthesize progressHUD = _progressHUD;

@synthesize  channelProxy = _channelProxy;

int count;

int searchFlag = 0;
#pragma mark -
#pragma mark Create UI

- (void)setLocalizedValues {
	
    saveButtonStr = NSLocalizedString(@"Save",@"Save Button Title");
    backButtonStr = NSLocalizedString(@"Back",@"Back Button Title");
    self.navigationItem.title = NSLocalizedString(@"Add Channels",@"Add Channels Screen, Navigation Bar Title "); 
    
    searchChannelPlaceHolderStr = NSLocalizedString(@"Search Channel",@"Add Channels Screen, Search Channel PlaceHolder Text");
    
    synchingChannelsHUDLabel = NSLocalizedString(@"Synching Channels",@"Add Channels Screen, Synching Channels HUD Label Text");
    
    pleaseSelectChannelsAlertStr = NSLocalizedString(@"Please Select Channels before Adding",@"Add Channels Screen, Please Select Channels before Adding Alert Message");

}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)loadView {
    
    [super loadView]; 
        
    [self setLocalizedValues];
    
	[self configureAddFavoriteChannelView];
    

}




- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    
    
    
    
    
    
    
    
    

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

#pragma mark -
#pragma mark User defined methods
#pragma mark -

-(void) configureAddFavoriteChannelView {

    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] )
    {
        UIImage *image = [UIImage imageNamed:@"bg_bartop"];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }

	[self addSearchBar];
	NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
	self.addChannelsArray = arrTemp;
	
    UIButton *save = [UIUtils createStandardButtonWithTitle:NSLocalizedString(@"Save",nil) addTarget:self action:@selector(saveButtonTapped:)];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithCustomView:save];
	self.navigationItem.rightBarButtonItem = saveButton;
    
    UIButton *back = [UIUtils createBackButtonWithTarget:self action:@selector(backButtonTapped:)];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:back];
	self.navigationItem.leftBarButtonItem = backButton;
	
	if(!self.searchArray) {
		NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
		self.searchArray = arrTemp;
	}
	
	[self createTableView];
	AppDelegate_iPhone *appDelegate = DELEGATE;
	appDelegate.currentViewController = self;
	
}


// Register for Status Bar Height Change i.e when incomming call
// Register for refresh screen notification when app enters fore ground from back ground.

- (void)viewWillAppear:(BOOL)animated {
    
    
    [UIControls registerRefreshScreenNotificationsFor:self];
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    
    [self changeTableViewHeight:NO]; 
    
    if([self.displayArray count] == 0 || self.displayArray == nil) {
        
        [self callChannelListAPI];
    }
        
    [self.channelsTableView setFrame:CGRectMake(channelsTableView.frame.origin.x, channelsTableView.frame.origin.y, channelsTableView.frame.size.width, 371)];

    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] )
    {
        UIImage *image = [UIImage imageNamed:@"bg_bartop"];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    [self addButtonOnNavigationBar];
	
    if(self.addChannelsArray) {
        
		[self.addChannelsArray removeAllObjects];
        
	}

	[self getChannelsFromDatabase];
    
	if([appDelegate.favoriteChannelsViewController.displayChannelArray count] != 0) {
		FavoriteChannel *fav = [appDelegate.favoriteChannelsViewController.displayChannelArray objectAtIndex:0];
		int max = fav.channel_order;
		for(int i = 0; i < [appDelegate.favoriteChannelsViewController.displayChannelArray count]; i++) {
			FavoriteChannel *favChannel = [appDelegate.favoriteChannelsViewController.displayChannelArray objectAtIndex:i];
			int iorder = favChannel.channel_order;
			if(iorder > max) {
				max = iorder;
			}
		}
		
		count = max+1;//[appDelegate.favoriteChannelsViewController.displayChannelArray count];
	} else {
		count = 0;
	}	
    searchFlag = 0;
    self.searchBarForChannels.text = @"";
    
    for(Channel *favChannel in appDelegate.favoriteChannelsViewController.favoriteChannelArray) {
		[self.channelNamesArray removeObject:favChannel.title];
		for(Channel *newchannel in self.displayArray) {
			if(newchannel.id == favChannel.id) {
				[self.displayArray removeObject:newchannel];
				break;
			}
		}
	}    
	[self.channelsTableView reloadData];
    
    self.channelsTableView.scrollsToTop = YES;
}


- (void)viewWillDisappear:(BOOL)animated {
    
     [self hideHUD];

    
     [[NSNotificationCenter defaultCenter] removeObserver:self];

}

-(void) addButtonOnNavigationBar {
}

- (void) setTopBarImage {
    
	UIImageView *ivTemp = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
	[ivTemp setImage:[UIImage imageNamed:@"labelbar.png"]];	
	[self.view addSubview:ivTemp];
}


-(void) createTableView {
    
	UITableView *tempTableView = [[UITableView alloc] init];
	tempTableView.frame = CGRectMake(0,45, self.view.frame.size.width, 371);
	tempTableView.tag = 0;
	self.channelsTableView = tempTableView;	
	self.channelsTableView.delegate = self;
	self.channelsTableView.dataSource = self;
    
    self.channelsTableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
	[self.view addSubview:self.channelsTableView];
}

-(void) addSearchBar {
    
	UISearchBar *tempSearchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
	self.searchBarForChannels = tempSearchbar;
    self.searchBarForChannels.barStyle = UIBarStyleBlackTranslucent;
    self.searchBarForChannels.tintColor = [UIUtils colorFromHexColor:@"b00a4f"];
	self.searchBarForChannels.showsCancelButton = YES;
	self.searchBarForChannels.delegate = self;
	self.searchBarForChannels.placeholder = searchChannelPlaceHolderStr;
    
    self.searchBarForChannels.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    
	[self.view addSubview:self.searchBarForChannels];
}

-(void) getChannelsFromDatabase {
    
	AppDelegate_iPhone * appDelegate = DELEGATE;

	
	if(!self.channelNamesArray) {
		NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
		self.channelNamesArray = arrTemp;
	} else {
		[self.channelNamesArray removeAllObjects];
	}

	if(!self.displayArray) {
		NSMutableArray *arrTemp1 = [[NSMutableArray alloc] init];
		self.displayArray = arrTemp1;
	} else {
		[self.displayArray removeAllObjects];
	}	
	
	for(Channel *channel in appDelegate.channelArray) {
		[self.channelNamesArray addObject:channel.title];
		[self.displayArray addObject:channel];
	}
	for(Channel *favChannel in appDelegate.favoriteChannelsViewController.favoriteChannelArray) {
		[self.channelNamesArray removeObject:favChannel.title];
		for(Channel *newchannel in self.displayArray) {
			if(newchannel.id == favChannel.id) {
				[self.displayArray removeObject:newchannel];
				break;
			}
		}
	}
}

#pragma mark -b
#pragma mark Post methods



// get called to fetch all  the channels from server.

-(void)callChannelListAPI {
    
    [self hideHUD];
    
	[self showHUDWithLabel:synchingChannelsHUDLabel];
	    
    [self createChannelProxy];
    
    [self.channelProxy getChannelsFor:@"AddView"];
}

// create the dictionary when users select the channels as it favorite.
// channel post request is called.

-(NSDictionary *) createValueDictionary : (NSString *) value {
	NSMutableDictionary *valueDict = [[NSMutableDictionary alloc] init];
	[valueDict setValue:value forKey:@"$"];
	return valueDict;
}

-(NSDictionary *) createDictionary {
    
	AppDelegate_iPhone * appDelegate = DELEGATE;	
	NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
	
	NSDictionary * nameDict = [self createValueDictionary:appDelegate.user.name];
	[userDict setValue:nameDict forKey:@"name"];
	
    
	NSDictionary * phoneDict = [self createValueDictionary:appDelegate.user.phone];
	[userDict setValue:phoneDict forKey:@"phone"];
	
	NSDictionary * emailDict = [self createValueDictionary:appDelegate.user.email];
	[userDict setValue:emailDict forKey:@"email"];
	

    
	NSMutableArray *channels = [[NSMutableArray alloc] init];
    
    if(!appDelegate.favoriteChannelsViewController.displayChannelArray) {
       
        [appDelegate.favoriteChannelsViewController getListofFavoriteChannels];
        
    }
    
	for(FavoriteChannel *favChannel in self.addChannelsArray) {
        
		if([appDelegate.favoriteChannelsViewController.displayChannelArray containsObject:favChannel]) {
		} else {
			[appDelegate.favoriteChannelsViewController.displayChannelArray addObject:favChannel];
		}

	}

	for (int i =0; i < [appDelegate.favoriteChannelsViewController.displayChannelArray count]; i++) {
		
        FavoriteChannel *favoriteChannel = [appDelegate.favoriteChannelsViewController.displayChannelArray objectAtIndex:i];
		
        NSDictionary *favChannelDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",favoriteChannel.channel_id],@"@id",[NSString stringWithFormat:@"%d",favoriteChannel.channel_order],@"@order",nil];
		
        [channels addObject:favChannelDict];
		
	}
	
	NSDictionary *channelDict = [[NSDictionary alloc] initWithObjectsAndKeys:channels,@"channel",nil];
	[userDict setValue:channelDict forKey:@"channels"];
	
	DLog(@"Add userDict : %@",userDict);
	
	return userDict;
	
}

// call the channel request to add channels to the server.

-(void)callAddChannelProxy {

	AppDelegate_iPhone * appDelegate = DELEGATE;	
    
    [self createChannelProxy];

    [self.channelProxy  postChannelsWithSessionKey:appDelegate.authenticationToken andUsername:appDelegate.user.email andChannels:[self createDictionary]];
}

#pragma mark -
#pragma mark Channel proxy delegate methods
#pragma mark -

// get called when pro users is required. 
// gets called when request returns pro-user is required.

- (void)channelProUserRequired {
    
    [self hideHUD];	
    
    [self showProUserRequiredScreen];
    
}


// gets called when the data request fails.

-(void)channelDataFailed:(NSString *)error {
	
    [self hideHUD];
}

// gets called when channe request is successfull. 

-(void)getAllChannels :(NSMutableArray *)array {
	
    [self hideHUD];	
    
    noRecordFound = NO;

	AppDelegate_iPhone * appDelegate = DELEGATE;
	
    appDelegate.channelArray = array;
		
	[self getChannelsFromDatabase];
	
    [self.channelsTableView reloadData];
    
}

// gets call when post channels request to server is successfull. 

-(void)postDataSuccess : (NSString *) response {
    
	[self dismissModalViewControllerAnimated:YES];	
	//[UIUtils alertView:@"Channels added successfully!" withTitle:@"Add Channels"];

    AppDelegate_iPhone * appDelegate = DELEGATE;
    [appDelegate.favoriteChannelsViewController refreshChannelsIds];
}

#pragma mark -
#pragma mark Methods to Display HUD

// hide's the network request progress indicator present on the view.

-(void)hideHUD {
	
	// Remove HUD from screen when the HUD was hidded
	[self.progressHUD hide:YES];
    
	[self.progressHUD  removeFromSuperview];
    self.progressHUD = nil;
	
}

// show's the network request progress indicator on the view.

- (void)showHUDWithLabel:(NSString *)strLabelText {
	
	// Should be initialized with the windows frame so the HUD disables all user input by covering the entire screen
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	MBProgressHUD *tempHUD= [[MBProgressHUD alloc] initWithWindow:window];
    self.progressHUD  = tempHUD;
    
    
	[window addSubview:self.progressHUD];
	
    self.progressHUD.labelText = strLabelText;	    
	
	// Show the HUD while the provided method executes in a new thread
    
	[self.progressHUD  show:YES];	
	
}


#pragma mark -
#pragma mark Event handling methods
#pragma mark -


-(void) backButtonTapped : (UIButton *) sender {   
    
        
    [self changeTableViewHeight:YES];        

	[self dismissModalViewControllerAnimated:YES];	
}

-(void) saveButtonTapped : (UIButton *) sender {
    
    
    [self changeTableViewHeight:YES];        
    
	if([self.addChannelsArray count] != 0) {
		
        AppDelegate_iPhone *appDelegate = DELEGATE;
        
        if (appDelegate.isGuest == YES) {
            
            [self saveAddedChannelsLocally];
            
        } else {

            [self callAddChannelProxy];            
            
        }
        
	} else {
        
		[UIUtils alertView: pleaseSelectChannelsAlertStr withTitle:self.navigationItem.title];
	}   
}

// this method adds the selected channels locally.
// it is requred when user select the continue without login.
// this locally saved channels are add to the users favorite list when it creates the new account.

- (void)saveAddedChannelsLocally {
    
    ChannelRepository *channelRepository = [[ChannelRepository alloc] init];
   
    NSMutableArray *defaultFavArray  = [channelRepository getDefaultFavoriteChannelFromDB];

    
    if ([defaultFavArray count] == 0 ) {
      
        
        AppDelegate_iPhone * appDelegate = DELEGATE;
        
        int orderCount = 0;
        
        for (int i = 0; i < [appDelegate.favoriteChannelsViewController.displayChannelArray count]; i++) {
            
            
           FavoriteChannel *favoriteChannel = [appDelegate.favoriteChannelsViewController.displayChannelArray objectAtIndex:i];
            
          [channelRepository addDefaultFavoriteChannelFromDB:favoriteChannel.channel_id andChannelOrder:i];
            
            orderCount = i;
            
        }
        

        for(FavoriteChannel *favChannel in self.addChannelsArray) {
			
            orderCount += 1; 
            
            [channelRepository addDefaultFavoriteChannelFromDB:favChannel.channel_id andChannelOrder:orderCount];
                    
        }  
        

    } else {
        
        
        int orderCount = [defaultFavArray count];
        
        for(FavoriteChannel *favChannel in self.addChannelsArray) {
			
            orderCount += 1;
            
            [channelRepository addDefaultFavoriteChannelFromDB:favChannel.channel_id andChannelOrder:orderCount];
            
        }   
        
    }
    

    
    [self dismissModalViewControllerAnimated:YES];	
    
    AppDelegate_iPhone * appDelegate = DELEGATE;
    
    [appDelegate.favoriteChannelsViewController callFavoriteChannelProxy];
    
    

}

#pragma mark -
#pragma mark Tableview datasource methods
#pragma mark -

// returns number of sections in the table view.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


// return no of row in each section of table view.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    	//AppDelegate_iPhone * appDelegate = DELEGATE;
	
    if (noRecordFound ) {
        
        return 1;
    }
    
    if(searchFlag == 1) {
        
        if ([self.searchArray count] != 0) {
		    return [self.searchArray count];
        } else {
            
            return 1;
        }
  
    } else{		
		return [self.displayArray count];
    }    
}

// creates reusable cell for channels and assigns values to it.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(noRecordFound) {
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"NORECORDS"];
        
        if (!cell) {
        
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NORECORDS"];
            [cell.textLabel setText: NSLocalizedString(@"No records found",nil)];
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:12]];
            [cell.textLabel setTextColor:[UIUtils colorFromHexColor:BLUE]];
            [cell setUserInteractionEnabled:NO];
        }    
        
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        
        return cell;
    }

    static NSString *CellIdentifier = @"Cell";    
    CustomCellForAddChannel *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CustomCellForAddChannel alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        [cell.backgroundView setBackgroundColor:[UIColor whiteColor]];
    }
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UILabel class]]) {
            [obj removeFromSuperview];
        }
    }];

	if(searchFlag != 1 || [self.searchArray count] == 0) {
		
		Channel *channel = [self.displayArray objectAtIndex:indexPath.row];
		NSMutableString *url = [[NSMutableString alloc] initWithString:BASEURL];
		
		if([channel.imageObjectsArray count] !=0 || channel.imageObjectsArray != nil) {
			Image *imageObject = [channel.imageObjectsArray objectAtIndex:0];
			if(imageObject.src != nil)
			[url appendString:imageObject.src];
			[cell setPhoto:url];
		}


		
        [cell addChannelNameLabel];
        
		[cell addLangNameLabel];
		
		for(FavoriteChannel *favChannel in self.addChannelsArray) {
			DLog(@"self.addChannelsArray = %@",self.addChannelsArray);
			if (favChannel.channel_id == channel.id) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
				break;
			}			
		}
		
		cell.channelLabel.text = channel.title;
        cell.langCode.text = channel.lang;
        
	} else {
        
		Channel *channel = [self.searchArray objectAtIndex:indexPath.row];
		
		if([channel.imageObjectsArray count] !=0 || channel.imageObjectsArray != nil) {
			Image *imageObject = [channel.imageObjectsArray objectAtIndex:0];
			NSMutableString *url = [[NSMutableString alloc] initWithString:BASEURL];
			if(imageObject.src != nil)
				[url appendString:imageObject.src];
			
			[cell setPhoto:url];
		}
		
		for(FavoriteChannel *favChannel in self.addChannelsArray) {
			
			if (favChannel.channel_id == channel.id) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
				break;
			}			
		}			
		[cell addChannelNameLabel];
        [cell addLangNameLabel];

		cell.channelLabel.text = channel.title;	
        
        cell.langCode.text = channel.lang;

	}

	return cell;
}


// gets called when user select the row in table view.
// It toggles between the select channels and unselect channel for the favorite list.

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	AppDelegate_iPhone *appDelegate = DELEGATE;	
	int irow = [indexPath row];	
	Channel * newChannel;
	if(searchFlag != 1) {
		newChannel = [self.displayArray objectAtIndex:irow];
	}
	else {
		newChannel = [self.searchArray objectAtIndex:irow];
	}
	
	BOOL elementPresent = [self elementToBeDeletedAlreadyPresent:newChannel];
	if(elementPresent == NO)
	{
		FavoriteChannel *favoriteChannel = [[FavoriteChannel alloc] init];
		favoriteChannel.user_id = appDelegate.user.user_id;
		favoriteChannel.channel_id = newChannel.id;
		favoriteChannel.channel_order = count;
		[self.addChannelsArray addObject:favoriteChannel];
		count++;
	}
	else
	{				
		[self removeChannelElement:newChannel.id];		
		count--;
	}
	
	[self.channelsTableView reloadData];
	DLog(@"self.addChannelsArray : %@",self.addChannelsArray);
}


// return height for table view.

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50.0f;//120
}


// it check if the channels is added to the favorite list if yes, that means users has uncheck the list.else add the channels to favorite list.

-(BOOL)elementToBeDeletedAlreadyPresent:(Channel *)objChannel
{
	BOOL elementPresent = NO;
	for(int i =0 ;i<[self.addChannelsArray count];i++)
	{
		FavoriteChannel *favoriteChannel = [self.addChannelsArray objectAtIndex:i] ;
		if(objChannel.id == favoriteChannel.channel_id)
		{
			elementPresent = YES;
			break;
		}
	}
	return elementPresent;
	
}

// If the above method returns yes then this is called and remove the channels from the list.

-(void)removeChannelElement:(int) channelId
{
	for(int i =0 ;i<[self.addChannelsArray count];i++)
	{
		FavoriteChannel *favoriteChannel = [self.addChannelsArray objectAtIndex:i] ;
		if(channelId == favoriteChannel.channel_id)
		{
			[self.addChannelsArray removeObjectAtIndex:i];			
			for (int j = i; j < [self.addChannelsArray count]; j++) {
				FavoriteChannel *favChannel = [self.addChannelsArray objectAtIndex:j];
				favChannel.channel_order = favChannel.channel_order-1;
			}
		}
	}	
}

#pragma mark -
#pragma mark Searchbar delegate methods
#pragma mark -


// gets called when search bar search texts changes 
// it then accordingly reloads the table view. with all the channels which matches the serach text.

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
	
	self.searchBarForChannels.showsCancelButton=YES;
	
    
	if([searchText isEqualToString:@""]) {	
        
		return;
	} else {	
        
	}
	
    searchFlag = 1;

    
	[self.searchArray removeAllObjects];

	NSInteger counter=0;	
	
	for(NSString *strName in self.channelNamesArray){
		@autoreleasepool {
			NSRange range=[strName rangeOfString:searchText options:NSCaseInsensitiveSearch];
					
			if(range.location!=NSNotFound){
						
				for(Channel *newchannel in self.displayArray) {
					if([newchannel.title isEqualToString:strName]) {
						if([self.searchArray containsObject:newchannel]) {
						
						} else {
							[self.searchArray addObject:newchannel];
						}
						break;
					}
				}				
			}		
			counter++;
		}
	}	
	[self.channelsTableView reloadData];	
} 


// gets called when search bar search button is clicked.

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{	
    

	searchFlag=1;
    
    [self changeTableViewHeight:YES];     
    
	[self.searchBarForChannels resignFirstResponder];	
	
	NSString *strText;
    
	NSString *strTextAppended=[self.searchBarForChannels text];
	
	if([strTextAppended isEqualToString:@""]) {		
		[self.searchArray addObjectsFromArray:self.displayArray];
		[self.channelsTableView reloadData];
		return;
	}	
	
	for(strText in self.channelNamesArray){
		
		NSComparisonResult crResult=[strText compare:strTextAppended options:NSCaseInsensitiveSearch];
		if(crResult==NSOrderedSame){
			[self searchBar:self.searchBarForChannels textDidChange:strTextAppended];
		}		
	}
	
	[self.channelsTableView reloadData];	
			
	[self.navigationController popViewControllerAnimated:YES];		
}


// gets called when users starts writing in the search bar text field.

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    
    [self changeTableViewHeight:NO];
        
   self.searchBarForChannels.showsCancelButton=YES;
   self.searchBarForChannels.autocorrectionType = UITextAutocorrectionTypeNo;	
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
	
}


#pragma mark -
#pragma mark Cancel Button Clicked

// gets callled when search bar cancle button is clicked.

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{	
	

    [self changeTableViewHeight:YES];
    
    searchFlag = 0;	
    searchBar.text = @"";
	[self.searchBarForChannels resignFirstResponder];
    self.searchBarForChannels.showsCancelButton=NO;	
}

// changes the table view height between the normal to minimum 
// when the keyboards appears on the screen.

- (void)changeTableViewHeight:(BOOL)increased {
    


        
        if (increased) {
            
            [channelsTableView setFrame:CGRectMake(channelsTableView.frame.origin.x, channelsTableView.frame.origin.y, channelsTableView.frame.size.width, 371 + 168)]; 
            
            [self.searchBarForChannels resignFirstResponder];

            
        } else {
            
            [channelsTableView setFrame:CGRectMake(channelsTableView.frame.origin.x, channelsTableView.frame.origin.y, channelsTableView.frame.size.width, 371 - 168)];
             
        }
        

    
    DLog(@"hight for table view");
}

#pragma mark -
#pragma mark ProUser Required Screens Methods 

// show pro user required screen.

- (void)showProUserRequiredScreen {
    
    ProUserRequiredScreen *proUserRequiredScreen = [[ProUserRequiredScreen alloc]init];
    
    [self.navigationController pushViewController:proUserRequiredScreen animated:YES];

    
}


// gets called when request is successfull but returns zero data objects.

- (void)noChannelsRecordsFound {
    
    noRecordFound = YES;
    [self.channelsTableView reloadData];
    
}



#pragma mark -
#pragma mark - Refresh Screen Notification Method

// This method is call when application enters to foreground from background state.

- (void)refreshScreen {
    
    [self callChannelListAPI];
    
}


#pragma mark -
#pragma mark - Proxy Creation 

// creates the proxy for Channels requests and assigns delegates. 


- (void)createChannelProxy {
    
    if (!self.channelProxy) {
        
        ChannelProxy *tempChannelProxy = [[ChannelProxy alloc] init];
        self.channelProxy = tempChannelProxy;
        
    }
    
    
    [self.channelProxy setChannelProxyDelegate:self];
}

@end
