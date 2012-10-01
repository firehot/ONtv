

#import <UIKit/UIKit.h>
#import "MenuBarEnums.h"
#import "CustomPageControl.h"
#import "SegmentedControl.h"

@protocol HeaderViewDelegate;

@interface HeaderView : UIImageView 


@property (nonatomic, weak) UILabel *headerTitleLbl;
@property (nonatomic, weak) UILabel *headerTitleShowLbl;
@property (nonatomic, weak) UILabel *headerTitleShowsValueLbl;
@property (nonatomic, weak) UIButton *dateButton;
@property (nonatomic, weak) UIImageView *channelLogoIV;
@property (nonatomic, weak) UIScrollView *pageControlScrollView;
@property (nonatomic, weak) CustomPageControl *pageControl;
@property (nonatomic, weak) UILabel *pageControlPagesLbl;
@property (nonatomic, weak) SegmentedControl *segmentedControl;
@property (nonatomic, weak) id<HeaderViewDelegate> headerViewDelegate;

- (id)initWithFrame:(CGRect)frame andType:(MenuBarButton)type;

@end

@protocol HeaderViewDelegate <NSObject>

@optional 

- (void)segmentedButtonClicked:(int)segmentedIndex;


@end
