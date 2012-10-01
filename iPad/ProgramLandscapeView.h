//
//  ProgramLandscapeView.h
//  OnTV
//
//  Created by Andreas Hirszhorn on 26/7/12.
//  Copyright (c) 2012 Touch Logic I/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Program.h"

@interface ProgramLandscapeView : UIView

@property (nonatomic, strong) Program *program;

- (id)initWithFrame:(CGRect)frame program:(Program*)program;

@end
