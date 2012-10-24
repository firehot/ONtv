
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

    UIImage *ontvLogoImage  = [UIImage imageNamed:@"HeaderTitleBackground"];
    [self setImage:ontvLogoImage];    
    [self setUserInteractionEnabled:YES];
    
} 


- (void)createUIForHomeHeader {
    
    self.headerTitleLbl =[UIControls createUILabelWithFrame:CGRectMake(10, 0, 150, 49) FondSize:16 FontName:@"System Bold" FontHexColor:@"117890" LabelText:@""];
    [self addSubview:self.headerTitleLbl];
    
}
 
- (void)createUIForListHeader {
    UIImageView *ChannelLogoBGIV = [UIControls createUIImageViewWithFrame:CGRectMake(0, 0, 320, 90)];
    ChannelLogoBGIV.backgroundColor=[UIColor whiteColor];
    // UIImage *ChannelLogoBGImage  = [UIImage imageNamed:@"imageBackground"];
    //[ChannelLogoBGIV setImage:ChannelLogoBGImage];
    [ChannelLogoBGIV setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:ChannelLogoBGIV];
    
    
    UIImageView *backgrounfImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_title.png"]];
    [backgrounfImage setFrame:(CGRectMake(0, 0, 320, 45))];
    [self addSubview:backgrounfImage];
    
   
    
    
    UIImageView *tempEGOIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigChannelLogo"]];		
    self.channelLogoIV  = tempEGOIV;
    self.channelLogoIV.frame = CGRectMake(17,48, 90, 34);
    self.channelLogoIV.contentMode = UIViewContentModeScaleAspectFit;
    [ChannelLogoBGIV addSubview:self.channelLogoIV];
    
    
    [self createPageControlScrollViewWithFrame:CGRectMake(100, 0, 80, 49)];
    
    [self createPageControlWithFrame:CGRectMake(0, 0, 80, 49)];
    
    [self createPageControlLabelWithFrame:CGRectMake(103, 30, 80, 20)];
    
    
    [self CreateDateUIView];
}


- (void)createUIForCategoryHeader {
    
   
    
    UIImageView *backgrounfImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_title.png"]];
    [backgrounfImage setFrame:(CGRectMake(0, 0, 320, 45))];
    [self addSubview:backgrounfImage];
    
    UIImageView *ChannelLogoBGIV = [UIControls createUIImageViewWithFrame:CGRectMake(5, 5, 38, 37)];
    UIImage *ChannelLogoBGImage  = [UIImage imageNamed:@"CategoryBackGround"];
    [ChannelLogoBGIV setImage:ChannelLogoBGImage];
    [ChannelLogoBGIV setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:ChannelLogoBGIV];    
    
    
     UIImageView *tempEGOIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigChannelLogo"]];
    self.channelLogoIV = tempEGOIV;
    self.channelLogoIV.frame = CGRectMake(10, 10, 20, 20);	
    [ChannelLogoBGIV addSubview:self.channelLogoIV];
    
    
    [self createPageControlScrollViewWithFrame:CGRectMake(65, 0, 100, 49)];

    [self createPageControlWithFrame:CGRectMake(0, 0, 100, 49)];
    
    [self createPageControlLabelWithFrame:CGRectMake(68, 30, 100, 20)];
    
    [self CreateDateUIView];
    
}


- (void)createUIForPlanHeader {
    
    self.headerTitleLbl =[UIControls createUILabelWithFrame:CGRectMake(10, 0, 150, 49) FondSize:16 FontName:@"System Bold" FontHexColor:@"117890" LabelText:@""];
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
    
    
    self.headerTitleShowLbl =[UIControls createUILabelWithFrame:CGRectMake(self.bounds.size.width-130, 0, 48, 49) FondSize:13 FontName:@"System Bold" FontHexColor:@"858585" LabelText:@""];
    
    self.headerTitleShowLbl.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;

    [self addSubview:self.headerTitleShowLbl];

    self.headerTitleShowsValueLbl =[UIControls createUILabelWithFrame:CGRectMake(self.bounds.size.width-85, 0, 60, 49) FondSize:13 FontName:@"System Bold" FontHexColor:@"117890" LabelText:@""];
    [self.headerTitleShowsValueLbl setTextAlignment:UITextAlignmentCenter];
    
    self.headerTitleShowsValueLbl.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;

    [self addSubview:self.headerTitleShowsValueLbl];
    
    self.dateButton = [UIControls createUIButtonWithFrame:CGRectMake(self.bounds.size.width-90, 0, 150, 49)];
    
    self.dateButton.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;

    UIImage *dateImage  = [UIImage imageNamed:@"HeaderArrowButton"];
    [self.dateButton setImage:dateImage forState:UIControlStateNormal];
    [self addSubview:self.dateButton];

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
