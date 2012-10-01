
#import "ProUserRequiredScreen.h"
#import "CustomCellForChannel.h"
#import "Program.h"
#import "Channel.h"
#import "NSString+utility.h"
#import "FavoriteChannelsViewController.h"
#import "MenuBar.h"
#import "NotificationTypes.h"
#import "SummaryScreenViewController.h"
#import "PlanView.h"
#import "CustomButton.h"
#import "Agents.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString *plansHeaderTodayLabelStr;

UIButton *editButton;

UILabel *titleLabel;




@interface PlanView()

- (void)createUI;

- (void)createTableView;

- (void)fetchPlans; 

- (void)showProUserRequiredScreen;

- (void)createHeaderView;

- (void)createEditButton;

- (CustomButton*)createButton;

- (void)removePlans:(NSString*)programId;

- (void)showPlanDetailView:(Program*)plan; 

- (void)showSummaryViewForProgram:(Program*)prog andChannels:(Channel*)chan;

- (void)setLocalizedValues;

- (void)removeAgents:(NSString*)agentId;

- (void)fetchAgents;

- (void)initializePlanAgentDictionary;

- (void)showAgentDetailView:(Agents*)agentObj;

- (NSString*)getChannelsImgSource:(int)channelID;

- (CustomCellForChannel*)populatePlanCellDetails:(CustomCellForChannel*)planCell atIndex:(NSIndexPath*)indexp;

- (CustomCellForChannel*)populateAgentCellDetails:(CustomCellForChannel*)agentCell atIndex:(NSIndexPath*)indexp;

- (void)changeTableViewEditModeToNomal;

- (void)logoutButtonClicked;

- (void)createAgentProxy;

- (void)createPlanProxy;

@end


@implementation PlanView


@synthesize planAgentDictionary = _planAgentDictionary;

@synthesize dicKEYs = _dicKEYs;

@synthesize planProxy = _planProxy;

@synthesize agentProxy = _agentProxy;

#pragma mark - 
#pragma mark - Life Cycle Methods


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createUI];
        
    }
    return self;
}


#pragma mark -
#pragma mark Create UI

- (void)setLocalizedValues {
    
    plansHeaderTodayLabelStr = NSLocalizedString(@"Today",@"Search Favorite Program, Search Header Search Date Label Text");
}


- (void)dealloc {
    
    
    
    
    
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}


#pragma mark -
#pragma mark Create UI

// create the view OR
// present login screen to user who is not logged in .. i.e selected continue without login to view the app.

// create UI
// Register for Status Bar Height Change i.e when incomming call
// Register for refresh screen notification when app enters fore ground from back ground.


- (void)createUI; {
    
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    [UIControls registerRefreshScreenNotificationsFor:self];
    
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    if (appDelegate.user && !appDelegate.isGuest) {
        
        [self setLocalizedValues];
        
        selectedSegmentedControl = @"PLAN";
        
        [self setLocalizedValues];
        
        [self createEditButton];
        
        [self createHeaderView];
        
        [self createTableView];
        
        [self fetchPlans];
        
    } else {
        
        
        [self logoutButtonClicked];
        
    }
}


-(void)createEditButton {
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    editButton = [self createButton];
    [editButton addTarget:self action:@selector(editButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    
    appDelegate.favoriteChannelsViewController.navigationItem.rightBarButtonItem = rightBarButton;
} 


- (void)createAddButton {
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    UIButton *addButton = [self createButton];
    [addButton addTarget:self action:@selector(addButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [addButton setFrame:CGRectMake(0, 0, 29, 30)];
    [addButton setImage: [UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [addButton setTitle:@"" forState:UIControlStateNormal];
    
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    
    appDelegate.favoriteChannelsViewController.navigationItem.leftBarButtonItem = leftBarButton;
    
}

- (void)addButtonTapped {
    
    Agents *agents = [[Agents alloc] init];
    [self showAgentDetailView:agents];
}

- (CustomButton*)createButton {
    
    CustomButton *button = [[CustomButton alloc]initWithFrame:CGRectMake(0, 0, 41, 30)];	
    
    UIImage *image = [UIImage imageNamed:@"buttonBackground"];
    image = [image stretchableImageWithLeftCapWidth: 5 topCapHeight: 5];
    
    [button setBackgroundImage:image forState:UIControlStateNormal]; 
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [button setTitle: NSLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
	[button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [button setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	CGSize stringSize = [NSLocalizedString(@"Edit", nil) sizeWithFont:[UIFont boldSystemFontOfSize:12.0f]]; 
    [button setFrame:CGRectMake(0,0,stringSize.width + 20, 30)];
    
    return button;
}

// event gets called when users selects the Edit Button on the Menu Bar.

- (void)editButtonTapped {
    
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    
    if ([selectedSegmentedControl isEqualToString:@"AGENT"] && [self.planAgentDictionary count] == 0) {
        
        [self createAddButton];
        
        appDelegate.favoriteChannelsViewController.navigationItem.title = NSLocalizedString(@"Edit Agent", nil);
        return;
    } 
    
    
    if ([selectedSegmentedControl isEqualToString:@"PLAN"] && [self.planAgentDictionary count] == 0) {
        
        
        appDelegate.favoriteChannelsViewController.navigationItem.title = nil;
        
        appDelegate.favoriteChannelsViewController.navigationItem.leftBarButtonItem = nil;
        
        [appDelegate.favoriteChannelsViewController createMenuBar];
        
        return;
    }
    
    if([self.planAgentDictionary count] > 0) {
        
        if(_planTableUser.editing){
            
            _planTableUser.editing=!_planTableUser.editing;
            
            [_planTableUser setFrame:CGRectMake(0,0,320,self.frame.size.height)];
            
            appDelegate.favoriteChannelsViewController.navigationItem.title = nil;
            
            appDelegate.favoriteChannelsViewController.navigationItem.leftBarButtonItem = nil;
            
            [appDelegate.favoriteChannelsViewController createMenuBar];
            
            [editButton setTitle: NSLocalizedString(@"Edit",nil) forState:UIControlStateNormal];
            
            [_planTableUser reloadData];
            
        }
        else{
            
            appDelegate.favoriteChannelsViewController.navigationItem.leftBarButtonItem = nil;
            
            if ([selectedSegmentedControl isEqualToString:@"AGENT"]) {
                [self createAddButton];
                
                appDelegate.favoriteChannelsViewController.navigationItem.title = NSLocalizedString(@"Edit Agent", nil);
                
            } else {
                
                appDelegate.favoriteChannelsViewController.navigationItem.title = NSLocalizedString(@"Edit planned",nil);
                
            }
            
            _planTableUser.editing=!_planTableUser.editing;
            [_planTableUser setFrame:CGRectMake(0,0,320,self.frame.size.height)];
            
            [editButton setTitle:@"Ok" forState:UIControlStateNormal];
            
            [_planTableUser reloadData];            
        }
        
    } else if ([editButton.titleLabel.text isEqualToString:@"Ok"]) {
        
        
        [_planTableUser setFrame:CGRectMake(0,0,320,self.frame.size.height)];
        
        appDelegate.favoriteChannelsViewController.navigationItem.title = nil;
        
        [appDelegate.favoriteChannelsViewController createMenuBar];
        
        [editButton setTitle: NSLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
        
        [_planTableUser reloadData];
        
    }
    
}

// gets called when user clicks on Cell Edit Button


- (void)cellEditButtonClicked:(CustomButton*)button  {
    
    
    NSString *key  = [self.dicKEYs objectAtIndex:button.cellSection];
    NSMutableArray *planArray  = [self.planAgentDictionary objectForKey:key];
    
    if ([selectedSegmentedControl isEqualToString:@"PLAN"]) { 
        
        Program *programObj = [planArray objectAtIndex:button.cellIndex];
        [self showPlanDetailView:programObj];
        
    } else if ([selectedSegmentedControl isEqualToString:@"AGENT"])  {
        
        Agents *agentsObj = [planArray objectAtIndex:button.cellIndex];
        [self showAgentDetailView:agentsObj];
    }
}


#pragma mark - 
#pragma mark - createTableView

- (void)createTableView {
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height)];
    
    _planTableUser = tableView;
	
    [_planTableUser setDelegate:self];
	
    [_planTableUser setDataSource:self];
	
    [_planTableUser setBackgroundColor:[UIColor clearColor]];
	
    [_planTableUser setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
	
    [_planTableUser setShowsVerticalScrollIndicator:YES];
    
    [_planTableUser setBounces:YES];
    
    _planTableUser.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	
    [self addSubview:_planTableUser];
    
}


#pragma mark - 
#pragma mark - createTableView 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if(noRecordFound) {
        
        return 1;
    }
    
    return [self.dicKEYs count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if(noRecordFound) {
        
        return 1;
    }
    
    NSString *key   = [self.dicKEYs objectAtIndex:section];
    
    return  [[self.planAgentDictionary objectForKey:key] count];
}


// create table view cell for each row and assign values.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
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
        
        cell = [[CustomCellForChannel alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier andTableType:@"PLAN"];
        
    }
    
    [cell.programTeaserLabel setText:@" "];
    
    if ([selectedSegmentedControl isEqualToString:@"PLAN"]) {
        
        
        cell = [self populatePlanCellDetails:cell atIndex:indexPath];
        
    } else if ([selectedSegmentedControl isEqualToString:@"AGENT"]) {
        
        cell = [self populateAgentCellDetails:cell atIndex:indexPath];
    }
    
    
    if (tableView.editing) {
        
        [cell.channelImageView setHidden:YES];
        
        CustomButton *cellEditbtn = [self createButton];
        
        [cellEditbtn addTarget:self action:@selector(cellEditButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        cellEditbtn.cellIndex = [indexPath row];
        
        cellEditbtn.cellSection = [indexPath section];
        
        [cellEditbtn setTag:[indexPath row]];
        
        cell.editingAccessoryView = cellEditbtn; 
        
        [cell.editingAccessoryView setHidden:NO];
        
        
    } else {
        
        [cell.channelImageView setHidden:NO];
        
        [cell.editingAccessoryView setHidden:YES];
    }
    
    return cell;
}

// Assigns values  to the table view Cell For PLAN.

- (CustomCellForChannel*)populatePlanCellDetails:(CustomCellForChannel*)planCell atIndex:(NSIndexPath*)indexp {
    
    
    NSString *key  = [self.dicKEYs objectAtIndex:[indexp section]];
    
    NSMutableArray *planArray  = [self.planAgentDictionary objectForKey:key];
    
    Program *programObj = [planArray objectAtIndex:[indexp row]];
    
    [planCell.programTitleLabel setText:programObj.title];
    
    [planCell.programTimeLabel setText:[UIUtils localTimeStringForGMTDateString:programObj.start]];
    
    [planCell.programTitleLabel setTextColor:[UIUtils colorFromHexColor:BLUE]];
    
    [planCell.programTitleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    
    [planCell.accessoryImageView setFrame:CGRectMake(320-17, 20, 8, 11)];
    
    [planCell.channelImageView setFrame:CGRectMake(245, 15, 45, 20)];
    
    [planCell.programTeaserLabel setFrame:CGRectMake(11, 25, 200, 20)];
    
    
    if ([programObj.remiderType isStringPresent]) {
        
        [planCell.programTimeLabel setFrame:CGRectMake(10, 5, 50, 30)];
        
        [planCell.programTitleLabel setFrame:CGRectMake(50, 5, 150, 30)];
        
        [planCell.programTeaserLabel setHidden:NO];
        
    }  else {
        
        [planCell.programTimeLabel setFrame:CGRectMake(10, 10, 50, 30)];
        
        [planCell.programTitleLabel setFrame:CGRectMake(50, 10, 150, 30)];
        
        [planCell.programTeaserLabel setHidden:YES];
        
    }  
    
    NSString *reminderType = [NotificationTypes getReminderType:programObj.remiderType];
    
    int agenID = [programObj.agentID intValue];
    
    
    if (agenID > 0) {
        
        [planCell.programTeaserLabel setHidden:NO];
        
        
        if ([programObj.remiderType isStringPresent]) {
            
            [planCell.programTeaserLabel setText:[NSString stringWithFormat: [NSLocalizedString(@"By Agent", nil) stringByAppendingString: @", %@ reminder"],reminderType]];
            
        } else {
            
            [planCell.programTimeLabel setFrame:CGRectMake(10, 5, 50, 30)];
            
            [planCell.programTitleLabel setFrame:CGRectMake(50, 5, 150, 30)];
            
            [planCell.programTeaserLabel setText:[NSString stringWithFormat: NSLocalizedString(@"By Agent", nil)]];
            
        }
        
    } else {
        
        [planCell.programTeaserLabel setText:[NSString stringWithFormat:@"%@ reminder",reminderType]];
    }
    
    
    NSString *urlStr = [self  getChannelsImgSource:programObj.channel];
    
    if (urlStr != nil) {
        
        [planCell.channelImageView setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"bigChannelLogo"]];
    }
    
    
    return planCell;
}


// Assigns values  to the table view Cell For AGENTS.


- (CustomCellForChannel*)populateAgentCellDetails:(CustomCellForChannel*)agentCell atIndex:(NSIndexPath*)indexp {
    
    
    NSString *key  = [self.dicKEYs objectAtIndex:[indexp section]];
    
    NSMutableArray *planArray  = [self.planAgentDictionary objectForKey:key];
    
    Agents *agentObject = [planArray objectAtIndex:[indexp row]];
    
    [agentCell.programTimeLabel setFrame:CGRectMake(10, 5, 200, 30)];
    
    [agentCell.programTitleLabel setFrame:CGRectMake(10, 25, 200, 30)];
    
    [agentCell.programTitleLabel setTextColor:[UIUtils colorFromHexColor:GRAY]];
    
    [agentCell.programTitleLabel setFont:[UIFont fontWithName:HELVETICA size:12]];
    
    [agentCell.programTeaserLabel setFrame:CGRectMake(11, 50, 200, 20)];
    
    [agentCell.channelImageView setFrame:CGRectMake(245, 30, 45, 20)];
    
    [agentCell.accessoryImageView setFrame:CGRectMake(320-17, 35, 8, 11)];
    
    if ([agentObject.reminderType isStringPresent]) {
        
        
        [agentCell.programTeaserLabel setHidden:NO];
        
        NSString *reminderType = [NotificationTypes getReminderType:agentObject.reminderType];
        
        [agentCell.programTeaserLabel setText:[NSString stringWithFormat:@"%@ reminder",reminderType]];
        
        
    }  else {
        
        [agentCell.programTeaserLabel setHidden:YES];
        
        
    }
    
    
    [agentCell.programTimeLabel setText:agentObject.searchText];
    
    [agentCell.programTitleLabel setText:[NSLocalizedString(@"Search in", nil) stringByAppendingFormat:@": %@ %@", [NotificationTypes getAgentSearchTitleCriteriaType:agentObject.searchTargetCriteria],[NotificationTypes getAgentSearchTypeCriteriaType:agentObject.searchTypeCriteria]]];
    
    
    if ([agentObject.channelID intValue] == 0) {
        
        agentCell.channelImageView.image = [UIImage imageNamed:@"AllChannels"];
        
        
    } else {
        
        NSString *urlStr = [self  getChannelsImgSource:[agentObject.channelID intValue]];
        
        if (urlStr != nil) {
            
            [agentCell.channelImageView setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"bigChannelLogo"]];
        }
    }    
    
    
    return agentCell;
    
}   



// get called to return Channel Logo image  server path.

- (NSString*)getChannelsImgSource:(int)channelID {
    
    
    AppDelegate_iPhone *appDelegate = DELEGATE;	
    
    
    for (int i = 0; i < [appDelegate.favoriteChannelsViewController.allChannelsArray count]; i++) {
        
        
        Channel *channelObj = [appDelegate.favoriteChannelsViewController.allChannelsArray objectAtIndex:i];
        
        if (channelObj.id == channelID) {
            
            
            if([channelObj.imageObjectsArray count] !=0 || channelObj.imageObjectsArray != nil) {
                
                NSMutableString *urlString = [[NSMutableString alloc] initWithString:BASEURL];
                
                Image *imageObject = [channelObj.imageObjectsArray objectAtIndex:0];
                if(imageObject.src != nil)
                    [urlString appendString:imageObject.src];
                
                return urlString;
                
                break;
            }
        }
        
    }
    
    return nil;
}




#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    DLog(@"Date");
    
}

// Called when user select the Cell 
// It Get the Selected Data Model for Plans/ Agents and display the Details of it it Summary Screen.

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *key  = [self.dicKEYs objectAtIndex:[indexPath section]];
    NSMutableArray *planArray  = [self.planAgentDictionary objectForKey:key];
    
    if ([selectedSegmentedControl isEqualToString:@"PLAN"]) {
        
        
        Program *program = [planArray objectAtIndex:[indexPath row]];
        
        AppDelegate_iPhone *appDelegate = DELEGATE;	
        
        
        for (int i = 0; i < [appDelegate.favoriteChannelsViewController.allChannelsArray  count]; i++) {
            
            
            Channel *channel = [appDelegate.favoriteChannelsViewController.allChannelsArray  objectAtIndex:i];
            
            if (channel.id == program.channel) {
                
                [self showSummaryViewForProgram:program andChannels:channel];
                
                break;
                
            }
            
        }
        
        
    } else if ([selectedSegmentedControl isEqualToString:@"AGENT"]) {
        
        
        Agents *agentsObj = [planArray objectAtIndex:[indexPath row]];
        [self showAgentDetailView:agentsObj];
        
    }    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

// it returns  the height for table view cell

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath 
{
    
    if(noRecordFound) {
        
        return 50;
    }
    
    if ([selectedSegmentedControl isEqualToString:@"PLAN"]) {
        
        return 50;     
        
    } else if ([selectedSegmentedControl isEqualToString:@"AGENT"]) {
        
        return 80;
        
    }  
    
    return 0;
}

// It is called to check the Editing of perticular cell, it our senarion we enable editing for all cell if table view is in editing mode.

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    if (tableView.editing) {
        
        return YES;
        
    } else {
        
        return YES;
    }
    
}

// called when users select the Delete button on Table View Cell when in Edit Mode.

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        NSString *key  = [self.dicKEYs objectAtIndex:[indexPath section]];
        NSMutableArray *planArray  = [self.planAgentDictionary objectForKey:key];
        
        if ([selectedSegmentedControl isEqualToString:@"PLAN"]) {
            
            Program *planObj = [planArray objectAtIndex:[indexPath row]];
            [self removePlans:planObj.programId];
            
        } else if ([selectedSegmentedControl isEqualToString:@"AGENT"]) {
            
            Agents *agentsObj = [planArray objectAtIndex:[indexPath row]];
            [self removeAgents:agentsObj.agentID];
        }    
        
    } 
    
}


// It return  Table View SectionHeader
// Only Plan Section are given the header.

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{      
    
    
    if ([selectedSegmentedControl isEqualToString:@"PLAN"]) { 
        
        NSString *sectionTitle;
        
        
        if (noRecordFound)  {
            
            [_planHeaderView.headerTitleLbl setText:@""];
            
            return _planHeaderView;
            
        } else {   
            
            NSString *key  = [self.dicKEYs objectAtIndex:section];
            
            
            NSMutableArray *planArray  = [self.planAgentDictionary objectForKey:key];
            Program *programObj = [planArray objectAtIndex:0];
            
            NSDate *reminderDate = [UIUtils dateFromGivenGMTString:programObj.start WithFormat:@"EEE,ddMMMyyyyHH:mm:ss z"];
            
            NSString *dayString = [UIUtils dateStringWithFormat:reminderDate format:@"EEEE"];
            
          //  (NSString *)dateStringWithFormat:(NSDate *)givenDate format:(NSString*)format
            
            NSString *dateString = [UIUtils stringFromGivenGMTDate:reminderDate WithFormat:@"dd/MM"];
            
            sectionTitle = [NSString stringWithFormat:@"%@ d. %@",dayString,dateString];
            
        }   
        
        
        if (section == 0) {
            
            [_planHeaderView.headerTitleLbl setText:sectionTitle];
            
            return _planHeaderView;
            
        } else {
            
            
            UIView *headerView = [UIControls createUIViewWithFrame:CGRectMake(0, 0, 320, 49) BackGroundColor:LIGHTGRAY];
            
            UILabel *headerLabel = [UIControls createUILabelWithFrame:CGRectMake(10, 0, 310, 49) FondSize:15 FontName:SYSTEMBOLD FontHexColor:BLUE LabelText:@""];
            
            [headerLabel setText:sectionTitle];
            
            [headerView addSubview:headerLabel];
            
            return headerView;
            
        }
        
        
    } else if ([selectedSegmentedControl isEqualToString:@"AGENT"])  {
        
        
        if (section == 0) {
            
            [_planHeaderView.headerTitleLbl setText:@""];
            
            return _planHeaderView;
        } 
        
    }
    
    return nil;
    
}


// return the height of header for all sections.

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    
    return 49;    
}






#pragma mark -
#pragma mark - Server Communication Methods for Plans

// get called to GET all the Plan Data Object form server.

- (void)fetchPlans {
    
    [self createPlanProxy];
    
    [self.planProxy getPlans];
}

// get called to Delete  the Plan Data Object form server.

- (void)removePlans:(NSString*)programId {
    
    [self createPlanProxy];
    
    [self.planProxy deletePlans:programId];
}

#pragma mark -
#pragma mark - Plan Delegate Methods 


// get called when Plan request is Failed.

- (void)planRequestFailed:(NSString *)error {
    
    
    
}

// get called when plan GET request is successfull.
// sorts the Data on Date parameter of attribute program Start Time

- (void)receivedPlan:(NSMutableArray*)array {
    
    noRecordFound = NO;
    
    
    [self.planAgentDictionary removeAllObjects];
    [self.dicKEYs removeAllObjects];
    
    [self initializePlanAgentDictionary];
    
    
    for (int i = 0; i < [array count]; i++) {
        
        Program *programObject = [array objectAtIndex:i];
        
        //Tue, 14 Feb 2012 10:10:00 GMT
        //Tue, 14 Feb 2012 09:45:00 GMT
        
        NSDate *reminderDate = [UIUtils dateFromGivenGMTString:programObject.start WithFormat:@"EEE,ddMMMyyyyHH:mm:ss z"];         
        
        
        NSString *DATE_KEY = [UIUtils stringFromGivenGMTDate:reminderDate WithFormat:@"dd MMM yyyy"];
        
        
        
        DLog(@"%@", DATE_KEY);
        
        BOOL keyPresent = NO;
        
        
        if ([DATE_KEY isKindOfClass: [NSNull class]] || DATE_KEY == nil) {
            
            keyPresent = YES;
        }          
        
        for (int key = 0; key < [self.dicKEYs count]; key++) { 
            
            if ([[self.dicKEYs objectAtIndex:key] isEqualToString:DATE_KEY]) {
                
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
            
            
            [self.planAgentDictionary setObject:planArray forKey:DATE_KEY];
            
            
            [self.dicKEYs addObject:DATE_KEY];
        }  
    }  
    
    
    [self changeTableViewEditModeToNomal];
    
    [_planTableUser reloadData];
    
}

// get called PLan  Delete Request is successfull. 

- (void)planDeletedSuccesfully {
    
    [self fetchPlans];
}


// called when Plan request is successfull but the return data count is zero.

- (void)noPlanRecordsFound {
    
    noRecordFound = YES;
    
    [self.planAgentDictionary removeAllObjects];
    [self.dicKEYs removeAllObjects];
    
    [self changeTableViewEditModeToNomal];
    
    [_planTableUser reloadData];
    
}

//  Gets called to check if the present records are zero if yes then change the table view EDIT mode to normal

- (void)changeTableViewEditModeToNomal {
    
    
    if ([self.planAgentDictionary count] == 0) {
        
        if(_planTableUser.editing) {
            
            _planTableUser.editing=!_planTableUser.editing;
        }    
        
        noRecordFound = YES;
        
        [self editButtonTapped];
        
    } else if (_planTableUser.editing == NO && [self.planAgentDictionary count] != 0) {
        
        if ([selectedSegmentedControl isEqualToString:@"PLAN"]) {
            
            AppDelegate_iPhone *appDelegate = DELEGATE;
            
            appDelegate.favoriteChannelsViewController.navigationItem.title = nil;
            appDelegate.favoriteChannelsViewController.navigationItem.leftBarButtonItem = nil;
            
            [appDelegate.favoriteChannelsViewController createMenuBar];
        }
    } 
    
}


#pragma mark -
#pragma mark - Create Header View

- (void)createHeaderView {
    
    _planHeaderView = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 49) andType:Plan];
    [_planHeaderView.headerTitleShowsValueLbl setText:plansHeaderTodayLabelStr];    
    [_planHeaderView setHeaderViewDelegate:self];
} 



#pragma mark -
#pragma mark - ProUserRequiredScreen

- (void)showProUserRequiredScreen {
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    ProUserRequiredScreen *proUserRequiredScreen = [[ProUserRequiredScreen alloc]init];
    
    [appDelegate.rootNavController pushViewController:proUserRequiredScreen animated:YES];
    
    
}


#pragma mark -
#pragma mark - Header View Delegate for segmented button clicked 

- (void)segmentedButtonClicked:(int)segmentedIndex {
    
    if (segmentedIndex == 0) {
        
        selectedSegmentedControl = @"PLAN";
        
        [self  fetchPlans];
        
        
        
    } else if (segmentedIndex == 1) {
        
        selectedSegmentedControl = @"AGENT";
        
        [self  fetchAgents];
        
        
    }
    
}


#pragma mark -
#pragma mark Show Plan Detail Screen

// shows the selected plan Setting in Details when user click the edit button in cell.

- (void)showPlanDetailView:(Program*)plan {
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    PlanDetailViewController *planDetailVC = [[PlanDetailViewController alloc] init];
    
    planDetailVC.program = plan;
    
    planDetailVC.fromPlanEditScreen = YES;
    
    planDetailVC.planDetailDelegate = self;
    
    [appDelegate.rootNavController pushViewController:planDetailVC animated:YES];
    
}


#pragma mark -
#pragma mark Create Summary View 

// Shows the selected plan, program Details.

- (void)showSummaryViewForProgram:(Program*)prog andChannels:(Channel*)chan {
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    SummaryScreenViewController *summaryVC = [[SummaryScreenViewController alloc] init];
    
    summaryVC.programId = prog.programId;
    
    summaryVC.channel = chan;
    
    summaryVC.fromSearch = YES;
    
    summaryVC.planView = self;
    
    [appDelegate.rootNavController pushViewController:summaryVC animated:YES];
    
    
}

#pragma mark -
#pragma mark Plan Detalils Delegate

// get called  to update the view when ever user edit the plan Setting. and save it. 

- (void)editedPlanSuccessfully {
    
    [self fetchPlans];
}



#pragma mark -
#pragma mark - Server Communication Methods For Agents

// gets called to get Agents objects from the server.

- (void)fetchAgents {
    
    [self createAgentProxy];
    
    [self.agentProxy getAgents];
}

// gets called when user click on delete button in cell to delete the agent from the server.

- (void)removeAgents:(NSString*)agentId {
    
    [self createAgentProxy];
    
    [self.agentProxy deleteAgents:agentId];
    
}

#pragma mark -
#pragma mark - Agents Delegate Methods 

// get called when Agent Request is Successfull.

- (void)agentRequestFailed:(NSString *)error {
    
    
}

// create the Plan Dictionary and Array to Store the Sorted Plans in Dictionary and its Keys in Array.

- (void)initializePlanAgentDictionary {
    
    if (!self.dicKEYs) {
        
        NSMutableArray *keyDic = [[NSMutableArray alloc] init];        
        self.dicKEYs = keyDic;
    }
    
    if (!self.planAgentDictionary) {
        
        NSMutableDictionary *objDic = [[NSMutableDictionary alloc] init];        
        self.planAgentDictionary = objDic;
    }
    
    
}

// get called when Get Agents request is successfull.

- (void)receivedAgent:(NSMutableArray*)array  {
    
    noRecordFound = NO;
    
    [self.planAgentDictionary removeAllObjects];
    [self.dicKEYs removeAllObjects];
    
    [self initializePlanAgentDictionary];
    
    
    if ([array count]>0) {
        
        [self.dicKEYs addObject:@"AGENT"];
        [self.planAgentDictionary setObject:array forKey:@"AGENT"];
    }
    
    
    [self changeTableViewEditModeToNomal];
    
    [_planTableUser reloadData];
    
}

// gets called when request is successfull but the return data count is zero.

- (void)noAgentRecordsFound {
    
    noRecordFound = YES;
    
    [self.planAgentDictionary removeAllObjects];
    [self.dicKEYs removeAllObjects];
    
    [self changeTableViewEditModeToNomal];
    
    
    [_planTableUser reloadData];
    
}


// gets called when Agent Deleted from server successfully.

- (void)agentDeletedSuccesfully {
    
    [self fetchAgents];
}


#pragma mark -
#pragma mark Show Plan Detail Screen

// show the Agent Settings Details

- (void)showAgentDetailView:(Agents*)agentObj {
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    AgentsDetailsViewController *agentsDetailsViewController = [[AgentsDetailsViewController alloc] init];
    
    agentsDetailsViewController.agent = agentObj;
    agentsDetailsViewController.agentsDetailsDelegate = self;
    [appDelegate.rootNavController pushViewController:agentsDetailsViewController animated:YES];
    
}

#pragma mark -
#pragma mark - Agent Details Delegate Methods 

// Called when user edit the Agent Setting and save it. 
// it refresh the Agents.
- (void)editedAgentsSuccessfully {
    
    [self fetchAgents];
    
}

#pragma mark -
#pragma mark Log out

// gets called when user is not Logged in.
// show the Login Screen.

- (void)logoutButtonClicked {
    
    AppDelegate_iPhone *appDelegate = DELEGATE;	
    
	[User deleteUser:appDelegate.user.name];
    if (appDelegate.user)
        appDelegate.user = nil;
    if (appDelegate.authenticationToken)
        appDelegate.authenticationToken = nil;
    
    appDelegate.loginScreenViewController.fromPlanView = YES;
    [appDelegate showLoginScreen];
    
}



#pragma mark -
#pragma mark - Refresh Screen Notification Method

// This method is call when application enters to foreground from background state.

- (void)refreshScreen {
    
    if ([selectedSegmentedControl isEqualToString:@"PLAN"]) {
        
        [self  fetchPlans];
        
    } else if ([selectedSegmentedControl isEqualToString:@"AGENT"]) {
        
        [self  fetchAgents];        
    }
    
}


#pragma mark -
#pragma mark - Proxy Creation 

// creates the proxy for Plan requests and assigns delegates. 


- (void)createPlanProxy {
    
    if (!self.planProxy) {
        
        PlanProxy *tempPlanProxy = [[PlanProxy alloc] init];
        
        self.planProxy = tempPlanProxy;
        
        
    }
    
    [self.planProxy setPlanProxyDelegate:self];
}


// creates the proxy for Agent requests and assigns delegates. 


- (void)createAgentProxy {
    
    if (!self.agentProxy) {
        
        AgentProxy *tempAgentProxy = [[AgentProxy alloc] init];
        
        self.agentProxy = tempAgentProxy;
        
        
    }
    
    [self.agentProxy setAgentProxyDelegate:self];
    
}

@end
