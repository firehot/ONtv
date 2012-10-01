

#import <UIKit/UIKit.h>
#import "MenuBarEnums.h"

@protocol MenuBarDelegate;

@interface MenuBar : UIView {

    
    __weak UIButton *_favoriteButton;
    __weak UIButton *_recommendationButton;
    __weak UIButton *_categoryButton;
    __weak UIButton *_planButton;
    __weak UIButton *_usersButton;
}

@property (nonatomic, weak) id<MenuBarDelegate> menuBarDelegate;

- (void)highLightcurrentSelectedButton:(MenuBarButton)type;

@end

@protocol MenuBarDelegate <NSObject>

- (void)menubarButtonClicked:(MenuBarButton)buttonType;

@end