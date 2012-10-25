

#import "CustomCellForChannel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CustomCellForChannel ()
- (void)createProgramTimeWithFrame:(CGRect)frame;
- (void)createProgramTitleLabelWithFrame:(CGRect)frame;
- (void)createProgramTeaserTextViewWithFrame:(CGRect)frame;
- (void)createCategoryImageView:(BOOL)rightAligned;
- (void)createAccessoryImageViewWithFrame:(CGRect)frame;
- (void)createProgramImageView;
- (void)createChannelImageViewWithFrame:(CGRect)frame;
- (void)createCellBackGround;
- (void)createSelectedCellBackGroundWithFrame:(CGRect)frame;
- (void)createLogoBackGroundImageViewWithFrame:(CGRect)frame andImage:(NSString*)imageName;
- (void)createprogramProLabel1WithFrame:(CGRect)frame;
- (void)createprogramProLabel3WithFrame:(CGRect)frame;


@end

@implementation CustomCellForChannel

@synthesize channelLabel;
@synthesize program1Label;
@synthesize program2Label;
@synthesize program3Label;
@synthesize time1Label;
@synthesize time2Label;
@synthesize time3Label;
@synthesize logoImageView;
@synthesize logoBackgroundImageView;


@synthesize categoryImageView = _categoryImageView;
@synthesize programTitleLabel = _programTitleLabel;
@synthesize programTimeLabel = _programTimeLabel;
@synthesize programTeaserLabel = _programTeaserLabel;
@synthesize programImageView = _programImageView;
@synthesize channelImageView = _channelImageView;
@synthesize logoBGImageView = _logoBGImageView;
@synthesize accessoryImageView = _accessoryImageView;
@synthesize programProLabel1 = _programProLabel1;
@synthesize programProLabel3 = _programProLabel3;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andTableType:(NSString*)tableType {
    
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        // ABP
        self.autoresizingMask=(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight); 
    
            
                if ([tableType isEqualToString:@"PROGRAMTV"]) {
                    
                    
                    @autoreleasepool {
                    
                        [self createSelectedCellBackGroundWithFrame:self.contentView.bounds];
                  
                        [self createProgramTimeWithFrame:CGRectMake(10, 10, 50, 30)];
                        
                        [self createProgramTitleLabelWithFrame:CGRectMake(50, 10, 180, 30)];
                        
                        [self createCategoryImageView:YES];
                        
                        UIImageView  *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.bounds.size.width-17, 20, 8, 11)];
                        accessoryView.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
                        
                        [self.contentView addSubview:accessoryView];
                        [accessoryView setImage:[UIImage imageNamed:@"ic_arrow_right"]];
                    
                    }
                    
                } else if ([tableType isEqualToString:@"PROGRAMTVPRO"]) {
                    
                    @autoreleasepool {

                        [self createSelectedCellBackGroundWithFrame:self.contentView.bounds];
                   
                        [self createProgramTimeWithFrame:CGRectMake(10, 10, 50, 30)];
                  
                        [self createProgramTitleLabelWithFrame:CGRectMake(50, 10, 180, 30)];
                                            
                        [self createprogramProLabel1WithFrame:CGRectMake(10, 40, 300, 30)];

                        [self createProgramTeaserTextViewWithFrame:CGRectMake(10, 40+30, 190, 75)];

                        [self createprogramProLabel3WithFrame:CGRectMake(10, 40+30+75, 300, 30)];
                        
                        [self createCategoryImageView:YES];
                   
                        UIImageView  *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.bounds.size.width-17, 20, 8, 11)];
                        accessoryView.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
                        
                        [self.contentView addSubview:accessoryView];
                        [accessoryView setImage:[UIImage imageNamed:@"ic_arrow_right"]];
                   
                        [self createProgramImageView];
                    
                    }

                    
                }  else if ([tableType isEqualToString:@"RECOMMENDEDPROGRAMTV"]) {
                    
                    
                    @autoreleasepool {
                    
                        [self createSelectedCellBackGroundWithFrame:self.contentView.bounds];
                        
                        [self createProgramTimeWithFrame:CGRectMake(10, 10, 50, 30)];
                        
                        [self createProgramTitleLabelWithFrame:CGRectMake(50, 10, 150, 30)];
                        
                        [self createChannelImageViewWithFrame:CGRectMake(self.bounds.size.width - 80, 15, 45, 20)];
                        
                        [self createCategoryImageView:YES];
                        
                        [self createAccessoryImageViewWithFrame:CGRectMake(self.contentView.bounds.size.width-17, 20, 8, 11)];
                    
                    }
                    
                } else if ([tableType isEqualToString:@"RECOMMENDEDPROGRAMTVPRO"]) {
                    
                    @autoreleasepool {
                    
                        [self createSelectedCellBackGroundWithFrame:self.contentView.bounds];
                        
                        [self createProgramTimeWithFrame:CGRectMake(10, 10, 50, 30)];
                        
                        [self createProgramTitleLabelWithFrame:CGRectMake(50, 10, 150, 30)];
                        
                        [self createChannelImageViewWithFrame:CGRectMake(self.bounds.size.width - 80, 15, 45, 20)];
                        
                        [self createprogramProLabel1WithFrame:CGRectMake(10, 40, 300, 30)];
                        
                        [self createProgramTeaserTextViewWithFrame:CGRectMake(10, 40+30, 190, 75)];
                        
                        [self createprogramProLabel3WithFrame:CGRectMake(10, 40+30+75, 300, 30)];                    
                  
                        [self createCategoryImageView:YES];
                        
                        [self createAccessoryImageViewWithFrame:CGRectMake(self.contentView.bounds.size.width-17, 20, 8, 11)];
                        
                        [self createProgramImageView];
                      
                    
                    }
                    
                    
                } else if ([tableType isEqualToString:@"CATEGORY"]) {
                    
                    @autoreleasepool {
                    
                        [self createCellBackGround];
                   
                        [self createSelectedCellBackGroundWithFrame:self.contentView.bounds];
                        
                       // [self createLogoBackGroundImageViewWithFrame:CGRectMake(10, 7, 38, 37) andImage:@"CategoryBackGround"];
                        
                        [self createProgramTitleLabelWithFrame:CGRectMake(55, 10, 150, 25)];
                        
                        [self createCategoryImageView:NO];
                        
                        [self createAccessoryImageViewWithFrame:CGRectMake(self.contentView.bounds.size.width-17, 20, 8, 11)];
                    
                    
                    }
                    
                    
                }  else if ([tableType isEqualToString:@"PLAN"]) {
                    
                    @autoreleasepool {
                    
                        [self createSelectedCellBackGroundWithFrame:self.contentView.bounds];
                        
                        [self createProgramTimeWithFrame:CGRectMake(10, 10, 50, 30)];
                        
                        [self createProgramTitleLabelWithFrame:CGRectMake(50, 10, 150, 30)];
                        
                        [self createChannelImageViewWithFrame:CGRectMake(self.bounds.size.width - 75, 15, 45, 20)];
                        
                        [self createProgramTeaserTextViewWithFrame:CGRectMake(11, 27, 200, 20)];
                        
                        [self createAccessoryImageViewWithFrame:CGRectMake(self.contentView.bounds.size.width-17, 20, 8, 11)];
                    
                    
                    }
                    
                    
                } else if ([tableType isEqualToString:@"PLANDETAILS"]) {
                    
                    @autoreleasepool {
                    
                        [self createSelectedCellBackGroundWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, 38)];
                        
                        [self createProgramTimeWithFrame:CGRectMake(10, 4, 150, 30)];
                        
                        [self createProgramTitleLabelWithFrame:CGRectMake(155, 4, 150, 30)];
                        
                        [self createAccessoryImageViewWithFrame:CGRectMake(self.contentView.bounds.size.width-35, 14, 8, 11)];
                
                    }
                    
                } else if ([tableType isEqualToString:@"CUSTOMLIST"]) {
                    
                    @autoreleasepool {
                    
                        [self createProgramTitleLabelWithFrame:CGRectMake(30, 4, 200, 30)];
                        
                        [self createAccessoryImageViewWithFrame:CGRectMake(self.contentView.bounds.size.width-35, 12, 13, 13)];
                        
                        [self.accessoryImageView setImage:[UIImage imageNamed:@"CheckedMark"]];
                    
                    }                    
                }
        
                else {
                    
                    self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
                
                    UIImageView *logoBackgroundImageViewTemp = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 84, 40)];
                    self.logoBackgroundImageView = logoBackgroundImageViewTemp;
                    //self.logoBackgroundImageView.image = [UIImage imageNamed:@"imageBackground.png"];
                    [self.contentView addSubview:self.logoBackgroundImageView];
                    
                    UIImageView  *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.bounds.size.width-17, 20, 8, 11)];
                    accessoryView.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
                    
                    [self.contentView addSubview:accessoryView];
                    [accessoryView setImage:[UIImage imageNamed:@"ic_arrow_right"]];
                    
                    
                    UIImageView *logoImageViewTemp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigChannelLogo"]];	
                    self.logoImageView = logoImageViewTemp;
                    self.logoImageView.frame = CGRectMake(16+10, 11+5, 50, 20);	
                    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
                    [self.contentView addSubview:self.logoImageView];
                    
                    
                    UIImageView *categoryImageViewTemp = [[UIImageView alloc] 
                                                           initWithImage:[UIImage imageNamed:@"bigChannelLogo"]]; 
                    self.categoryImageView = categoryImageViewTemp;
                    [self.contentView addSubview:self.categoryImageView];

                    
                }
            
           
        
    }    
    
    return self;
    
}

- (void)prepareForReuse
{
    [searchLogoImageView cancelCurrentImageLoad];
    [self.logoImageView cancelCurrentImageLoad];
    [self.programImageView cancelCurrentImageLoad];
    [self.channelImageView cancelCurrentImageLoad];
    [self.categoryImageView cancelCurrentImageLoad];
    [super prepareForReuse];
}




- (void)createCellBackGround {
    self.backgroundView = [[UIView alloc] initWithFrame:self.contentView.bounds];
      
    [self.backgroundView setBackgroundColor:[UIUtils colorFromHexColor:@"F5F5F5"]];
      
   
}


- (void)createSelectedCellBackGroundWithFrame:(CGRect)frame {

    self.selectedBackgroundView = [[UIView alloc] initWithFrame:frame];
    [self.selectedBackgroundView setBackgroundColor:[UIUtils colorFromHexColor:@"FFFFFF"]];
}

- (void)createProgramTimeWithFrame:(CGRect)frame {
    
    self.programTimeLabel = [UIControls createUILabelWithFrame:frame FondSize:14 FontName:@"System Bold" FontHexColor:@"000000" LabelText:@""];
    [self.contentView addSubview:self.programTimeLabel];
}

- (void)createProgramTitleLabelWithFrame:(CGRect)frame {

    self.programTitleLabel = [UIControls createUILabelWithFrame:frame FondSize:14 FontName:@"System Bold" FontHexColor:@"000000" LabelText:@""];
    self.programTitleLabel.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:self.programTitleLabel];  

}

- (void)createProgramTeaserTextViewWithFrame:(CGRect)frame {

    self.programTeaserLabel = [UIControls createUILabelWithFrame:frame FondSize:12 FontName:HELVETICA FontHexColor:GRAY LabelText:@""]; 
    [self.programTeaserLabel setTextAlignment:UITextAlignmentLeft];
    [self.contentView addSubview:self.programTeaserLabel];
    
} 



- (void)createprogramProLabel1WithFrame:(CGRect)frame {
    
    self.programProLabel1 = [UIControls createUILabelWithFrame:frame FondSize:12 FontName:HELVETICA FontHexColor:GRAY LabelText:@""]; 
    [self.programProLabel1 setTextAlignment:UITextAlignmentLeft];
    [self.contentView addSubview:self.programProLabel1];
    
} 


- (void)createprogramProLabel3WithFrame:(CGRect)frame {
    
    self.programProLabel3 = [UIControls createUILabelWithFrame:frame FondSize:12 FontName:HELVETICA FontHexColor:GRAY LabelText:@""]; 
    [self.programProLabel3 setTextAlignment:UITextAlignmentLeft];
    [self.contentView addSubview:self.programProLabel3];
} 



- (void)createProgramImageView {
    
    UIImageView *programImageViewTemp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigChannelLogo"]];
    self.programImageView = programImageViewTemp;
    self.programImageView.frame = CGRectMake(210, 53+10, 100, 75);	
    self.programImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.programImageView.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
    
    [self.contentView addSubview:self.programImageView];
    
}


- (void)createChannelImageViewWithFrame:(CGRect)frame {
    
   UIImageView *channelImageViewTemp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigChannelLogo"]];
	self.channelImageView = channelImageViewTemp;
    self.channelImageView.frame = frame;	
    self.channelImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.channelImageView.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
    
    [self.contentView addSubview:self.channelImageView];
    
}


- (void)createLogoBackGroundImageViewWithFrame:(CGRect)frame andImage:(NSString*)imageName {
    
    self.logoBGImageView = [UIControls createUIImageViewWithFrame:frame];
    [self.logoBGImageView setImage:[UIImage imageNamed:imageName]];
    [self.contentView addSubview:self.logoBGImageView];
}


- (void)createCategoryImageView:(BOOL)rightAligned {
    
    
    
    
    UIImageView *categoryImageViewTemp =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigChannelLogo"]];  
    self.categoryImageView = categoryImageViewTemp;
    self.categoryImageView.autoresizingMask= rightAligned ? UIViewAutoresizingFlexibleLeftMargin : UIViewAutoresizingFlexibleRightMargin;
    self.categoryImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    [self.contentView addSubview:self.categoryImageView];
}

- (void)createAccessoryImageViewWithFrame:(CGRect)frame {
    
    self.accessoryImageView =[UIControls createUIImageViewWithFrame:frame];                    
    [self.accessoryImageView setImage:[UIImage imageNamed:@"ic_arrow_right"]];
    
    self.accessoryImageView.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
    
    [self.contentView addSubview:self.accessoryImageView];
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void) addChannelNameLabel {
	UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 12, 140, 40)];
	nameLabel.textColor = [UIColor grayColor];
	nameLabel.font = [UIFont boldSystemFontOfSize:12.0f];
	nameLabel.textColor = [UIUtils colorFromHexColor:@"000000"];//[UIUtils colorFromHexColor:@"486b9a"]; // 36b6d5
	nameLabel.backgroundColor = [UIColor clearColor];
	self.channelLabel = nameLabel;
	[self.contentView addSubview:self.channelLabel];
}

- (void) addProgram1Label {
        
	UILabel *programLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 5, self.contentView.bounds.size.width-150-24, 20)];//30	
    
    programLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    programLabel.font = [UIFont boldSystemFontOfSize:13.0f];

	programLabel.textColor = [UIUtils colorFromHexColor:@"000000"];
	programLabel.backgroundColor = [UIColor clearColor];
    programLabel.highlightedTextColor = [UIColor whiteColor];
	self.program1Label = programLabel;
	[self.contentView addSubview:self.program1Label];
}

- (void) addTime1Label {
	UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 5, 90, 20)];
	timeLabel.font = [UIFont boldSystemFontOfSize:13.0f];
	timeLabel.textColor = [UIUtils colorFromHexColor:@"000000"];
	timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.highlightedTextColor = [UIColor whiteColor];
	self.time1Label = timeLabel;
	[self.contentView addSubview:self.time1Label];
}
- (void) addProgram2Label {
	UILabel *programLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 20, self.contentView.bounds.size.width-150-24, 20)];//55
	//programLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    
    programLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    programLabel.font = [UIFont systemFontOfSize:13];
	programLabel.textColor = [UIColor grayColor];
	programLabel.backgroundColor = [UIColor clearColor];
    programLabel.highlightedTextColor = [UIColor whiteColor];
	self.program2Label = programLabel;
	[self.contentView addSubview:self.program2Label];
}
- (void) addTime2Label {
	UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 20, 90, 20)];
	//timeLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    timeLabel.font = [UIFont systemFontOfSize:13];
	timeLabel.textColor = [UIColor grayColor];
	timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.highlightedTextColor = [UIColor whiteColor];
	self.time2Label = timeLabel;
	[self.contentView addSubview:self.time2Label];
}

- (void)setPhoto:(NSString*)channelPhoto {
	[logoImageView setImageWithURL:[NSURL URLWithString:channelPhoto] placeholderImage:[UIImage imageNamed:@"bigChannelLogo"]];
}

#pragma mark -
#pragma mark Search Labels


- (void) addProgramForSearchLabel {
	UILabel *programLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 200, 20)];	
	programLabel.font = [UIFont boldSystemFontOfSize:12.0f];
	programLabel.textColor = [UIUtils colorFromHexColor:@"117890"];
	programLabel.backgroundColor = [UIColor clearColor];
	self.program3Label = programLabel;
	[self.contentView addSubview:self.program3Label];
}
- (void) addTimeForSearchLabel {
	UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 90, 20)];
	timeLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
	timeLabel.textColor = [UIUtils colorFromHexColor:@"117890"];
	timeLabel.backgroundColor = [UIColor clearColor];
	self.time3Label = timeLabel;
	[self.contentView addSubview:self.time3Label];
}

- (void)setSearchPhoto:(NSString*)channelPhoto {
     searchLogoImageView = [NSURL URLWithString:channelPhoto];
}




@end
