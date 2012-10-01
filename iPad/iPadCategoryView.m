//
//  iPadCategoryView.m
//  OnTV
//
//  Created by Andreas Hirszhorn on 31/7/12.
//  Copyright (c) 2012 Touch Logic I/S. All rights reserved.
//


#import "iPadCategoryView.h"
#import "CustomCellForChannel.h"
#import "ChannelCategory.h"
#import "CategoryDataModel.h"
#import "ProgramListViewController.h"
#import "iPadSingleCategoryView.h"


@interface iPadCategoryView()

- (void)createUI;
- (void)fetchCategories; 
- (void)showProgramListControllerWithProgramsForChannel:(int)cIndex; 
- (void)createCategoryProxy;

@end


NSIndexPath* aindexPath; 

@implementation iPadCategoryView

@synthesize categoryArray = _categoryArray;
@synthesize categoryProxy = _categoryProxy;
@synthesize scrollView=_scrollView;

#pragma mark - 
#pragma mark - Life Cycle Methods


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame]; 
        scrollView.backgroundColor = [UIColor lightGrayColor];
        self.scrollView = scrollView;
        [self addSubview:self.scrollView];
        
        [self createUI];
        
    }
    return self;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -
#pragma mark Create UI

// create UI
// Register for Status Bar Height Change i.e when incomming call
// Register for refresh screen notification when app enters fore ground from back ground.

- (void)createUI {
    
    [UIControls registerRefreshScreenNotificationsFor:self];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self fetchCategories];
}

//TODO: update the iPadCategoryView
- (void)updateCategories{
    
    int MARGIN_VERTICAL = 20;
    int MARGIN_HORIZONTAL = 40;
    int HEIGHT_OF_CHANNEL = 220;
    int width = (768 - 3*MARGIN_HORIZONTAL)/2; 
    
    int i = 0;
    for (CategoryDataModel *categoryObj in self.categoryArray) {
        //TODO Update the iPadSingleCategoryViews
        CGRect rect = CGRectMake(MARGIN_HORIZONTAL+(width+MARGIN_HORIZONTAL)*(i%2), 
                                 MARGIN_VERTICAL+(HEIGHT_OF_CHANNEL+MARGIN_VERTICAL)*(i/2), 
                                 width, 
                                 HEIGHT_OF_CHANNEL);
        i++;
        
        iPadSingleCategoryView *catView = [[iPadSingleCategoryView alloc] initWithFrame:rect andCategory:categoryObj];
        [self.scrollView addSubview:catView];
    }

    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, ([self.categoryArray count]+1)/2 * (HEIGHT_OF_CHANNEL+MARGIN_VERTICAL) + MARGIN_VERTICAL)];
}

#pragma mark -
#pragma mark - Server Communication Methods 

// gets called to fetch all the categories for server / cache 

- (void)fetchCategories {
    [self createCategoryProxy];
    [self.categoryProxy getCategories];
}

#pragma mark -
#pragma mark - Category Delegate Methods 

// gets called whenever the server request is failed.

- (void)categoryRequestFailed:(NSString *)error {
    
}

// gets called whenever the server request is succesfully.

- (void)receivedCategory:(NSMutableArray*)array {
    
    noRecordFound = NO;    
    [self.categoryArray removeAllObjects];    
    self.categoryArray = array;
            
    [self updateCategories];
}


// gets called when ever request is successfully but the return data objects count is zero.

- (void)nocategoryRecordsFound {
    
    noRecordFound = YES;    
    [self.categoryArray removeAllObjects];
    
    [self updateCategories];
}

#pragma mark -
#pragma mark Show ProgramListController methods

// show the selected category programs.

-(void)showProgramListControllerWithProgramsForChannel:(int)cIndex {
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    
	ProgramListViewController *programListViewController = [[ProgramListViewController alloc] init];
    
    
    [programListViewController setArray:appDelegate.favoriteChannelsViewController.favoriteChannelArray AndCurrentSelectedIndex:cIndex AndSeletedMenuType:Categories];
    
    programListViewController.categoryArray = self.categoryArray;
    
	[appDelegate.rootNavController pushViewController:programListViewController animated:YES];
}




#pragma mark -
#pragma mark - Refresh Screen Notification Method

// This method is call when application enters to foreground from background state.

- (void)refreshScreen {
    [self fetchCategories];
}


#pragma mark -
#pragma mark - Proxy Creation 

// creates the proxy for category requests and assigns delegates. 

- (void)createCategoryProxy {
    
    if (!self.categoryProxy) {
        
        CategoryProxy *tempCategoryProxy = [[CategoryProxy alloc] init];
        
        self.categoryProxy = tempCategoryProxy;
        
    }
    
    [self.categoryProxy setCategoryProxyDelegate:self];
}

@end
