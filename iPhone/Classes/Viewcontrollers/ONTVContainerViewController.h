//
//  ONTVContainerViewController.h
//  OnTV
//
//  Created by Romain Briche on 6/19/12.
//  Copyright (c) 2012 Springfeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ONTVContainerViewController : UIViewController
@property (nonatomic, readonly, strong) UINavigationController *ontvNavigationController;

- (id)initWithRootViewController:(UIViewController*)viewController;

@end
