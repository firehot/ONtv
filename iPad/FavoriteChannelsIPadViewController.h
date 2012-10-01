
//#define LANDSCAPE_MODE_ENABLED 1

#import <UIKit/UIKit.h>
#import "AddChannelsViewController.h"
#import "ChannelProxy.h"
#import "FavoriteChannel.h"
#import "ProgramProxy.h"

#import "ProUserRequiredScreen.h"
#import "MenuBar.h"
#import "LoginProxy.h"
#import "ONTVUIViewController.h"
#import "CategoryView.h"
#ifdef LANDSCAPE_MODE_ENABLED
#import "FavoriteChannelLandscapeView.h"
#endif
#import "iPadFavoriteChannelPortraitView.h"
#import "Program.h"
#import "iPadCategoryView.h"



@interface FavoriteChannelsIPadViewController : FavoriteChannelsViewController
@property (nonatomic, strong) UIScrollView *favoriteChannelsScrollView;
#ifdef LANDSCAPE_MODE_ENABLED
@property (nonatomic, strong) FavoriteChannelLandscapeView *landscapeView;
#endif
@property (nonatomic, strong) iPadFavoriteChannelPortraitView *portraitView;

@property (nonatomic, strong) iPadCategoryView *catView;

- (void) updateIPadChannelView;

-(void) userDidSelectChannelWithTag:(NSInteger)tag;
-(void) userDidSelectChannel:(Channel*)channel withTag:(NSInteger)tag;
-(void) userDidSelectProgram:(Program*)program;
@end




@interface MyUITableView : UITableView
- (id) initWithIPadViewController:(FavoriteChannelsIPadViewController*)owner;

@property (nonatomic, strong) FavoriteChannelsIPadViewController *owner;
@end