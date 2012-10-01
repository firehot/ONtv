
#import "CustomControl.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation CustomControl
@synthesize customControlDelegate;
@synthesize detailsTextView;
@synthesize imageUrlString;


-(void) addProgramLogo {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigChannelLogo"]];
	programlogoImageView = imageView;
	programlogoImageView.frame = CGRectMake(5, 25, 100, 100);
	programlogoImageView.contentMode = UIViewContentModeScaleAspectFit;
	[self addSubview:programlogoImageView];
//    [programlogoImageView setImageURL:programToDisplay.]
}

- (void) createProgramDetailsTextview  {
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(5, 25, 305, 200)];
	detailsTextView = textView;//x=120
	detailsTextView.backgroundColor = [UIColor clearColor];	
    detailsTextView.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
	//detailsTextView.backgroundColor = [UIColor grayColor];
    detailsTextView.layer.borderWidth = 1;
	detailsTextView.layer.borderColor = [[UIColor grayColor] CGColor];
	detailsTextView.layer.cornerRadius = 10;	
    detailsTextView.layer.masksToBounds = NO;
	detailsTextView.layer.shadowColor = [UIColor grayColor].CGColor;
	detailsTextView.layer.shadowOpacity = 2.0;//0.8
	detailsTextView.layer.shadowRadius = 12;//12
	detailsTextView.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);

	detailsTextView.delegate = self;
	detailsTextView.tag = 1;
	[self addSubview:detailsTextView];	
    [detailsTextView setText:programToDisplay.title];
}



- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.exclusiveTouch = YES;
		//[self addProgramLogo];
		[self createProgramDetailsTextview];

		self.backgroundColor = [UIColor blackColor];
		
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame andProgram:(Program *)theProgram{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.exclusiveTouch = YES;
        programToDisplay = theProgram;
        [self addProgramLogo];
        
		[self createProgramDetailsTextview];        
		self.backgroundColor = [UIColor clearColor];
		[self addTarget:self action:@selector(touchDetected:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


- (void)displayPhoto:(NSString*)programPhoto {
	[programlogoImageView setImageWithURL:[NSURL URLWithString:programPhoto] placeholderImage:[UIImage imageNamed:@"bigChannelLogo"]];
}

- (void)setProgramDescription : (NSString*) programDescription {
//    if([programToDisplay. isEqualToString:]) {
//        
//    }
	detailsTextView.text = programDescription;
}

-(void) touchDetected : (id) sender {
	if(customControlDelegate) {
		[customControlDelegate controlClickEvent:sender];
	}
}

#pragma mark -
#pragma mark Textview delegate methods
#pragma mark -

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if([text isEqualToString:@"\n"])
	{
		[textView resignFirstResponder];
		return NO;
	}
	return YES;
}

@end
