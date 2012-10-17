//
//  iPadProgramView.m
//  OnTV
//
//  Created by Andreas Hirszhorn on 25/7/12.
//  Copyright (c) 2012 Touch Logic I/S. All rights reserved.
//

#import "iPadProgramView.h"

#import "ChannelCategory.h"
#import "FavoriteChannelsIPadViewController.h"

@implementation iPadProgramView
@synthesize categoryImageView=_categoryImageView;
@synthesize program=_program;
@synthesize channel=_channel;

- (id)initWithFrame:(CGRect)frame timeline:(bool)timeline program:(Program*)program andTag:(NSInteger)tag{
    self = [super initWithFrame:frame];
    if (self) {        
        self.tag = tag;
        self.program = program;
        
        NSString *time = @"";
        NSString *text = @"";
        
        if (!program) {
            //        time = NSLocalizedString(@"Channel.no.transmission.1", nil);
            text = NSLocalizedString(@"Channel.no.transmission.1", nil);
        }
        else {
            NSString *startTime = [UIUtils localTimeStringForGMTDateString:program.start];        
            time = startTime;
            text = program.title;        
        }
        
        [self createProgramTimeText:time onView:self];
        [self createProgramTitleLabelWithText:text onView:self];
        if(timeline) [self createTimebarOnView:self withProgram:self.program];
        
        CGRect f = CGRectMake(self.bounds.size.width-17, 20, 8, 11);
        [self createAccessoryImageViewOnView:self withFrame:f]; 
        
        [self createCategoryImageView:YES andType:program.type];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)]];
    }
    return self;
}

#pragma mark - 
#pragma mark Program View

- (void)createProgramTimeText:(NSString*)text onView:(UIView*)view{
    UILabel* time = [UIControls createUILabelWithFrame:CGRectMake(10, 10, 50, 30) FondSize:14 FontName:HELVETICA FontHexColor:GRAY LabelText:text];
    [view addSubview:time];
}

- (void)createProgramTitleLabelWithText:(NSString*)text onView:(UIView*)view{    
    UILabel* title = [UIControls createUILabelWithFrame:CGRectMake(50, 10, view.frame.size.width-100, 30) FondSize:14 FontName:@"System Bold" FontHexColor:@"117890" LabelText:text];
    title.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    title.textAlignment = UITextAlignmentLeft;
    [view addSubview:title];
}

//Creating a time bar on the view
- (void)createTimebarOnView:(UIView*)view withProgram:(Program*)program{
    UILabel *timebarBG = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, view.frame.size.width-20, 10)];
    [timebarBG setBackgroundColor:[UIColor lightGrayColor]];    
    timebarBG.layer.cornerRadius = 5;
    [view addSubview:timebarBG];
    
    double runtimeDone = ([program timeOfProgramSinceNowInMins]+0.0)/[program lengthOfProgramInMins];
    if (runtimeDone > 1) runtimeDone = 1.0;
    
    UILabel *timebarFG = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, (view.frame.size.width-20)*runtimeDone, 10)];
    [timebarFG setBackgroundColor:[UIUtils colorFromHexColor:BLUE]];    

    UIRectCorner roundedCorners = runtimeDone == 1 ? (UIRectCornerAllCorners) : (UIRectCornerTopLeft|UIRectCornerBottomLeft);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:timebarFG.bounds 
                                                   byRoundingCorners:roundedCorners
                                                         cornerRadii:CGSizeMake(5.0, 5.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = timebarFG.bounds;
    maskLayer.path = maskPath.CGPath;
    timebarFG.layer.mask = maskLayer;
    
    [view addSubview:timebarFG];
}

- (void) addBottomLine{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];  
    [self addSubview:lineView];
}

#pragma mark - 
#pragma mark Helper View Methods

- (void)createAccessoryImageViewOnView :(UIView*)view withFrame:(CGRect)frame{
//    self.accessoryImageView = [UIControls createUIImageViewWithFrame:frame];                    
//    [self.accessoryImageView setImage:[UIImage imageNamed:@"CellArrow"]];
//    self.accessoryImageView.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
//    [view addSubview:self.accessoryImageView];

    UIImageView *accessoryImageView = [UIControls createUIImageViewWithFrame:frame];                    
    [accessoryImageView setImage:[UIImage imageNamed:@"ic_arrow_right"]];
    accessoryImageView.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
    [view addSubview:accessoryImageView];
}


//Copied directly from customcellfor... - needs to be fixed. Not optimal nor very pretty...
- (void)createCategoryImageView:(BOOL)rightAligned andType:(NSString*)type{
    UIImageView *categoryImageView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigChannelLogo"]];  
    categoryImageView.autoresizingMask= rightAligned ? UIViewAutoresizingFlexibleLeftMargin : UIViewAutoresizingFlexibleRightMargin;    
    
    NSString *imageName = [ChannelCategory getChannelCatgegoryType:type];
    NSString *imagePath = [[NSBundle mainBundle]pathForResource:imageName ofType:@"png"];
    UIImage *image = [[UIImage alloc]initWithContentsOfFile:imagePath];
    [categoryImageView setFrame:CGRectMake(265, 15, image.size.width, image.size.height)];    
    
    UIImage *categoryImage = [UIImage imageNamed:imageName];
    [categoryImageView setImage:categoryImage];
    
    self.categoryImageView = categoryImageView;
    [self addSubview:self.categoryImageView];
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
