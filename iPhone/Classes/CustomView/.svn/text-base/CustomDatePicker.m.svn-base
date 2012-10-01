

#import "CustomDatePicker.h"
#import "UIUtils.h"

@interface CustomDatePicker (Private)

- (NSDate*)getNewDateFromDate:(NSDate*)oldDate NewDateDayDifferance:(int)daydifference;

@end


@implementation CustomDatePicker
@synthesize customDatePickerDelegate;
@synthesize toolbar;





- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {       
        self.datePickerMode = UIDatePickerModeDate;
        
        NSLocale *locale = [NSLocale currentLocale];
        //self.locale = locale; 
        self.calendar = [locale objectForKey:NSLocaleCalendar];
        self.timeZone = [NSTimeZone localTimeZone];

        [self setDate:[NSDate date]];
        [self setMinimumDate:[NSDate date]];
        [self setMaximumDate:[self getNewDateFromDate:[NSDate date] NewDateDayDifferance:14]];

        [self addTarget:self action:@selector(pickerValueChanged) forControlEvents:UIControlEventValueChanged];
        [self createToolBarforDatePicker];
    }
    return self;
}

-(void) createToolBarforDatePicker {	
    if(!self.toolbar) {
        UIToolbar *toolB = [[UIToolbar alloc] init];
        self.toolbar = toolB;
    }
	//self.toolbar = [UIToolbar new];
	self.toolbar.barStyle = UIBarStyleBlackTranslucent;
	// size up the toolbar and set its frame
	[self.toolbar sizeToFit];	
	[self.toolbar setFrame:CGRectMake(0, self.frame.origin.y - 40, 320, 40)];
	
	//systemItem.width=75.0f;
    
    
    UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:@" Done "
																   style:UIBarButtonItemStyleBordered
																  target:self
																  action:@selector(doneButtonClicked:)];
    
    
    UIBarButtonItem *flexibleWidthButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *cancelBarItem = [[UIBarButtonItem alloc] initWithTitle:@" Cancel " style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonClicked)];

	
	NSArray *items = [NSArray arrayWithObjects: doneBarItem,flexibleWidthButton,cancelBarItem,nil];
	[self.toolbar setItems:items animated:NO];
	
	
	
}

-(void) doneButtonClicked : (id) sender {
	if(self != nil){
        if(self.customDatePickerDelegate) {
             
            
            NSLocale *locale = [NSLocale currentLocale];
            //self.locale = locale; 
            self.calendar = [locale objectForKey:NSLocaleCalendar];
            self.timeZone = [NSTimeZone localTimeZone];
           
        
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"EEEddMMMyyyy HH:mm:ss"];	
            [dateFormat setLocale:locale];
            
            //NSString *dateStr = [dateFormat stringFromDate:self.date];
            
            //NSDate *dateActual = [dateFormat dateFromString:dateStr];
            

            //DLog(@"dateString : %@",dateStr);
            //DLog(@"dateActual : %@",dateActual);
            [self.customDatePickerDelegate getSelectedDateFromDatePicker:[self date]];
        }

		[self removeFromSuperview]; 
	}
	self.toolbar.hidden=YES;
	
}


- (void)cancelButtonClicked {
	
	[self removeFromSuperview];
    self.toolbar.hidden=YES;
	
}	

-(void) pickerValueChanged {

}


- (NSDate*)getNewDateFromDate:(NSDate*)oldDate NewDateDayDifferance:(int)daydifference 
{
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setLocale:[NSLocale currentLocale]];
    [gregorian setTimeZone:[NSTimeZone localTimeZone]];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:daydifference];
    NSDate *newDate = [gregorian dateByAddingComponents:offsetComponents toDate:oldDate options:0];
    
    
    return newDate;
    
}





@end
