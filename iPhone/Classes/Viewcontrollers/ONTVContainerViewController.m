//
//  ONTVContainerViewController.m
//  OnTV
//
//  Created by Romain Briche on 6/19/12.
//  Copyright (c) 2012 Springfeed. All rights reserved.
//

#import "ONTVContainerViewController.h"

#define kONTVContainerViewControllerAdsAnimationDuration 0.3f



//static void * kAppDelegateUserObservationContext = &kAppDelegateUserObservationContext;

@interface ONTVContainerViewController ()
@property (nonatomic, readwrite, strong) UINavigationController *ontvNavigationController;
@property (nonatomic, readonly, assign) BOOL containmentAPISupported;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) GADBannerView *adsView;
@property (nonatomic, readonly, weak) AppDelegate_iPhone *appDelegate;

- (void)hideAds:(BOOL)hidden animated:(BOOL)animated;
- (BOOL)shouldDisplayAds;
- (BOOL)shouldRemoveAds;

@end

@implementation ONTVContainerViewController
@synthesize ontvNavigationController = _ontvNavigationController;
@synthesize containerView = _containerView;
@synthesize adsView = _adsView;

- (void)dealloc
{
    _containerView = nil;
    _adsView = nil;
}

/*- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context 
{
    if (context == kAppDelegateUserObservationContext) {
        
        if ([self shouldDisplayAds]) {
            [self hideAds:NO animated:YES];
            
        } else if ([self shouldRemoveAds]) {
            [self hideAds:YES animated:YES];
            
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}*/


- (id)initWithRootViewController:(UIViewController*)viewController
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        [self.ontvNavigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:NO];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // content view
    UIView *containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    containerView.clipsToBounds = YES;
    containerView.autoresizesSubviews = YES;

  
    
    [self.view addSubview:containerView];
    self.containerView = containerView;
     containerView = nil;
    
    // ads
    if ([self shouldDisplayAds]) {
        [self hideAds:NO animated:NO];
    }
    
    // navigation controller
    if (self.containmentAPISupported) [self addChildViewController:self.ontvNavigationController];
    
    self.ontvNavigationController.view.frame = self.containerView.bounds;
    [self.containerView addSubview:self.ontvNavigationController.view];
    
    if (self.containmentAPISupported) [self.ontvNavigationController didMoveToParentViewController:self];
    
    
    /*[self.appDelegate addObserver:self 
                       forKeyPath:NSStringFromSelector(@selector(user)) 
                          options:NSKeyValueObservingOptionNew 
                          context:kAppDelegateUserObservationContext];*/
}

- (void)viewDidUnload
{
    if (self.containmentAPISupported) {
        [self.ontvNavigationController willMoveToParentViewController:nil];
        [self.ontvNavigationController removeFromParentViewController];
    } else {
        [self.ontvNavigationController.view removeFromSuperview];
        self.ontvNavigationController.view = nil;
    }
    
    //[self.appDelegate removeObserver:self forKeyPath:NSStringFromSelector(@selector(user)) context:kAppDelegateUserObservationContext];
    
    self.containerView = nil;
    self.adsView = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.containmentAPISupported) {
        [self.ontvNavigationController viewWillAppear:animated];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.containmentAPISupported) {
        [self.ontvNavigationController viewDidAppear:animated];
    }
}



- (void)viewWillDisappear:(BOOL)animated 
{
    [super viewWillDisappear:animated];
    
    if (!self.containmentAPISupported) {
        [self.ontvNavigationController viewWillDisappear:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated 
{
    [super viewDidDisappear:animated];
    
    if (!self.containmentAPISupported) {
        [self.ontvNavigationController viewDidDisappear:animated];
    }
}

- (BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return [self.ontvNavigationController.visibleViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration 
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if (!self.containmentAPISupported) {
        [self.ontvNavigationController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if (!self.containmentAPISupported) {
        [self.ontvNavigationController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation 
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    if (!self.containmentAPISupported) {
        [self.ontvNavigationController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    }
}


#pragma mark - Private

- (BOOL)containmentAPISupported
{
    // containment API is supported on iOS 5 and up
    static BOOL containmentAPISupported;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        containmentAPISupported = ([self respondsToSelector:@selector(addChildViewController:)] &&
                                   [self respondsToSelector:@selector(removeFromParentViewController)] &&
                                   [self respondsToSelector:@selector(willMoveToParentViewController:)] &&
                                   [self respondsToSelector:@selector(didMoveToParentViewController:)] && 
                                   [self respondsToSelector:@selector(transitionFromViewController:toViewController:duration:options:animations:completion:)]);
    });
    
    return containmentAPISupported;
}


- (AppDelegate_iPhone *)appDelegate
{
    return DELEGATE;
}


- (BOOL)shouldDisplayAds
{
    return !self.adsView && (!self.appDelegate.user || (![self.appDelegate.user.subscription isEqualToString:PRO_USER] && ![self.appDelegate.user.subscription isEqualToString:PLUS_USER]));
}

- (BOOL)shouldRemoveAds
{
    return self.adsView && self.appDelegate.user && ([self.appDelegate.user.subscription isEqualToString:PRO_USER] || [self.appDelegate.user.subscription isEqualToString:PLUS_USER]);
}

- (UINavigationController *)ontvNavigationController
{
    if (_ontvNavigationController) return _ontvNavigationController;
    
    _ontvNavigationController = [[UINavigationController alloc] initWithNibName:nil bundle:nil];
    _ontvNavigationController.navigationBar.autoresizesSubviews=YES;
    
    return _ontvNavigationController;
}

- (void)hideAds:(BOOL)hidden animated:(BOOL)animated
{    
    if (!hidden && !self.adsView) {
        
        GADBannerView *adsView = [UIControls showAdMOBAdsOnView:self];
        [self.view addSubview:adsView];
        self.adsView = adsView;
        
        void (^layoutBlock)(void) = ^{
            
            CGRect frame = self.containerView.frame;
            frame.size.height = CGRectGetHeight(self.view.bounds)-CGRectGetHeight(self.adsView.frame);
            self.containerView.frame = frame;
            
            frame = self.adsView.frame;
            frame.origin.y = CGRectGetMaxY(self.containerView.frame);
            self.adsView.frame = frame;
        };
        
        
        if (animated) {
                        
            CGRect frame = self.adsView.frame;
            frame.origin.y = CGRectGetMaxY(self.containerView.frame);
            self.adsView.frame = frame;
            
            [UIView animateWithDuration:kONTVContainerViewControllerAdsAnimationDuration 
                                  delay:0.0f 
                                options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseOut
                             animations:layoutBlock 
                             completion:nil];
            
        } else {
            layoutBlock();
        }
        
    } else if (hidden && self.adsView) {
        
        
        void (^layoutBlock)(void) = ^{
            
            self.containerView.frame = self.view.bounds;
            
            CGRect frame = self.adsView.frame;
            frame.origin.y = CGRectGetMaxY(self.containerView.frame);
            self.adsView.frame = frame;
        };
        
        
        void (^completionBlock)(BOOL finished) = ^(BOOL finished){
            
            [self.adsView removeFromSuperview];
            self.adsView = nil;
        };
        
        
        if (animated) {
                        
            [UIView animateWithDuration:kONTVContainerViewControllerAdsAnimationDuration 
                                  delay:0.0f 
                                options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseOut
                             animations:layoutBlock 
                             completion:completionBlock];
            
        } else {
            layoutBlock();
            completionBlock(YES);
        }
        
    }
}

@end
