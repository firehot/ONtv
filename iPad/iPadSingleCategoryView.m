//
//  iPadSingleCategoryView.m
//  OnTV
//
//  Created by Andreas Hirszhorn on 31/7/12.
//  Copyright (c) 2012 Touch Logic I/S. All rights reserved.
//

#import "iPadSingleCategoryView.h"
#import "Program.h"
#import "ChannelCategory.h"

@interface iPadSingleCategoryView ()

- (void)addHeaderView :(NSString*)header;
- (void)createLogoImageView;
- (void)createAccessoryImageViewWithFrame:(CGRect)frame;

@end

@implementation iPadSingleCategoryView
@synthesize headerView=_headerView;
@synthesize headerLbl=_headerLbl;
@synthesize accessoryImageView=_accessoryImageView;
@synthesize logoImageView=_logoImageView;
@synthesize logoBackgroundImageView=_logoBackgroundImageView;
@synthesize category=_category;

- (id)initWithFrame:(CGRect)frame andCategory:(CategoryDataModel*)category{
    self = [super initWithFrame:frame];
    if (self) {
        self.category = category;
        
        [self addHeaderView:category.categoryTitle];
        

        //TODO: Add the correct first program in the list here, and it should make the cell correctly except for the text...
        
//        [self createBodyWithProgram:nil];        
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
    }
    return self;
}

int CAT_HEADER_HEIGHT = 60;

#pragma mark - 
#pragma mark Category Header View

- (void) addHeaderView :(NSString*)header {   
    int lbl_width = 200;    
    
    UIView *h = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, CAT_HEADER_HEIGHT)];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CAT_HEADER_HEIGHT-1, self.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];  
    [h addSubview:lineView];
    
	UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(h.bounds.size.width-lbl_width-20, 19, lbl_width, 20)];
	nameLabel.font = [UIFont boldSystemFontOfSize:14];
	nameLabel.textColor = [UIUtils colorFromHexColor:@"117890"];
	nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = UITextAlignmentRight;
    nameLabel.text = header;   
	self.headerLbl = nameLabel;
    [h addSubview:self.headerLbl];
    
    [self createAccessoryImageViewWithFrame:CGRectMake(self.bounds.size.width-17, 25, 8, 11)];
    [self createLogoImageView];
    
    [h addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapOnHeader:)]];
    
    self.headerView = h;
	[self addSubview:self.headerView];
}

- (void)createLogoImageView{
    //Adding the logo background image
    UIImageView *logoBackgroundImageViewTemp = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    self.logoBackgroundImageView = logoBackgroundImageViewTemp;
    //self.logoBackgroundImageView.image = [UIImage imageNamed:@"imageBackground.png"];
    [self addSubview:self.logoBackgroundImageView];
    
    NSString *imageName = [ChannelCategory getChannelCatgegoryType:self.category.categoryType];
    UIImage *image = [UIImage imageNamed:imageName];
    
    //Adding the channel logo
    UIImageView *logoImageViewTemp = [[UIImageView alloc] initWithImage:image];	
    logoImageViewTemp.frame = CGRectMake(15, 15, 30, 30); //CGRectMake(16+10, 11+5, 50, 20);	
    logoImageViewTemp.contentMode = UIViewContentModeScaleAspectFit;
    self.logoImageView = logoImageViewTemp;    
    
    [self addSubview:self.logoImageView];
}


#pragma mark - 
#pragma mark Category Body View

- (void) createBodyWithProgram:(Program*)program{
    UIView *bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, CAT_HEADER_HEIGHT, self.frame.size.width, self.frame.size.height-CAT_HEADER_HEIGHT)];    
    
    [self createProgramTimeText:program.start onView:bodyView];
    [self createProgramTitleLabelWithText:program.title onView:bodyView];
    [self createTimebarOnView:bodyView withProgram:program];
    
    
    //TODO: add label, picture, logo and arrow
    [self createCategoryImageViewOnView:bodyView];
    [self createAccessoryImageViewWithFrame:CGRectMake(self.bounds.size.width-17, 20, 8, 11)];
}


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
    [timebarFG setBackgroundColor:[UIColor grayColor]];    
    
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


- (void)createCategoryImageViewOnView:(UIView*)view{
    UIImageView *categoryImageViewTemp =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigChannelLogo"]];  
    categoryImageViewTemp.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    categoryImageViewTemp.contentMode = UIViewContentModeScaleAspectFit;
    
    [view addSubview:categoryImageViewTemp];
}


#pragma mark - 
#pragma mark Helper View Methods

- (void)createAccessoryImageViewWithFrame:(CGRect)frame{
    self.accessoryImageView =[UIControls createUIImageViewWithFrame:frame];                    
    [self.accessoryImageView setImage:[UIImage imageNamed:@"ic_arrow_right"]];
    self.accessoryImageView.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
    [self addSubview:self.accessoryImageView];
}

#pragma mark - 
#pragma mark Touch event methods

- (void)handleSingleTapOnHeader:(UITapGestureRecognizer *)recognizer {    
    NSLog(@"Header pressed");
}


//- (FavoriteChannelsIPadViewController*)viewController {
//    for (UIView* next = [self superview]; next; next = next.superview) {
//        UIResponder* nextResponder = [next nextResponder];
//        if ([nextResponder isKindOfClass:[FavoriteChannelsIPadViewController class]]) {
//            return (FavoriteChannelsIPadViewController*)nextResponder;
//        }
//    }
//    return nil;
//}


@end
