//
//  iPadFavoriteChannelPortraitView.m
//  OnTV
//
//  Created by Andreas Hirszhorn on 30/7/12.
//  Copyright (c) 2012 Touch Logic I/S. All rights reserved.
//

#import "iPadFavoriteChannelPortraitView.h"
#import "iPadChannelView.h"

@implementation iPadFavoriteChannelPortraitView
@synthesize scrollView=_scrollView;
@synthesize channels=_channels;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {        
        UIScrollView *channelView = [[UIScrollView alloc] initWithFrame:frame];
        channelView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        channelView.backgroundColor = [UIUtils colorFromHexColor:LIGHTBLUE];
        self.scrollView = channelView;
        [self addSubview:self.scrollView];

    }
    return self;
}



- (void) updateViewWithChannels:(NSArray*)channels{    
    self.channels = channels;
    
    int MARGIN_VERTICAL = 20;
    int MARGIN_HORIZONTAL = 40;
    int HEIGHT_OF_CHANNEL = 220;
    
    for (iPadChannelView *sv in [self.scrollView subviews]) {
        [sv removeFromSuperview];
    }
    
    //IPAD SPECIFIC PROGRAMMED WITH CARDCODED WIDTH. CHANGE THIS TO FLEXIBLE IF THE VIEW NEEDS TO BE USED ON IPHONE OR IN LANDSCAPE.
    //BE SURE YOU THINK ABOUT THE SIZE ON CREATION TIME
    int width = (768 - 3*MARGIN_HORIZONTAL)/2; 
    
    for (int i = 0; i < [self.channels count]; i++) {
        Channel *channel = [self.channels objectAtIndex:i];
        CGRect rect = CGRectMake(MARGIN_HORIZONTAL+(width+MARGIN_HORIZONTAL)*(i%2), 
                                 MARGIN_VERTICAL+(HEIGHT_OF_CHANNEL+MARGIN_VERTICAL)*(i/2), 
                                 width, 
                                 HEIGHT_OF_CHANNEL);
        
        iPadChannelView *cView = [[iPadChannelView alloc] initWithFrame:rect andChannel:channel andTag:i];
        [self.scrollView addSubview:cView];
    }
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, ([self.channels count]+1)/2 * (HEIGHT_OF_CHANNEL+MARGIN_VERTICAL) + MARGIN_VERTICAL)];
}

@end
