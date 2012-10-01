//
//  iPadFavoriteChannelPortraitView.h
//  OnTV
//
//  Created by Andreas Hirszhorn on 30/7/12.
//  Copyright (c) 2012 Touch Logic I/S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iPadFavoriteChannelPortraitView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *channels;

- (id)initWithFrame:(CGRect)frame;

- (void) updateViewWithChannels:(NSArray*)channels;

@end
