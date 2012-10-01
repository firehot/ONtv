
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#ifndef kAnimationKey
#define kAnimationKey @"transitionViewAnimation"
#endif 

@interface UIUtils : NSObject {

}

+(void)alertView:(NSString *)message withTitle:(NSString *)title;
+(void)alertView:(NSString *)message withTitle:(NSString *)title andDelegate:(id)target andTag:(int)tagValue;
+ (UIColor *) colorFromHexColor: (NSString *) hexColor;
+ (UIImage *)scaleImage:(UIImage *) image maxWidth:(float) maxWidth maxHeight:(float) maxHeight;
+(UIImage *) scaleAndCropImage:(UIImage*) image maxWidth:(float)toWidth maxHeight:(float)toHeight;
+ (CATransition *) getSwipeAnimationWithDirection:(NSString *) direction withDuration:(float) time;
+(NSDate *)dateFromUTCString:(NSString*)dateString;
+ (NSString *)stringFromGivenDate:(NSDate *)givenDate;
+ (NSString *)stringFromGivenDate:(NSDate *)givenDate withLocale:(NSString*)localeIdentifier;
+ (NSString *)stringFromGivenDate:(NSDate *)givenDate withLocale:(NSString*)localeIdentifier andFormat:(NSString*)format;
+ (NSString *)endTimeFromGivenDate:(NSDate *)givenDate;
+(NSString *)localTimeStringForGMTDateString:(NSString *)gmtDateString;

+ (NSString *)dateStringWithFormat:(NSDate *)givenDate format:(NSString*)format;
+(NSString *)localDayStringForGMTDateString:(NSString *)gmtDateString;
+ (NSString *)startTimeFromGivenDate:(NSDate *)givenDate;

+ (NSDate *)dateFromGivenGMTString:(NSString *)givenDate  WithFormat:(NSString*)format;
+ (NSString *)stringFromGivenGMTDate:(NSDate *)givenDate  WithFormat:(NSString*)format;

+ (UIButton *)createBackButtonWithTarget:(id)target action:(SEL)action;
+ (UIButton *)createStandardButtonWithTitle:(NSString *)title addTarget:(id)target action:(SEL)action;
+ (UIButton *)createRedButtonWithTitle:(NSString *)title addTarget:(id)target action:(SEL)action;
+ (UIButton *)createGreenButtonWithTitle:(NSString *)title addTarget:(id)target action:(SEL)action;

@end
