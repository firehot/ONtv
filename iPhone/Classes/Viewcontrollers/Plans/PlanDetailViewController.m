

#import "PlanDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomCellForChannel.h"
#import "NotificationTypes.h"



@interface  PlanDetailViewController ()

- (void)createUI;

- (void)createTableView;

- (UISwitch*)createSwitch;

- (void)showCustomListViewForType:(NSString*)type;

- (void)createNavigationButton;

- (void)createProgramObject;

- (void)removePlans;

- (void)addPlans;;

- (void)getConvertedIntoReminderTime;

- (void)getDifferenceBetweenDate;

- (void)getSelectedPlan;

- (void)initializeRiminderTypeValue:(NSString*)remindType;

- (void)initializeRiminderTimeTypeValue:(NSString*)remindTime andRemindTimeType:(NSString*)remindTimeType;

- (void)createTimeTextField;

- (void)fetchAgents:(NSString*)agentId;

- (CustomCellForChannel*)populateRemindMeEveryTimeItISAiredSectionCell:(CustomCellForChannel*)remindMe
                                                               atIndex:(int)rowIndex; 

- (CustomCellForChannel*)populatePlanEveryTimeItISAiredSectionCell:(CustomCellForChannel*)planAired
                                                           atIndex:(int)rowIndex;
- (void)ShowHoursPickerView;

- (void)convertRiminderTimeTODeltaType;

- (void)showPreviousController;

- (void)addAgents;

- (void)registerForKeyboardNotifications;

- (void)removeObserverforKeyBoardNofication;

- (void)createAgentProxy;

- (void)createPlanProxy;

@end

@implementation PlanDetailViewController

@synthesize program = _program;

@synthesize riminderTimeType = _riminderTimeType;

@synthesize riminderTimeTypeTextField = _riminderTimeTypeTextField;

@synthesize agent = _agent;

@synthesize fromPlanEditScreen;

@synthesize planDetailDelegate;

@synthesize planProxy = _planProxy;

@synthesize agentProxy = _agentProxy;


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

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


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




#pragma mark -
#pragma mark Create UI


// creates Plan Details view
// if the screen is show form the Edit mode event then it check if the Agent is present if yes the Fetchs the Agent Details. else only Plan with reminder setting is shown.

- (void)createUI {
      
    [self.view setBackgroundColor:[UIUtils colorFromHexColor:@"353535"]];
    
    [self createTimeTextField];
    
    Agents *agents = [[Agents alloc] init];
    self.agent = agents;
    
    if (self.fromPlanEditScreen == YES) {
            
        if (self.program.agentID) {
            
            planWhenAiredSwitchON = YES;
            
            [self fetchAgents:self.program.agentID];
        
        } else {
          
             [self createTableView]; 
            
        }
          
        
    } else {
        
        [self getSelectedPlan];
    }

    [self createNavigationButton];

}


- (void)createTimeTextField {
    
    self.riminderTimeTypeTextField = [UIControls createUITextFieldWithFrame:CGRectMake(10, 4, 130, 30) FondSize:14 FontName:@"" FontHexColor:GRAY];
    [self.riminderTimeTypeTextField setBorderStyle:UITextBorderStyleNone];
    [self.riminderTimeTypeTextField setKeyboardType:UIKeyboardTypeNumberPad];
} 



#pragma mark - 
#pragma mark - createTableView


- (void)createTableView {
    
    DLog(@"%@",self.program.remiderType);
    
    if (self.program.remiderType) {
        
        remindMeSwitchON = YES;
        
        [self getDifferenceBetweenDate];
        
    }

    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,10,self.view.bounds.size.width,self.view.bounds.size.height-44) style:UITableViewStyleGrouped];
    
    _planDetailTableView = tableView;

	[_planDetailTableView setDelegate:self];
    
    [_planDetailTableView setDataSource:self];
    
    [_planDetailTableView setBackgroundColor:[UIColor clearColor]];
	
    [_planDetailTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    [_planDetailTableView setSeparatorColor:[UIColor lightGrayColor]];
    
    _planDetailTableView.opaque = NO;
    
    _planDetailTableView.backgroundView = nil;
    
    [_planDetailTableView setBounces:YES];
	
    [_planDetailTableView setShowsVerticalScrollIndicator:YES];
    
    _planDetailTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	
    [self.view addSubview:_planDetailTableView];

}



#pragma mark -
#pragma mark Table view data source

// Return the number of sections.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}


// Return the number of rows in the section.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    
    if (section == 0) {
        
        if (remindMeSwitchON) {
                        
            return 3;
            
        } else {
        
            return 1;
        }
        
    } else if (section == 1) {
        
        if (self.program.agentID || planWhenAiredSwitchON) {
            
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
       	
         cell.backgroundColor = [UIColor whiteColor];

   // } 

    
    if ([indexPath section] == 0) {
        
        cell = [self populateRemindMeEveryTimeItISAiredSectionCell:cell atIndex:[indexPath row]];
        
    } else if ([indexPath section] == 1) {
        
      cell = [self populatePlanEveryTimeItISAiredSectionCell:cell atIndex:[indexPath row]];        
    }
	
    return cell;
}


// Assigns values  to the table view section "0".

- (CustomCellForChannel*)populateRemindMeEveryTimeItISAiredSectionCell:(CustomCellForChannel*)remindMe
                                                           atIndex:(int)rowIndex {
    
    if (rowIndex == 0) {
        
        [remindMe.programTimeLabel setFrame:CGRectMake(10, 4, 200, 30)];
        [remindMe.programTitleLabel setHidden:YES];
        [remindMe.programTimeLabel setText: NSLocalizedString(@"Remind me when it's aired",nil)];
        
        UISwitch *switchView = [self createSwitch];
        switchView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [switchView setTag:1];
        remindMe.accessoryView = switchView;
        
        
        if (remindMeSwitchON) {
            
            [switchView setOn:YES animated:NO];
            
        } else {
            
            [switchView setOn:NO animated:NO];
        }
        
        [remindMe setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
    } else if (rowIndex == 1) {
        
        [remindMe.programTimeLabel setText:@"via"];
        [remindMe.programTimeLabel setTextColor:[UIUtils colorFromHexColor:GRAY]];
        [remindMe.programTitleLabel setFrame:CGRectMake(100, 4, 320-150, 30)];
        
        if ([self.program.remiderType isEqualToString:@"temp"]) {
            
            [remindMe.programTitleLabel setText:@""];
            
        } else {
            [remindMe.programTitleLabel setText:[NotificationTypes getReminderType:self.program.remiderType]];            
        }
        
        [remindMe.programTitleLabel setTextAlignment:UITextAlignmentRight];
        
        
    } else if(rowIndex == 2) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(150, 0, 1, 38)];
        [view setBackgroundColor:[UIColor lightGrayColor]];
        [remindMe.contentView addSubview:view];
        
        [remindMe.programTimeLabel setText:@""];        
        
        [remindMe.contentView addSubview:self.riminderTimeTypeTextField];
        
        [remindMe.programTitleLabel setText:self.riminderTimeType];
        [remindMe.programTitleLabel setTextColor:[UIUtils colorFromHexColor:GRAY]];
        
        
    }
    
    return remindMe;
}

// Assigns values  to the table view section "1".

- (CustomCellForChannel*)populatePlanEveryTimeItISAiredSectionCell:(CustomCellForChannel*)planAired
                                                           atIndex:(int)rowIndex {
    
    if (rowIndex == 0) {
        
        [planAired.programTimeLabel setFrame:CGRectMake(10, 4, 200, 30)];
        [planAired.programTitleLabel setHidden:YES];
        [planAired.programTimeLabel setText: NSLocalizedString(@"Plan every time it's aired",nil)];
        
        
        UISwitch *switchView = [self createSwitch];
        switchView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        if (self.program.agentID) {
            
            [switchView setTag:-100]; 
            [switchView setUserInteractionEnabled:NO];

        } else {
            [switchView setTag:2]; 
            [switchView setUserInteractionEnabled:YES];

        }

        planAired.accessoryView = switchView;
        
        if (self.program.agentID || planWhenAiredSwitchON) {
            
            [switchView setOn:YES animated:NO];
    
        } else {
            
            [switchView setOn:NO animated:NO];
            
        }
        
        [planAired setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
    } else if (rowIndex == 1) {
        
        [planAired.programTimeLabel setText: NSLocalizedString(@"On days",nil)];
        
        [planAired.programTitleLabel setTextColor:[UIUtils colorFromHexColor:GRAY]];
        [planAired.programTitleLabel setFrame:CGRectMake(140, 4, 150, 30)];
        [planAired.programTitleLabel setTextAlignment:UITextAlignmentRight];
        [planAired.accessoryImageView setHidden:YES];
        
        AppDelegate_iPhone *appDelegate = DELEGATE;
        
        if (self.agent.reminderDay == nil) {
            
            
            if (appDelegate.user.defaultDaysType == nil || [appDelegate.user.defaultDaysType isKindOfClass:[NSNull class]]){
                
                [planAired.programTitleLabel setText: NSLocalizedString(@"All weekdays", nil)];  
                self.agent.reminderDay = @"-1";
                
            } else {

                DLog(@"%@",appDelegate.user.defaultDaysType);
                
                [planAired.programTitleLabel setText:[NotificationTypes getProUserAgentDayType:appDelegate.user.defaultDaysType]];
                
                self.agent.reminderDay = appDelegate.user.defaultDaysType;
            }
            
        } else {
            
            [planAired.programTitleLabel setText:[NotificationTypes getProUserAgentDayType:self.agent.reminderDay]];
        }
        
        
    } else if (rowIndex == 2) {
        
        [planAired.programTimeLabel setText: NSLocalizedString(@"Between", nil)];
        
        [planAired.programTitleLabel setTextColor:[UIUtils colorFromHexColor:GRAY]];
        [planAired.programTitleLabel setFrame:CGRectMake(140, 4, 150, 30)];
        [planAired.programTitleLabel setTextAlignment:UITextAlignmentRight];
        [planAired.accessoryImageView setHidden:YES]; 
        
        if ( self.agent.reminderHours == nil || [self.agent.reminderHours isEqualToString:@""] || [self.agent.reminderHours isEqualToString:@"0-23"] || [self.agent.reminderHours isEqualToString:@"0"]  ) {
            
    
            AppDelegate_iPhone *appDelegate = DELEGATE;
            

            if (appDelegate.user.defaultHoursType == nil 
                || [appDelegate.user.defaultHoursType isKindOfClass:[NSNull class]]){
                
            
                [planAired.programTitleLabel setText: NSLocalizedString(@"All hours", nil)];  
                self.agent.reminderHours = @"0-23";
                
            } else {
                
                
                if ([appDelegate.user.defaultHoursType isEqualToString:@"0"]) {
                    
                    [planAired.programTitleLabel setText: NSLocalizedString(@"All hours", nil)];
                    self.agent.reminderHours = @"0-23";

                    
                } else {
                    
                    [planAired.programTitleLabel setText:appDelegate.user.defaultHoursType];
                    self.agent.reminderHours = appDelegate.user.defaultHoursType;

                }
                
            }
            
        } else {
            
            [planAired.programTitleLabel setText:self.agent.reminderHours];
        }
        
    }
   
    return planAired;
}

#pragma mark -
#pragma mark Table view delegate
// This methods show the user custom list view of type VIA, TIME , WEEKS.

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [self.riminderTimeTypeTextField resignFirstResponder];
    
    
    if ([indexPath section]== 0) {
        
        if ([indexPath row]== 1) {
            
            [self showCustomListViewForType:@"VIA"];
            
        } else if ([indexPath row] == 2) {
                    
            [self showCustomListViewForType:@"TIME"];
        }
        
        
    } else if ([indexPath section]== 1) {
        
        if (!self.program.agentID) {
            
            if ([indexPath row]== 1) {
            
                [self showCustomListViewForType:@"WEEKS"];                
                
                
            } else if ([indexPath row] == 2) {
            
                [self ShowHoursPickerView];
            }
        
        } 
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath 
{

    return 38;
    
}


- (UISwitch*)createSwitch {
    
    UISwitch *aSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    
    [aSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    if ([aSwitch respondsToSelector:@selector(setOnTintColor:)]) {
      
        [aSwitch setOnTintColor:[UIUtils colorFromHexColor:@"b00a4f"]];
    }
    
    return aSwitch; 
}

// gets called when ever user toggle between the switch, it also assign the defaults values.

- (void) switchChanged:(id)sender {
    
    UISwitch* switchControl = sender;
    
    if (switchControl.tag == 1) {
    
        if (switchControl.on) {
             
            [self createProgramObject];
           
            remindMeSwitchON = YES;
            
            AppDelegate_iPhone *appDelegate = DELEGATE;
            
            if (!self.program.remiderType || [self.program.remiderType isEqualToString:@""]) {
                
                
                if (appDelegate.user.defaultReminderType == nil || [appDelegate.user.defaultReminderType isKindOfClass:[NSNull class]]) {
                    
                    [self initializeRiminderTypeValue:@"email"];

                    
                } else {
                    
                    [self initializeRiminderTypeValue:appDelegate.user.defaultReminderType];
                }
                
                                
            } 
            if (self.riminderTimeTypeTextField.text == nil 
                || self.riminderTimeTypeTextField.text == @"") {
               
                
                
                if (appDelegate.user.defaultReminderTime == nil || [appDelegate.user.defaultReminderTime isKindOfClass:[NSNull class]]) {
                    
                    self.riminderTimeTypeTextField.text = @"15";

                    
                } else {
                    
                    self.riminderTimeTypeTextField.text = appDelegate.user.defaultReminderTime;

                }
                
                
        
        
            } 
            if (!self.riminderTimeType) {
                
                
                if (appDelegate.user.defaultReminderbeforeType == nil || [appDelegate.user.defaultReminderbeforeType isKindOfClass:[NSNull class]]){
                    
                    self.riminderTimeType = NSLocalizedString(@"Minutes before",nil);

                    
                } else {
                    
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
                        
                    } else if (hrs > 0) {
                        
                        self.riminderTimeType = NSLocalizedString(@"Hours before",nil);
                        
                    } else if (min > 0) {
                        
                        self.riminderTimeType = NSLocalizedString(@"Minutes before",nil);
                        
                    } else  {
                        
                        self.riminderTimeType = NSLocalizedString(@"Minutes before",nil);
                        
                    }
                    
                }
                
            }
            
            
        } else {
                    
            remindMeSwitchON = NO;
            
        }

    }    
    else if (switchControl.tag == 2) {
       
       
        if (switchControl.on) {
            
                        
            planWhenAiredSwitchON = YES;
        
                    
        } else {
            
            planWhenAiredSwitchON = NO;
            
        }


    }  
    
    
    [_planDetailTableView reloadData];


}   

// assign the selected reminder type value. 

- (void)initializeRiminderTypeValue:(NSString*)remindType {
    
    self.program.remiderType = remindType;
    
}


// assign the selected reminder Time value and Time Call type i.e Mins,Hrs or Days before. 


- (void)initializeRiminderTimeTypeValue:(NSString*)remindTime andRemindTimeType:(NSString*)remindTimeType {
        
    self.riminderTimeType = remindTimeType;
    self.riminderTimeTypeTextField.text = remindTime;
}



#pragma mark -
#pragma mark Show Custom List View  Screen and Delegate Methods

// show the Custom list for selected cell of type Via, Time and Weeks

- (void)showCustomListViewForType:(NSString*)type {
        
    CustomListViewController *customListViewController = [[CustomListViewController alloc] init];
    customListViewController.customListViewControllerDelegate = self;
    
    if ([type isEqualToString:@"VIA"]) {
    
        customListViewController.selectedListValue = self.program.remiderType;

    } else if ([type isEqualToString:@"TIME"]) {
        
        customListViewController.selectedListValue = self.riminderTimeType;

    } else if ([type  isEqualToString:@"WEEKS"]) {
            
        customListViewController.selectedListValue = self.agent.reminderDay;
            
    } 
        
        
    customListViewController.listType = type;
    
    [self.navigationController pushViewController:customListViewController animated:YES];
    
}


// gets called when the Selected Custom List Value is Changed. 

- (void)selectedListValue:(NSString*)rType For:(NSString*)type {
    
    [self createProgramObject];
    
    if ([type isEqualToString:@"VIA"]) {
        
        [self initializeRiminderTypeValue:rType];
        
    } else if ([type isEqualToString:@"TIME"]) {
        
        [self initializeRiminderTimeTypeValue:self.riminderTimeTypeTextField.text andRemindTimeType:rType]; 
        
    } else if ([type  isEqualToString:@"WEEKS"]) {
        
        self.agent.reminderDay = [NotificationTypes getProUserAgentDayTypeForServer:rType];

    }
    
    
    [_planDetailTableView reloadData];
}


- (void)createProgramObject {
    
    if (!self.program) {
        
        Program *tempProgram = [[Program alloc] init];
        
        self.program = tempProgram;
        
    }
}



#pragma mark -
#pragma mark createBackButton

- (void)createNavigationButton {
    
    
	self.navigationItem.hidesBackButton = YES;
    
    if (self.fromPlanEditScreen == YES) {
        
        self.navigationItem.title = NSLocalizedString(@"Edit planning",nil);

        
    } else {

        self.navigationItem.title = NSLocalizedString(@"Add planning",nil);        
    }
    
    
    UIButton *save = [UIUtils createStandardButtonWithTitle:NSLocalizedString(@"Save",nil) addTarget:self action:@selector(savebuttonClicked)];
	UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:save];
	self.navigationItem.rightBarButtonItem = leftButton;
    
    //    UIButton *save = [[UIButton alloc] initWithFrame:CGRectMake(395, 10, 300, 39)];
    //    [save setTitle:NSLocalizedString(@"Save",nil) forState:UIControlStateNormal];
    //    [save.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    //    [save.titleLabel setTextColor:[UIColor whiteColor]];
    //    [save addTarget:self action:@selector(savebuttonClicked) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:save];
    
    UIButton *backBtn = [UIUtils createBackButtonWithTarget:self action:@selector(backbuttonClicked)];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
	self.navigationItem.leftBarButtonItem = rightBarButton;
    
}


- (void)backbuttonClicked {

    [self.riminderTimeTypeTextField resignFirstResponder];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)savebuttonClicked {
    
    
    [self.riminderTimeTypeTextField resignFirstResponder];

    [self removePlans];        

}





#pragma mark -
#pragma mark - Server Communication Methods 

// called to get selected Plan Details from Server.

- (void)getSelectedPlan {
    
    [self createPlanProxy];
    
    [self.planProxy getPlanForProgramID:self.program.programId];
}

// called to add new Plan to Server.

- (void)addPlans {
    
    if(remindMeSwitchON == NO) {
        
        self.program.remiderType = @"";
        
    } else {
        
        self.program.remiderType = [NotificationTypes getReminderTypeForServer:self.program.remiderType];
        [self getConvertedIntoReminderTime];
        
    }
        
    [self createPlanProxy];
    
    
    [self.planProxy addPlans:self.program];
    
}

// called to remove the plan form the server.
// since put request is not present. we update the plan, by deleting it and addind the new


- (void)removePlans {
        
    [self createPlanProxy];
    
    [self.planProxy deletePlans:self.program.programId];
}


#pragma mark -
#pragma mark - Plan Delegate Methods 


// gets called when is Plan request fails.

- (void)planRequestFailed:(NSString *)error {
    
    
}

// gets called when selected plan get request is successfully.

- (void)receivedPlan:(NSMutableArray*)array {
    
    
    if ([array count] >0) {
        
        Program *progObj = [array objectAtIndex:0];
        
        if ([progObj.start isEqualToString:self.program.start]) {
            
            
            if (self.program.agentID) {
                
                planWhenAiredSwitchON = YES;

                [self fetchAgents:self.program.agentID];
            
            } else {
                
                self.program = progObj;
                [self createTableView];  
            }
            
            self.program = progObj;
        }
            
    }  
    
}

// gets called when the request is successfull but the return data count is zero.

- (void)noPlanRecordsFound {
    
    [self createTableView];  
    [_planDetailTableView reloadData];
}


// gets called when plan is deleted successfully.


- (void)planDeletedSuccesfully {
    
    
    [self addPlans];
}

// gets called when plan is added/ updated successfully.

- (void)planAddedSuccesfully {
    
    if (self.program.agentID) {
        
        [self showPreviousController]; 

        
    } else {
        
        
        if (planWhenAiredSwitchON == NO)  {
            
            [self showPreviousController]; 

            
        } else {
           
            [self addAgents]; 
        }
    }

}

// gets called when plan is Added / updated successfully. 
// when the current view is about to exit and show the previous view "i.e plan screen"
// It called delegate method to update the previous view.

- (void)showPreviousController {
    
    if (self.planDetailDelegate && [self.planDetailDelegate respondsToSelector:@selector(editedPlanSuccessfully)]) {
        
        [self.planDetailDelegate editedPlanSuccessfully];
    }
    
    [self.navigationController popViewControllerAnimated:YES];   
}



// gets called when plan is added to server to make the riminder time formate as per server accepted formate.

- (void)getConvertedIntoReminderTime {
    
    signed int selectedTime = ([self.riminderTimeTypeTextField.text intValue] * -1);
    
    DLog(@"selectedTime : %d",selectedTime);
    
    DLog(@"self.program.start : %@",self.program.start);

    NSDate *oldDate = [UIUtils dateFromUTCString:self.program.start];
    
    DLog(@"OLD DATE : %@",oldDate);
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    [gregorian setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    gregorian.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];

    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    
    if ([self.riminderTimeType isEqualToString:NSLocalizedString(@"Days before",nil)]) {
    
        [offsetComponents setDay:selectedTime];
        
    } else if ([self.riminderTimeType isEqualToString:NSLocalizedString(@"Hours before",nil)]) {
        
         [offsetComponents setHour:selectedTime];
        
    } else if ([self.riminderTimeType isEqualToString:NSLocalizedString(@"Minutes before",nil)]) {
        
        [offsetComponents setMinute:selectedTime];
    }
    
    NSDate *newDate = [gregorian dateByAddingComponents:offsetComponents toDate:oldDate options:0];
    
    DLog(@"NEW DATE : %@",newDate);
    
    //self.program.remiderProgramStartTime  = [UIUtils stringFromGivenDate2:newDate];
    
    self.program.remiderProgramStartTime  = [UIUtils stringFromGivenGMTDate:newDate  WithFormat:@"EEE,ddMMMyyyyHH:mm:ss"];
    
    DLog(@"self.program.start : %@",self.program.remiderProgramStartTime);
}


// gets called to convert reminder type formate from server accepted to native.

- (void)getDifferenceBetweenDate {
    
    NSTimeInterval timeInterval = [[UIUtils dateFromUTCString:self.program.start] timeIntervalSinceDate:[UIUtils dateFromUTCString:self.program.remiderProgramStartTime]];
    
    
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
        
        [self initializeRiminderTimeTypeValue:[NSString stringWithFormat:@"%d",day] andRemindTimeType:NSLocalizedString(@"Days before",nil)];

        
    } else if (hrs > 0) {
        
        [self initializeRiminderTimeTypeValue:[NSString stringWithFormat:@"%d",hrs] andRemindTimeType:NSLocalizedString(@"Hours before",nil)];
        
    } else if (min > 0) {
    
        [self initializeRiminderTimeTypeValue:[NSString stringWithFormat:@"%d",min] andRemindTimeType:NSLocalizedString(@"Minutes before",nil)];
    }
    
    
    DLog(@"days : %d",day);
    
    DLog(@"hours : %d",hrs);
    
    DLog(@"minutes : %d",min);
    
}







#pragma mark - 
#pragma mark Touches Methods

// gets called if touched coordinates are view, to resign the keyboard. 

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
        
    [self.riminderTimeTypeTextField resignFirstResponder];
}



#pragma mark -
#pragma mark - Server Communication Methods For Agents

// get called to fetch Agent Details 
// if the Seleted Plan Program contails Agent id then this method is called.

- (void)fetchAgents:(NSString*)agentId {
        
    [self createAgentProxy];
    
    [self.agentProxy  getAgentForAgentID:agentId];
    
}

// gets called when new agent is added/or agent is updated 

- (void)addAgents {
    
    
    if(remindMeSwitchON) {
        
        self.agent.reminderType = self.program.remiderType;

        
    } else {
      
        self.agent.reminderType = @"";

    }
    
    if ([self.program.title isEqualToString:@""] || self.program.title == nil) {
        
        [UIUtils alertView:@"program title can not be blank" withTitle:@"Info"];
        
    } else {
        
        self.agent.searchText = self.program.title;
        [self convertRiminderTimeTODeltaType];
        
        self.agent.searchTargetCriteria = @"title"; 
        self.agent.searchTypeCriteria = @"exact";
        self.agent.channelID = [NSString stringWithFormat:@"%d",self.program.channel];
                
        [self createAgentProxy];
        
        [self.agentProxy addAgent:self.agent];
        
    }  
    
}

// get called when agent is added successfully to server.

- (void)agentAddedSuccesfully {
    
    [self showPreviousController];
    
}

// get called when agent details is  received successfully from server.

- (void)receivedAgent:(NSMutableArray*)array  {
    
    if ([array count] > 0) {
       
        self.agent = [array objectAtIndex:0];
    }
    
    [self createTableView];  

}


// gets called when the Agent request fails.

- (void)agentRequestFailed:(NSString *)error {
    
}

//Get called when adds or update the Agent. it converts the native riminder type  data 
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
#pragma mark - Hours Screen and Delegate Methods 

// Show the Picker view for the hours type cell.


- (void)ShowHoursPickerView {
    
    
    NSArray *hoursItems = [self.agent.reminderHours componentsSeparatedByString:@"-"];
    
    
    self.pickerController = [[CustomPickerViewController alloc] init];
    [self.view addSubview:self.pickerController.view];
   
    self.pickerController.selectedHoursFirstComponent = [hoursItems objectAtIndex:0];
    
    self.pickerController.selectedHoursSecondComponent = [hoursItems objectAtIndex:1];
    self.pickerController.customPickerViewDelegate = self; 
    
    
}

// Gets Called when user clicks the done button on picker view, to update the hour cell.

- (void)doneClicked:(NSString *)selectedHours {
    
    self.agent.reminderHours = selectedHours;
    [_planDetailTableView reloadData];
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
    
    [self.riminderTimeTypeTextField resignFirstResponder];
}

// gets called when keyboard return to hide State from Visible State.
// here we remove the custom done button added to the keyboard.

- (void)keyboardWillHide {
    
    [[_keyboardView viewWithTag:1000] removeFromSuperview];
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
