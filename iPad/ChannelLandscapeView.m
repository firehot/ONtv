//
//  ChannelLandscapeView.m
//  OnTV
//
//  Created by Andreas Hirszhorn on 26/7/12.
//  Copyright (c) 2012 Touch Logic I/S. All rights reserved.
//

#import "ChannelLandscapeView.h"
#import "Program.h"
#import "ProgramLandscapeView.h"
#import "FavoriteChannelsIPadViewController.h"

@implementation ChannelLandscapeView


- (id)initWithFrame:(CGRect)frame channel:(Channel*)channel tag:(int)tag andSizeOfHours:(int)sizeOfHours{
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = tag;
        
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 1.0;
                
        [self addProgramSubviews:sizeOfHours andChannel:channel];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)]];
    }
    return self;
}

// Drawing the programs in the channel-view. The programs should be arranged by time in the "channel.programs" array on the channel, 
// and should consist of all the programs that needs to be shown on the view. 
// E.g. if the view shows from monday 05:00 -> tuesday 05:00, 
// the channel.programs array should contain all programs in this time interval in order by time.
- (void)addProgramSubviews:(int)sizeOfHours andChannel:(Channel*)channel{
    int x = 0;       
        
    for (Program *p in channel.programs) {
        int size = [p lengthOfProgramInMins] * (sizeOfHours/60);
        
        CGRect rect = CGRectMake(x, 0, size, self.frame.size.height);
        x += size;
        ProgramLandscapeView *pView = [[ProgramLandscapeView alloc] initWithFrame:rect program:p];
        pView.tag = self.tag;
        [self addSubview:pView];
    }
}

#pragma mark - 
#pragma mark Touch event methods

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {   
    [[self viewController] userDidSelectChannelWithTag:self.tag];
}


- (FavoriteChannelsIPadViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[FavoriteChannelsIPadViewController class]]) {
            return (FavoriteChannelsIPadViewController*)nextResponder;
        }
    }
    return nil;
}

@end
