//
//  SegmentedControl.m
//  OnTV
//
//  Created by Romain Briche on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SegmentedControl.h"

@interface SegmentedControl ()
- (void)setupStandardImages;
@end



@implementation SegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupStandardImages];
    }
    return self;
}

- (id)initWithItems:(NSArray *)items
{
    self = [super initWithItems:items];
    if (self) {
        [self setupStandardImages];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        [self setupStandardImages];
    }
    return self;
}


#pragma mark - Private

- (void)setupStandardImages
{
    self.normalImageLeft = [UIImage imageNamed:@"btn_double_selector_grey_left"];
    self.normalImageMiddle = nil;
    self.normalImageRight= [UIImage imageNamed:@"btn_double_selector_grey_right"];
    self.selectedImageLeft = [UIImage imageNamed:@"btn_double_selector_red_left"];
    self.selectedImageMiddle = nil;
    self.selectedImageRight = [UIImage imageNamed:@"btn_double_selector_red_right"];
}

@end
