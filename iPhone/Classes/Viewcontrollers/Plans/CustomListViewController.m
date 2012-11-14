
#import "CustomListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomCellForChannel.h"
#import "CustomCellForChannel.h"
#import "NotificationTypes.h"
#import "Channel.h"

@interface  CustomListViewController()

- (void)createUI;

- (void)createTableView;

- (void)createBackButton;

@end


@implementation CustomListViewController

@synthesize customListViewControllerDelegate = _customListViewControllerDelegate;

@synthesize selectedListValue =_selectedListValue;

@synthesize listType = _listType;

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


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma mark Create UI

// create UI for List type VIA, TIME, WEEKS, TITLE, TYPE, CHANNELS, DATE.


- (void)createUI; {
    
    [self.view setBackgroundColor:[UIUtils colorFromHexColor:White]];
    
    if ([self.listType  isEqualToString:@"VIA"]) {
       
         _listArray = [[NSMutableArray alloc] initWithObjects:@"Apple Push Notifications",@"SMS",@"E-mail",@"ical",@"c2dm",nil];
        self.navigationItem.title = NSLocalizedString(@"Remind me via",nil);

    } else if ([self.listType  isEqualToString:@"TIME"]) {
        
        _listArray = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"Minutes before",nil), 
                      NSLocalizedString(@"Hours before",nil), 
                      NSLocalizedString(@"Days before",nil),nil];
        self.navigationItem.title = NSLocalizedString(@"Remind Time",nil);

    } else if ([self.listType  isEqualToString:@"WEEKS"]) {
        
        _listArray = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"All",nil),NSLocalizedString(@"Weekdays(mon-fri)",nil),NSLocalizedString(@"Weekends(sat-sun)",nil),NSLocalizedString(@"Mondays",nil),NSLocalizedString(@"Tuesdays",nil),NSLocalizedString(@"Wednesdays",nil),NSLocalizedString(@"Thursdays",nil),NSLocalizedString(@"Fridays",nil),NSLocalizedString(@"Saturdays",nil),NSLocalizedString(@"Sundays",nil),nil];
        
        self.navigationItem.title = NSLocalizedString(@"Select Days",nil);
        
    } else if ([self.listType  isEqualToString:@"TITLE"]) {
        
        _listArray = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"Title",nil),NSLocalizedString(@"Summary",nil),NSLocalizedString(@"Title or summary",nil),nil];
        self.navigationItem.title = NSLocalizedString(@"Search Target",nil);
        
    } else if ([self.listType  isEqualToString:@"TYPE"]) {
        
        _listArray = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"Is",nil),NSLocalizedString(@"Contains",nil),NSLocalizedString(@"Begins with",nil),NSLocalizedString(@"Ends with",nil),nil];
        self.navigationItem.title = NSLocalizedString(@"Search Type",nil);
        
    } else if ([self.listType  isEqualToString:@"CHANNELS"]) {
        
        AppDelegate_iPhone *appDelegate = DELEGATE;

        _listArray = [[NSMutableArray alloc] init];
       
        Channel *channel = [[Channel alloc] init];
        channel.title = NSLocalizedString(@"All",nil);
        channel.id = 0;
        [_listArray addObject:channel];
        
        
        for (int i = 0; i<[appDelegate.favoriteChannelsViewController.allChannelsArray count]; i++) 
        {
            
          [_listArray addObject:[appDelegate.favoriteChannelsViewController.allChannelsArray objectAtIndex:i]];
        }

        self.navigationItem.title = NSLocalizedString(@"Select Channel",nil);

    } else if ([self.listType  isEqualToString:@"DATE"]) {
        
           _listArray = [[NSMutableArray alloc] init];

            for (int i = 0; i < 15; i++) {
                
                NSDate *newDate = [[NSDate date] dateByAddingTimeInterval: 86400*i];
                
                [_listArray addObject:newDate];
            }
        
        self.navigationItem.title = NSLocalizedString(@"Select Date",nil);
            
    }
    
    [self createTableView];
    [self createBackButton];
}


#pragma mark - 
#pragma mark - createTableView


- (void)createTableView {
    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,10,self.view.bounds.size.width,self.view.bounds.size.height) style:UITableViewStylePlain];
    
    _listTableView = tableView;

	[_listTableView setDelegate:self];
	[_listTableView setDataSource:self];
    [_listTableView setBackgroundColor:[UIColor clearColor]];
	[_listTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_listTableView setSeparatorColor:[UIColor lightGrayColor]];
    _listTableView.opaque = NO;
    _listTableView.backgroundView = nil;
    [_listTableView setBounces:YES];
	[_listTableView setShowsVerticalScrollIndicator:YES];
    
    _listTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
	[self.view addSubview:_listTableView];
    
}


#pragma mark -
#pragma mark Table view data source


// Return the number of rows in the section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [_listArray count];
}


// create table view cell for each row and assign values as per selected list type.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *cellIdentifier = @"Cell";

    
    CustomCellForChannel *cell = (CustomCellForChannel *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if (cell == nil) {
        
        cell = [[CustomCellForChannel alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier andTableType:@"CUSTOMLIST"];
       	
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    [cell.accessoryImageView setTag:0];
    [cell.accessoryImageView setHidden:YES];
    
    
    if ([self.listType  isEqualToString:@"VIA"]) {
        
        if ([[NotificationTypes getReminderType:self.selectedListValue] isEqualToString:[_listArray objectAtIndex:[indexPath row]]]) {
            
            [cell.accessoryImageView setTag:1];
            [cell.accessoryImageView setHidden:NO];
            
        } 
        
    } else if ([self.listType  isEqualToString:@"TIME"]) {
        
        if ([self.selectedListValue isEqualToString:[_listArray objectAtIndex:[indexPath row]]]) {
            
            [cell.accessoryImageView setTag:1];
            [cell.accessoryImageView setHidden:NO];
            
        }

        
    } else if ([self.listType  isEqualToString:@"WEEKS"]) {
        
        
        if ([[NotificationTypes getProUserAgentDayType:self.selectedListValue] isEqualToString:[_listArray objectAtIndex:[indexPath row]]]) {
            
            [cell.accessoryImageView setTag:1];
            [cell.accessoryImageView setHidden:NO];
            
        } 
 
        
    } else if ([self.listType  isEqualToString:@"TITLE"]) {
   
        
        if ([[NotificationTypes getAgentSearchTitleCriteriaType:self.selectedListValue] isEqualToString:[_listArray objectAtIndex:[indexPath row]]]) {
            
            [cell.accessoryImageView setTag:1];
            [cell.accessoryImageView setHidden:NO];
            
        } 
        
    } else if ([self.listType  isEqualToString:@"TYPE"]) {
    
        if ([[NotificationTypes getAgentSearchTypeCriteriaType:self.selectedListValue] isEqualToString:[_listArray objectAtIndex:[indexPath row]]]) {
            
            [cell.accessoryImageView setTag:1];
            [cell.accessoryImageView setHidden:NO];
            
        } 
        
    } else if ([self.listType  isEqualToString:@"DATE"]) {
        
        NSDate *dateObj = [_listArray objectAtIndex:[indexPath row]];
        
        NSString *dateStr = [UIUtils dateStringWithFormat:dateObj format:@"dd.MM.yyyy"];
        
        [cell.programTitleLabel setText:dateStr];
        
        if ([self.selectedListValue isEqualToString: [UIUtils dateStringWithFormat: [_listArray objectAtIndex:[indexPath row]] format:@"MM-dd-yy"]]) {
            
            [cell.accessoryImageView setTag:1];
            [cell.accessoryImageView setHidden:NO];
            
        }
        
    }
    
    
    
    if ([self.listType  isEqualToString:@"CHANNELS"]) {
        
        
      Channel *channel = [_listArray objectAtIndex:[indexPath row]];
      [cell.programTitleLabel setText:channel.title]; 
        
        
        NSString *channelIDString = [[NSString alloc] initWithFormat:@"%d",channel.id];
        
        if ([self.selectedListValue  isEqualToString:channelIDString]) {
            
            
            [cell.accessoryImageView setTag:1];
            [cell.accessoryImageView setHidden:NO];
     
        }  
        
        
        
    } else if ([self.listType  isEqualToString:@"DATE"]) {
    
        NSDate *dateObj = [_listArray objectAtIndex:[indexPath row]];
        
        NSString *dateStr = [UIUtils dateStringWithFormat:dateObj format:@"dd.MM.yyyy"];
        
        [cell.programTitleLabel setText:dateStr];
        
        
    } else {
        
        [cell.programTitleLabel setText:[_listArray objectAtIndex:[indexPath row]]];
    
    } 

	return cell;
}

#pragma mark -
#pragma mark Table view delegate

// get called when user select the options form the list.
// it send the select option to the appropriate delegating object and exit the view to show the previous view.

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CustomCellForChannel *cell = (CustomCellForChannel*)[tableView cellForRowAtIndexPath:indexPath];

    if ([self.listType  isEqualToString:@"CHANNELS"]) {
        
        Channel *channel = [_listArray objectAtIndex:[indexPath row]];
        NSString *channelIDString = [[NSString alloc] initWithFormat:@"%d",channel.id];
        self.selectedListValue = channelIDString;
        
    
    } else if ([self.listType  isEqualToString:@"DATE"]) {
        
        
        self.selectedListValue = [UIUtils dateStringWithFormat: [_listArray objectAtIndex:[indexPath row]] format:@"MM-dd-yy"];
        
    } else {
        
         self.selectedListValue = cell.programTitleLabel.text;
    }
    
    [tableView reloadData];
    
    if (self.customListViewControllerDelegate && [self.customListViewControllerDelegate respondsToSelector:@selector(selectedListValue:For:)]) {
        
        
        if ([self.listType  isEqualToString:@"DATE"]) {
            
            [self.customListViewControllerDelegate selectedListValue:[_listArray objectAtIndex:[indexPath row]] For:self.listType];

            
        } else {
            
            [self.customListViewControllerDelegate selectedListValue:self.selectedListValue For:self.listType];
        }
    }

    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath 
{
    
    return 38;
    
}


#pragma mark -
#pragma mark createBackButton
   
- (void)createBackButton {
    
	self.navigationItem.hidesBackButton = YES;

    UIButton *backBtn = [UIUtils createBackButtonWithTarget:self action:@selector(backbuttonClicked)];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
	self.navigationItem.rightBarButtonItem = rightBarButton;

}

// event is executed when back button is clicked.

- (void)backbuttonClicked {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
