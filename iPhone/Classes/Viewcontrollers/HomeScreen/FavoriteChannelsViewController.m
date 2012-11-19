
#import "FavoriteChannelsViewController.h"
#import "CustomCellForChannel.h"
#import "AppDelegate_iPhone.h"
#import "Channel.h"
#import "FavoriteChannel.h"
#import "Program.h"
#import "ProgramListViewController.h"
#import "UIUtils.h"
#import "ChannelCategory.h"

#import "CategoryView.h"
#import "RecommendationView.h"
#import "SummaryScreenViewController.h"
#import "UserView.h"
#import "PlanView.h"
#import "ChannelRepository.h"
#import "NSString+utility.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString *editChannelsNavigationTitleStr;
NSString *searchHeaderLabelStr;
NSString *searchHeaderShowsLabelStr;
NSString *channelsButtonStr;
NSString *searchbarPlaceHolderStr;
NSString *searchHeaderTodayLabelStr;

BOOL formProgramDetail;



@interface FavoriteChannelsViewController()


@end

@implementation UINavigationBar (UINavigationBarCategory)

- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed: @"bg_bartop.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}


@end

@implementation FavoriteChannelsViewController

@synthesize favoriteChannelsTableView;
@synthesize favoriteChannelArray;
@synthesize displayChannelArray;
@synthesize addChannelsViewController;
@synthesize searchBarForChannels;
@synthesize channelNamesArray;
@synthesize channelIndex;
@synthesize startDateString;
@synthesize endDateString;
@synthesize menuBarView = _menuBarView;
@synthesize allChannelsArray = _allChannelsArray;
@synthesize dicKeys = _dicKeys;
@synthesize searchDictionary = _searchDictionary;
@synthesize channelProxy = _channelProxy;
@synthesize programProxy = _programProxy;
@synthesize loginProxy = _loginProxy;
@synthesize categoryView = _categoryView;

#pragma mark -
#pragma mark Create UI


// It called to get the local dependent strings which we use to display as button title, label text etc.

- (void)setLocalizedValues {

    
    editChannelsNavigationTitleStr = NSLocalizedString(@"Edit Channels Navigation Title ",@"Edit Channels Screen, Navigation Bar Title");
    
    channelsButtonStr = NSLocalizedString(@"Channels",@"Home Screen, channels Button title Text");
    
    searchHeaderLabelStr = NSLocalizedString(@"Searched",@"Search Favorite Program Screen, Search Header Search Label Text");
    
    searchHeaderShowsLabelStr = NSLocalizedString(@"Shows",@"Search Favorite Program Screen, Search Header Shows Label Text");
    
    searchHeaderTodayLabelStr = NSLocalizedString(@"Today",@"Search Favorite Program, Search Header Search Date Label Text");

    searchbarPlaceHolderStr = NSLocalizedString(@"Search Programs",@"Search Favorite Program, Search Bar Place Holder");

}


#pragma mark -
#pragma mark Life Cycle Method


// Implement loadView to create a view hierarchy programmatically, without using a nib.

// create UI
// Register for Status Bar Height Change i.e when incomming call
// Register for refresh screen notification when app enters fore ground from back ground.

- (void)loadView {
    
    [super loadView];
    
    [UIControls registerRefreshScreenNotificationsFor:self];
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    appDelegate.selectedMenuItem = Favorite;
    
    
    if (appDelegate.isGuest == NO) {
        [appDelegate getAllRegisterDevices];
    }   

 
    
    [self setLocalizedValues];
    
	[self configureFavoriteChannelView];
    

}


- (void)viewWillAppear:(BOOL)animated {
    self.favoriteChannelsTableView.contentInset=UIEdgeInsetsMake(-self.searchDisplayController.searchBar.frame.size.height,0,0,0);
    self.favoriteChannelsTableView.contentOffset = CGPointMake(0.0, 44.0);
    //show the cancel button in your search bar
    self.searchBarForChannels.showsCancelButton = NO;
    //Iterate the searchbar sub views
    for (UIView *subView in searchBarForChannels.subviews) {
        //Find the button
        if([subView isKindOfClass:[UIButton class]])
        {
            //Change its properties
            UIButton *cancelButton = (UIButton *)[searchBarForChannels.subviews lastObject];
            [cancelButton setBackgroundImage:[UIImage imageNamed:@"btn_edit"] forState:UIControlStateNormal];
            //cancelButton.titleLabel.text = @"Changed";
        }
    }
    
    [super viewWillAppear:animated];
    
    
    if ([self.allChannelsArray count] == 0) {
        
         [self fetchAllChannels];
    }

	AppDelegate_iPhone *appDelegate = DELEGATE;
    
  if (appDelegate.selectedMenuItem == Favorite) {

	appDelegate.favoriteChannelsViewController = self;
	[self.favoriteChannelsTableView reloadData];
    
    if(isAddButtonTapped == YES) {
        self.navigationItem.title = editChannelsNavigationTitleStr;
        [self addAddChannelButton];
        isEditButtonClicked = YES;
    } else {
        self.navigationItem.title = nil;
        self.navigationItem.leftBarButtonItem = nil;
        [self createMenuBar];
        /*
        if(appDelegate.isGuest == NO) {	
            [self addEditButton];	
        } else {
            self.navigationItem.rightBarButtonItem = nil;
        }
         */
        
        [self addEditButton];
        
        isEditButtonClicked = NO;
    }
    isAddButtonTapped = NO;
    isReorder = NO;
      
    if (formProgramDetail) {
        
      //  self.navigationItem.leftBarButtonItem = nil;
        formProgramDetail = NO;
    }
    
  }
    
    [self changeRightBarButtonItemStatus];

}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    DLog(@"***********************viewDidAppear*********************");

    [self showPushedProgramInSummaryScreen];
    
    
    NSLog(@"######### %@", NSStringFromCGRect(self.view.frame));
}

// this change the Right bar button present on top Menu Bar Status.
// if the selected menu is not Favorite(Home) OR 

- (void)changeRightBarButtonItemStatus {
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    if (appDelegate.selectedMenuItem != Favorite && appDelegate.selectedMenuItem != Plan) {
        self.navigationItem.leftBarButtonItem = nil;
    } 
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark User defined methods
#pragma mark -

-(void)configureFavoriteChannelView {
        
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] )
    {
        UIImage *image = [UIImage imageNamed:@"bg_bartop"];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
	[self createTableView];
    
	AppDelegate_iPhone *appDelegate = DELEGATE;
	if(appDelegate.isGuest == NO) {	
		[self addEditButton];	
	}
	    
    [self createMenuBar];
    [self callFavoriteChannelProxy];
    
	appDelegate.currentViewController = self;
    NSDate *startDate=[NSDate date];
    NSDateFormatter *localDateFormat = [[NSDateFormatter alloc] init];
    [localDateFormat setTimeZone:[NSTimeZone localTimeZone]];
    [localDateFormat setDateFormat:@"EEEddMMMyyyy hh:mm:ss"];
    [localDateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    NSString * localDateStr = [localDateFormat stringFromDate:startDate];
    self.startDateString=localDateStr;
       
    self.endDateString = [UIUtils endTimeFromGivenDate:[NSDate date]];
    self.searchBarForChannels.showsCancelButton = YES;
    for (UIView *subView in searchBarForChannels.subviews) {
        //Find the button
        if([subView isKindOfClass:[UIButton class]])
        {
            //Change its properties
            UIButton *cancelButton = (UIButton *)[searchBarForChannels.subviews lastObject];
            [cancelButton setBackgroundImage:[UIImage imageNamed:@"btn_edit"] forState:UIControlStateNormal];
            //cancelButton.titleLabel.text = @"Changed";
        }
    }
    [self addSearchBar];
    [self.favoriteChannelsTableView  setFrame: CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)];

	
}


-(void) createTableView {
    
	UITableView *channelTableView = [[UITableView alloc] init];
    channelTableView.autoresizingMask=(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    NSLog(@"%f", CGRectGetHeight(self.view.bounds)-CGRectGetHeight(self.menuBarView.frame)-CGRectGetHeight(self.searchBarForChannels.frame));

	channelTableView.tag = 0;
    
	self.favoriteChannelsTableView = channelTableView;	
    self.favoriteChannelsTableView.frame = CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height);
    self.favoriteChannelsTableView.contentOffset = CGPointMake(0.0, 44.0);
    self.favoriteChannelsTableView.delegate = self;
	self.favoriteChannelsTableView.dataSource = self;	
	[self.view addSubview:self.favoriteChannelsTableView];
	self.favoriteChannelsTableView.hidden = NO;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGPoint offset=self.favoriteChannelsTableView.contentOffset;
    CGFloat barHeight=self.searchDisplayController.searchBar.frame.size.height;
    if (self.favoriteChannelsTableView.contentOffset.y <= barHeight/2.0f) {
        self.favoriteChannelsTableView.contentInset=UIEdgeInsetsZero;
    }else{
        self.favoriteChannelsTableView.contentInset=UIEdgeInsetsMake(-barHeight,0,0,0);
    }
    
    self.favoriteChannelsTableView.contentOffset=offset;
}


-(void)getListofFavoriteChannels {
    
	AppDelegate_iPhone *appDelegate = DELEGATE;
	appDelegate.favoriteChannelsViewController = self;
	if(!self.channelNamesArray) {
		NSMutableArray *arrTemp1 = [[NSMutableArray alloc] init];
		self.channelNamesArray = arrTemp1;
	} else {
        [self.channelNamesArray removeAllObjects];
    }
	if(!self.displayChannelArray) {
		NSMutableArray *arrTemp2 = [[NSMutableArray alloc] init];
		self.displayChannelArray = arrTemp2;
	} else {
        [self.displayChannelArray removeAllObjects];
    }
	
	if(appDelegate.isGuest == NO) {
                
		for(Channel *newChannel in self.favoriteChannelArray) {
			for (int i = 0; i < [appDelegate.user.channels count]; i++) {
				FavoriteChannel *favChannel = [appDelegate.user.channels objectAtIndex:i];
				if(favChannel.channel_id == newChannel.id) {
					[self.channelNamesArray addObject:newChannel.title];
                    if([self.displayChannelArray containsObject:favChannel]) {
                    } else {
                        [self.displayChannelArray addObject:favChannel];
                    }
				}
			}
		}
        
        
	} else {
        
        
		for (int i = 0; i < [self.favoriteChannelArray count]; i++) {
            
			Channel *newChannel = [self.favoriteChannelArray objectAtIndex:i];
            
            FavoriteChannel *favChannel = [[FavoriteChannel alloc] init];
			
            favChannel.channel_id = newChannel.id;
			
            [self.channelNamesArray addObject:newChannel.title];
            
            if([self.displayChannelArray containsObject:favChannel]) {
                
            } else {
                
                [self.displayChannelArray addObject:favChannel];
            }
		}
	}
    DLog(@"INITIAL array : %@", self.displayChannelArray);
	[self.favoriteChannelsTableView reloadData];
}
 


-(void) addEditButton {
      
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame=CGRectMake(0, 0, 70, 30);
    [editButton addTarget:self action:@selector(editButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [editButton setBackgroundImage:[UIImage imageNamed:@"btn_channels.png"] forState:UIControlStateNormal];
    [editButton setBackgroundImage:[UIImage imageNamed:@"btn_channels_pressed"] forState:UIControlStateHighlighted];
    [editButton setTitle:channelsButtonStr forState:UIControlStateNormal];
    [editButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
    UIBarButtonItem *channelsBarButton=[[UIBarButtonItem alloc] initWithCustomView:editButton];
    self.navigationItem.leftBarButtonItem = channelsBarButton;
    
  
}

-(void) addAddChannelButton {
    
    self.navigationItem.leftBarButtonItem = nil;
    UIButton *add = [UIButton buttonWithType:UIButtonTypeCustom];
    add.frame = CGRectMake(0, 0, 35, 30);
    [add addTarget:self action:@selector(addButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [add setBackgroundImage:[UIImage imageNamed:@"btn_plus.png"] forState:UIControlStateNormal];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:add];
    self.navigationItem.rightBarButtonItem = addButton;
    UIButton *save = [UIUtils createStandardButtonWithTitle: NSLocalizedString(@"Save",nil) addTarget:self action:@selector(saveButtonTapped:)];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:save];
	self.navigationItem.leftBarButtonItem = backButton;
}


-(void) addSearchBar {
    
	UISearchBar *tempSearchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.searchBarForChannels = tempSearchbar;
    UIImageView *im=[[UIImageView alloc]init];
    [im setImage:[UIImage imageNamed:@"bg_bartop"]];
    [im setFrame:CGRectMake(0, 0, tempSearchbar.frame.size.width, tempSearchbar.frame.size.height)];
    [self.searchBarForChannels insertSubview:im atIndex:1];
    self.searchBarForChannels.showsCancelButton = YES;
	  searchBarForChannels.tintColor=[UIUtils colorFromHexColor:@"b00a4f"];
	self.searchBarForChannels.delegate = self;
	self.searchBarForChannels.placeholder = searchbarPlaceHolderStr;
	self.favoriteChannelsTableView.tableHeaderView = self.searchBarForChannels;
    [self.view bringSubviewToFront:self.searchBarForChannels];
    [self.favoriteChannelsTableView setNeedsLayout];
    
}

#pragma mark -
#pragma mark Post methods

-(void)callFavoriteChannelProxy {
    
	AppDelegate_iPhone *appDelegate = DELEGATE;
	
    [self createChannelProxy];
	
	NSMutableArray *arrIDs = [[NSMutableArray alloc] init];
    
	if(appDelegate.isGuest == NO) {		
		
        for (FavoriteChannel *favChannel in appDelegate.user.channels) {
			[arrIDs addObject:[NSNumber numberWithInt:favChannel.channel_id]];
		}
            
        if([arrIDs count] != 0) {
                                    
            [self.channelProxy getChannelsWithChannelIds:arrIDs];
        }	
        
	} else {
        
        ChannelRepository *channelRepository = [[ChannelRepository alloc] init];
        NSMutableArray *defaultFavArrray = [channelRepository getDefaultFavoriteChannelFromDB];
        
        if ([defaultFavArrray count] > 0) {
            
            
            for (FavoriteChannel *favChannel in defaultFavArrray) {
                [arrIDs addObject:[NSNumber numberWithInt:favChannel.channel_id]];
            }
                        
            
            
            if([arrIDs count] != 0) {
                                
                
                [self.channelProxy getChannelsWithChannelIds:arrIDs];

            }	
            
            
        } else {
                                
            [self.channelProxy getDefaultFavoriteChannels];
        }   
        
	}
    	
}

-(NSDictionary *)createValueDictionary:(NSString *)value {
    
	NSMutableDictionary *valueDict = [[NSMutableDictionary alloc] init];
	[valueDict setValue:value forKey:@"$"];
	return valueDict;
}

-(NSDictionary *)createDictionary {
    
	AppDelegate_iPhone * appDelegate = DELEGATE;	
	NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
	
	NSDictionary * nameDict = [self createValueDictionary:appDelegate.user.name];
	[userDict setValue:nameDict forKey:@"name"];
	
	
	NSDictionary * phoneDict = [self createValueDictionary:appDelegate.user.phone];
	[userDict setValue:phoneDict forKey:@"phone"];
	
	NSDictionary * emailDict = [self createValueDictionary:appDelegate.user.email];
	[userDict setValue:emailDict forKey:@"email"];
	
		
	NSMutableArray *channels = [[NSMutableArray alloc] init];
	
	for (int i =0; i < [self.displayChannelArray count]; i++) {
		FavoriteChannel *favoriteChannel = [self.displayChannelArray objectAtIndex:i];
		NSDictionary *favChannelDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",favoriteChannel.channel_id],@"@id",[NSString stringWithFormat:@"%d",favoriteChannel.channel_order],@"@order",nil];
		[channels addObject:favChannelDict];
	}
	
	NSDictionary *channelDict = [[NSDictionary alloc] initWithObjectsAndKeys:channels,@"channel",nil];
	[userDict setValue:channelDict forKey:@"channels"];
	
	DLog(@"UserDict : %@",userDict);
	
	return userDict;
	
}

#pragma mark -
#pragma mark Get methods

- (void)callSearchProgramProxy {

    DLog(@"self.startDateString : %@ , self.EndDate : %@",self.startDateString,self.endDateString);
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    NSMutableArray *channelsIDs = [[NSMutableArray alloc] init];
	
	if (appDelegate.isGuest) {
        
    
        for (Channel *favChannel in  self.favoriteChannelArray) {
            
            [channelsIDs addObject:[NSNumber numberWithInt:favChannel.id]];
        }
        
        
    } else {
    
    
        for (FavoriteChannel *favChannel in  appDelegate.user.channels) {
            
             [channelsIDs addObject:[NSNumber numberWithInt:favChannel.channel_id]];
        }
        
    }
    
        
    [self createProgramProxy];
    [self.programProxy getProgramsWithProgramName:self.searchBarForChannels.text andChannelIds:channelsIDs andStartDate:self.startDateString  andEndtDate:self.endDateString];
    
}

- (void)callChannelProxyForReordering {
    
    AppDelegate_iPhone * appDelegate = DELEGATE;

    [self createChannelProxy];

    [self.channelProxy deleteChannelsWithSessionKey:appDelegate.authenticationToken andUsername:appDelegate.user.email andChannels:[self createDictionary]];
}


#pragma mark -
#pragma mark Channel proxy delegate methods
#pragma mark -


-(void)channelDataFailed:(NSString *)error {
	
}

-(void)getAllChannels :(NSMutableArray *)array {	
    
    noRecordFound = NO;
    
    if(self.favoriteChannelArray) {
        [self.favoriteChannelArray removeAllObjects];
    }
	self.favoriteChannelArray = array;
	
	[self getListofFavoriteChannels];	
    
	[self.favoriteChannelsTableView reloadData];	
}

-(void)postDataSuccess : (NSString *) response {
	
    
    [self refreshChannelsIds];
}


- (void)channelProUserRequired {
    
    [self showProUserRequiredScreen];
    
}


- (void)receivedDefaultFavoriteChannels:(NSMutableArray*)defaultFavoriteChannels {
    
    [self createChannelProxy];

    
    if ([defaultFavoriteChannels count] > 0) {
    
        [self.channelProxy getChannelsWithChannelIds:defaultFavoriteChannels];
    
        
    } else {
        
        NSMutableArray *arrIDs = [[NSMutableArray alloc] init];
        
        [arrIDs addObjectsFromArray:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],[NSNumber numberWithInt:31],[NSNumber numberWithInt:5],[NSNumber numberWithInt:6],[NSNumber numberWithInt:10093],[NSNumber numberWithInt:8],[NSNumber numberWithInt:7],[NSNumber numberWithInt:10066],[NSNumber numberWithInt:10111],[NSNumber numberWithInt:15],[NSNumber numberWithInt:10155],nil]];
               
        
        [self.channelProxy getChannelsWithChannelIds:arrIDs];
            
    }
    
}

#pragma mark -
#pragma mark Program proxy delegate methods
#pragma mark -

- (void)programProUserRequired {
   
   [self showProUserRequiredScreen];
}

-(void)programDataFailed:(NSString *)error {

}
					
- (void)receivedProgramsForChannel:(id)objects ForType:(NSString*)queryType {
    
    noRecordFound = NO;
    
    NSMutableArray *array = (NSMutableArray*)objects;
    
    [self.searchDictionary removeAllObjects];
    [self.dicKeys removeAllObjects];
            
    if (!self.dicKeys) {
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        self.dicKeys = tempArray;
    } 
    
    if (!self.searchDictionary) {
        
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
        self.searchDictionary = tempDic;
    }
    
    
    for (int i = 0; i < [array count]; i++) {
        
        Program *programObject = [array objectAtIndex:i];
        
        NSDate *startDate = [UIUtils dateFromGivenGMTString:programObject.start WithFormat:@"EEE,ddMMMyyyyHH:mm:ss z"];         
        
        NSString *DATE_KEY = [UIUtils stringFromGivenGMTDate:startDate WithFormat:@"dd MMM yyyy"];
        
        DLog(@"%@", DATE_KEY);
        
        BOOL keyPresent = NO;
        
        
        if ([DATE_KEY isKindOfClass: [NSNull class]] || DATE_KEY == nil) {
            
            keyPresent = YES;
        }          
        
        for (int key = 0; key < [self.dicKeys count]; key++) { 
            
            if ([[self.dicKeys objectAtIndex:key] isEqualToString:DATE_KEY]) {
                
                keyPresent = YES;
                break;
            }  
        }
        
        if (!keyPresent) {
            
            NSMutableArray *planArray = [[NSMutableArray alloc] init];
            
            for (int j = 0; j < [array count]; j++) {
                
                Program *programObject = [array objectAtIndex:j];
                
                
                if ([programObject.start contains:DATE_KEY]) {
                    
                    [planArray  addObject:programObject];
                }  
                
            }
            
            [self.searchDictionary setObject:planArray forKey:DATE_KEY];
            
            
            [self.dicKeys addObject:DATE_KEY];
        }  
    }  

    [self.favoriteChannelsTableView reloadData];
    
}




#pragma mark -
#pragma mark Tableview datasource methods
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if(searchFlag == 1) {
        
        if(noRecordFound) {
            
            return 1;
            
        } else {
        
           return [self.dicKeys count];
        }
    

    } else {
        
        return 1;

    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (noRecordFound) {
        
        return 1;
    } 
    
    if(searchFlag == 1) {
        
        NSString *key   = [self.dicKeys objectAtIndex:section];
        return  [[self.searchDictionary objectForKey:key] count];
         
    }    
	else {
        
        if(isEditButtonClicked == NO) {
            
            self.favoriteChannelsTableView.tableHeaderView.hidden = NO;   
            
            CGRect frame = self.favoriteChannelsTableView.frame;
            frame.origin.y = 0;
            frame.size.height = self.view.bounds.size.height;
            
            self.favoriteChannelsTableView.frame = frame;
            
        } else {
            
            CGRect frame = self.favoriteChannelsTableView.frame;                    
                    frame.size.height = self.view.bounds.size.height+45;
            
            self.favoriteChannelsTableView.frame = frame;
            
        }
		return [self.favoriteChannelArray count];
        
    }    
}



-(NSString *) getTimeIntervalForTheProgramWithStartTime : (NSString *)programStartTime andEndTime : (NSString *) programEndTime {
	
    NSArray *startDateTime = [programStartTime componentsSeparatedByString:@" "];
	NSString *getStartTime= [startDateTime objectAtIndex:4];
	
	NSArray *startHours = [getStartTime componentsSeparatedByString:@":"];
	NSString *startTime= [startHours objectAtIndex:0];
	startTime = [startTime stringByAppendingFormat:@":%@",[startHours objectAtIndex:1]];
    
	return startTime;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{    
    static NSString *CellIdentifier = @"Cell";
         
    if(noRecordFound) {
        
        UITableViewCell  *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"norecords"];
        
        [cell.textLabel setText: NSLocalizedString(@"No records found",nil)];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [cell.textLabel setTextColor:[UIColor blackColor]];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];

        [cell setUserInteractionEnabled:NO];
        return cell;
        
    }
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    CustomCellForChannel *cell = (CustomCellForChannel *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
	if (cell == nil) {
        
        cell = [[CustomCellForChannel alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier andTableType:@"HOMETV"];
    } else {
        
        for (UIView *temp in [cell.contentView subviews]) {
            if ([temp isKindOfClass:[UILabel class]]) {
                [temp removeFromSuperview];
            }
        }
        
        for(UIView *cellSubview in cell.subviews) {
            if ([cellSubview isKindOfClass:[UILabel class]]) {
				[cellSubview removeFromSuperview];
			}
        }
	}
    
    
	if(searchFlag!= 1) {
        
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        cell.backgroundView.backgroundColor=[UIColor whiteColor];
        UIView *viewd = [[UIView alloc] initWithFrame:CGRectMake(100, 0, 1, 50)];
        viewd.backgroundColor=[UIUtils colorFromHexColor:@"e6e5e4"];
        
        [cell.contentView addSubview:viewd];
        
        [cell.categoryImageView setHidden:YES];
        
		Channel *newChannel = [self.favoriteChannelArray objectAtIndex:indexPath.row];
        
		NSMutableString *url = [[NSMutableString alloc] initWithString:BASEURL];
		if([newChannel.imageObjectsArray count] !=0 || newChannel.imageObjectsArray != nil) {
            
            [cell.logoBackgroundImageView setHidden:NO];
            [cell.logoImageView setFrame:CGRectMake(16, 11, 75, 30)];
			Image *imageObject = [newChannel.imageObjectsArray objectAtIndex:0];
            DLog(@"channel server path string %@", imageObject.src);
			
            if(imageObject.src != nil) {
				[url appendString:imageObject.src];
            }
			[cell setPhoto:url];
		}
     
       
        if(isEditButtonClicked == YES) {
            
            
            [cell addChannelNameLabel];
            
            NSString *subscriptionText = newChannel.title;   
            CGSize suggestedSize = [subscriptionText sizeWithFont:[UIFont boldSystemFontOfSize:12.0f] constrainedToSize:CGSizeMake(140, 40) lineBreakMode:UILineBreakModeWordWrap];
            CGRect channelLabelFrame = cell.channelLabel.frame;             
            channelLabelFrame.size.height = suggestedSize.height;
            cell.channelLabel.frame = channelLabelFrame;
            cell.channelLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.channelLabel.numberOfLines = 0;
            cell.channelLabel.text = newChannel.title;
            
        } else {
            
            NSArray *programs = newChannel.programs;
            [cell addProgram1Label];
            [cell addProgram2Label];
            if([programs count] != 0) {
                
                Program *program1 = [programs objectAtIndex:0];
                cell.program1Label.text = program1.title;
                
                if(program1.start != nil && program1.end != nil) {
                    
                    [cell addTime1Label];	
                 //   [cell.time1Label setFont:[UIFont boldSystemFontOfSize:12.0f]];
                  
                    
                    NSString *startTime = [UIUtils localTimeStringForGMTDateString:program1.start];
                    
                    
                    NSDate *programAirDate = [UIUtils dateFromGivenGMTString:program1.start  WithFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
                    
                    
                    NSTimeInterval programAirTimeInterval = [[NSDate date] timeIntervalSinceDate:programAirDate];

                    
                    if (programAirTimeInterval > 0) {
                        
                        cell.time1Label.text = startTime;
                        
                        Program *program2 = [programs objectAtIndex:1];
                        cell.program2Label.text = program2.title;
                        
                        if(program2.start != nil && program2.end != nil) {
                            [cell addTime2Label];		
                            NSString *startTime2 = [UIUtils localTimeStringForGMTDateString:program2.start];
                            cell.time2Label.text = startTime2;
                            
                        }
                        
                    } else {
                        
                        cell.program1Label.text =  NSLocalizedString(@"Channel.no.air.1", nil);
                        cell.program2Label.text =  NSLocalizedString(@"Channel.no.air.2", nil);                     
                        [cell.program2Label setTextColor:[UIColor blackColor]];
                        [cell.program2Label setFont:[UIFont boldSystemFontOfSize:13.0f]];
                        
                        [cell.program1Label setFrame:CGRectMake(110, 5, 140, 20)];
                        [cell.program2Label setFrame:CGRectMake(110, 20, 140, 20)];
                    
                    }
                    
                }			
            
			}
            
             else {
                [cell addTime1Label];			
                [cell addTime2Label];			
                [cell.time1Label setFrame:CGRectMake(110, 5, 240, 20)];
                [cell.time2Label setFrame:CGRectMake(110, 20, 240, 20)];
                
                cell.time1Label.text =  NSLocalizedString(@"Channel.no.transmission.1", nil);
                cell.time2Label.text =  NSLocalizedString(@"Channel.no.transmission.2", nil);  
            }
         
		}
        
	} else { 
        
        
        NSString *key  = [self.dicKeys objectAtIndex:[indexPath section]];
        NSMutableArray *searchProgramArray  = [self.searchDictionary objectForKey:key];
        
                [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];

                [cell.backgroundView setBackgroundColor:[UIColor whiteColor]];

                [cell.logoBackgroundImageView setHidden:YES];
                
                Program *newProgram = [searchProgramArray objectAtIndex:indexPath.row];            
                [cell addTime1Label];
                [cell.time1Label setFrame:CGRectMake(110, 15, 140, 20)];
                cell.time1Label.text = newProgram.title;

                
                [cell addTime2Label];		
                
                NSArray *startDateTime = [newProgram.start componentsSeparatedByString:@" "];
                NSString *getStartTime= [startDateTime objectAtIndex:4];
                
                NSArray *startHours = [getStartTime componentsSeparatedByString:@":"];
                NSString *startTime= [startHours objectAtIndex:0];
                startTime = [startTime stringByAppendingFormat:@":%@",[startHours objectAtIndex:0]];
                
                NSArray *endDateTime = [newProgram.end componentsSeparatedByString:@" "];
                NSString *getEndTime= [endDateTime objectAtIndex:4];
                
                NSArray *endHours = [getEndTime componentsSeparatedByString:@":"];
                NSString *endTime= [endHours objectAtIndex:0];
                endTime = [endTime stringByAppendingFormat:@":%@",[endHours objectAtIndex:1]];
                
                if(startTime != nil && endTime != nil) {
                    
                    [cell addTime2Label];	
                    [cell.time2Label setFrame:CGRectMake(10, 15, 100, 20)];
                    cell.time2Label.text = [startTime stringByAppendingFormat:@" - %@",endTime];
                    
                } 
            
                // set channel logo image to image view 
                        
                for(Channel *newChannel in self.favoriteChannelArray) {
                    if(newProgram.channel == newChannel.id) {
                        if([newChannel.imageObjectsArray count] !=0 || newChannel.imageObjectsArray != nil) {
                            Image *imageObject = [newChannel.imageObjectsArray objectAtIndex:0];
                            NSMutableString *url = [[NSMutableString alloc] initWithString:BASEURL];
                            if(imageObject.src != nil)
                            [url appendString:imageObject.src];
                            [cell.logoImageView setFrame:CGRectMake(self.view.bounds.size.width-70, 15, 45, 20)];
                            [cell.logoImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"bigChannelLogo"]];
                            
                            DLog(@"channel server path string %@", imageObject.src);

                        }
                    }
                }
              
    }

	return cell;
}
		

#pragma mark -
#pragma mark Tableview delegate methods
#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    	
    [self.searchBarForChannels resignFirstResponder];
    
	if(searchFlag!= 1) {		

		self.channelIndex = [indexPath row];
        
        [self showProgramListControllerWithProgramsForChannel:[indexPath row]];

        
	} else {
         
        formProgramDetail = YES;
    
         NSString *key  = [self.dicKeys objectAtIndex:[indexPath section]];
         NSMutableArray *searchProgramArray  = [self.searchDictionary objectForKey:key];
        
         Program *program = [searchProgramArray objectAtIndex:[indexPath row]];
         
         
        for (int i = 0; i < [self.favoriteChannelArray count]; i++) {
            
            
            Channel *channel = [self.favoriteChannelArray objectAtIndex:i];
            
            
            if (channel.id == program.channel) {
                
                [self showSummaryViewForProgram:program.programId andChannels:channel forPush:NO];
                
                break;
                
            }
        }
         
	}

    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if(isEditButtonClicked == YES) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
	return YES;
}


- (void)deleteChannelsLocally:(int)index {
    
    
    FavoriteChannel *deletedfavoriteChannel = [self.displayChannelArray objectAtIndex:index];
    
    ChannelRepository *channelRepository = [[ChannelRepository alloc] init];
    
    NSMutableArray *defaultFavArray  = [channelRepository getDefaultFavoriteChannelFromDB];
    
    for (int k = 0; k < [defaultFavArray count]; k++) {
        
        FavoriteChannel *favoriteChannel = [defaultFavArray objectAtIndex:k];
        
        [channelRepository deleteDefaultFavoriteChannelFromDB:favoriteChannel.channel_id];  
        
    }
    
        
    AppDelegate_iPhone * appDelegate = DELEGATE;
    
    
    NSMutableArray *channelSToAddArray = [[NSMutableArray alloc]init];
    
    
    for (int i = 0; i < [appDelegate.favoriteChannelsViewController.displayChannelArray count]; i++) {
        
        
        FavoriteChannel *favoriteChannel = [appDelegate.favoriteChannelsViewController.displayChannelArray objectAtIndex:i];
        
        if (favoriteChannel.channel_id != deletedfavoriteChannel.channel_id) {
            
            [channelSToAddArray addObject:favoriteChannel];
        }  
        
        
    }
    
    
   for (int j = 0; j< [channelSToAddArray count]; j++) {
        
        
        FavoriteChannel *favoriteChannel = [channelSToAddArray objectAtIndex:j];
    
        [channelRepository addDefaultFavoriteChannelFromDB:favoriteChannel.channel_id andChannelOrder:j];  
    }
    
    
    [self callFavoriteChannelProxy];
    
}


- (void)reorderChannelsLocally {
    
    
    ChannelRepository *channelRepository = [[ChannelRepository alloc] init];
    
    NSMutableArray *defaultFavArray  = [channelRepository getDefaultFavoriteChannelFromDB];
    
    for (int k = 0; k < [defaultFavArray count]; k++) {
        
        FavoriteChannel *favoriteChannel = [defaultFavArray objectAtIndex:k];
        
        [channelRepository deleteDefaultFavoriteChannelFromDB:favoriteChannel.channel_id];  
        
    }
    
    
    AppDelegate_iPhone * appDelegate = DELEGATE;
    
    for (int j = 0; j< [appDelegate.favoriteChannelsViewController.displayChannelArray count]; j++) {
        
        
        FavoriteChannel *favoriteChannel = [appDelegate.favoriteChannelsViewController.displayChannelArray objectAtIndex:j];
        
        [channelRepository addDefaultFavoriteChannelFromDB:favoriteChannel.channel_id andChannelOrder:j];  
    }
    
    
    [self callFavoriteChannelProxy];

}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
	AppDelegate_iPhone * appDelegate = DELEGATE;
    isReorder = NO;
    
    
    if(appDelegate.isGuest == YES)  {        
        [self deleteChannelsLocally:[indexPath row]];        
        return;
        
    }
    
	if(isEditButtonClicked) {	
        
		newfavoriteChannel = [self.displayChannelArray objectAtIndex:[indexPath row]];
		Channel *newChannel = [self.favoriteChannelArray objectAtIndex:[indexPath row]];
			
		for(FavoriteChannel *favChannel in self.displayChannelArray) {
            
			if(favChannel.channel_id == newChannel.id) {
				
                newfavoriteChannel = favChannel;
                
                int indexOfObject = [self.displayChannelArray indexOfObject:favChannel];
                
                DLog(@"Index : %d",indexOfObject);
                
                [self.displayChannelArray removeObjectAtIndex:indexOfObject];
                                
				break;
			}
		}	
        DLog(@"Post array : %@", self.displayChannelArray);
		[self.favoriteChannelArray removeObjectAtIndex:[indexPath row]];
		[self.channelNamesArray removeObjectAtIndex:[indexPath row]];	
        
	}
	
	for(int i = indexPath.row ; i < [self.displayChannelArray count]; i++) { 
        
		FavoriteChannel *favChannel = [self.displayChannelArray objectAtIndex:i];
		favChannel.channel_order = favChannel.channel_order-1;
	}	
	
	NSArray * arrTemp=[[NSArray alloc] initWithObjects:[NSIndexPath indexPathForRow:[indexPath row] inSection:0],nil];
	if([arrTemp count] > 1)
		[self.favoriteChannelsTableView deleteRowsAtIndexPaths:arrTemp withRowAnimation:UITableViewRowAnimationFade];
	else
		[self.favoriteChannelsTableView reloadData];
	
	if(appDelegate.isGuest == NO) {
        
        
        [self createChannelProxy];
        [self.channelProxy deleteChannelsWithSessionKey:appDelegate.authenticationToken andUsername:appDelegate.user.email andChannels:[self createDictionary]];

	}
    
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
			
    isReorder = YES;
    
	Channel *channelToMove = [self.favoriteChannelArray objectAtIndex:sourceIndexPath.row];
   	[self.favoriteChannelArray removeObject:channelToMove];
    [self.favoriteChannelArray insertObject:channelToMove atIndex:destinationIndexPath.row];
	
	FavoriteChannel *favChannelToMove = [self.displayChannelArray objectAtIndex:sourceIndexPath.row];
    [self.displayChannelArray removeObject:favChannelToMove];
	favChannelToMove.channel_order = destinationIndexPath.row;
	
	DLog(@"sourceIndexPath.row : %d destinationIndexPath.row : %d",sourceIndexPath.row,destinationIndexPath.row);
	
	if(destinationIndexPath.row < sourceIndexPath.row) {
		for(int i = destinationIndexPath.row; i < sourceIndexPath.row; i++) { 			FavoriteChannel *favChannel = [self.displayChannelArray objectAtIndex:i];
			favChannel.channel_order = favChannel.channel_order+1;
			DLog(@"Before favChannel.channel_order : %d",favChannel.channel_order);
		}	
	} else {
		for(int i = sourceIndexPath.row; i < destinationIndexPath.row; i++) { 			FavoriteChannel *favChannel = [self.displayChannelArray objectAtIndex:i];
			favChannel.channel_order = favChannel.channel_order-1;
			DLog(@"After favChannel.channel_order : %d",favChannel.channel_order);
		}	
	}	
	
    [self.displayChannelArray insertObject:favChannelToMove atIndex:destinationIndexPath.row];
	
	
	NSString *stringToMove = [self.channelNamesArray objectAtIndex:sourceIndexPath.row];
    [self.channelNamesArray removeObjectAtIndex:sourceIndexPath.row];
    [self.channelNamesArray insertObject:stringToMove atIndex:destinationIndexPath.row];
	

		
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (noRecordFound  || searchFlag != 1)  {
        
        return 0;
        
    } else {
    
        return 45;

    } 
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {      
    if (noRecordFound  || searchFlag != 1)  {        
        return nil;        
    } 
    else {
        NSString *key  = [self.dicKeys objectAtIndex:section];
        
        NSMutableArray *searchProgramArray  = [self.searchDictionary objectForKey:key];
        Program *programObj = [searchProgramArray objectAtIndex:0];
        
        NSDate *reminderDate = [UIUtils dateFromGivenGMTString:programObj.start WithFormat:@"EEE,ddMMMyyyyHH:mm:ss z"];         
        
        NSString *dayString = [UIUtils stringFromGivenGMTDate:reminderDate WithFormat:@"EEEE"];
        
        NSString *dateString = [UIUtils stringFromGivenGMTDate:reminderDate WithFormat:@"dd/MM"];
        
        NSString *sectionTitle = [NSString stringWithFormat:@"%@ d. %@",dayString,dateString];
        
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 45)];
        headerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_title"]];
        UILabel *headerLabel = [UIControls createUILabelWithFrame:CGRectMake(10, 0, 310, 49) FondSize:15 FontName:SYSTEMBOLD FontHexColor:White LabelText:@""];
        [headerLabel setText:sectionTitle];
        [headerView addSubview:headerLabel];
        
        return headerView;
    } 
}


#pragma mark -
#pragma mark Event handling methods

-(void) editButtonTapped : (UIButton *) sender {	
    
    isEditButtonClicked = YES;
    isReorder = NO;
    self.navigationItem.title = editChannelsNavigationTitleStr;
    
    self.favoriteChannelsTableView.tableHeaderView.hidden = YES;
    CGRect frame = self.favoriteChannelsTableView.frame;
    frame.origin.y = frame.origin.y - 45;
    //frame.size.height = 460;
    
    frame.size.height = self.view.bounds.size.height;
    
    self.favoriteChannelsTableView.frame = frame;
    [self.favoriteChannelsTableView scrollRectToVisible:frame animated:NO];
    
	if(self.favoriteChannelsTableView.editing){
		self.favoriteChannelsTableView.editing=!self.favoriteChannelsTableView.editing;
	}
	else{
       	self.favoriteChannelsTableView.editing=!self.favoriteChannelsTableView.editing;
	}
	[self addAddChannelButton];
    [self.favoriteChannelsTableView reloadData];
}

-(void) addButtonTapped : (UIButton *) sender {
    
   AppDelegate_iPhone * appDelegate = DELEGATE;
	if(!self.addChannelsViewController) {
		AddChannelsViewController *vcTemp = [[AddChannelsViewController alloc] init];
		self.addChannelsViewController = vcTemp;
	}
    isAddButtonTapped = YES;

    self.addChannelsViewController.view.frame =  self.view.frame;
    
	UINavigationController *modalnavigationController = [[UINavigationController alloc]
													initWithRootViewController:self.addChannelsViewController];
    
	//[self.addChannelsViewController viewWillAppear:YES];

	[appDelegate.containerViewController presentModalViewController:modalnavigationController animated:YES];
}

-(void) saveButtonTapped : (UIButton *) sender {
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    self.navigationItem.title = nil;
    self.navigationItem.leftBarButtonItem = nil;
    isEditButtonClicked = NO;
    [self.favoriteChannelsTableView reloadData];

    
    
    if(isReorder == YES) {
        
        
        if (appDelegate.isGuest == YES) {
            
            
            [self reorderChannelsLocally];
            
        } else {
          
            [self callChannelProxyForReordering];
        }   
    }
    
    
     self.favoriteChannelsTableView.tableHeaderView.hidden = NO;
    CGRect frame = self.favoriteChannelsTableView.frame;
    frame.origin.y = 0;
    
    frame.size.height = self.view.bounds.size.height;
    
    self.favoriteChannelsTableView.frame = frame;

    [self addEditButton];	
    [self createMenuBar];
    if(self.favoriteChannelsTableView.editing){ 
        self.favoriteChannelsTableView.editing=!self.favoriteChannelsTableView.editing;
    }
   
}



#pragma mark -
#pragma mark - ProUserRequiredScreen

- (void)showProUserRequiredScreen {
    
    ProUserRequiredScreen *proUserRequiredScreen = [[ProUserRequiredScreen alloc]init];
    
    [self.navigationController pushViewController:proUserRequiredScreen animated:YES];
    
}


- (void)swithToHomeFromSearchScreen {
    
    searchFlag = 0;
            
    [favoriteChannelsTableView setFrame:CGRectMake(favoriteChannelsTableView.frame.origin.x, 0, favoriteChannelsTableView.frame.size.width, favoriteChannelsTableView.frame.size.height)];
    
    [self.searchBarForChannels resignFirstResponder];
    [self.favoriteChannelsTableView reloadData];
    [self dismissModalViewControllerAnimated:YES];
    [self addEditButton];
    
}

#pragma mark -
#pragma mark Searchbar delegate methods


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

	self.searchBarForChannels.showsCancelButton=YES;
} 

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    self.startDateString = [UIUtils startTimeFromGivenDate:[NSDate date]];
    
    AppDelegate_iPhone *appDelegate = DELEGATE;

    int newdateDaysFromCurrentDate = 0;
    
    if ([appDelegate.user.subscription isEqualToString:PRO_USER]|| [appDelegate.user.subscription isEqualToString:PLUS_USER] ) {

        newdateDaysFromCurrentDate = 14;
    } 
    
    NSDate *newDate = [[NSDate date] dateByAddingTimeInterval:86400*newdateDaysFromCurrentDate];
    
    self.endDateString = [UIUtils endTimeFromGivenDate:newDate];
	searchFlag=1;
	[self.searchBarForChannels resignFirstResponder];

	if([searchBar.text isEqualToString:@""] || searchBar.text == nil) {
	} else {
		[self callSearchProgramProxy];
	}	
    
    [favoriteChannelsTableView setFrame:CGRectMake(favoriteChannelsTableView.frame.origin.x, 0, favoriteChannelsTableView.frame.size.width, self.view.bounds.size.height)];

    
    self.searchBarForChannels.tintColor = [UIUtils colorFromHexColor:@"b00a4f"];
    
    self.navigationItem.leftBarButtonItem = nil;
    UIButton *back = [UIUtils createBackButtonWithTarget:self action:@selector(backButtonTapped)];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem=backButton;
    [self dismissModalViewControllerAnimated:YES];
    
}
-(void)backButtonTapped {
    searchFlag=0;
    [self configureFavoriteChannelView];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{

	self.searchBarForChannels.showsCancelButton=YES;
	self.searchBarForChannels.autocorrectionType = UITextAutocorrectionTypeNo;	
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
	self.searchBarForChannels.showsCancelButton=NO;
}

#pragma mark -
#pragma mark Cancel Button Clicked

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{	

    
    [searchBar resignFirstResponder];
		
}




#pragma mark -
#pragma mark Show ProgramListController methods


-(void)showProgramListControllerWithProgramsForChannel:(int)cIndex {
    
	ProgramListViewController *programListViewController = [[ProgramListViewController alloc] init];
    
    
    [programListViewController setArray:self.favoriteChannelArray AndCurrentSelectedIndex:cIndex AndSeletedMenuType:other];
    
	[self.navigationController pushViewController:programListViewController animated:YES];

}


#pragma mark -
#pragma mark Show Recommendation View method


- (void)showRecommendationView:(CGRect)frame {
    
    self.navigationItem.leftBarButtonItem = nil;

    RecommendationView *recommendationView = [[RecommendationView alloc] initWithFrame:frame];
    
    // ABP
    recommendationView.autoresizingMask=(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);  
    
    [recommendationView setTag:Recommendation];
    
    [recommendationView channelArray:self.favoriteChannelArray];
    [recommendationView createUI];
    
    [self.view addSubview:recommendationView];
    
}



#pragma mark -
#pragma mark Show Category View method 

- (void)showCategoryView:(CGRect)frame {
    
    self.navigationItem.leftBarButtonItem = nil;

    CategoryView *categoryView = [[CategoryView alloc] initWithFrame:frame];

    categoryView.autoresizingMask=(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight); 
    
    [categoryView setTag:Categories];
    self.categoryView = categoryView;
        
    [self.view addSubview:categoryView];
    
}


#pragma mark -
#pragma mark Show User View method 

- (void)showUserView:(CGRect)frame {
    
    self.navigationItem.leftBarButtonItem = nil;
    
    UserView *userView = [[UserView alloc] initWithFrame:frame];
    
    // ABP
    userView.autoresizingMask=(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    
    [userView setTag:Users];
    
    [self.view addSubview:userView];
    
    
}


#pragma mark -
#pragma mark Show Plan View method 

- (void)showPlanView:(CGRect)frame {
    
    
    PlanView *planView = [[PlanView alloc] initWithFrame:frame];
    
    // ABP
    planView.autoresizingMask=(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    
    [planView setTag:Plan];

    [self.view addSubview:planView];
    
    
}



#pragma mark -
#pragma mark - Menu Bar Creation and Delegate Methods 

- (void)createMenuBar {
    
    MenuBar *tempMenuBar = [[MenuBar alloc] initWithFrame:CGRectMake(0, 0, 197, 44)];
    self.menuBarView = tempMenuBar;
    self.menuBarView.menuBarDelegate = self;
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:self.menuBarView];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    AppDelegate_iPhone *appDelegate = DELEGATE;

    [self.menuBarView highLightcurrentSelectedButton:appDelegate.selectedMenuItem];
        
}
- (void)createMenuBarForiPad {
    
    MenuBar *tempMenuBar = [[MenuBar alloc] initWithFrame:CGRectMake(0, 0, 197, 44)];
    self.menuBarView = tempMenuBar;
    self.menuBarView.menuBarDelegate = self;
 
    UIView *men=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 197, 44)];
    [men addSubview:self.menuBarView];
    self.navigationItem.titleView = men;
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    [self.menuBarView highLightcurrentSelectedButton:appDelegate.selectedMenuItem];
    
}

- (void)menubarButtonClicked:(MenuBarButton)buttonType {
    
    
    DLog(@"%d",buttonType);
    
    [self.searchBarForChannels resignFirstResponder];
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    appDelegate.selectedMenuItem  = buttonType;
    
    self.searchBarForChannels.tintColor = [UIUtils colorFromHexColor:@"b00a4f"];
    self.startDateString = [UIUtils stringFromGivenDate:[NSDate date] withLocale: @"en_US" andFormat: @"EEEddMMMyyyy hh:mm:ss"];
    
    [self showSelectedMenu];
}



- (void)showSelectedMenu {

    DLog(@"**********showSelectedMenu1**********");

    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    DLog(@"%d",appDelegate.selectedMenuItem);
    
    BOOL PresentView = [self removeViews:appDelegate.selectedMenuItem];   
    [self.menuBarView highLightcurrentSelectedButton:appDelegate.selectedMenuItem];
    
    if (!PresentView) {
        
        [self addSubViews:appDelegate.selectedMenuItem];
        
    }
    
    if (appDelegate.selectedMenuItem == Favorite) {
    
        [self callFavoriteChannelProxy];
    } 
    
    [self showPushedProgramInSummaryScreen];
    
    DLog(@"**********showSelectedMenu2**********");

}


- (BOOL)removeViews:(MenuBarButton)selectedMenu {
    
    UIView *present = [self.view viewWithTag:selectedMenu];
    
    if (present) {
        
        return YES;
    }

    [[self.view viewWithTag:Categories] removeFromSuperview];
    [[self.view viewWithTag:Recommendation] removeFromSuperview];
    [[self.view viewWithTag:Plan] removeFromSuperview];
    [[self.view  viewWithTag:Users] removeFromSuperview];
    
    return  NO;
    
}

// This methods create the Selected Menu view and shows 

- (void)addSubViews:(MenuBarButton)buttonType {
    
  self.navigationItem.leftBarButtonItem = nil;
  
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    switch (buttonType) {
            
        case Favorite: {
        
            [self swithToHomeFromSearchScreen];
            [self addEditButton];
        } 
        break;
            
        case Recommendation: {
            
            [self showRecommendationView:frame];
        }
        break;
            
        case Categories: {
            
            [self showCategoryView:frame];
        }
        break;
            
        case Plan: {

            [self showPlanView:frame];

        }
        break;
            
        case Users: {
    
            [self showUserView:frame];
    
        }
        break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark Create Summary View 

- (void)showSummaryViewForProgram:(NSString*)progID andChannels:(Channel*)chan forPush:(BOOL)push
{

    SummaryScreenViewController *summaryVC = [[SummaryScreenViewController alloc] init];
    summaryVC.programId = progID;
    summaryVC.channel = chan;
    
    if (push) {
        
        summaryVC.fromSearch = NO;
        summaryVC.fromPush = YES;
    
    } else {
        
        summaryVC.fromSearch = YES;
        summaryVC.fromPush = NO;
    }
    
    [self.navigationController pushViewController:summaryVC animated:YES];
    
}

- (void)noChannelsRecordsFound {
    
    noRecordFound = YES;
    [self.favoriteChannelsTableView reloadData];
}
- (void)noProgramRecordsFound {
    
    noRecordFound = YES;
    [self.favoriteChannelsTableView reloadData];    
}


- (void)refreshChannelsIds {
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
        
    [self createLoginProxy];

    [self.loginProxy getCredentialsWithUsername:appDelegate.user.email andBase64Value:appDelegate.authenticationToken];
    
}


-(void)loginSuccessful :(User *)user {
    
    AppDelegate_iPhone *appDelegate = DELEGATE;

    appDelegate.user = user;
    
    [self callFavoriteChannelProxy];
}

-(void)loginFailed:(NSString *)error {
    
    
}


-(void)fetchAllChannels {
    	    
    [self createChannelProxy];

    [self.channelProxy setChannelProxyDelegate:self];

    [self.channelProxy getChannelsFor:@"FavoriteView"];

}


- (void)receivedAllChannnel:(NSMutableArray*)channelArray {
        
    self.allChannelsArray = channelArray;
    
}



#pragma mark 
#pragma mark Push Notification


// Method gets called when user receive the Push notification
// It show the received push notification program's details in summary view.

- (void)showPushedProgramInSummaryScreen {
    
    DLog(@"showPushedProgramInSummaryScreen1");

    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    
    if (appDelegate.isGuest) {
        
        return;
    }
    
    DLog(@"***####showPushedProgramInSummaryScreen#########**** %@",appDelegate.pushProgramId);
    
    if(![appDelegate.pushProgramId isEqualToString:@"-1"]) {
        
        [self showSummaryViewForProgram:appDelegate.pushProgramId andChannels:nil forPush:YES];
        appDelegate.pushProgramId = @"-1";
    }
    
    DLog(@"showPushedProgramInSummaryScreen2");
    
    
}

#pragma mark -
#pragma mark - Refresh Screen Notification Method

// This method is call when application enters to foreground from background state.

- (void)refreshScreen {
    
    
    if (searchFlag ==  1) {
        
        if([searchBarForChannels.text isEqualToString:@""] || searchBarForChannels.text == nil) {
    
            [self callSearchProgramProxy];
        }

    } else {
     
        [self callFavoriteChannelProxy];

    }
}




#pragma mark -
#pragma mark - Proxy Creation 

// creates the proxy for program requests and assigns delegates. 


- (void)createProgramProxy {
    
    if (!self.programProxy) {
        
        ProgramProxy *tempprogramProxy = [[ProgramProxy alloc] init];
        self.programProxy = tempprogramProxy;
        
    }
    
    [self.programProxy setProgramProxyDelegate:self];
    
}

// creates the proxy for channels requests and assigns delegates. 


- (void)createChannelProxy {
    
    if (!self.channelProxy) {
        
        ChannelProxy *tempChannelProxy = [[ChannelProxy alloc] init];
        self.channelProxy = tempChannelProxy;
    }
    
    [self.channelProxy setChannelProxyDelegate:self];
    
}


// creates the proxy for login requests and assigns delegates. 


- (void)createLoginProxy {
    
    if (!self.loginProxy) {
        
        LoginProxy *tempLoginProxy = [[LoginProxy alloc] init];
        self.loginProxy = tempLoginProxy;
        
    }
    
    [self.loginProxy setLoginProxyDelegate:self];
}


@end
