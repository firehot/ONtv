
#import "FavoriteChannelsIPadViewController.h"
#import "CustomCellForChannel.h"
#import "AppDelegate_iPad.h"
#import "Channel.h"
#import "FavoriteChannel.h"
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
#import "iPadChannelView.h"


NSString *editChannelsNavigationTitleStr;
NSString *searchHeaderLabelStr;
NSString *searchHeaderShowsLabelStr;
NSString *channelsButtonStr;
NSString *searchbarPlaceHolderStr;
NSString *searchHeaderTodayLabelStr;

BOOL formProgramDetail;


@implementation FavoriteChannelsIPadViewController

@synthesize menuBarView = _menuBarView;
@synthesize allChannelsArray = _allChannelsArray;
@synthesize dicKeys = _dicKeys;
@synthesize searchDictionary = _searchDictionary;
@synthesize channelProxy = _channelProxy;
@synthesize programProxy = _programProxy;
@synthesize loginProxy = _loginProxy;
@synthesize categoryView = _categoryView;
@synthesize favoriteChannelsScrollView = _favoriteChannelsScrollView;
#ifdef LANDSCAPE_MODE_ENABLED
@synthesize landscapeView=_landscapeView;
#endif
@synthesize portraitView=_portraitView;
@synthesize catView=_catView;

#pragma mark -
#pragma mark User defined methods

-(void)configureFavoriteChannelView {    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.tintColor = [UIUtils colorFromHexColor:@"36b6d5"];
    
	[self createTableView];
    
    [self createIPadChannelView];
#ifdef LANDSCAPE_MODE_ENABLED
    [self createLandscapeView];
    
    //Hide one of the view-types according to orientation!
    if(UIDeviceOrientationIsLandscape(self.interfaceOrientation)){
        self.favoriteChannelsScrollView.hidden = YES;
    }
    else {
        self.landscapeView.hidden = YES;
    }
#endif
    
    
	AppDelegate_iPad *appDelegate = IPADDELEGATE;
	if(appDelegate.isGuest == NO) {	
		[self addEditButton];	
	}
	
    
    [self createMenuBar];
    [self callFavoriteChannelProxy];
	appDelegate.currentViewController = self;
    
    
    self.startDateString = [UIUtils stringFromGivenDate:[NSDate date] withLocale: @"en_US" andFormat: @"EEEddMMMyyyy hh:mm:ss"];
    self.endDateString = [UIUtils endTimeFromGivenDate:[NSDate date]];
    
    [self addSearchBar];
    [self.favoriteChannelsTableView  setFrame: CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)]; 
}

-(void) createTableView {
	MyUITableView *channelTableView = [[MyUITableView alloc] initWithIPadViewController:self];
    channelTableView.autoresizingMask=(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    NSLog(@"%f", CGRectGetHeight(self.view.bounds)-CGRectGetHeight(self.menuBarView.frame)-CGRectGetHeight(self.searchBarForChannels.frame));
	channelTableView.tag = 0;
    
	self.favoriteChannelsTableView = channelTableView;	
    self.favoriteChannelsTableView.frame = CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height);
	self.favoriteChannelsTableView.delegate = self;
	self.favoriteChannelsTableView.dataSource = self;	
	[self.view addSubview:self.favoriteChannelsTableView];
	self.favoriteChannelsTableView.hidden = YES;
}

#pragma mark -
#pragma mark Event handling methods

-(void) editButtonTapped : (UIButton *) sender {	
    self.favoriteChannelsTableView.hidden = NO;
    self.favoriteChannelsScrollView.hidden = YES;
#ifdef LANDSCAPE_MODE_ENABLED
    self.landscapeView.hidden = YES;
#endif
    [super editButtonTapped:sender];
}

-(void) saveButtonTapped : (UIButton *) sender {
    self.favoriteChannelsTableView.hidden = YES;

#ifdef LANDSCAPE_MODE_ENABLED
    if(UIDeviceOrientationIsLandscape(self.interfaceOrientation)){
        self.landscapeView.hidden = NO;
    }
    else {
        self.favoriteChannelsScrollView.hidden = NO;
    }
#else
    self.favoriteChannelsScrollView.hidden = NO;
#endif
    
    [super saveButtonTapped:sender];
}


#pragma mark -
#pragma mark Landscape view

#ifdef LANDSCAPE_MODE_ENABLED
- (void) createLandscapeView{
    NSLog(@"--------------------------> Create iPad Landscape view with width=%f and height=%f",self.view.bounds.size.width,self.view.bounds.size.height);

    CGRect frame = CGRectMake(0,0,1024,768-44-20); //Hardcoded because we don't want the view to change when rotating device!
    FavoriteChannelLandscapeView *landscapeView = [[FavoriteChannelLandscapeView alloc] initWithFrame:frame andChannels:self.favoriteChannelArray];
    
    self.landscapeView = landscapeView;
    [self.view addSubview:self.landscapeView];
}

- (void) updateLandscapeView{
    NSLog(@"--------------------------> Update iPad Landscape view with width=%f and height=%f",self.view.bounds.size.width,self.view.bounds.size.height);    
    NSLog(@"Channels: %d - programs:%d",[self.favoriteChannelArray count], [[[self.favoriteChannelArray objectAtIndex:0] programs] count]);
    
    [self.landscapeView updateScrollViewsWithFrame:self.landscapeView.frame andChannels:self.favoriteChannelArray];
}
#endif

#pragma mark -
#pragma mark iPad specific views

- (void) createIPadChannelView{
    NSLog(@"--------------------------> Create iPad Table view with orientation %d!",self.interfaceOrientation);   
    
//    iPadCategoryView *catView = [[iPadCategoryView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024-44-20)];    
//    self.catView = catView;
//    [self.view addSubview:self.catView];
    
    iPadFavoriteChannelPortraitView *portraitView = [[iPadFavoriteChannelPortraitView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    portraitView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.portraitView = portraitView;
    [self.view addSubview:self.portraitView];
}

- (void) updateIPadChannelView{
    NSLog(@"--------------------------> Update iPad Table view!");
    [self.portraitView updateViewWithChannels:self.favoriteChannelArray];
}


#pragma mark -
#pragma mark On touch event controllers


-(void) userDidSelectChannelWithTag:(NSInteger)tag{
    [self.searchBarForChannels resignFirstResponder];
    	
    self.channelIndex = tag;
    [self showProgramListControllerWithProgramsForChannel:tag];
}

-(void) userDidSelectChannel:(Channel*)channel withTag:(NSInteger)tag{
    [self.searchBarForChannels resignFirstResponder];
    
	if(searchFlag!= 1) {		
		self.channelIndex = tag;
        [self showProgramListControllerWithProgramsForChannel:tag];
	} 
}

//Is this how we need to select a program????
-(void) userDidSelectProgram:(Program*)program{
    [self.searchBarForChannels resignFirstResponder];
    
    for (int i = 0; i < [self.favoriteChannelArray count]; i++) {
        Channel *channel = [self.favoriteChannelArray objectAtIndex:i];
        
        if (channel.id == program.channel) {
            AppDelegate_iPhone *appDelegate = DELEGATE;
            
            SummaryScreenViewController *summaryVC = [[SummaryScreenViewController alloc] init];
            summaryVC.programId = program.programId;
            summaryVC.channel = channel;
            
            if ([appDelegate.user.subscription isEqualToString:PRO_USER] || [appDelegate.user.subscription isEqualToString:PLUS_USER])  { 
                
                summaryVC.program = program;
            }    
            
            [self.navigationController pushViewController:summaryVC animated:YES];
            break;
        }
    }
}

#pragma mark -
#pragma mark - Device rotation

#ifdef LANDSCAPE_MODE_ENABLED
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if (self.favoriteChannelsTableView.hidden) {
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            self.favoriteChannelsScrollView.hidden = true;
            self.landscapeView.hidden = false;
        }
        else {
            self.favoriteChannelsScrollView.hidden = false;
            self.landscapeView.hidden = true;
        }
    }
}
#endif

@end



@implementation MyUITableView
@synthesize owner=_owner;

- (id) initWithIPadViewController:(FavoriteChannelsIPadViewController*)owner{
    self = [super init];
    if (self) {
        self.owner = owner;
    }
    return self;
}

- (void)reloadData {
    [super reloadData];
    [self.owner updateIPadChannelView];
#ifdef LANDSCAPE_MODE_ENABLED
    [self.owner updateLandscapeView];
#endif
}

@end







