

#import "MenuBar.h"

@interface MenuBar ()

- (void)createUI;


@end


@implementation MenuBar

@synthesize menuBarDelegate = _menuBarDelegate;

#pragma mark -
#pragma mark - Life Cycle Methods


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        @autoreleasepool {
        
            [self createUI];        
        
        }

    }
    return self;
}




#pragma mark -
#pragma mark - Create UI

- (void)createUI {
    

    _favoriteButton = [UIControls createUIButtonWithFrame:CGRectMake(0, 0, 45-5, 50-6)];
    //[_favoriteButton setFrame:CGRectMake(0, 0, 45-5, 50-6)];
    [_favoriteButton setImage:[UIImage imageNamed:@"tv"] forState:UIControlStateNormal];
    [_favoriteButton addTarget:self action:@selector(menuBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_favoriteButton setTag:Favorite]; 
    [self addSubview:_favoriteButton];
    
    _categoryButton = [UIControls createUIButtonWithFrame:CGRectMake(45-5, 0, 46-5, 50-6)];
    //[_categoryButton setFrame:CGRectMake(45-5, 0, 46-5, 50-6)];
    [_categoryButton setTag:Categories]; 
    [_categoryButton setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
    [_categoryButton addTarget:self action:@selector(menuBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
     [_categoryButton setTag:Categories]; 
    [self addSubview:_categoryButton];
    
    
    _recommendationButton = [UIControls createUIButtonWithFrame:CGRectMake(45+46-10, 0, 46-5, 50-6)];
    //[_recommendationButton setFrame:CGRectMake(45+46-10, 0, 46-5, 50-6)];
    [_recommendationButton setImage:[UIImage imageNamed:@"thumb"] forState:UIControlStateNormal];
    [_recommendationButton addTarget:self action:@selector(menuBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_recommendationButton setTag:Recommendation];
    [self addSubview:_recommendationButton];
    

    _planButton = [UIControls createUIButtonWithFrame:CGRectMake(45+(2*46)-15, 0, 46-5, 50-6)];
   // [_planButton setFrame:CGRectMake(45+(2*46)-15, 0, 46-5, 50-6)];
    [_planButton  setImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
    [_planButton addTarget:self action:@selector(menuBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_planButton setTag:Plan]; 
    [self addSubview:_planButton];
    
    
    _usersButton = [UIControls createUIButtonWithFrame:CGRectMake(45+(3*46)-20, 0, 46-5, 50-6)];
    //[_usersButton setFrame:CGRectMake(45+(3*46)-20, 0, 46-5, 50-6)];
    [_usersButton addTarget:self action:@selector(menuBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_usersButton setImage:[UIImage imageNamed:@"user"] forState:UIControlStateNormal];
    [_usersButton setTag:Users]; 
    [self addSubview:_usersButton];
    

}

#pragma mark -
#pragma mark -  Munu Bar Button Events Handling 


- (void)menuBarButtonClicked:(UIButton*)sender {
    
    [self highLightcurrentSelectedButton:sender.tag];

    
    if (self.menuBarDelegate && [self.menuBarDelegate respondsToSelector:@selector(menubarButtonClicked:)]) 
    {
        
        [self.menuBarDelegate menubarButtonClicked:sender.tag];
        
    }
    
}
 
- (void)highLightcurrentSelectedButton:(MenuBarButton)type {
    
    
    switch (type) {
            
        case Favorite: {
            
            
            [_favoriteButton setImage:[UIImage imageNamed:@"tvHighlighted"] forState:UIControlStateNormal];
            
            [_categoryButton setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
            
            [_recommendationButton setImage:[UIImage imageNamed:@"thumb"] forState:UIControlStateNormal];
            
            
            [_planButton setImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
            
            
            [_usersButton setImage:[UIImage imageNamed:@"user"] forState:UIControlStateNormal];
            
            
        }
            
            break;
            
        case Categories: {
            
            
            [_favoriteButton setImage:[UIImage imageNamed:@"tv"] forState:UIControlStateNormal];
            
            [_categoryButton setImage:[UIImage imageNamed:@"paginationHighlighted"] forState:UIControlStateNormal];
            
            [_recommendationButton setImage:[UIImage imageNamed:@"thumb"] forState:UIControlStateNormal];
            
            
            [_planButton setImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
            
            
            [_usersButton setImage:[UIImage imageNamed:@"user"] forState:UIControlStateNormal];
            
        }
            
            break;
            
        case Recommendation: {
            
            
            [_favoriteButton setImage:[UIImage imageNamed:@"tv"] forState:UIControlStateNormal];
            
            [_categoryButton setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
            
            [_recommendationButton setImage:[UIImage imageNamed:@"thumbHighlighted"] forState:UIControlStateNormal];
            
            
            [_planButton setImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
            
            
            [_usersButton setImage:[UIImage imageNamed:@"user"] forState:UIControlStateNormal];
            
        }
            
            break;
            
        case Plan: {
            
            
            [_favoriteButton setImage:[UIImage imageNamed:@"tv"] forState:UIControlStateNormal];
            
            [_categoryButton setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
            
            [_recommendationButton setImage:[UIImage imageNamed:@"thumb"] forState:UIControlStateNormal];
            
            
            [_planButton setImage:[UIImage imageNamed:@"calendarHighlighted"] forState:UIControlStateNormal];
            
            
            [_usersButton setImage:[UIImage imageNamed:@"user"] forState:UIControlStateNormal];
            
        }
            break;
            
        case Users: {
            
            
            [_favoriteButton setImage:[UIImage imageNamed:@"tv"] forState:UIControlStateNormal];
            
            [_categoryButton setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
            
            [_recommendationButton setImage:[UIImage imageNamed:@"thumb"] forState:UIControlStateNormal];
            
            
            [_planButton setImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
            
            
            [_usersButton setImage:[UIImage imageNamed:@"userHighlighted"] forState:UIControlStateNormal];
            
            
        }
            
            break;
            
        default:
            break;
    }
    
    
    
}


@end
