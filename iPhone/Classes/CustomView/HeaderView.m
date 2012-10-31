
#import "HeaderView.h"
#import "UIControls.h"
#import "CustomPageControl.h"

@interface HeaderView ()
  
- (void)createCommonUI;
- (void)createUIForHomeHeader;
- (void)createUIForListHeader;
- (void)createUIForCategoryHeader;
- (void)createUIForPlanHeader;

- (void)createPageControlScrollViewWithFrame:(CGRect)frame;
- (void)createPageControlWithFrame:(CGRect)frame;
- (void)createPageControlLabelWithFrame:(CGRect)frame;
- (void)CreateDateUIView;
- (void)createSegmentedControl;

@end


@implementation HeaderView


@synthesize headerTitleLbl = _headerTitleLbl;
@synthesize headerTitleShowLbl = _headerTitleShowLbl;
@synthesize headerTitleShowsValueLbl = _headerTitleShowsValueLbl;
@synthesize dateButton = _dateButton;
@synthesize channelLogoIV = _channelLogoIV;
@synthesize pageControl = _pageControl;
@synthesize pageControlScrollView = _pageControlScrollView; 
@synthesize pageControlPagesLbl = _pageControlPagesLbl;
@synthesize segmentedControl = _segmentedControl;
@synthesize headerViewDelegate = _headerViewDelegate;

- (id)initWithFrame:(CGRect)frame andType:(MenuBarButton)type 
{
    self = [super initWithFrame:frame];
   
    if (self) {
        
        
        [self createCommonUI];
        
        @autoreleasepool {
        
            if (type == Favorite || type == Recommendation ) {
                
                [self createUIForHomeHeader];
            
            } else if (type == other) {
                
                [self createUIForListHeader];
       
            } else if  (type == Categories) {
                
                [self createUIForCategoryHeader];
            
            } else if (type == Plan) {
                
                [self createUIForPlanHeader];
            }
        
        }
        
    }
    return self;
}





- (void)createCommonUI {

    //UIImage *ontvLogoImage  = [UIImage imageNamed:@"HeaderTitleBackground"];
    UIImageView *back=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_title"]];
    
    [self addSubview:back];
    [self setUserInteractionEnabled:YES];
    
} 


- (void)createUIForHomeHeader {
    
    self.headerTitleLbl =[UIControls createUILabelWithFrame:CGRectMake(10, 0, 150, 49) FondSize:16 FontName:@"System Bold" FontHexColor:@"FFFFFF" LabelText:@""];
    [self addSubview:self.headerTitleLbl];
    
    [self CreateDateUIView];
    
}
 
- (void)createUIForListHeader {
    UIImageView *ChannelLogoBGIV = [UIControls createUIImageViewWithFrame:CGRectMake(0, 0, 320, 90)];
    ChannelLogoBGIV.backgroundColor=[UIColor whiteColor];
    [ChannelLogoBGIV setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:ChannelLogoBGIV];
    
    
    UIImageView *backgrounfImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_title"]];
    [backgrounfImage setFrame:(CGRectMake(0, 0, 320, 45))];
    [self addSubview:backgrounfImage];
       
    
    UIImageView *tempEGOIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigChannelLogo"]];		
    self.channelLogoIV  = tempEGOIV;
    self.channelLogoIV.frame = CGRectMake(17,48, 90, 34);
    self.channelLogoIV.contentMode = UIViewContentModeScaleAspectFit;
    [ChannelLogoBGIV addSubview:self.channelLogoIV];
    
    UIView *divider=[[UIView alloc] initWithFrame:CGRectMake(120, 55, 1, 25)];
    [divider setBackgroundColor:[UIColor grayColor]];
    [self addSubview:divider];
    
    UILabel *tempCategoryName = [[UILabel alloc] initWithFrame:CGRectMake(136, 55, 170, 25)];
    [tempCategoryName setBackgroundColor:[UIColor clearColor]];
    [tempCategoryName setFont:[UIFont boldSystemFontOfSize:14.0f]];
    [tempCategoryName setTextColor:[UIColor blackColor]];
    self.channelNameLabel=tempCategoryName;
    [self addSubview:self.channelNameLabel];
    
    
    UIButton *leftButton=[[UIButton alloc] initWithFrame:CGRectMake(5, 14.5f, 11, 16)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"ic_pagination_arrow_left"] forState:UIControlStateNormal];
    self.leftPagination = leftButton;
    [self addSubview:self.leftPagination];
    
    
    [self createPageControlScrollViewWithFrame:CGRectMake(16, 0, 90, 45)];
    [self createPageControlWithFrame:CGRectMake(16, 0, 90, 45)];
    
    UIButton *rightButton=[[UIButton alloc] initWithFrame:CGRectMake(16+90, 14.5f, 11, 16)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"ic_pagination_arrow_right"] forState:UIControlStateNormal];
    self.rightPagination = rightButton;
    [self addSubview:self.rightPagination];
    
        
    UILabel *showsLabel = [[UILabel alloc] initWithFrame:CGRectMake(90+27+60, 14.5f, 60, 16)];
    [showsLabel setText:@"Shows:"];
    [showsLabel setBackgroundColor:[UIColor clearColor]];
    [showsLabel setTextColor:[UIColor whiteColor]];
    [showsLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [self addSubview:showsLabel];
    
    [self CreateDateUIView];
}


- (void)createUIForCategoryHeader {
    
    UIView *back=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
    [back setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:back];
    
    UIImageView *backgrounfImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_title"]];
    [backgrounfImage setFrame:(CGRectMake(0, 0, 320, 45))];
    [self addSubview:backgrounfImage];
    
     
    UIImageView *tempEGOIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigChannelLogo"]];
    self.channelLogoIV = tempEGOIV;
    self.channelLogoIV.frame = CGRectMake(20, 55, 34.5f, 28.5f);
    [self addSubview:self.channelLogoIV];
    
    UILabel *tempCategoryName = [[UILabel alloc] initWithFrame:CGRectMake(65, 55, 200, 25)];
    [tempCategoryName setBackgroundColor:[UIColor clearColor]];
    [tempCategoryName setFont:[UIFont boldSystemFontOfSize:14.0f]];
    [tempCategoryName setTextColor:[UIColor blackColor]];
    self.categoryNameLabel=tempCategoryName;
    [self addSubview:self.categoryNameLabel];
        
    
    UIButton *leftButton=[[UIButton alloc] initWithFrame:CGRectMake(5, 14.5f, 11, 16)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"ic_pagination_arrow_left"] forState:UIControlStateNormal];
    self.leftPagination = leftButton;
    [self addSubview:self.leftPagination];
    
    
    [self createPageControlScrollViewWithFrame:CGRectMake(16, 0, 90, 45)];
    [self createPageControlWithFrame:CGRectMake(16, 0, 90, 45)];
    
    UIButton *rightButton=[[UIButton alloc] initWithFrame:CGRectMake(16+90, 14.5f, 11, 16)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"ic_pagination_arrow_right"] forState:UIControlStateNormal];
    self.rightPagination = rightButton;
    [self addSubview:self.rightPagination];
    
    UILabel *showsLabel = [[UILabel alloc] initWithFrame:CGRectMake(90+27+60, 14.5f, 60, 16)];
    [showsLabel setText:@"Shows:"];
    [showsLabel setBackgroundColor:[UIColor clearColor]];
    [showsLabel setTextColor:[UIColor whiteColor]];
    [showsLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [self addSubview:showsLabel];

    
    [self CreateDateUIView];
    
}


- (void)createUIForPlanHeader {
    
    self.headerTitleLbl =[UIControls createUILabelWithFrame:CGRectMake(10, 0, 150, 49) FondSize:16 FontName:@"System Bold" FontHexColor:@"FFFFFF" LabelText:@""];
    UIImageView *back=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_title.png"]];
    
    [self addSubview:back];
    [self addSubview:self.headerTitleLbl];

    [self createSegmentedControl];

}

- (void)createPageControlScrollViewWithFrame:(CGRect)frame {
    
    self.pageControlScrollView = [UIControls createScrollViewWithFrame:frame];
    [self.pageControlScrollView setContentSize:CGSizeMake(frame.size.width, 49)];
    [self.pageControlScrollView setBackgroundColor:[UIColor clearColor]];
    [self.pageControlScrollView setUserInteractionEnabled:NO];
    [self addSubview:self.pageControlScrollView];
    
}

- (void)createPageControlWithFrame:(CGRect)frame  {
    
    CustomPageControl *tempPageControl = [[CustomPageControl alloc] init];
    self.pageControl = tempPageControl;
    self.pageControl.frame = frame;
    [self.pageControl setUserInteractionEnabled:NO];
    [self.pageControl setBackgroundColor:[UIColor clearColor]];
    [self.pageControl setClipsToBounds:YES];
    [self.pageControlScrollView addSubview:self.pageControl];
    
}


- (void)createPageControlLabelWithFrame:(CGRect)frame  {

    self.pageControlPagesLbl =[UIControls createUILabelWithFrame: frame FondSize:10 FontName:@"System Bold" FontHexColor:@"000000" LabelText:@""];
    
    [self.pageControlPagesLbl setTextAlignment:UITextAlignmentCenter];
    
    [self addSubview:self.pageControlPagesLbl];    
}

- (void)CreateDateUIView { 
    //Label that shows text "Shows"
    
    //self.headerTitleShowLbl =[UIControls createUILabelWithFrame:CGRectMake(self.bounds.size.width-130, 0, 48, 49) FondSize:13 FontName:@"System Bold" FontHexColor:@"858585" LabelText:@""];
    
   // self.headerTitleShowLbl.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;

   // [self addSubview:self.headerTitleShowLbl];

    self.headerTitleShowsValueLbl =[UIControls createUILabelWithFrame:CGRectMake(self.bounds.size.width-85, 5, 70, 34) FondSize:13 FontName:@"System Bold" FontHexColor:@"FFFFFF" LabelText:@""];
    [self.headerTitleShowsValueLbl setTextAlignment:UITextAlignmentCenter];
    
    self.headerTitleShowsValueLbl.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;

    
    self.dateButton.titleLabel.font=[UIFont fontWithName:@"System Bold" size:13];
    self.dateButton.titleLabel.textColor=[UIColor whiteColor];
    
    self.dateButton = [UIControls createUIButtonWithFrame:CGRectMake(self.bounds.size.width-90, 5, 80, 34)];
    
    self.dateButton.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;

    UIImage *dateImage  = [UIImage imageNamed:@"btn_channels.png"];
    UIImage *dateImagePressed=[UIImage imageNamed:@"btn_channels_pressed.png"];
    [self.dateButton setBackgroundImage:dateImage forState:UIControlStateNormal];
    [self.dateButton setBackgroundImage:dateImagePressed forState:UIControlStateHighlighted];
    [self addSubview:self.dateButton];
    [self addSubview:self.headerTitleShowsValueLbl];

}


- (void)createSegmentedControl {
    
    NSArray *itemArray = [NSArray arrayWithObjects:
                          NSLocalizedString(@"Segment.planned", nil),
                          NSLocalizedString(@"Segment.agents", nil),
                          nil];
    
    SegmentedControl *tempSegmentedControl = [[SegmentedControl alloc] initWithItems:itemArray];
    self.segmentedControl = tempSegmentedControl;
    
    [self.segmentedControl setFrame:CGRectMake(self.bounds.size.width - 10 - 120, 10,120,30)];
    [self.segmentedControl setSelectedSegmentIndex:0];
    //[self.segmentedControl setMomentary:YES];
    
    [self.segmentedControl addTarget:self action:@selector(segmentedControlButtonClicked:) forControlEvents:UIControlEventValueChanged];
    
    self.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    
    [self addSubview:self.segmentedControl];
}

- (void)segmentedControlButtonClicked:(UISegmentedControl*)segmentedControl 
{
    
    if (self.headerViewDelegate && [self.headerViewDelegate respondsToSelector:@selector(segmentedButtonClicked:)]) 
    {
        [self.headerViewDelegate segmentedButtonClicked:segmentedControl.selectedSegmentIndex];
    }
}

@end
