


#import <UIKit/UIKit.h>
#import "GADBannerView.h"


@interface UIControls : UIView 

+ (UILabel*)createUILabelWithFrame:(CGRect)frame FondSize:(CGFloat)fSize FontName:(NSString*)fName FontHexColor:(NSString*)fColor LabelText:(NSString*)text;

+ (UIView*)createUIViewWithFrame:(CGRect)frame BackGroundColor:(NSString*)bgcolor;

+ (UIImageView*)createUIImageViewWithFrame:(CGRect)frame;

+ (UIButton*)createUIButtonWithFrame:(CGRect)frame;

+ (UIScrollView*)createScrollViewWithFrame:(CGRect)frame;

+ (UITextView*)createUITextViewWithFrame:(CGRect)frame FondSize:(CGFloat)fsize FontName:(NSString*)fName FontHexColor:(NSString*)fColor;
                                                            
+ (UITextField*)createUITextFieldWithFrame:(CGRect)frame FondSize:(CGFloat)fsize FontName:(NSString*)fName FontHexColor:(NSString*)fColor;

+ (GADBannerView*)showAdMOBAdsOnView:(id)delgatingObj;

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSString*)pathString;

+ (void)registerRefreshScreenNotificationsFor:(id)object;


@end