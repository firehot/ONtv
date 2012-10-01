
#import "RecommendationView.h"
#import "CustomCellForChannel.h"
#import "ChannelCategory.h"
#import "Program.h"
#import "NSString+utility.h"
#import "SummaryScreenViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface RecommendationView()

- (void)createUI;

- (void)createHeaderView;

- (void)showProUserRequiredScreen;

- (void)setLocalizedValues;

- (void)createTableView;

- (void)fetchRecommendedProgramsForStartDate:(NSString*)sDate  AndEndDate:(NSString*)eDate; 

- (void)fetchProgramDetails; 

- (CGSize)getSizeFor:(NSString*)textString withConstrained:(CGSize)maxSize;

- (void)showSummaryViewForProgram:(Program*)prog andChannels:(Channel*)chan;

- (void)createProgramProxy;

@end


@implementation RecommendationView


NSString *recommendationHeaderShowsLabelStr;
NSString *recommendationHeaderTodayLabelStr;
NSString *recommendationHeaderTitle;




@synthesize channelArray  = _channelArray;
@synthesize programArray = _programArray;
@synthesize programProxy = _programProxy;



#pragma mark - 
#pragma mark - Life Cycle Methods


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}



#pragma mark -
#pragma mark Create UI

- (void)setLocalizedValues {
    
    recommendationHeaderShowsLabelStr = NSLocalizedString(@"Shows",@"Search Favorite Program Screen, Search Header Shows Label Text");
    
    recommendationHeaderTodayLabelStr = NSLocalizedString(@"Today",@"Search Favorite Program, Search Header Search Date Label Text");
    
    recommendationHeaderTitle = NSLocalizedString(@"Recommendation",@"HeaderView Title, RecommendationScreen");
}


#pragma mark -
#pragma mark Create UI

// create UI
// Register for Status Bar Height Change i.e when incomming call
// Register for refresh screen notification when app enters fore ground from back ground.


- (void)createUI; {
    
    [UIControls registerRefreshScreenNotificationsFor:self];
    
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setLocalizedValues];
    [self createHeaderView];
    [self createTableView];
    
    [self fetchRecommendedProgramsForStartDate:[UIUtils stringFromGivenDate:[NSDate date] withLocale:@"en_US" andFormat: @"EEEddMMMyyyy hh:mm:ss"] AndEndDate:[UIUtils endTimeFromGivenDate:[NSDate date]]];

}


#pragma mark -
#pragma mark External methods


- (void)channelArray:(NSMutableArray *)cArray {
    self.channelArray = cArray;
} 



#pragma mark -
#pragma mark - Create Header View

// create the view header with date control in it.

- (void)createHeaderView {
    
    HeaderView *headerView = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 49) andType:Recommendation];
    
    _RecommendationHeaderView = headerView;
    
    [_RecommendationHeaderView.headerTitleShowLbl setText:recommendationHeaderShowsLabelStr];
    [_RecommendationHeaderView.headerTitleShowsValueLbl setText:recommendationHeaderTodayLabelStr];    
    [_RecommendationHeaderView.headerTitleLbl setText:recommendationHeaderTitle];
    
    [_RecommendationHeaderView.dateButton addTarget:self action:@selector(dayButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    _RecommendationHeaderView.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    
    [self addSubview:_RecommendationHeaderView];
    
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
        
        
        if ([_RecommendationHeaderView.headerTitleShowsValueLbl.text isEqualToString:recommendationHeaderTodayLabelStr]) 
        {
            customListViewController.selectedListValue = [UIUtils dateStringWithFormat:[NSDate date] format:@"MM-dd-yy"];
            
        } else {
            
            customListViewController.selectedListValue = _RecommendationHeaderView.headerTitleShowsValueLbl.text;                
        }
        
        
        customListViewController.listType = @"DATE";
        
        AppDelegate_iPhone *appDelegate = DELEGATE;
   
        [appDelegate.rootNavController pushViewController:customListViewController animated:YES];
        
        
        
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
    components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:rType];
    NSDate *selectedDate = [cal dateFromComponents:components];
    
    
    NSString *startString;
    
    if([today isEqualToDate:selectedDate]) {
        
        [_RecommendationHeaderView.headerTitleShowsValueLbl setText:recommendationHeaderTodayLabelStr];
        
        startString = [UIUtils stringFromGivenDate:[NSDate date] withLocale:@"en_US" andFormat: @"EEEddMMMyyyy hh:mm:ss"];
        DLog(@"Date %@",startString);
        
    } else {
        
        [_RecommendationHeaderView.headerTitleShowsValueLbl setText:[UIUtils dateStringWithFormat:rType format:@"MM-dd-yy"]];
        
        startString = [UIUtils startTimeFromGivenDate:rType];
        DLog(@"Date %@",startString);
    }    
    
    NSString *endString = [UIUtils endTimeFromGivenDate:rType];
    DLog(@"Date %@",endString);
    
    [self fetchRecommendedProgramsForStartDate:startString AndEndDate:endString];    
}

#pragma mark - 
#pragma mark - createTableView

- (void)createTableView {
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,49,self.bounds.size.width,self.frame.size.height-49)];
    _recommendationProgramTableView = tableView;
	[_recommendationProgramTableView setDelegate:self];
	[_recommendationProgramTableView setDataSource:self];
	[_recommendationProgramTableView setBackgroundColor:[UIColor clearColor]];
	[_recommendationProgramTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
	[_recommendationProgramTableView setShowsVerticalScrollIndicator:YES];
    [_recommendationProgramTableView setBounces:YES];
    
    _recommendationProgramTableView.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    
	[self addSubview:_recommendationProgramTableView];
    
}


#pragma mark -
#pragma mark Table view data source

// Return the number of sections.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


// Return the number of rows in the section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(noRecordFound) {
        return 1;
    }         
    return [self.programArray count];
}

// create reusable cell and assign values to it.
// assign the short summary and image if the user is PRo/PLUS.
// hide the Short Summary and Image if the Show Short summary option is set to off.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    if(noRecordFound) {
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"NORECORDS"];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NORECORDS"];
        }    
        [cell.textLabel setText: NSLocalizedString(@"No records found",nil)];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [cell.textLabel setTextColor:[UIUtils colorFromHexColor:BLUE]];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [cell setUserInteractionEnabled:NO];
        
        return cell;
        
    }
    
    CustomCellForChannel *cell = (CustomCellForChannel *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
	if (cell == nil) {
        
        AppDelegate_iPhone *appDelegate = DELEGATE;
        if ([appDelegate.user.subscription isEqualToString:PRO_USER] || [appDelegate.user.subscription isEqualToString:PLUS_USER]) { 
            
            cell = [[CustomCellForChannel alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier andTableType:@"RECOMMENDEDPROGRAMTVPRO"];
            
        } else {
            
            cell = [[CustomCellForChannel alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier andTableType:@"RECOMMENDEDPROGRAMTV"];
        }
        
        
    }
    
    Program *programObj = [self.programArray objectAtIndex:[indexPath row]];            
    [cell.programTitleLabel setText:programObj.title];
    [cell.programTimeLabel setText:[UIUtils localTimeStringForGMTDateString:programObj.start]];
    
    // to set the Category type image size dynamicallly
    
    NSString *imageName = [ChannelCategory getChannelCatgegoryType:programObj.type];
    NSString *imagePath = [[NSBundle mainBundle]pathForResource:imageName ofType:@"png"];
    UIImage *image = [[UIImage alloc]initWithContentsOfFile:imagePath];
    [cell.categoryImageView setFrame:CGRectMake(265, 15, image.size.width, image.size.height)];
    
    
    UIImage *categoryImage = [UIImage imageNamed:imageName];
    [cell.categoryImageView setImage:categoryImage];
    
    
    [cell.programTeaserLabel setText:programObj.teaser];
    
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
    
    for (int i = 0; i < [self.channelArray count]; i++) {
        
        Channel *channelObj = [self.channelArray objectAtIndex:i];

        
        if (channelObj.id == programObj.channel) {
            
             
            NSMutableString *channelImageURLStr = [[NSMutableString alloc] initWithString:BASEURL];
            Image *imageObj = [channelObj.imageObjectsArray objectAtIndex:1];
            
            if(imageObj.src != nil) {
                
                [channelImageURLStr appendString:imageObj.src];
                
                [cell.channelImageView setImageWithURL:[NSURL URLWithString:channelImageURLStr] placeholderImage:[UIImage imageNamed:@"bigChannelLogo"]];
                
            }   
            
            
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
    
    Program *program = [self.programArray objectAtIndex:[indexPath row]];
    
    
    for (int i = 0; i < [self.channelArray count]; i++) {
        
        
        Channel *channel = [self.channelArray objectAtIndex:i];
        
        if (channel.id == program.channel) {
            
            [self showSummaryViewForProgram:program andChannels:channel];
            
            break;
            
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// returns the height of each row in table view.
// here if the user is pro/plus user then height logic is check depending upon the available parameter lengths.


-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath {
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
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    ProUserRequiredScreen *proUserRequiredScreen = [[ProUserRequiredScreen alloc]init];
        
    [appDelegate.rootNavController pushViewController:proUserRequiredScreen animated:YES];

    
}





#pragma mark -
#pragma mark - Server Communication Methods 

// called to fetch recommended program for selected date from server.

- (void)fetchRecommendedProgramsForStartDate:(NSString*)sDate  AndEndDate:(NSString*)eDate {
    
    NSMutableArray *channelsIDArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.channelArray count]; i++) {
        
        Channel *channelObj = [self.channelArray objectAtIndex:i];
        
        [channelsIDArray addObject:[NSString stringWithFormat:@"%d",channelObj.id]];
        
    }
    
    DLog(@"%@", [channelsIDArray description]);
    
    
    NSString *channelsIDString = [channelsIDArray componentsJoinedByString:@";"];
    
    DLog(@"%@", channelsIDString);
    
    
    [self createProgramProxy];
    
    [self.programProxy getRecommendedProgramsForFavoriteChannelWithChannelId:channelsIDString AndStartDate:sDate AndEndDate:eDate];
    

}


// This is called to fetch the program details like image src path of program.
// it is called only if the user is pro/plus user.


- (void)fetchProgramDetails {
    
    NSMutableArray *programsIdArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.programArray count]; i++) {
        
        Program *programObj = [self.programArray objectAtIndex:i];
        
        [programsIdArray addObject:programObj.programId];
        
    }
    
    DLog(@"%@", [programsIdArray description]);
    
    NSString *programsIDString = [programsIdArray componentsJoinedByString:@";"];
    
    DLog(@"%@", programsIDString);
    
    [self createProgramProxy];

    
     [self.programProxy getProgramDetails:programsIDString forType:@"GetProgramDetails" forDate:nil];
    
    
}


#pragma mark -
#pragma mark Create Summary View 

// called to show the recommended program details in summary.

- (void)showSummaryViewForProgram:(Program*)prog andChannels:(Channel*)chan {
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    
    SummaryScreenViewController *summaryVC = [[SummaryScreenViewController alloc] init];
    summaryVC.programId = prog.programId;
    summaryVC.channel = chan;
    
    if ([appDelegate.user.subscription isEqualToString:PRO_USER] || [appDelegate.user.subscription isEqualToString:PLUS_USER]) { 
        
        summaryVC.program = prog;
    }    
    
    [appDelegate.rootNavController  pushViewController:summaryVC animated:YES];
    
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



// called when recommended program are fetch successfully from the server.
// if the user is pro/ plus user then it call the fetch program details request.

- (void)receivedProgramsForChannel:(id)objects ForType:(NSString*)queryType {
    
    noRecordFound = NO;
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    if ([appDelegate.user.subscription isEqualToString:PRO_USER] || [appDelegate.user.subscription isEqualToString:PLUS_USER]) {    
        
        
        if ([queryType isEqualToString:@"GetAllPrograms"]) {	
            
            
            [self.programArray removeAllObjects];
            
            self.programArray = (NSMutableArray*)objects;
            [self fetchProgramDetails];
            
            
        } else if ([queryType isEqualToString:@"GetProgramDetails"]) {
            
            
            [self.programArray removeAllObjects];
            self.programArray = (NSMutableArray*)objects;
            
            DLog(@"%d",[self.programArray count]);
            
            [_recommendationProgramTableView reloadData]; 
            
        }
        
    } else  {    
        
        
        [self.programArray removeAllObjects];
        self.programArray = (NSMutableArray*)objects;
        [_recommendationProgramTableView reloadData];
        
    }    
}

// gets called when server request is successfull but, return data count is zero.

- (void)noProgramRecordsFound {
    noRecordFound = YES;
    [self.programArray removeAllObjects];
    [_recommendationProgramTableView reloadData];
}



#pragma mark -
#pragma mark - Refresh Screen Notification Method

// This method is call when application enters to foreground from background state.

- (void)refreshScreen {
    
    [self fetchRecommendedProgramsForStartDate:[UIUtils stringFromGivenDate:[NSDate date] withLocale:@"en_US" andFormat: @"EEEddMMMyyyy hh:mm:ss"] AndEndDate:[UIUtils endTimeFromGivenDate:[NSDate date]]];       
    
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



@end
