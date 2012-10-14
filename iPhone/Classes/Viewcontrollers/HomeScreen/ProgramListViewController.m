

#import "ProgramListViewController.h"
#import "CustomCellForChannel.h"
#import "ChannelCategory.h"
#import "Program.h"
#import "NSString+utility.h"
#import "CategoryDataModel.h"
#import "SummaryScreenViewController.h"
#import "UIUtils.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ProgramListViewController()

- (void)createHeaderView;

- (void)showProUserRequiredScreen;

- (void)setLocalizedValues;

- (void)swipeGestureRecognizer;

- (void)createTableView;

- (void)fetchProgramsForChannel:(int)channelId; 

- (void)fetchProgramDetailsforType:(NSString*)dataType;

- (CGSize)getSizeFor:(NSString*)textString withConstrained:(CGSize)maxSize;

- (void)fetchProgramsForCategory:(NSString*)categoryType;

- (void)callServerRequestMethod;

- (void)showSummaryViewForProgram:(Program*)prog andChannels:(Channel*)chan;

- (void)createMenuBar;

- (UITableViewCell*)getNoRecordPresentCellForTableView:(UITableView*)table;

- (void)createProgramProxy;


@end




NSString *searchHeaderShowsLabelStr;
NSString *searchHeaderTodayLabelStr;


@implementation ProgramListViewController

#pragma mark -
#pragma mark Create UI

- (void)setLocalizedValues {
    
    searchHeaderShowsLabelStr = NSLocalizedString(@"Shows",@"Search Favorite Program Screen, Search Header Shows Label Text");
    
    searchHeaderTodayLabelStr = NSLocalizedString(@"Today",@"Search Favorite Program, Search Header Search Date Label Text");
}



// Implement loadView to create a view hierarchy programmatically, without using a nib.

// create UI
// Register for Status Bar Height Change i.e when incomming call
// Register for refresh screen notification when app enters fore ground from back ground.

- (void)loadView {
    
    [super loadView];
    
    
    [UIControls registerRefreshScreenNotificationsFor:self];
    
    
    noRecordFound = NO;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setLocalizedValues];
        
    [self createMenuBar];
    
    [self createHeaderView];
    
}


- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    //only if not set already
    if(!self.startDateString && !self.endDateString)
    {
                   
//        NSString *toDaysString = [UIUtils stringFromGivenGMTDate:[NSDate date] WithFormat:@"EEEddMMMyyyy HH:mm:ss"];
//        self.startDateString =toDaysString;
        
        
        NSDate *startDate=[NSDate date];
        
        NSDateFormatter *localDateFormat = [[NSDateFormatter alloc] init];
        [localDateFormat setTimeZone:[NSTimeZone localTimeZone]];
        [localDateFormat setDateFormat:@"EEEddMMMyyyy HH:mm:ss"];
        [localDateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        
        NSString * localDateStr = [localDateFormat stringFromDate:startDate];
        self.startDateString=localDateStr;
        
       
      
        self.endDateString =  [UIUtils endTimeFromGivenDate:[NSDate date]];
        
        [self  callServerRequestMethod];
    }

   // [NSThread detachNewThreadSelector:@selector(callServerRequestMethod) toTarget:self withObject:nil];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
        
    [super viewDidUnload];

}


- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

#pragma mark -
#pragma mark External methods

// set the channel array and the current index the channel present in favorite list.
// also set the selected menu type i.e Favorite OR Category.

-(void) setArray:(NSMutableArray *)array AndCurrentSelectedIndex:(int)currentIndex AndSeletedMenuType:(MenuBarButton)type 
{

    self.channelArray = [array copy];
  
    _index = currentIndex;
    
    _menuSelected = type;
} 



#pragma mark -
#pragma mark - Date Button Clicked Event

// get called when user tap on date button.
// display custom date picker of with next 15 days if the user is PRO OR PLUS user.

-(void) dayButtonTapped : (UIButton *) sender {
    
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    if ([appDelegate.user.subscription isEqualToString:PRO_USER] || [appDelegate.user.subscription isEqualToString:PLUS_USER]  ) {    
        
   
        CustomListViewController *customListViewController = [[CustomListViewController alloc] init];
        customListViewController.customListViewControllerDelegate = self;
        
        
            if ([_programHeaderView.headerTitleShowsValueLbl.text isEqualToString:searchHeaderTodayLabelStr]) 
            {
                customListViewController.selectedListValue = [UIUtils dateStringWithFormat:[NSDate date] format:@"MM-dd-yy"];
                
            } else {
                
                customListViewController.selectedListValue = _programHeaderView.headerTitleShowsValueLbl.text;                
            }
        
        
        customListViewController.listType = @"DATE";
       
        [self.navigationController pushViewController:customListViewController animated:YES];
        
        

    } else {
    
        [self showProUserRequiredScreen];
    }
    
}


#pragma mark -
#pragma mark custom List View delegate methods for (Date Type List)


// gets called when user select the date from the dat custom date list.
// it checks if the selected date and todays date is equal then show todays label else show the selected day in header.
// it calls the get request for recommendation of selected date. 

- (void)selectedListValue:(id)rType For:(NSString*)type {
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    
    NSDate *today = [cal dateFromComponents:components];
    
    components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|
                                  NSDayCalendarUnit) fromDate:rType];
    
    NSDate *selectedDate = [cal dateFromComponents:components];
    
    
    if([today isEqualToDate:selectedDate]) {
        
        [_programHeaderView.headerTitleShowsValueLbl setText:searchHeaderTodayLabelStr];
        
        self.startDateString = [UIUtils stringFromGivenDate:rType withLocale:@"en_US" andFormat: @"EEEddMMMyyyy hh:mm:ss"];
    }
    else
    {
        [_programHeaderView.headerTitleShowsValueLbl setText:[UIUtils dateStringWithFormat:rType format:@"MM-dd-yy"]];
        
        self.startDateString = [UIUtils startTimeFromGivenDate:rType];
    }    
    
    DLog(@"Date %@",self.startDateString);
    NSLog(@"StartDate %@",self.startDateString);
    
    self.endDateString = [UIUtils endTimeFromGivenDate:rType];
    DLog(@"Date %@",self.endDateString);
    NSLog(@"EndDate %@",self.endDateString);
    
    [self callServerRequestMethod];
    
}

#pragma mark - 
#pragma mark - createTableView

- (void)createTableView {
    
    
    if (self.programTableView) {
        
        [self.programTableView reloadData];
        
        tableBusy = NO;
        return;
    } else {
        
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,49,self.view.frame.size.width,self.view.frame.size.height-49)];
        self.programTableView = tableView;
        
        // ABP
        self.programTableView.autoresizingMask=(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        
        [self.programTableView setDelegate:self];
        [self.programTableView setDataSource:self];
        [self.programTableView setBackgroundColor:[UIColor clearColor]];
        [self.programTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [self.programTableView setShowsVerticalScrollIndicator:YES];
        [self.programTableView setBounces:YES];
        
        [self.programTableView setExclusiveTouch:YES];
        
        [self.view addSubview:self.programTableView];
        
        [self swipeGestureRecognizer];
        
    }  
}


#pragma mark -
#pragma mark Table view data source

// Return the number of sections.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}


// Return the number of rows in the section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if(noRecordFound) {
        
        return 1;
    }
        
    return  [self.programArray count];
}

// return no record found cell.

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

// create reusable cell and assign values to it.
// assign the short summary and image if the user is PRO/PLUS.
// hide the Short Summary and Image if the Show Short summary option is set to off.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{

    
    if(noRecordFound) {
        
        UITableViewCell *cell = [self getNoRecordPresentCellForTableView:tableView];
        return cell;
        
    }
    
    
    static NSString *CellIdentifier = @"Cell";
    
    CustomCellForChannel *cell = (CustomCellForChannel *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
	if (cell == nil) {
        
       AppDelegate_iPhone *appDelegate = DELEGATE;
        
       if ([appDelegate.user.subscription isEqualToString:PRO_USER] || [appDelegate.user.subscription isEqualToString:PLUS_USER] ) { 
           
            cell = [[CustomCellForChannel alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier andTableType:@"PROGRAMTVPRO"];
           
       } else {
           
            cell = [[CustomCellForChannel alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier andTableType:@"PROGRAMTV"];
       }
        
        cell.contentMode = UIViewContentModeRedraw;
    }

    
    Program *programObj = [self.programArray objectAtIndex:[indexPath row]];            
    [cell.programTitleLabel setText:programObj.title];
    [cell.programTimeLabel setText:[UIUtils localTimeStringForGMTDateString:programObj.start]];
    
    // to set the Category type image size dynamicallly
    
    if (_menuSelected == other) {
    
        NSString *imageName = [ChannelCategory getChannelCatgegoryType:programObj.type];
        UIImage *image = [UIImage imageNamed:imageName];
        [cell.categoryImageView setFrame:CGRectMake(cell.contentView.bounds.size.width-55, 15, image.size.width, image.size.height)];
        
        
        UIImage *categoryImage = [UIImage imageNamed:imageName];
        [cell.categoryImageView setImage:categoryImage];
        
    } else if (_menuSelected == Categories) {
        
    
        for (int i = 0; i < [self.channelArray count]; i++) {
           
            
            Channel *channelObj = [self.channelArray objectAtIndex:i];
            
            if (channelObj.id == programObj.channel) {
                
                
                if([channelObj.imageObjectsArray count] !=0 || channelObj.imageObjectsArray != nil) {
                
                    NSMutableString *url = [[NSMutableString alloc] initWithString:BASEURL];

                    Image *imageObject = [channelObj.imageObjectsArray objectAtIndex:1];
                    if(imageObject.src != nil)
                        [url appendString:imageObject.src];
                    [cell.categoryImageView setFrame:CGRectMake(cell.contentView.bounds.size.width-78, 15, 50, 20)];

                    [cell.categoryImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"bigChannelLogo"]];

                    break;
                }
                
                
            }
        }
        
    }
    
    [cell.programImageView setHidden:YES];
    [cell.programTeaserLabel setHidden:YES];

    [cell.programProLabel1 setText:@""];
    [cell.programTeaserLabel setText:@""];
    [cell.programProLabel3 setText:@""];

    
    
    AppDelegate_iPhone *appDelegate = DELEGATE;

    
    if ([appDelegate.user.deviceSummaryListing isEqualToString:@"1"]) {
        
        NSMutableString *urlStr = [[NSMutableString alloc] initWithString:BASEURL];

        
        if([programObj.imgSrc isStringPresent]) { // if image is present
            
            [cell.programProLabel1 setHidden:NO];
            [cell.programProLabel1 setNumberOfLines:2];
            
            [cell.programProLabel3 setHidden:NO];
            [cell.programProLabel3 setNumberOfLines:2];
            
            [urlStr appendString:programObj.imgSrc];
            [cell.programImageView setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"bigChannelLogo"]];
            [cell.programImageView setHidden:NO];
            
            if ([programObj.summary isStringPresent]) {
                
                if ([programObj.summary length] >= 80) {
                    
                    [cell.programProLabel1 setText:[programObj.summary substringFrom:0 to:80]];
                    
                    if ([programObj.summary length] >= 235) {
                        
                        [cell.programTeaserLabel setText:[programObj.summary substringFrom:80 to:235]];
                        
                        [cell.programProLabel3 setText:[programObj.summary substringFrom:235 to:[programObj.summary length]-1 ]];
                        
                    } else {
                        
                        [cell.programTeaserLabel setText:[programObj.summary substringFrom:80 to:[programObj.summary length]-1]];  
                    }
                    
                } else  {
                    
                    [cell.programProLabel1 setText:[programObj.summary substringFrom:0 to:[programObj.summary length]-1]];
                    
                }
                
                
            } else if ([programObj.teaser isStringPresent]) {
                
                if ([programObj.teaser length] >= 80) {
                    
                    
                    [cell.programProLabel1 setText:[programObj.teaser substringFrom:0 to:80]];
                    
                    if ([programObj.teaser length] >= 235) {
                        
                        
                        [cell.programTeaserLabel setText:[programObj.teaser substringFrom:80 to:235]];
                        
                        [cell.programProLabel3 setText:[programObj.teaser substringFrom:235 to:[programObj.teaser length]-1 ]];
                        
                    } else {
                        
                        [cell.programTeaserLabel setText:[programObj.teaser substringFrom:80 to:[programObj.teaser length]-1]];  
                        
                        
                    }
                } else  {
                    
                    [cell.programProLabel1 setText:[programObj.teaser substringFrom:0 to:[programObj.teaser length]-1]];
                    
                }
                
            }
            
            CGSize  size = [self getSizeFor:cell.programTeaserLabel.text withConstrained:CGSizeMake(190, [cell.programTeaserLabel.text length])]; 
            
            int noOfLines = (int)ceilf(size.height/18);
            
            [cell.programTeaserLabel setNumberOfLines:noOfLines];
            
            [cell.programTeaserLabel setFrame:CGRectMake(10, 40+30, 190, size.height)];
            
            [cell.programTeaserLabel setHidden:NO];
            
            
            
        } else { // if image is not present
            
            
            [cell.programProLabel1 setHidden:YES];
            [cell.programProLabel3 setHidden:YES];
            
            
            if ([programObj.summary isStringPresent]) {
                
                [cell.programTeaserLabel setText:programObj.summary];
                
            } else if ([programObj.teaser isStringPresent])  {
                
                [cell.programTeaserLabel setText:programObj.teaser];
                
            }
            
            
            CGSize  size = [self getSizeFor:cell.programTeaserLabel.text withConstrained:CGSizeMake(300, 120)];
            
            [cell.programTeaserLabel setFrame:CGRectMake(10, 40, 300, size.height)];
            int noOfLines = (int)ceilf(size.height/18);
            [cell.programTeaserLabel setNumberOfLines:noOfLines];
            [cell.programTeaserLabel setHidden:NO];
        }
        
        
    }     
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

// gets called when user clicks the table view row.
// finds the selected channels and program and passes it to the summary view controller to show the details.

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableBusy)
    {
        return;
    }
    Program *program = [self.programArray objectAtIndex:[indexPath row]];
    
    
    for (int i = 0; i < [self.channelArray count]; i++) {
        
        
        Channel *channel = [self.channelArray objectAtIndex:i];
        
        if (channel.id == program.channel) {
            
            [self showSummaryViewForProgram:program andChannels:channel];
            
            break;
            
        }
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


// returns the height of each row in table view.
// here if the user is pro/plus user then height logic is check depending upon the available parameter lengths.

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath 
{
    
    
    if([self.programArray count] == 0) {
        
        return 50;
    }

    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    if ([appDelegate.user.subscription isEqualToString:PRO_USER] || [appDelegate.user.subscription isEqualToString:PLUS_USER]) {    
        
    
        if ([appDelegate.user.deviceSummaryListing isEqualToString:@"0"]) {
            
            return (10+30+10);
        }
        
        Program *programObj = [self.programArray objectAtIndex:[indexPath row]];
        
        
        if([programObj.imgSrc isStringPresent]) {
            
            if([programObj.summary isStringPresent]) {
                
                
                if ([programObj.summary length] < 235) {
                    
                    return (10+30+75+30+10);
                }
                
                return  (10+30+30+75+30+10);
                
            } else if([programObj.teaser isStringPresent]) {
                
                if ([programObj.teaser length] < 235) {
                    
                    return (10+30+75+30+10);
                }
                
                return  (10+30+30+75+30+10);
                
            } else {
                
                return  (10+30+75+10);
            }
            
            
        } else if([programObj.summary isStringPresent]) {
            
            CGSize  size = [self getSizeFor:programObj.summary withConstrained:CGSizeMake(300, 120)];
            
            return  (10+30+size.height+10);     
            
        } else if([programObj.teaser isStringPresent]) { 
            
            CGSize  size = [self getSizeFor:programObj.teaser withConstrained:CGSizeMake(300, 120)];
            
            return  (10+30+size.height+10);  
            
        } else  {
            
            return  (10+30+10);                
        }
        
        
    } else {
        
        return (10+30+10);
    }
    
}


#pragma mark -
#pragma mark  Get Size 


// This methods returns the size i.e required height and width, when string and constrained size is passed to it.
// we use this size to determine the width and height of the UILable dynamiclly.



- (CGSize)getSizeFor:(NSString*)textString withConstrained:(CGSize)maxSize {
    
    
    CGSize suggestedSize = [textString sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12.0f] constrainedToSize:maxSize lineBreakMode:UILineBreakModeWordWrap];
    
    DLog(@" width  == %f, height == %f", suggestedSize.width, suggestedSize.height);
    
    return suggestedSize;
}




#pragma mark -
#pragma mark - ProUserRequiredScreen

// shows the pro user screen.

- (void)showProUserRequiredScreen {
    
    
    ProUserRequiredScreen *proUserRequiredScreen = [[ProUserRequiredScreen alloc]init];
    
    
    [self.navigationController pushViewController:proUserRequiredScreen animated:YES];

    
    
}




#pragma mark -
#pragma mark - Create Header View

// create the header for the view with channel logo/category logo.
// create's Date Button on Header.
// create's Page Control on header. and assigns the page number and selected index to the page control.


- (void)createHeaderView {
    
    HeaderView *headerView = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 49) andType:_menuSelected];
    
    _programHeaderView = headerView;
    
    // ABP
    _programHeaderView.autoresizingMask=(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin);
    
    [_programHeaderView.headerTitleShowLbl setText:searchHeaderShowsLabelStr];
    [_programHeaderView.headerTitleShowsValueLbl setText:searchHeaderTodayLabelStr];    
    
    
    [_programHeaderView.dateButton addTarget:self action:@selector(dayButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (_menuSelected == other) {
                  
        
        [_programHeaderView.pageControl setNumberOfPages:[self.channelArray count]];
        
        
        [_programHeaderView.pageControl setCurrentPage:_index];
        
        [_programHeaderView.pageControl setFrame:CGRectMake(0,0,(18*([self.channelArray count])),49)];
        [_programHeaderView.pageControlScrollView setContentSize:CGSizeMake((18*([self.channelArray count])), 49)];
        [_programHeaderView.pageControl setNumberOfPages:[self.channelArray count]];
        
        
        
    } else if (_menuSelected == Categories)  {
        
        [_programHeaderView.pageControl setNumberOfPages:[self.categoryArray count]];
        
        
        [_programHeaderView.pageControl setCurrentPage:_index];
        
        [_programHeaderView.pageControl setFrame:CGRectMake(0,0,(18*([self.categoryArray count])),49)];
        [_programHeaderView.pageControlScrollView setContentSize:CGSizeMake((18*([self.categoryArray count])), 49)];
        [_programHeaderView.pageControl setNumberOfPages:[self.categoryArray count]];
        

    }
    
    
    [_programHeaderView.pageControl setCurrentPage:_index]; 

    

    if (_index > 2) {
    
        float  offsetX = 0;
        offsetX = (_index)*16;
        offsetX -= 5;
        DLog(@"%f", offsetX);
    
        [_programHeaderView.pageControlScrollView setContentOffset:CGPointMake(offsetX,0) animated:YES];
        
    } else {
        
        [_programHeaderView.pageControlScrollView setContentOffset:CGPointMake(22.0,0.0) animated:YES];
    }
    
    DLog(@"%d", _programHeaderView.pageControl.currentPage);
    NSLog(@" Offset = %@ ",NSStringFromCGPoint(_programHeaderView.pageControlScrollView.contentOffset))   ;
    
    DLog(@"%f", _programHeaderView.pageControlScrollView.contentOffset.x);
    
     
    [_programHeaderView.pageControlPagesLbl setText:[NSString stringWithFormat:@"%d of %d",(_index+1),[self.channelArray count]]];
    
    
    
    if (_menuSelected == other) {
        
        
     [_programHeaderView.pageControlPagesLbl setText:[NSString stringWithFormat:@"%d of %d",(_index+1),[self.channelArray count]]];
        
        
    } else if (_menuSelected == Categories)  {

    
        [_programHeaderView.pageControlPagesLbl setText:[NSString stringWithFormat:@"%d of %d",(_index+1),[self.categoryArray count]]];
    }
    
    [self.view addSubview:_programHeaderView];

    
} 




#pragma mark -
#pragma mark - Swipe Gesture Recognizer 

// here we add gesture recognizer to table view. so that when ever user swipe on table view from left/right the given selector event gets called.

- (void)swipeGestureRecognizer {
        
    UISwipeGestureRecognizer *rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromRight)];
    [rightSwipeRecognizer setDelegate:self];
    [rightSwipeRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.programTableView addGestureRecognizer:rightSwipeRecognizer];
    
    
    UISwipeGestureRecognizer *leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromLeft)];
    [leftSwipeRecognizer setDelegate:self];
    [leftSwipeRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.programTableView addGestureRecognizer:leftSwipeRecognizer];


}

// events get called when user swipe from right
// it check if the swipe index is not the first(index 0),if not first then it changes the page control page, page number, and channel/category logo and call the server request to get the program details of selected category/channels.

- (void)handleSwipeFromRight {
    tableBusy = YES;
    
    BOOL reachedLimit = NO;
    
    if (_menuSelected == Categories) {
        
        if  ((_index - 1) < 0)  {
            
            
            reachedLimit = YES;
            
        } else {
            
            reachedLimit = NO;    
        }
        
        
    } else if (_menuSelected == other) {
        
        
        if  ((_index - 1) < 0)  {
            
            reachedLimit = YES;
            
        } else {
            
            reachedLimit = NO;
        }
        
    }
    
    
    if (reachedLimit)  {
        
        
    } else {

        _index -=1; 
        
        [_programHeaderView.pageControl setCurrentPage:_programHeaderView.pageControl.currentPage - 1];
        
        
        if (_programHeaderView.pageControl.currentPage > 1) {
            
            [_programHeaderView.pageControlScrollView setContentOffset:CGPointMake((_programHeaderView.pageControlScrollView.contentOffset.x-16),0) animated:YES];
        }
        
        
        DLog(@"off Set %f", _programHeaderView.pageControlScrollView.contentOffset.x);

        
        DLog(@"handleSwipeFromRight");
        [self.programTableView setFrame:CGRectMake(-self.view.frame.size.width, 49, self.programTableView.frame.size.width, self.programTableView.frame.size.height)];
        [UIView beginAnimations:@"swipe View" context:NULL];
        [self.programTableView setFrame:CGRectMake(0, 49, self.programTableView.frame.size.width, self.programTableView.frame.size.height)];
        [UIView commitAnimations];
        
        if (_menuSelected == other) {
            
            
            [_programHeaderView.pageControlPagesLbl setText:[NSString stringWithFormat:@"%d of %d",(_index+1),[self.channelArray count]]];
            
            
        } else if (_menuSelected == Categories)  {
            
            
            [_programHeaderView.pageControlPagesLbl setText:[NSString stringWithFormat:@"%d of %d",(_index+1),[self.categoryArray count]]];
        }
        
        
        [self callServerRequestMethod];
    
    }
}


// events get called when user swipe from Left
// it check if the swipe index is not the Last(=[array count]),if not last then it changes the page control page, page number, and channel/category logo and call the server request to get the program details of selected category/channels.

- (void)handleSwipeFromLeft {
   tableBusy = YES;
    
    BOOL reachedLimit = NO;
    
    if (_menuSelected == Categories) {
        
        if ((_index + 1) >= [self.categoryArray count])  {
            
            
            reachedLimit = YES;
        
        } else {
            
            reachedLimit = NO;    
        }
        
        
    } else if  (_menuSelected == other) {
        
       
        if ((_index + 1) >= [self.channelArray count])  {
            
            reachedLimit = YES;
            
        } else {
            
            reachedLimit = NO;
        }
        
    }
    
    if (reachedLimit)  {
        

    } else {
        
        _index +=1;
    
        [_programHeaderView.pageControl setCurrentPage:_programHeaderView.pageControl.currentPage + 1];
        
        
        if (_programHeaderView.pageControl.currentPage > 2) {
            
            [_programHeaderView.pageControlScrollView setContentOffset:CGPointMake((16+_programHeaderView.pageControlScrollView.contentOffset.x),0) animated:YES];
        }
        
        DLog(@"off Set %f", _programHeaderView.pageControlScrollView.contentOffset.x);

        
        DLog(@"handleSwipeFromLeft");
        [self.programTableView setFrame:CGRectMake(self.view.frame.size.width, 49, self.programTableView.frame.size.width, self.programTableView.frame.size.height)];
        [UIView beginAnimations:@"swipe View" context:NULL];
        [self.programTableView setFrame:CGRectMake(0, 49, self.programTableView.frame.size.width, self.programTableView.frame.size.height)];
        [UIView commitAnimations];
        

            
        if (_menuSelected == other) {
            
            
            [_programHeaderView.pageControlPagesLbl setText:[NSString stringWithFormat:@"%d of %d",(_index+1),[self.channelArray count]]];
            
            
        } else if (_menuSelected == Categories)  {
            
            
            [_programHeaderView.pageControlPagesLbl setText:[NSString stringWithFormat:@"%d of %d",(_index+1),[self.categoryArray count]]];
        }
        
        
        
        [self callServerRequestMethod];
    
        
    }     

}   

// Gesture recognizer delegate which we have to adhere to enable the gesture recognizer in the view.

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


#pragma mark -
#pragma mark - Server Communication Methods


- (void)callServerRequestMethod {
    
    if (_menuSelected == other) {
        
        Channel *channelObj = [self.channelArray objectAtIndex:_index];
        [self fetchProgramsForChannel:channelObj.id];
        
        
    } else if (_menuSelected == Categories) {
        
        CategoryDataModel *categoryObj = [self.categoryArray objectAtIndex:_index];
        [self fetchProgramsForCategory:categoryObj.categoryType];
    }
}


// called to fetch the Programs for Selected Channels.

- (void)fetchProgramsForChannel:(int)channelId {
    
    Channel *channelObj = [self.channelArray objectAtIndex:_index];
    
    NSMutableString *urlStr = [[NSMutableString alloc] initWithString:BASEURL];
    Image *imageObj = [channelObj.imageObjectsArray objectAtIndex:1];
		
    if(imageObj.src != nil) {
	
        [urlStr appendString:imageObj.src];

        [_programHeaderView.channelLogoIV setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"bigChannelLogo"]];
        
    }   
    

    [self createProgramProxy];
    
    [self.programProxy getProgramsForChannelId:channelId AndStartDate:self.startDateString AndEndDate:self.endDateString];
    
}


// called to fetch the Programs for Selected Category.

- (void)fetchProgramsForCategory:(NSString*)categoryType {
    

   UIImage *imageObj = [UIImage imageNamed:[ChannelCategory getChannelCatgegoryType:categoryType]]; 
    
    _programHeaderView.channelLogoIV.image = imageObj;


    NSMutableArray *categoryIdArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.channelArray count]; i++) {
        
        Channel *channelObj = [self.channelArray objectAtIndex:i];
        
        [categoryIdArray addObject:[NSString stringWithFormat:@"%d",channelObj.id]];
        
    }
    
    DLog(@"%@", [categoryIdArray description]);
    
    
    NSString *channelIDString = [categoryIdArray componentsJoinedByString:@";"];
    
    DLog(@"%@", channelIDString);
    
    
    [self createProgramProxy];
    
    [self.programProxy getProgramsForCategory:categoryType andFavoriteChannelIds:channelIDString AndStartDate:self.startDateString AndEndDate: self.endDateString];
    
    

}

// called to fetch the program details like image src path, short summary if the user is pro/plus user.

- (void)fetchProgramDetailsforType:(NSString*)dataType {
        
    NSMutableArray *programsIdArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.programArray count]; i++) {
        
        Program *programObj = [self.programArray objectAtIndex:i];
        
        [programsIdArray addObject:programObj.programId];
        
    }
    
    DLog(@"%@", [programsIdArray description]);
    
    
    NSString *programsIDString = [programsIdArray componentsJoinedByString:@";"];
    
    DLog(@"%@", programsIDString);
    
    [self createProgramProxy];
    
    [self.programProxy getProgramDetails:programsIDString forType:dataType forDate:self.startDateString];
    
    
    
}



#pragma mark -
#pragma mark - Program Proxy and Program Proxy Delegate Methods


// It called when server request return, that pro/plus user account is required.


- (void)programProUserRequired {
    
    [self showProUserRequiredScreen];
}


// called when server request fails.

-(void)programDataFailed:(NSString *)error {
    
}

// called when the programs are fetch successfully from the server.
// if the user is pro/ plus user then it call the fetch program details request.

-(void)reloadTableView
{
    //[self createMenuBar];
    
    [self performSelectorOnMainThread:@selector(createTableView) withObject:nil waitUntilDone:YES];
    
}

- (void)receivedProgramsForChannel:(id)objects ForType:(NSString*)queryType {
    
    noRecordFound = NO;
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    if ([appDelegate.user.subscription isEqualToString:PRO_USER] || [appDelegate.user.subscription isEqualToString:PLUS_USER]) {    


        if ([queryType isEqualToString:@"GetAllProgramsForChannel"]) {	
            
            [self.programArray removeAllObjects];
            
            self.programArray = (NSMutableArray*)objects;
            
            if ([self.programArray count] > 0) {
               
                [self fetchProgramDetailsforType:@"GetProgramDetailsForChannel"];
            }   
            
        
        } else if ([queryType isEqualToString:@"GetAllProgramsForCategory"]) {	
            
            [self.programArray removeAllObjects];
            
            self.programArray = (NSMutableArray*)objects;
            
            if ([self.programArray count] > 0) {
                
                [self fetchProgramDetailsforType:@"GetProgramDetailsForCategory"];
                
            }    
    
            
        } else if ([queryType isEqualToString:@"GetProgramDetailsForChannel"]) {
        
                    
            [self.programArray removeAllObjects];
            
            self.programArray = (NSMutableArray*)objects;

            
            [self reloadTableView];
        
            
        } else if ([queryType isEqualToString:@"GetProgramDetailsForCategory"]) {
            
            
            [self.programArray removeAllObjects];
            
            self.programArray = (NSMutableArray*)objects;

            [self reloadTableView];
                        
        }
        
    } else  {    
        
        [self.programArray removeAllObjects];
        
        self.programArray = (NSMutableArray*)objects;
        
        [self reloadTableView];
        
    }    
    
}

// gets called when server request is successfull but, return data count is zero.



- (void)noProgramRecordsFound {

        noRecordFound = YES;
        
        [self.programArray removeAllObjects];
        
        [self.programTableView reloadData];
        
        [self reloadTableView];
  
    
}


#pragma mark -
#pragma mark Create Summary View 

// show the selected program details in sumary view.

- (void)showSummaryViewForProgram:(Program*)prog andChannels:(Channel*)chan {
    
    AppDelegate_iPhone *appDelegate = DELEGATE;

    
    SummaryScreenViewController *summaryVC = [[SummaryScreenViewController alloc] init];
    summaryVC.programId = prog.programId;
    summaryVC.channel = chan;
     
    if ([appDelegate.user.subscription isEqualToString:PRO_USER] || [appDelegate.user.subscription isEqualToString:PLUS_USER])  { 
         
        summaryVC.program = prog;
    }    
         
    [self.navigationController pushViewController:summaryVC animated:YES];
    
}



#pragma mark -
#pragma mark - Menu Bar Creation and Delegate Methods 


// create the menu bar on the top of the screen.

- (void)createMenuBar {
    
    MenuBar *menuBarObj = [[MenuBar alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    menuBarObj.menuBarDelegate = self;
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBarObj];
    self.navigationItem.leftBarButtonItem = buttonItem;
    
    UIButton *backBtn = [UIUtils createBackButtonWithTarget:self action:@selector(backbuttonClicked)];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
	self.navigationItem.rightBarButtonItem = rightBarButton;
    
}

// event gets called when ever users clicks on menu bar buttons.

- (void)menubarButtonClicked:(MenuBarButton)buttonType {
    
    
    DLog(@"%d",buttonType);
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    appDelegate.selectedMenuItem  = buttonType;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    [appDelegate.favoriteChannelsViewController  showSelectedMenu];
    
}



- (void)backbuttonClicked {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark -
#pragma mark - Refresh Screen Notification Method

// This method is call when application enters to foreground from background state.

- (void)refreshScreen {

    [self callServerRequestMethod];        

}

#pragma mark -
#pragma mark - Proxy Creation 

// creates the proxy for Program requests and assigns delegates. 


- (void)createProgramProxy {
    
    if (!self.programProxy) {
        
        ProgramProxy *tempprogramProxy = [[ProgramProxy alloc] init];
        self.programProxy = tempprogramProxy;
        
    }
    
    [self.programProxy setProgramProxyDelegate:self];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
    if(self.programTableView)
        [self.programTableView reloadRowsAtIndexPaths:self.programTableView.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationNone];
    
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

@end
