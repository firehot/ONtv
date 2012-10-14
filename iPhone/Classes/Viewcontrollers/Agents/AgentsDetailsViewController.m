
#import "AgentsDetailsViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "CustomCellForChannel.h"
#import "NotificationTypes.h"
#import "CustomListViewController.h"
#import "Channel.h"
#import "CustomPickerViewController.h"

@interface  AgentsDetailsViewController ()

- (void)createUI;

- (void)createTableView;

- (UISwitch*)createSwitch;

- (void)switchChanged:(id)sender;

- (void)createTimeTextField;

- (void)createAgentObject;

- (void)createNavigationButton;


- (void)resignKeyboard;

- (void)addAgents;

- (void)removeAgents;

- (CustomCellForChannel*)populateCellforReminder:(CustomCellForChannel*)reminderCell AtIndex:(int)rowIndex;

- (CustomCellForChannel*)populateCellforPlansAirings:(CustomCellForChannel*)planAiringCell AtIndex:(int)rowIndex;

- (CustomCellForChannel*)populateCellforAgentProUser:(CustomCellForChannel*)limitationCell AtIndex:(int)rowIndex;


- (CustomCellForChannel*)populateCellforAgentForNonProUser:(CustomCellForChannel*)agentNonproUserCell AtIndex:(int)rowIndex;

- (void)showCustomListViewForType:(NSString*)type;

- (void)ShowHoursPickerView;

- (void)convertRiminderTimeFromDeltaType;

- (void)convertRiminderTimeTODeltaType;

- (void)ShowHoursPickerView;

- (void)registerForKeyboardNotifications;

- (void)removeObserverforKeyBoardNofication;

- (void)keyboardWillHide;

- (void)createAgentProxy;

@end

BOOL isNumberPad;

@implementation AgentsDetailsViewController

@synthesize agentsDetailsDelegate = _agentsDetailsDelegate;
@synthesize agent = _agent;
@synthesize searchTypeTextField = _searchTypeTextField;
@synthesize riminderTimeTypeTextField = _riminderTimeTypeTextField;
@synthesize riminderTimeType = _riminderTimeType;
@synthesize agentProxy =_agentProxy;


#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    [self createUI];
}


- (void)viewWillAppear:(BOOL)animated {
    [self registerForKeyboardNotifications];
}


- (void) viewWillDisappear:(BOOL)animated {
     [self removeObserverforKeyBoardNofication];    
}

- (void)dealloc {   
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark Create UI

- (void)createUI {
    
    [self.view setBackgroundColor:[UIUtils colorFromHexColor:LIGHTGRAY]];
    
    [self createTimeTextField];

    [self convertRiminderTimeFromDeltaType];
    
    if (self.agent.reminderType) {
        
        agentSwitchON = YES;        
    }
    
    [self createTableView];  
    [self createNavigationButton];
}



#pragma mark - 
#pragma mark - createTableView


- (void)createTableView {
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    _agentDetailTableView = tableView;
    
	[_agentDetailTableView setDelegate:self];
	
    [_agentDetailTableView setDataSource:self];
    
    [_agentDetailTableView setBackgroundColor:[UIColor clearColor]];
	
    [_agentDetailTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    [_agentDetailTableView setSeparatorColor:[UIColor lightGrayColor]];
    
    _agentDetailTableView.opaque = NO;
    
    _agentDetailTableView.backgroundView = nil;
    
    [_agentDetailTableView setBounces:YES];
	
    [_agentDetailTableView setShowsVerticalScrollIndicator:YES];
    
    _agentDetailTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	
    [self.view addSubview:_agentDetailTableView];
    
    UIView *footerView = 
    [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _agentDetailTableView.bounds.size.width, 10.0f)];
    
    _agentDetailTableView.tableFooterView = footerView;
    
}


#pragma mark -
#pragma mark Table view data source

// Return the number of sections.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    AppDelegate_iPhone *appDelegate = DELEGATE;

    if ([appDelegate.user.subscription isEqualToString:PRO_USER]) {
        
        return 3;
        
    } else {
        
        return 4;
    }     
}


// Return the number of rows in the section.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    AppDelegate_iPhone *appDelegate = DELEGATE;

    if (section == 0 || section == 3) {
        
        return 2;
        
    } else if (section == 1) {
        
        if ([appDelegate.user.subscription isEqualToString:PRO_USER])  {
            
            return 3;
        } else {
            return 1;
        }    
        
    } else if (section == 2) {
        
        if (agentSwitchON) {
            
            return 3;
            
        } else {
            
            return 1;
        }        
    }         

    
    return 0;
}


 // create table view cell for each row and assign values.


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *cellIdentifier = @"Cell";
    
    //CustomCellForChannel *cell = (CustomCellForChannel *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    CustomCellForChannel *cell;
    
	//if (cell == nil) {
    
    cell = [[CustomCellForChannel alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier andTableType:@"PLANDETAILS"];
    
    cell.backgroundColor = [UIColor clearColor];
    
    [cell setUserInteractionEnabled:YES];
    
    // } 
    
    
    if ([indexPath section] == 0) {
        
        [self populateCellforPlansAirings:cell AtIndex:[indexPath row]];
        
    } else if ([indexPath section] == 1) {

        [self  populateCellforAgentProUser:cell AtIndex:[indexPath row]];
            
    } else if ([indexPath section] == 2) {
        
        [self populateCellforReminder:cell AtIndex:[indexPath row]];
        
    } else if ([indexPath section] == 3) {
        
        [self  populateCellforAgentForNonProUser:cell AtIndex:[indexPath row]];
    }
    
    
	return cell;
    
}

// Assigns values  to the table view section "0".

- (CustomCellForChannel*)populateCellforPlansAirings:(CustomCellForChannel*)planAiringCell AtIndex:(int)rowIndex {
    

    [planAiringCell.accessoryImageView setHidden:YES];
    
    if(rowIndex == 0) {
    
        UIButton *titleButton = [UIControls createUIButtonWithFrame:CGRectMake(0, 0, 149, 38)];
        [titleButton addTarget:self action:@selector(cellButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [titleButton setTag:1];
        
        [titleButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
         
        [titleButton setTitleColor:[UIUtils colorFromHexColor:GRAY] forState:UIControlStateNormal];	
        
        [titleButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        
        [titleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];	
        
        [titleButton  setBackgroundImage:[UIImage imageNamed:@"CellButton"] forState:UIControlStateNormal];

        if ([[NotificationTypes getAgentSearchTitleCriteriaType:self.agent.searchTargetCriteria] isEqualToString:NSLocalizedString(@"Title",nil)] || self.agent.searchTargetCriteria == nil) {
            
            self.agent.searchTargetCriteria = NSLocalizedString(@"Title",nil);
            
            [titleButton setTitle:[NSString stringWithFormat:@"  %@",[NotificationTypes getAgentSearchTitleCriteriaType:self.agent.searchTargetCriteria]] forState:UIControlStateNormal];
            
        } else {
            
           [titleButton setTitle:[NSString stringWithFormat:@"  %@",[NotificationTypes getAgentSearchTitleCriteriaType:self.agent.searchTargetCriteria]] forState:UIControlStateNormal];
            
        }   
        
        
        [planAiringCell.contentView addSubview:titleButton];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(150, 0, 1, 38)];
       
        [view setBackgroundColor:[UIColor lightGrayColor]];
        
        [planAiringCell.contentView addSubview:view];
        
        
        UIButton *isButton = [UIControls createUIButtonWithFrame:CGRectMake(151, 0, 149, 38)];
        [isButton addTarget:self action:@selector(cellButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [isButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
       
        [isButton setTitleColor:[UIUtils colorFromHexColor:GRAY] forState:UIControlStateNormal];	
        
        [isButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        
        [isButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];	
        
        [isButton  setBackgroundImage:[UIImage imageNamed:@"CellButton"] forState:UIControlStateNormal];
        
        if ([[NotificationTypes getAgentSearchTypeCriteriaType:self.agent.searchTypeCriteria] isEqualToString:@"Is"] || self.agent.searchTypeCriteria == nil) {
            
            self.agent.searchTypeCriteria = @"exact";
            
            [isButton setTitle:[NSString stringWithFormat:@"  %@",[NotificationTypes getAgentSearchTypeCriteriaType:self.agent.searchTypeCriteria]] forState:UIControlStateNormal];
            
        } else {
            
            [isButton setTitle:[NSString stringWithFormat:@"  %@",[NotificationTypes getAgentSearchTypeCriteriaType:self.agent.searchTypeCriteria]] forState:UIControlStateNormal];
            
        } 
    
        [isButton setTag:2];
        
        [planAiringCell.contentView addSubview:isButton];
        
    } else if(rowIndex == 1) {
        
    
        DLog(@"%@", self.agent.searchText);
       
        [planAiringCell.contentView addSubview:self.searchTypeTextField];
        
        self.searchTypeTextField.text = self.agent.searchText;
        
    }  
    
    return planAiringCell;
    
}


// event is executed when users clicked on when users clicks on title OR type cell in section 0.

- (void)cellButtonClicked:(UIButton*)button {

    [self resignKeyboard];
    
    if ([button tag] == 1) {
        
        [self showCustomListViewForType:@"TITLE"];
        
    } else if ([button tag] == 2) {
        
        [self showCustomListViewForType:@"TYPE"];        
    }
    
}

// Assigns values  to the table view section "2", i.e the riminder section.

- (CustomCellForChannel*)populateCellforReminder:(CustomCellForChannel*)reminderCell AtIndex:(int)rowIndex {
    
    [reminderCell.accessoryImageView setHidden:NO];
    
    if (rowIndex == 0) {
        
        [reminderCell.programTimeLabel setFrame:CGRectMake(10, 4, 200, 30)];
    
        [reminderCell.programTitleLabel setHidden:YES];
        
        [reminderCell.programTimeLabel setText: NSLocalizedString(@"Remind me",nil)];
        
        UISwitch *switchView = [self createSwitch];
     
        reminderCell.accessoryView = switchView;
        
        if (agentSwitchON) {
            
            [switchView setOn:YES animated:NO];
            
        } else {
            
            [switchView setOn:NO animated:NO];
        }
        
        [reminderCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
    } else if (rowIndex == 1) {
        
        [reminderCell.programTimeLabel setText:@"via"];
       
        [reminderCell.programTimeLabel setTextColor:[UIUtils colorFromHexColor:GRAY]];
        
        [reminderCell.programTitleLabel setFrame:CGRectMake(100, 4, 320-150, 30)];
        
        [reminderCell.programTitleLabel setText:[NotificationTypes getReminderType:self.agent.reminderType]];            
        
        [reminderCell.programTitleLabel setTextAlignment:UITextAlignmentRight];
        
        
    } else if(rowIndex == 2) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(150, 0, 1, 38)];
      
        [view setBackgroundColor:[UIColor lightGrayColor]];
        
        [reminderCell.contentView addSubview:view];
        
        
        self.riminderTimeTypeTextField.text = self.agent.reminderStartTime;
        
        [reminderCell.contentView addSubview:self.riminderTimeTypeTextField];
        
        [reminderCell.programTitleLabel setText:self.riminderTimeType];
        
        [reminderCell.programTitleLabel setTextColor:[UIUtils colorFromHexColor:GRAY]];
    
    }
  
    return reminderCell;
}
    
// Assigns values  to the table view section "1", when user is PRO USER
    
- (CustomCellForChannel*)populateCellforAgentProUser:(CustomCellForChannel*)agentProUserCell AtIndex:(int)rowIndex {
    
    [agentProUserCell.programTimeLabel setTextColor:[UIUtils colorFromHexColor:BLUE]];
  
    [agentProUserCell.programTitleLabel setTextColor:[UIUtils colorFromHexColor:GRAY]];


    if (rowIndex == 0) {
        
        [agentProUserCell.accessoryImageView setHidden:NO];
       
        [agentProUserCell.programTimeLabel setText: NSLocalizedString(@"On channels",nil)];
        
        [agentProUserCell.programTitleLabel setFrame:CGRectMake(100, 4, 320-150, 30)];
        
        [agentProUserCell.programTitleLabel setTextColor:[UIUtils colorFromHexColor:GRAY]];
        
        [agentProUserCell.programTitleLabel setTextAlignment:UITextAlignmentRight];
        
        if ([self.agent.channelID isEqualToString:@"0"] ||  self.agent.channelID == nil) {
            
            [agentProUserCell.programTitleLabel setText: NSLocalizedString(@"All",nil)];  
            
            self.agent.channelID = @"0"; 
            
        } else {
            
            AppDelegate_iPhone *appDelegate = DELEGATE;
            
            for (int i = 0; i<[appDelegate.favoriteChannelsViewController.allChannelsArray count]; i++) 
            {
                
                Channel *channelObj  =  [appDelegate.favoriteChannelsViewController.allChannelsArray objectAtIndex:i];   
                
                if (channelObj.id == [self.agent.channelID intValue]) {
                    
                    [agentProUserCell.programTitleLabel setText:channelObj.title];  
                    break;
                }
            }
        }
        
    } else if (rowIndex == 1 ) {
        
        [agentProUserCell.programTimeLabel setText: NSLocalizedString(@"On days", nil)];

        [agentProUserCell.programTitleLabel setFrame:CGRectMake(100, 4, 320-150, 30)];
                
        
        AppDelegate_iPhone *appDelegate = DELEGATE;

        
        if (self.agent.reminderDay == nil) {
            
            if (appDelegate.user.defaultDaysType == nil || [appDelegate.user.defaultDaysType isKindOfClass:[NSNull class]]){
                
                [agentProUserCell.programTitleLabel setText: NSLocalizedString(@"All weekdays",nil)];  
               
                self.agent.reminderDay = @"-1";
                
            } else {
                
                [agentProUserCell.programTitleLabel setText:[NotificationTypes getProUserAgentDayType:appDelegate.user.defaultDaysType]];
                
                self.agent.reminderDay = appDelegate.user.defaultDaysType;
            }
            
        } else {
            
            [agentProUserCell.programTitleLabel setText:[NotificationTypes getProUserAgentDayType:self.agent.reminderDay]];
        }

    
        [agentProUserCell.programTitleLabel setTextAlignment:UITextAlignmentRight];
        
        
    } else if(rowIndex == 2) {
        
        [agentProUserCell.programTimeLabel setText: NSLocalizedString(@"Between", nil)];
      
        [agentProUserCell.programTitleLabel setFrame:CGRectMake(100, 4, 320-150, 30)];
        
        if (self.agent.reminderHours == nil || [self.agent.reminderHours isEqualToString:@""] ||[self.agent.reminderHours isEqualToString:@"0-23"] || [self.agent.reminderHours isEqualToString:@"0"] ) {
            
            AppDelegate_iPhone *appDelegate = DELEGATE;
            
            if (appDelegate.user.defaultHoursType == nil || [appDelegate.user.defaultHoursType isKindOfClass:[NSNull class]]){
                

                [agentProUserCell.programTitleLabel setText: NSLocalizedString(@"All hours",nil)];  
                
                self.agent.reminderHours = @"0-23";
                
            } else {
                
            
                if ([appDelegate.user.defaultHoursType isEqualToString:@"0"]) {
                    
                    [agentProUserCell.programTitleLabel setText: NSLocalizedString(@"All hours",nil)];
                    
                    self.agent.reminderHours = @"0-23";

                    
                } else {
                    
                    [agentProUserCell.programTitleLabel setText:appDelegate.user.defaultHoursType];
                
                    self.agent.reminderHours = appDelegate.user.defaultHoursType;
                
                }
                
                
          }
            
        
        } else {
            
            [agentProUserCell.programTitleLabel setText:self.agent.reminderHours];
        }
        
        [agentProUserCell.programTitleLabel setTextAlignment:UITextAlignmentRight];
        
    }
    
    return agentProUserCell;

}


// Assigns values  to the table view section "1", when user is NON PRO USER



- (CustomCellForChannel*)populateCellforAgentForNonProUser:(CustomCellForChannel*)agentNonproUserCell AtIndex:(int)rowIndex {
    
    [agentNonproUserCell.programTimeLabel setTextColor:[UIUtils colorFromHexColor:GRAY]];
  
    [agentNonproUserCell.programTitleLabel setTextColor:[UIUtils colorFromHexColor:GRAY]];
    
    [agentNonproUserCell.programTitleLabel setTextAlignment:UITextAlignmentRight];
    
    [agentNonproUserCell.programTitleLabel setFrame:CGRectMake(100, 4, 320-150, 30)];
    
    [agentNonproUserCell setUserInteractionEnabled:NO];
    
    if (rowIndex == 0 ) {
        
        [agentNonproUserCell.programTimeLabel setText: NSLocalizedString(@"On days",nil)];
    
        [agentNonproUserCell.programTitleLabel setText: NSLocalizedString(@"All weekdays",nil)];  
        
        
    } else if(rowIndex == 1) {
        
       [agentNonproUserCell.programTimeLabel setText: NSLocalizedString(@"Between",nil)];
     
        [agentNonproUserCell.programTitleLabel setText: NSLocalizedString(@"All hours",nil)];  
       
    }
    
    return agentNonproUserCell;
    
}


#pragma mark -
#pragma mark Table view delegate

// gets called when ever users select the cell, which are non- button and non textfields 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    [self resignKeyboard];
    
    if ([indexPath section] == 1 && [indexPath row] == 0) {
        
        
        [self showCustomListViewForType:@"CHANNELS"];
        
    } else if ([indexPath section] == 1 && [indexPath row] == 1) {
        
        [self showCustomListViewForType:@"WEEKS"];                
   
    } else if ([indexPath section] == 1 && [indexPath row] == 2) {
        [self ShowHoursPickerView];
        
    } else if ([indexPath section] == 2 && [indexPath row] == 1) {
        
        [self showCustomListViewForType:@"VIA"];                

    } else if ([indexPath section] == 2 && [indexPath row] == 2) {
        
        [self showCustomListViewForType:@"TIME"];                
 
    } 

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath 
{
    
    return 38;
    
}


// Assigns Header view and title to the sections. 

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{

    
    if (section == 0 || section == 3) {
        
        
        UIView *headerView = [UIControls createUIViewWithFrame:CGRectMake(0, 0, 320, 49) BackGroundColor:LIGHTGRAY];
        
        UILabel *headerLabel = [UIControls createUILabelWithFrame:CGRectMake(10, 0, 310, 49) FondSize:15 FontName:SYSTEMBOLD FontHexColor:BLUE LabelText:@""];
        
        if (section == 0) {
            
            [headerLabel setText: NSLocalizedString(@"Plan all airings where", nil)];  
            
        }else if (section == 3) {
            
            [headerLabel setText: NSLocalizedString(@"Limitations", nil)];
            
        }
        
        
        [headerView addSubview:headerLabel];
        
        return headerView;
        
    } 
    
    return nil;    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 38;
    
}

#pragma Mark - 
#pragma Mark - CustomListViewController  Call Method and Delegate 

// This methods show the user custom list view of type VIA, TIME ,TITLE, TYPE, CHANNELS.

- (void)showCustomListViewForType:(NSString*)type {
    
    CustomListViewController *customListViewController = [[CustomListViewController alloc] init];
    
    customListViewController.customListViewControllerDelegate = self;
    
    customListViewController.listType = type;
    
    
    if ([type  isEqualToString:@"VIA"]) {

        customListViewController.selectedListValue = [NotificationTypes getReminderTypeForServer:self.agent.reminderType];
        
    } else if ([type  isEqualToString:@"TIME"]) {

        customListViewController.selectedListValue = self.riminderTimeType;
        
    } else if ([type  isEqualToString:@"WEEKS"]) {
    
        customListViewController.selectedListValue = self.agent.reminderDay;

    } else if ([type  isEqualToString:@"TITLE"]) {
        
        customListViewController.selectedListValue = self.agent.searchTargetCriteria;
 
    } else if ([type  isEqualToString:@"TYPE"]) {
        
        customListViewController.selectedListValue = self.agent.searchTypeCriteria;
   
    } else if ([type  isEqualToString:@"CHANNELS"]) {
        
        customListViewController.selectedListValue = self.agent.channelID;
    }
    
    [self.navigationController pushViewController:customListViewController animated:YES];
    
}


// gets call when ever user select the values in the custom view, to update the view accordingly.

- (void)selectedListValue:(NSString*)rType For:(NSString*)type {

    if ([type  isEqualToString:@"VIA"]) {
        
        self.agent.reminderType = [NotificationTypes getReminderTypeForServer:rType];
        
    } else if ([type  isEqualToString:@"TIME"]) {
        
        self.riminderTimeType = rType;
        
    } else if ([type  isEqualToString:@"WEEKS"]) {
        
        self.agent.reminderDay = [NotificationTypes getProUserAgentDayTypeForServer:rType];
        
    } else if ([type  isEqualToString:@"TITLE"]) {
        
        self.agent.searchTargetCriteria = [NotificationTypes getAgentSearchTitleCriteriaTypeForServer:rType];
        
    } else if ([type  isEqualToString:@"TYPE"]) {
        
        self.agent.searchTypeCriteria = [NotificationTypes getAgentSearchTypeCriteriaTypeForServer:rType];
        
    } else if ([type  isEqualToString:@"CHANNELS"]) {
        
        self.agent.channelID = rType;
        
    }

    
    [_agentDetailTableView reloadData];
}




#pragma Mark - 
#pragma Mark - Create Switch and Its Event

- (UISwitch*)createSwitch {
    
    UISwitch *aSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    
    [aSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    if ([aSwitch respondsToSelector:@selector(setOnTintColor:)]) {
        
        [aSwitch setOnTintColor:[UIUtils colorFromHexColor:BLUE]];
    }
    
    return aSwitch; 
}


// gets called when ever user toggle between the switch, it also assign the defaults values.

- (void)switchChanged:(id)sender {
    

    UISwitch* switchControl = sender;
        
        if (switchControl.on) {
            
            [self createAgentObject];
            
            agentSwitchON = YES;
            
            AppDelegate_iPhone *appDelegate = DELEGATE;

            if (!self.agent.reminderType 
                || [self.agent.reminderType isEqualToString:@""]) {
                
                if (appDelegate.user.defaultReminderType == nil || [appDelegate.user.defaultReminderType isKindOfClass:[NSNull class]]) {
                    
                    self.agent.reminderType = @"email";
                    
                } else {
                
                    self.agent.reminderType = appDelegate.user.defaultReminderType; //@"email";
                }
                
            } 
            
            if (self.riminderTimeTypeTextField.text == nil || self.riminderTimeTypeTextField.text == @"") {
                
                
                if (appDelegate.user.defaultReminderTime == nil || [appDelegate.user.defaultReminderTime isKindOfClass:[NSNull class]]) {
                    
                    self.riminderTimeTypeTextField.text = @"15";
                   
                    self.agent.reminderStartTime = @"-15";
                    
                    [self convertRiminderTimeFromDeltaType];

                    self.riminderTimeType = NSLocalizedString(@"Minutes before",nil);
                    
                } else {
                    
                    self.riminderTimeTypeTextField.text = appDelegate.user.defaultReminderTime;
                    
                    self.agent.reminderStartTime = appDelegate.user.defaultReminderTime;
                    

                    int  timeInterval =  [appDelegate.user.defaultReminderbeforeType intValue];
                    
                    DLog (@"%@",appDelegate.user.defaultReminderbeforeType);
                    
                    int min  = timeInterval / 60;
                    
                    
                    int hrs = 0;
                    
                    if (min >=60) {
                        
                        hrs = min / 60;
                        
                    } 
                    
                    int day = 0;
                    
                    if (hrs >=24) {
                        
                        day = hrs / 24;
                        
                    } 
                    
                    if (day > 0) {
                        
                        self.riminderTimeType = NSLocalizedString(@"Days before",nil);
                       
                        self.agent.reminderStartTime = [NSString stringWithFormat:@"%d",day];
                        
                    } else if (hrs > 0) {
                        
                        self.riminderTimeType = NSLocalizedString(@"Hours before",nil);
                        
                        self.agent.reminderStartTime = [NSString stringWithFormat:@"%d",hrs];
                        
                    } else if (min > 0) {
                        
                        self.riminderTimeType = NSLocalizedString(@"Minutes before",nil);
                        
                        self.agent.reminderStartTime = [NSString stringWithFormat:@"%d",min];
                        
                    } else  {
                        
                        self.riminderTimeType = NSLocalizedString(@"Minutes before",nil);
                        
                        self.agent.reminderStartTime = [NSString stringWithFormat:@"%d",timeInterval];
                        
                    }
                    
                }

    
            }
            
            [_agentDetailTableView reloadData];
            
        } else {
            
            agentSwitchON = NO;
            
            [_agentDetailTableView reloadData];
        }
        
       
}   


#pragma Mark - 
#pragma Mark - Create TextField

- (void)createTimeTextField {
    
    @autoreleasepool {
    
        self.searchTypeTextField = [UIControls createUITextFieldWithFrame:CGRectMake(10, 4, 280, 30) FondSize:14 FontName:@"" FontHexColor:GRAY];
        
        [self.searchTypeTextField setBorderStyle:UITextBorderStyleNone];
        
        [self.searchTypeTextField setKeyboardType:UIKeyboardTypeDefault];
        
        [self.searchTypeTextField setFont:[UIFont boldSystemFontOfSize:14]];
        
        [self.searchTypeTextField  setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        [self.searchTypeTextField setDelegate:self];
        
        [self.searchTypeTextField setReturnKeyType:UIReturnKeyDone];
        
        [self.searchTypeTextField setTag:1];

        [self.searchTypeTextField setPlaceholder:@"Type keywords"];
        

        self.riminderTimeTypeTextField = [UIControls createUITextFieldWithFrame:CGRectMake(10, 4, 130, 30) FondSize:14 FontName:@"" FontHexColor:GRAY];
        
        [self.riminderTimeTypeTextField setBorderStyle:UITextBorderStyleNone];
        
        [self.riminderTimeTypeTextField setKeyboardType:UIKeyboardTypeNumberPad];
        
        [self.riminderTimeTypeTextField setFont:[UIFont boldSystemFontOfSize:14]];
        
        [self.riminderTimeTypeTextField  setContentHorizontalAlignment:
        UIControlContentHorizontalAlignmentLeft];

        [self.riminderTimeTypeTextField setDelegate:self];
        
        [self.riminderTimeTypeTextField setTag:2];

    }
} 


#pragma Mark - 
#pragma Mark - Create Agent Object

- (void)createAgentObject {
    
    if (!self.agent) {
        
        Agents *tempAgents = [[Agents alloc] init];
        
        self.agent = tempAgents;
        
    }
}





#pragma mark - 
#pragma mark Touches Methods

// gets called if touched coordinates are view, to resign the keyboard. 

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self resignKeyboard];
}

#pragma mark -
#pragma mark create Navigation Button and Navigation Button Event Handling

- (void)createNavigationButton {
    
    
	self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.title = NSLocalizedString(@"Add planning", nil);
    
    UIButton *save = [UIUtils createStandardButtonWithTitle:NSLocalizedString(@"Save",nil) addTarget:self action:@selector(savebuttonClicked)];
	
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:save];
	
    self.navigationItem.leftBarButtonItem = leftButton;
	
    
    UIButton *backBtn = [UIUtils createBackButtonWithTarget:self action:@selector(backbuttonClicked)];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
	
    self.navigationItem.rightBarButtonItem = rightBarButton;
	
    
}

// gets called when ever user wants to hides the keyboards

- (void)resignKeyboard {
    
    [_agentDetailTableView setContentOffset:CGPointMake(0, 0) animated:YES];

    self.agent.searchText = self.searchTypeTextField.text;
   
    self.agent.reminderStartTime = self.riminderTimeTypeTextField.text;

    DLog(@"%@",self.agent.searchText  );
    DLog(@"%@", self.searchTypeTextField.text);
    
    [self.searchTypeTextField resignFirstResponder];
    
    [self.riminderTimeTypeTextField resignFirstResponder];
}

- (void)backbuttonClicked {
    
    [self resignKeyboard];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)savebuttonClicked {
    
    
    [self resignKeyboard];
    
    [self removeAgents];        
    
}




#pragma mark -
#pragma mark - Server Communication Methods 

// Called to add new agent to the server.

- (void)addAgents {
    
    if(agentSwitchON == NO) {
        
        self.agent.reminderType = @"";
        
    } 
    if ([self.searchTypeTextField.text isEqualToString:@""] || self.searchTypeTextField.text == nil) {
        
        [UIUtils alertView:@"Please enter Search text" withTitle:@"Info"];

    } else {
    
        self.agent.searchText = self.searchTypeTextField.text;
        
        [self convertRiminderTimeTODeltaType];
        
        [self createAgentProxy];
        
        [self.agentProxy  addAgent:self.agent];

    }   
    
}


// Called to remove selected agents from the server
// since put request is not present. we update the Agent, by deleting it and adding the new

- (void)removeAgents {
    
    [self createAgentProxy];
    
    [self.agentProxy  deleteAgents:self.agent.agentID];
    
}


#pragma mark -
#pragma mark - Agent Delegate Methods 

// Called whenever the server request is failed.

- (void)agentRequestFailed:(NSString *)error {
    
    
}

// Called whenever the server Delete request is succesfully.

- (void)agentDeletedSuccesfully {
    
    [self addAgents];
}

// Called whenever the server POST request is succesfully.

- (void)agentAddedSuccesfully {
    
    if (self.agentsDetailsDelegate && [self.agentsDetailsDelegate respondsToSelector:@selector(editedAgentsSuccessfully)]) {
        
        [self.agentsDetailsDelegate editedAgentsSuccessfully];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark -
#pragma mark - Hours Screen and Delegate Methods 

// Show the Picker view for the hours type cell.

- (void)ShowHoursPickerView {
    

    NSArray *hoursItems = [self.agent.reminderHours componentsSeparatedByString:@"-"];
    
    CustomPickerViewController *customPickerViewController = [[CustomPickerViewController alloc] init];
    
    customPickerViewController.selectedHoursFirstComponent = [hoursItems objectAtIndex:0];
    
    customPickerViewController.selectedHoursSecondComponent = [hoursItems objectAtIndex:1];
    
    [self.view addSubview:customPickerViewController.view];
   
    
    customPickerViewController.customPickerViewDelegate = self; 
    
}

// Gets Called when user clicks the done button on picker view, to update the hour cell.

- (void)doneClicked:(NSString *)selectedHours
 {
    
    self.agent.reminderHours = selectedHours;
    [_agentDetailTableView reloadData];
}


//Get called when user is in Agent EDIT Mode. it converts the api riminder Time data in to the native type.

- (void)convertRiminderTimeFromDeltaType {
    
     int  timeInterval =  [self.agent.reminderStartTime intValue];
    
    DLog(@"%d", timeInterval);
    
    timeInterval = timeInterval * -1;
    
    DLog(@"%d", timeInterval);

    
    int min  = timeInterval / 60;
    
    
    DLog(@"%d", min);

    
    int hrs = 0;
    
    if (min >=60) {
        
        hrs = min / 60;
        
    } 
    
    
    DLog(@"%d", hrs);

    
    int day = 0;
    
    if (hrs >=24) {
        
        day = hrs / 24;
        
    } 
    
    
    DLog(@"%d", day);

    
    if (day > 0) {
        
        self.riminderTimeType = NSLocalizedString(@"Days before",nil);
       
        self.agent.reminderStartTime = [NSString stringWithFormat:@"%d",day];
        
    } else if (hrs > 0) {
        
        self.riminderTimeType = NSLocalizedString(@"Hours before",nil);
        
        self.agent.reminderStartTime = [NSString stringWithFormat:@"%d",hrs];
        
    } else if (min > 0) {
        
        self.riminderTimeType = NSLocalizedString(@"Minutes before",nil);
        
        self.agent.reminderStartTime = [NSString stringWithFormat:@"%d",min];
        
    } else  {
        
        self.riminderTimeType = NSLocalizedString(@"Minutes before",nil);
        
        self.agent.reminderStartTime = [NSString stringWithFormat:@"%d",timeInterval];

    }
    
}

//Get called when user is in Agent EDIT Mode OR ADD Mode. it converts the native riminder type  data 
// in to api riminder Time data.

- (void)convertRiminderTimeTODeltaType  {
    

    int  timeInterval =  [self.riminderTimeTypeTextField.text intValue];

    timeInterval = timeInterval * -1;
    
    
    if ([self.riminderTimeType isEqualToString:NSLocalizedString(@"Days before",nil)]) {
        
        timeInterval = timeInterval*60*60*24;
         
    
    } else if ([self.riminderTimeType isEqualToString:NSLocalizedString(@"Hours before",nil)]) {
        
        timeInterval = timeInterval*60*60;
        
    } else if ([self.riminderTimeType isEqualToString:NSLocalizedString(@"Minutes before",nil)]) {
     
        timeInterval = timeInterval*60;
    }
    
    self.agent.reminderStartTime = [NSString stringWithFormat:@"%d",timeInterval];
    
    DLog(@"self.agent.reminderStartTime %@", self.agent.reminderStartTime);
    

}


#pragma mark - 
#pragma mark - Text Field Delegate 

// Gets Called when users clicks on RETURN Button on Keyboard to hide the keyboard.

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{	
    
    if (self.searchTypeTextField.tag == 1) {
        
        [self resignKeyboard];
    } 
    
	return YES;
}

// Gets Called when users select the TextField, it make the selected field visible on view.

- (void)textFieldDidBeginEditing:(UITextField *)textField {
 
    
    if (textField.keyboardType == UIKeyboardTypeNumberPad) {
        
        isNumberPad = YES;
        
        [_agentDetailTableView setContentOffset:CGPointMake(0, 250) animated:YES];
        
        
    } else {
        
        [self keyboardWillHide];
        isNumberPad = NO;        
    }
    
    

}


#pragma mark - 
#pragma mark - Key BoardHandling Methods

// here we register for keyboard notification.
// so when ever keyboard is shown/Hide, the view gets notified.
// we use it to put custom Done on Keyboard.


- (void)registerForKeyboardNotifications
{
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification object:nil];
	
}


// here we remove the keyboard notification observer.
// it is called when the view is released.

- (void)removeObserverforKeyBoardNofication {
    
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
	
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


//  gets called when keyboard is shown. we add custom done button on keyboard.

- (void)keyboardDidShow {
   
    if (!isNumberPad) {
        
        return;
    }
    
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 163, 106, 53)];
    [doneBtn setTag:1000];
    
    [doneBtn setImage:[UIImage imageNamed:@"DoneUp.png"] forState:UIControlStateNormal];
    [doneBtn setTitle: NSLocalizedString(@"Keyboard.done", nil) forState:UIControlStateNormal];
    [doneBtn setTitleColor: [UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [doneBtn setImage:[UIImage imageNamed:@"DoneDown.png"] forState:UIControlStateHighlighted];
    [doneBtn setTitle: NSLocalizedString(@"Keyboard.done", nil) forState:UIControlStateHighlighted];
    [doneBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateHighlighted];
        
    [doneBtn addTarget:self action:@selector(doneKeyBoardButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    // locate keyboard view
  
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    
    UIView* keyboard = nil;

    for(int i=0; i<[tempWindow.subviews count]; i++) {
    
        keyboard = [tempWindow.subviews objectAtIndex:i];
        // keyboard found, add the button
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
        
            if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES) 
             
                [keyboard addSubview:doneBtn];
            
            _keyboardView = keyboard;
        }
        
    }
    
}


// gets called when users clicked on DONE button on keyboard.

- (void)doneKeyBoardButtonClicked {
    
    [self resignKeyboard];

}

// gets called when keyboard return to hide State from Visible State.
// here we remove the custom done button added to the keyboard.

- (void)keyboardWillHide {
        
    [[_keyboardView viewWithTag:1000] removeFromSuperview];
}


#pragma mark -
#pragma mark - Proxy Creation 

// creates the proxy for Agent requests and assigns delegates. 

- (void)createAgentProxy {
    
    if (!self.agentProxy) {
        
        AgentProxy *tempAgentProxy = [[AgentProxy alloc] init];
       
        self.agentProxy = tempAgentProxy;
        
        
    }
    
    [self.agentProxy setAgentProxyDelegate:self];
}


@end
