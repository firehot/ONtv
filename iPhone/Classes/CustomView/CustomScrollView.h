
#import <UIKit/UIKit.h>
@protocol CustomScrollViewDelegate;

@interface CustomScrollView : UIScrollView




@property (nonatomic, weak) id<CustomScrollViewDelegate> customScrollViewDelegate;

@end


@protocol CustomScrollViewDelegate <NSObject>

- (void)backGroundTapped;

@end