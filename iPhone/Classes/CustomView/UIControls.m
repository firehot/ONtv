

#import "UIControls.h"
#import "UIDevice+IdentifierAddition.h"
#import <sys/xattr.h>

@implementation UIControls

static GADBannerView *bannerView = nil;
    

+ (UILabel*)createUILabelWithFrame:(CGRect)frame FondSize:(CGFloat)fSize FontName:(NSString*)fName FontHexColor:(NSString*)fColor LabelText:(NSString*)text 
{
    
    UILabel *label = [[UILabel alloc]initWithFrame:frame];	
    
    if ([fName isEqualToString:@"System Bold"]) {
        
        [label setFont:[UIFont boldSystemFontOfSize:fSize]];
        
    } else {
        
         [label setFont:[UIFont fontWithName:fName size:fSize]];
    }

    [label setTextColor:[UIUtils colorFromHexColor:fColor]];
    [label setHighlightedTextColor:[UIUtils colorFromHexColor:@"ffffff"]];
    [label setText:text];
	[label setBackgroundColor:[UIColor clearColor]];
    
    return label;
}



+ (UIView*)createUIViewWithFrame:(CGRect)frame BackGroundColor:(NSString*)bgcolor 
{
    
    UIView *view = [[UIView alloc]initWithFrame:frame];	
	[view setBackgroundColor:[UIUtils colorFromHexColor:bgcolor]];
    return view;
}


+ (UIImageView*)createUIImageViewWithFrame:(CGRect)frame {
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];	
	[imageView setUserInteractionEnabled:YES];
    
    return imageView;
}


+ (UIButton*)createUIButtonWithFrame:(CGRect)frame {
    
    UIButton *button = [[UIButton alloc]initWithFrame:frame];	
    return button;
}


+ (UIScrollView*)createScrollViewWithFrame:(CGRect)frame {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [scrollView setBounces:NO];
    [scrollView setUserInteractionEnabled:NO];
    
    
    return scrollView;
}


+ (UITextView*)createUITextViewWithFrame:(CGRect)frame FondSize:(CGFloat)fsize FontName:(NSString*)fName FontHexColor:(NSString*)fColor {
    

    UITextView *textView = [[UITextView alloc] initWithFrame:frame];
    [textView setTextAlignment:UITextAlignmentLeft];
    [textView setFont:[UIFont fontWithName:fName size:fsize]];
    [textView setTextColor:[UIUtils colorFromHexColor:fColor]];
    [textView setEditable:NO];
    [textView setContentMode:UIViewContentModeTop];
    [textView setScrollEnabled:NO];
    
    
    return  textView;

}   


+ (UITextField*)createUITextFieldWithFrame:(CGRect)frame FondSize:(CGFloat)fsize FontName:(NSString*)fName FontHexColor:(NSString*)fColor {
    
    
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    [textField setTextAlignment:UITextAlignmentLeft];
    [textField setBorderStyle:UITextBorderStyleRoundedRect]; 
    [textField setFont:[UIFont fontWithName:fName size:fsize]];
    [textField setTextColor:[UIUtils colorFromHexColor:fColor]];
    
    [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [textField setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [textField setTextAlignment:UITextAlignmentLeft];

    return  textField;
    
} 


+ (GADBannerView*)showAdMOBAdsOnView:(id)delgatingObj {
    
    @synchronized(bannerView) {
        
        
        CGSize viewSize = [delgatingObj isKindOfClass:[UIViewController class]] ? ((UIViewController*)delgatingObj).view.bounds.size : CGSizeZero;
        
        if (bannerView == nil ) {
            
            bannerView = [[GADBannerView alloc]
                          initWithFrame:CGRectZero];
            
            bannerView.adUnitID = MY_BANNER_UNIT_ID;
            
            GADRequest *request = [GADRequest request];    
            
            /*
             NSString  *deviceUDID  =[[UIDevice currentDevice] uniqueDeviceIdentifier];
             request.testDevices = [NSArray arrayWithObjects:
             GAD_SIMULATOR_ID,                               // Simulator
             deviceUDID,                              // Test iOS Device
             nil];
             */
                        
            bannerView.rootViewController = delgatingObj;

            [bannerView loadRequest:request]; 

        } else {
            
            
            
            bannerView.rootViewController = delgatingObj;


            bannerView.adUnitID = MY_BANNER_UNIT_ID;
        
            GADRequest *request = [GADRequest request];    

            /*
            NSString  *deviceUDID  =[[UIDevice currentDevice] uniqueDeviceIdentifier];
            request.testDevices = [NSArray arrayWithObjects:
                                   GAD_SIMULATOR_ID,                               // Simulator
                                   deviceUDID,                              // Test iOS Device
                                   nil];
            
            */

            [bannerView loadRequest:request]; 

        }  
        
        
        [bannerView setTag:1234567890];
        
       // [bannerView setBackgroundColor:[UIColor brownColor]];
        
        
        CGSize bannerSize = CGSizeMake(viewSize.width, 50.0f);
        [bannerView setFrame:CGRectMake(0.0f, viewSize.height-bannerSize.height, bannerSize.width, bannerSize.height)];
        
        bannerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;

        return bannerView;
    } 
}


+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSString*)pathString
{
    const char* filePath = [pathString fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}



+ (void)registerRefreshScreenNotificationsFor:(id)object {
    
    
    [[NSNotificationCenter defaultCenter] addObserver:object
                                             selector:@selector(refreshScreen)
                                                 name:@"REFRESH_SCREEN"
                                               object:nil];
}





@end
