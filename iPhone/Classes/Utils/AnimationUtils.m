
#import "AnimationUtils.h"

@implementation AnimationUtils

+ (void)pushViewFromRight:(UIViewController*)coming over:(UIViewController*)going {
    
	CGRect frameComing = coming.view.frame;
	CGRect frameGoing = going.view.frame;
	int width = going.view.frame.size.width;
	frameComing.origin.x = width;
	coming.view.frame = frameComing;	
	[UIView beginAnimations:@"frame" context:nil];
	[UIView setAnimationDuration:0.35];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];    
	frameComing.origin.x = 0;
	coming.view.frame = frameComing;
	frameGoing.origin.x = -width;
	going.view.frame = frameGoing;
	[going viewDidDisappear:YES];
	[coming viewDidAppear:YES];
	[UIView commitAnimations];
	
}

+ (void)pushViewFromLeft:(UIViewController*)coming over:(UIViewController*)going {
    
	CGRect frameComing = coming.view.frame;
	CGRect frameGoing = going.view.frame;
	int width = coming.view.frame.size.width;
	frameComing.origin.x = -width;
	coming.view.frame = frameComing;	
	[UIView beginAnimations:@"frame" context:nil];
	[UIView setAnimationDuration:0.35];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	frameComing.origin.x = 0;
	coming.view.frame = frameComing;
	frameGoing.origin.x = width;
	going.view.frame = frameGoing;
	[going viewDidDisappear:YES];
	[coming viewDidAppear:YES];	
	[UIView commitAnimations];
	
}


@end
