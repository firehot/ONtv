

#import "CustomScrollView.h"

@implementation CustomScrollView

@synthesize customScrollViewDelegate = _customScrollViewDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
    }
    
    return self;
}





#pragma Mark -
#pragma Mark Touch Delegate Method

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
    if (self.customScrollViewDelegate && [self.customScrollViewDelegate respondsToSelector:@selector(backGroundTapped)]) {
        
        [self.customScrollViewDelegate backGroundTapped];
    }
    
}




@end
