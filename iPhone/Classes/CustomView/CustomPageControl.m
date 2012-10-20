

#import "CustomPageControl.h"

@implementation CustomPageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        inactiveImage  = [UIImage imageNamed:@"ic_pagination_dot"];
        activeImage = [UIImage imageNamed:@"ic_pagination_dot_active.png"];
    }
    return self;
}

-(void)updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        if (i == self.currentPage) dot.image = activeImage;
        else dot.image = inactiveImage;
    }
}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}



@end
