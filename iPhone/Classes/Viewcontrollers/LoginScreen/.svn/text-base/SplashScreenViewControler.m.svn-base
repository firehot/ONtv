

#import "SplashScreenViewControler.h"

@implementation SplashScreenViewControler

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView{
    [super loadView];
    
    UIImageView *splashScreenIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [splashScreenIV setImage:[UIImage imageNamed:@"loginBackground"]];
    [self.view addSubview:splashScreenIV];
    
    UIImage *logo = [UIImage imageNamed:@"loginLogo"];
    UIImageView *splashScreenLogo = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - logo.size.width)*.5f, (self.view.bounds.size.height - logo.size.height)*.5f, logo.size.width, logo.size.height)];
    [splashScreenLogo setImage:logo];
    splashScreenLogo.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:splashScreenLogo];
}

@end
