

#import "SplashScreenViewControler.h"

@implementation SplashScreenViewControler

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView{
    [super loadView];
    
    UIImageView *splashScreenIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [splashScreenIV setImage:[UIImage imageNamed:@"bg_splash"]];
    [self.view addSubview:splashScreenIV];
    
}

@end
