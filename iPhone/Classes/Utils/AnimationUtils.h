

#import <Foundation/Foundation.h>

@interface AnimationUtils : NSObject

+ (void)pushViewFromRight:(UIViewController*)coming over:(UIViewController*)going;
+ (void)pushViewFromLeft:(UIViewController*)coming over:(UIViewController*)going;

@end
