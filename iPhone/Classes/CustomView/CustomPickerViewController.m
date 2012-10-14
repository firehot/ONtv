
#import "CustomPickerViewController.h"


@implementation CustomPickerViewController

@synthesize picker = _picker;
@synthesize selectedHoursFirstComponent = _selectedHoursFirstComponent;
@synthesize selectedHoursSecondComponent = _selectedHoursSecondComponent;
@synthesize customPickerViewDelegate = _customPickerViewDelegate;
@synthesize hoursArrayOne = _hoursArrayOne;
@synthesize hoursArrayTwo = _hoursArrayTwo;

// Implement loadView to create a view hierarchy programmatically, without using a nib.

- (void)loadView {

	[super loadView];
	[self.view setBackgroundColor:[UIColor clearColor]];

    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 460-255, 320, 255)];
    self.view = tempView;
    [self designView];
    
}

    

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)designView {
	
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
	[toolBar sizeToFit];	
	[toolBar setFrame:CGRectMake(0, 0, 320, 40)];
	
    
    UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:@" Done "
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(doneButton)];
    
    
    UIBarButtonItem *flexibleWidthButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *cancelBarItem = [[UIBarButtonItem alloc] initWithTitle:@" Cancel " style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonClicked)];
    
	
	NSArray *items = [NSArray arrayWithObjects: doneBarItem,flexibleWidthButton,cancelBarItem,nil];
	[toolBar setItems:items animated:NO];
	

    [self.view addSubview:toolBar];
    
    UIPickerView *tempPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0,40,320,215)];
	self.picker = tempPicker;
	self.picker.delegate = self;
	self.picker.dataSource =self;
	self.picker.showsSelectionIndicator = YES;
	[self.view addSubview:self.picker];
	
    
	[self.picker reloadAllComponents];
	
    
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    self.hoursArrayOne = tempArray;
    
    
    for (int i = 0; i < 24; i++) {
        
        [self.hoursArrayOne addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    
    NSMutableArray *tempArray2 = [[NSMutableArray alloc]init];
    self.hoursArrayTwo = tempArray2;
    
    
    for (int i = 23; i >= 0; i--) {
        
        [self.hoursArrayTwo addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    
    int currentSecectedValues1 = [self.selectedHoursFirstComponent intValue];
    int currentSecectedValues2 = [self.selectedHoursSecondComponent intValue];
    
    
    [self.picker  selectRow:currentSecectedValues1 inComponent:0 animated:YES];
    [self.picker  selectRow:(23 - currentSecectedValues2) inComponent:1 animated:YES];
    		
}	
#pragma mark -
#pragma mark Actions

- (void)cancelButtonClicked {
	
    [self.view removeFromSuperview];	

}	

- (void)doneButton {
	
	if (customPickerViewDelegate && [customPickerViewDelegate respondsToSelector:@selector(doneClicked:)]) {
		
		[customPickerViewDelegate doneClicked:[NSString stringWithFormat:@"%@-%@",self.selectedHoursFirstComponent,self.selectedHoursSecondComponent]];		
	}
    
     [self.view removeFromSuperview];	
	
}	


#pragma mark -
#pragma mark pickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	
	return 2; 
}	

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	 
 	
	return [self.hoursArrayOne count];

}	


#pragma mark - 
#pragma mark - date Picker delegate 

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
		
    
    if (component == 0) {
        
        return [self.hoursArrayOne objectAtIndex:row];

    } else {
        
        return [self.hoursArrayTwo objectAtIndex:row];

    }
}	

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
	   
    if (component == 0) {
        
        self.selectedHoursFirstComponent = [self.hoursArrayOne objectAtIndex:row];
        
    } else {
        
        self.selectedHoursSecondComponent = [self.hoursArrayTwo objectAtIndex:row];
        
    }

}	

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	
	return 70; 			

}	



@end
