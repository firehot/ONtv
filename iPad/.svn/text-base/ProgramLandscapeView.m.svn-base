//
//  ProgramLandscapeView.m
//  OnTV
//
//  Created by Andreas Hirszhorn on 26/7/12.
//  Copyright (c) 2012 Touch Logic I/S. All rights reserved.
//

#import "ProgramLandscapeView.h"
#import "FavoriteChannelsIPadViewController.h"
#import "UIControls.h"


@implementation ProgramLandscapeView
@synthesize program=_program;

- (id)initWithFrame:(CGRect)frame program:(Program*)program{
    self = [super initWithFrame:frame];
    if (self) {
        self.program = program;
        
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 1.0;
        
        self.backgroundColor = [UIColor whiteColor];
            
        UILabel* time = [UIControls createUILabelWithFrame:CGRectMake(10, 0, frame.size.width-10, frame.size.height) FondSize:14 
                                                  FontName:HELVETICA FontHexColor:GRAY LabelText:program.title];
        [self addSubview:time];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)]];
    }
    return self;
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
