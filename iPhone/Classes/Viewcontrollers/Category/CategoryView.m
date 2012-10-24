	


#import "CategoryView.h"

#import "CustomCellForChannel.h"
#import "ChannelCategory.h"
#import "Program.h"
#import "CategoryProxy.h"
#import "CategoryDataModel.h"
#import "ProgramListViewController.h"

@interface CategoryView()

- (void)createUI;

- (void)createTableView;

- (void)fetchCategories; 

- (void)showProgramListControllerWithProgramsForChannel:(int)cIndex; 

- (UITableViewCell*)getNoRecordPresentCellForTableView:(UITableView*)table;

- (void)createCategoryProxy;

@end


NSIndexPath* aindexPath; 



@implementation CategoryView

@synthesize categoryArray = _categoryArray;
@synthesize categoryProxy = _categoryProxy;
@synthesize categoryTableView = _categoryTableView;

#pragma mark - 
#pragma mark - Life Cycle Methods


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
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

- (void)createUI; {
    
    [UIControls registerRefreshScreenNotificationsFor:self];
    
    [self setBackgroundColor:[UIColor whiteColor]];
   
    [self createTableView];
    
    [self fetchCategories];

    
}


#pragma mark - 
#pragma mark - createTableView

- (void)createTableView {
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
    _categoryTableView = tableView;
	
    [_categoryTableView setDelegate:self];
	
    [_categoryTableView setDataSource:self];
	
    [_categoryTableView setBackgroundColor:[UIColor clearColor]];
	
    [_categoryTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
	
    [_categoryTableView setShowsVerticalScrollIndicator:YES];
    
    [_categoryTableView setBounces:YES];
    
	_categoryTableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:_categoryTableView];
    
}


#pragma mark - 
#pragma mark - createTableView 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (noRecordFound) {
        
        return 1;   
    }
    
   return  [self.categoryArray count];
}

// Displays No Record Present Cell, when server api returns zero results.

- (UITableViewCell*)getNoRecordPresentCellForTableView:(UITableView*)table {
    
    static NSString *CellIdentifier = @"NORECORDS";
    
    UITableViewCell *cell = (UITableViewCell *)[table dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NORECORDS"];
        [cell.textLabel setText: NSLocalizedString(@"No records found",nil)];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [cell.textLabel setTextColor:[UIUtils colorFromHexColor:BLUE]];
        [table setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [cell setUserInteractionEnabled:NO];
    }    
    
    return cell;
    
}

// create reusable table view cell for each row and assign values.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(noRecordFound) {
        
        UITableViewCell *cell = [self getNoRecordPresentCellForTableView:tableView];
        return cell;
    }
    
    
    static NSString *CellIdentifier = @"Cell";
    CustomCellForChannel *cell = (CustomCellForChannel *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
	if (cell == nil) {
        cell = [[CustomCellForChannel alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier andTableType:@"CATEGORY"];
    }

    CategoryDataModel *categoryObj = [self.categoryArray objectAtIndex:[indexPath row]];
 
    [cell.programTitleLabel setText:categoryObj.categoryTitle];
    
    // to set the Category type image size dynamicallly
    
    
    
    NSString *colorName=[self colorForCatgegoryType:categoryObj.categoryType];
    UIView *categoryView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 34.5f, 28.5f)];
    [categoryView.layer setCornerRadius:5.0f];
    [categoryView setBackgroundColor:[UIUtils colorFromHexColor:colorName]];
    
    [cell.categoryImageView addSubview:categoryView];
    
       
    cell.categoryImageView.frame= CGRectMake(10, 10, 34.5f, 28.5f);
    
    [cell.categoryImageView addSubview:categoryView];

    
                                                                        
    return cell;
}
- (NSString*)colorForCatgegoryType:(NSString*)type
{
    
    if ([type isEqualToString:@"documentary"]) {
        
        return @"7959c3";
        
    } else if ([type isEqualToString:@"entertainment"]) {
        
        return @"c03e8d";
        
    } else if ([type isEqualToString:@"kids"]) {
        
        return @"17b8cb";
        
    } else if ([type isEqualToString:@"movie"]) {
        
        return @"a51311";
        
    } else if ([type isEqualToString:@"music"]) {
        
        return @"f0db2a";
        
    } else if ([type isEqualToString:@"news"]) {
        
        return @"004f92";
        
    } else if ([type isEqualToString:@"serie"]) {
        
        return @"e08e00";
        
    } else if ([type isEqualToString:@"show"]) {
        
        //return @"ShowCategory";
        return @"DramaCategory";
        
    } else if ([type isEqualToString:@"sport"]) {
        
        return @"1bab5f";
        
    } else if ([type isEqualToString:@"drama"]) {
        
        return @"1bab5f";
        
    } else if ([type isEqualToString:@"science"]) {
        
        return @"FFFFFF";
        
    }
    
    return @"000000";
    
}

#pragma mark -
#pragma mark Table view delegate

// gets called when ever user selects the row (cell)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showProgramListControllerWithProgramsForChannel:[indexPath row]];

    DLog(@"%@",[indexPath description]);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}



-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    return 45;
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
    
    [_categoryTableView reloadData];
}


// gets called when ever request is successfully but the return data objects count is zero.

- (void)nocategoryRecordsFound {
    
    noRecordFound = YES;
   
    [self.categoryArray removeAllObjects];
    
    [_categoryTableView reloadData];
    
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
