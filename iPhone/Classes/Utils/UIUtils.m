

#import "UIUtils.h"


@implementation UIUtils


+(void)alertView:(NSString *)message withTitle:(NSString *)title {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
	[alert show];
}

+(void)alertView:(NSString *)message withTitle:(NSString *)title andDelegate:(id)target andTag:(int)tagValue {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
	alert.delegate = target;
	alert.tag = tagValue;
	[alert show];
}
+ (UIColor *) colorFromHexColor: (NSString *) hexColor { 
	NSUInteger red, green, blue; 
	NSRange range; 
	range.length = 2; 
	range.location = 0; 
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red]; 
	range.location = 2; 
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green]; 
	range.location = 4; 
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue]; 
	return [UIColor colorWithRed:(float)(red/255.0) green:(float)(green/255.0) blue:(float)(blue/255.0) alpha:1.0]; 
} 

#pragma mark -
#pragma mark Image methods

+ (UIImage*)cropImage:(UIImage *)imageToCrop toRect:(CGRect)rect {
	//create a context to do our clipping in
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef currentContext = UIGraphicsGetCurrentContext();
	
	//create a rect with the size we want to crop the image to
	//the X and Y here are zero so we start at the beginning of our
	//newly created context
	CGRect clippedRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
	CGContextClipToRect( currentContext, clippedRect);
	
	//create a rect equivalent to the full size of the image
	//offset the rect by the X and Y we want to start the crop
	//from in order to cut off anything before them
	CGRect drawRect = CGRectMake(rect.origin.x * -1,
								 rect.origin.y * -1,
								 imageToCrop.size.width,
								 imageToCrop.size.height);
	
	
	CGContextTranslateCTM(currentContext, 0.0, drawRect.size.height);
	CGContextScaleCTM(currentContext, 1.0, -1.0);
	
	//draw the image to our clipped context using our offset rect
	CGContextDrawImage(currentContext, drawRect, imageToCrop.CGImage);
	
	//pull the image from our cropped context
	UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
	
	//pop the context to get back to the default
	UIGraphicsEndImageContext();
	
	//Note: this is autoreleased
	return cropped;
}

+ (UIImage *)scaleImage:(UIImage *) image maxWidth:(float) maxWidth maxHeight:(float) maxHeight {
	CGImageRef imgRef = image.CGImage;
	
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
	
	if (width <= maxWidth && height <= maxHeight)
	{
		return image;
	}
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	if (width > maxWidth || height > maxHeight)
	{
		CGFloat ratio = width/height;
		if (ratio > 1)
		{
			bounds.size.width = maxWidth;
			bounds.size.height = bounds.size.width / ratio;
		}
		else
		{
			bounds.size.height = maxHeight;
			bounds.size.width = bounds.size.height * ratio;
		}
	}
	
	CGFloat scaleRatio = bounds.size.width / width;
	
	UIGraphicsBeginImageContext(bounds.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextScaleCTM(context, scaleRatio, -scaleRatio);
	CGContextTranslateCTM(context, 0, -height);
	
	CGContextConcatCTM(context, transform);
	
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	
	return imageCopy;
}


+(UIImage *) scaleAndCropImage:(UIImage*) image maxWidth:(float)toWidth maxHeight:(float)toHeight {
	CGImageRef imgRef = image.CGImage;
	
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
	
	UIImage *scaledImage = nil;
	
	if(width > height) {
		
		float ratio = width / height;		
		float toAdjustedWith = toHeight * ratio;		
		scaledImage = [UIUtils scaleImage:image maxWidth:toAdjustedWith maxHeight:toHeight];
	} else {
		
		float ratio = height / width;		
		float toAdjustedHeight = toWidth * ratio;	
		scaledImage = [UIUtils scaleImage:image maxWidth:toWidth maxHeight:toAdjustedHeight];
	}
	
	CGImageRef scaledImageRef = scaledImage.CGImage;
	
	float scaledWidth = CGImageGetWidth(scaledImageRef);
	
	float x = (scaledWidth - toWidth) / 2;
	
	CGRect cropRect = CGRectMake(x, 0, toWidth, toHeight);
	
	UIImage* croppedImage = [UIUtils cropImage:scaledImage toRect:cropRect];
	
	return croppedImage;
}

+ (CATransition *) getSwipeAnimationWithDirection:(NSString *) direction withDuration:(float) time {
	CATransition *animation = [CATransition animation];
	[animation setDelegate:self];
	[animation setType:kCATransitionPush];
	[animation setSubtype:direction];
	[animation setDuration:time];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	return animation;
}

+(NSDate *)dateFromUTCString:(NSString*)dateString {
   
    DLog(@"OLD DATE : %@",dateString);

	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
	[dateFormat setDateFormat:@"EEE,ddMMMyyyy HH:mm:ss 'GMT'"];
	[dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
	NSDate *start = [dateFormat dateFromString:dateString];
	return start ;
}



+(NSString *)localTimeStringForGMTDateString:(NSString *)gmtDateString {
    
	NSDateFormatter *gmtDateFormat = [[NSDateFormatter alloc] init];
    [gmtDateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
	[gmtDateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
	NSDate *gmtDate = [gmtDateFormat dateFromString:gmtDateString];
    NSDateFormatter *localDateFormat = [[NSDateFormatter alloc] init];
    [localDateFormat setTimeZone:[NSTimeZone localTimeZone]];
    
    NSLocale *locale = [NSLocale currentLocale];
    [localDateFormat setLocale:locale];
    [localDateFormat setDateFormat:@"HH:mm"];
    NSString * localDateStr = [localDateFormat stringFromDate:gmtDate];
    
    DLog(@"Date %@",localDateStr);
    
    return  localDateStr;
}


+(NSString *)localDayStringForGMTDateString:(NSString *)gmtDateString {
    
	NSDateFormatter *gmtDateFormat = [[NSDateFormatter alloc] init];
    [gmtDateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
	[gmtDateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
	NSDate *gmtDate = [gmtDateFormat dateFromString:gmtDateString];
    NSDateFormatter *localDateFormat = [[NSDateFormatter alloc] init]; 
    [localDateFormat setTimeZone:[NSTimeZone localTimeZone]];
    
    NSLocale *locale = [NSLocale currentLocale];
    [localDateFormat setLocale:locale];
    
	[localDateFormat setDateFormat:@"EEEE"];
    NSString * localDateStr = [localDateFormat stringFromDate:gmtDate];
    
    DLog(@"Date %@",localDateStr);
    
    return  localDateStr;
}


+ (NSString *)stringFromGivenDate:(NSDate *)givenDate
{
	return [UIUtils stringFromGivenDate:givenDate withLocale:[[NSLocale currentLocale] localeIdentifier]];
}

+ (NSString *)stringFromGivenDate:(NSDate *)givenDate withLocale:(NSString*)localeIdentifier
{
	return [UIUtils stringFromGivenDate:givenDate withLocale:[[NSLocale currentLocale] localeIdentifier] andFormat: @"EEEddMMMyyyy HH:mm:ss"]; 
}

+ (NSString *)stringFromGivenDate:(NSDate *)givenDate withLocale:(NSString*)localeIdentifier andFormat:(NSString*)format
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier: localeIdentifier]];
	[dateFormat setDateFormat: format];
	[dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSLog(@"Current local timezone  is  %@",[NSTimeZone systemTimeZone]);
	
	NSString *dateStr = [dateFormat stringFromDate:givenDate];
    
    DLog(@"Date %@",dateStr);
    
	return dateStr;
}

+ (NSString *)dateStringWithFormat:(NSDate *)givenDate format:(NSString*)format {
	
    NSDateFormatter *localDateFormat = [[NSDateFormatter alloc] init]; 
    [localDateFormat setTimeZone:[NSTimeZone localTimeZone]];

    NSLocale *locale = [NSLocale currentLocale];
    [localDateFormat setLocale:locale];
    
	[localDateFormat setDateFormat:format];	
	NSString *dateStr = [localDateFormat stringFromDate:givenDate];
    
    DLog(@"Date %@",dateStr);
    
	return dateStr;
} 


 
+ (NSString *)startTimeFromGivenDate:(NSDate *)givenDate 
{
     unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
     NSDate *date = givenDate;
     DLog(@"%@",date);
     NSCalendar *calendar = [NSCalendar currentCalendar];
     NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
     
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
     
     //update for the start date
     [comps setHour:6];
     [comps setMinute:0];
     [comps setSecond:0];
     NSDate *sDate = [calendar dateFromComponents:comps];
     
     DLog(@"start date in GMT %@",sDate);
     
     NSDateFormatter *localDateFormatter = [[NSDateFormatter alloc] init];
     localDateFormatter.dateFormat = @"EEEddMMMyyyy hh:mm:ss";
     [localDateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
     
     DLog(@"LOCAL START DATE %@",[localDateFormatter stringFromDate:sDate]);
     
     NSDateFormatter *dateFormatterGMT = [[NSDateFormatter alloc] init];
     
     [dateFormatterGMT setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
     
     [dateFormatterGMT setDateFormat:@"EEEddMMMyyyy hh:mm:ss"];
     
     [dateFormatterGMT setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];

     NSString *startStr = [dateFormatterGMT stringFromDate:sDate];
     
     DLog(@"GMT START DATE %@",startStr);
    
     return startStr;
 }
 


+ (NSString *)endTimeFromGivenDate:(NSDate *)givenDate
{
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *date = givenDate;
    DLog(@"%@",date);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    
    //update for the end date
    [comps setHour:29];
    [comps setMinute:59];
    [comps setSecond:0];
    NSDate *eDate = [calendar dateFromComponents:comps];
        
    DLog(@"end Date in GMT %@",eDate);
    
    NSDateFormatter *localDateFormatter = [[NSDateFormatter alloc] init];
    localDateFormatter.dateFormat = @"EEEddMMMyyyy hh:mm:ss";
    [localDateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    DLog(@"LOCAL END DATE %@",[localDateFormatter stringFromDate:eDate]);
    
    NSDateFormatter *dateFormatterGMT = [[NSDateFormatter alloc] init];
    
    [dateFormatterGMT setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    [dateFormatterGMT setDateFormat:@"EEEddMMMyyyy hh:mm:ss"];
    
    [dateFormatterGMT setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSString *endStr = [dateFormatterGMT stringFromDate:eDate];
    
    DLog(@"GMT END DATE %@",endStr);

    return endStr;
}

+ (NSString *)stringFromGivenGMTDate:(NSDate *)givenDate  WithFormat:(NSString*)format 
{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormat setDateFormat:format];
    
    NSString *dateString = [dateFormat stringFromDate:givenDate];
    
    return dateString;
    
}


+ (NSDate *)dateFromGivenGMTString:(NSString *)givenDate  WithFormat:(NSString*)format {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormat setDateFormat:format];
    
    NSDate *dateObj = [dateFormat dateFromString:givenDate];
    
    return dateObj;
    
}

+ (UIButton *)createBackButtonWithTarget:(id)target action:(SEL)action{
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [backBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    UIImage *image = [UIImage imageNamed:@"btn_back"];
    image = [image stretchableImageWithLeftCapWidth: 15 topCapHeight: 4];
    [backBtn setBackgroundImage:image forState:UIControlStateNormal];
    
    UIImage*highlitedImage = [UIImage imageNamed:@"btn_back_pressed"];
    highlitedImage = [highlitedImage stretchableImageWithLeftCapWidth: 15 topCapHeight: 4];
    [backBtn setBackgroundImage:highlitedImage forState:UIControlStateHighlighted];
    [backBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [backBtn setTitle: NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
	[backBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [backBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 10.0f);
    [backBtn sizeToFit];
    
    CGRect btnFrame = backBtn.frame;
    btnFrame.size.height = 30.0f;
    backBtn.frame = btnFrame;
    
    return backBtn;
    
}

+ (UIButton *)createStandardButtonWithTitle:(NSString *)title addTarget:(id)target action:(SEL)action{

    UIButton *standardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [standardBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageNamed:@"btn_edit"];
    UIImage *imageHighlited= [UIImage imageNamed:@"btn_edit_pressed.png"];
    imageHighlited = [imageHighlited stretchableImageWithLeftCapWidth: 5 topCapHeight: 5];
    image = [image stretchableImageWithLeftCapWidth: 5 topCapHeight: 5];
    [standardBtn setBackgroundImage:image forState:UIControlStateNormal];
    [standardBtn setBackgroundImage:imageHighlited forState:UIControlStateHighlighted];
    [standardBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [standardBtn setTitle: title forState:UIControlStateNormal];
	[standardBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [standardBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	CGSize stringSize = [title sizeWithFont:[UIFont boldSystemFontOfSize:12.0f]]; 
    [standardBtn setFrame:CGRectMake(0,0,stringSize.width + 20, 30)];
    
    return standardBtn;
    
}

+ (UIButton *)createRedButtonWithTitle:(NSString *)title addTarget:(id)target action:(SEL)action{
    
    UIButton *standardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [standardBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageNamed:@"LogoutButton"];
    image = [image stretchableImageWithLeftCapWidth: 5 topCapHeight: 5];
    [standardBtn setBackgroundImage:image forState:UIControlStateNormal]; 
    [standardBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [standardBtn setTitle: title forState:UIControlStateNormal];
	[standardBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [standardBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	CGSize stringSize = [title sizeWithFont:[UIFont boldSystemFontOfSize:12.0f]]; 
    [standardBtn setFrame:CGRectMake(0,0,stringSize.width + 20, 30)];
    
    return standardBtn;
    
}

+ (UIButton *)createGreenButtonWithTitle:(NSString *)title addTarget:(id)target action:(SEL)action{
    
    UIButton *standardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [standardBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageNamed:@"createBackground"];
    image = [image stretchableImageWithLeftCapWidth: 5 topCapHeight: 5];
    [standardBtn setBackgroundImage:image forState:UIControlStateNormal]; 
    [standardBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [standardBtn setTitle: title forState:UIControlStateNormal];
	[standardBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [standardBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	CGSize stringSize = [title sizeWithFont:[UIFont boldSystemFontOfSize:12.0f]]; 
    [standardBtn setFrame:CGRectMake(0,0,stringSize.width + 20, 30)];
    
    return standardBtn;
    
}



@end
