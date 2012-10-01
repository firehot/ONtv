//
//  iPadProgramView.h
//  OnTV
//
//  Created by Andreas Hirszhorn on 25/7/12.
//  Copyright (c) 2012 Touch Logic I/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Program.h"
#import "Channel.h"

@interface iPadProgramView : UIView

@property (nonatomic, weak) UIImageView *categoryImageView;
@property (nonatomic, weak) Program *program;
@property (nonatomic, weak) Channel *channel;

- (id)initWithFrame:(CGRect)frame timeline:(bool)timeline program:(Program*)program andTag:(NSInteger)tag;

- (void) addBottomLine;

@end
