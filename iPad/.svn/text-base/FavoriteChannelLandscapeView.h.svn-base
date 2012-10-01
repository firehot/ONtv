//
//  FavoriteChannelLandscapeView.h
//  OnTV
//
//  Created by Andreas Hirszhorn on 25/7/12.
//  Copyright (c) 2012 Touch Logic I/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Channel.h"

@interface FavoriteChannelLandscapeView : UIView <UIScrollViewDelegate>

@property (nonatomic, copy) NSArray *channels;
@property (nonatomic, strong) UIScrollView *programScrollView;
@property (nonatomic, strong) UIScrollView *timeScrollView;
@property (nonatomic, strong) UIScrollView *channelScrollView;
@property (nonatomic, strong) UIView *lineView;
//@property (nonatomic, weak) UIView *lineView2;


- (id)initWithFrame:(CGRect)frame andChannels:(NSArray*)channels;
- (void) updateScrollViewsWithFrame:(CGRect)frame andChannels:(NSArray*)channels;

@end
