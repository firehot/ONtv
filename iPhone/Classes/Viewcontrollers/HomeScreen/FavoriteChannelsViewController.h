
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


@interface FavoriteChannelsViewController : ONTVUIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,ChannelProxyDelegate,ProgramProxyDelegate,MenuBarDelegate, LoginProxyDelegate> {
	
    __weak UITableView *favoriteChannelsTableView;
	NSMutableArray *favoriteChannelArray;
	NSMutableArray *displayChannelArray;
    
	AddChannelsViewController *addChannelsViewController;
	__weak UISearchBar *searchBarForChannels;
	NSMutableArray *channelNamesArray;
	int searchFlag;
	
	FavoriteChannel *newfavoriteChannel;

	Channel *searchedChannel;
	int channelIndex;
    NSString *startDateString;
    NSString *endDateString;
    BOOL isDoneButtonClicked;
    BOOL isAddButtonTapped;
    BOOL isEditButtonClicked;
    BOOL isReorder;
    
    BOOL noRecordFound;
    
}

@property (nonatomic, weak) UITableView *favoriteChannelsTableView;

@property (nonatomic, strong) NSMutableArray *favoriteChannelArray;

@property (nonatomic, strong) NSMutableArray *displayChannelArray;

@property (nonatomic, strong) AddChannelsViewController *addChannelsViewController;

@property (nonatomic, weak) UISearchBar *searchBarForChannels;

@property (nonatomic, strong) NSMutableArray *channelNamesArray;

@property (nonatomic, assign) int channelIndex;

@property (nonatomic, copy) NSString *startDateString;

@property (nonatomic, copy) NSString *endDateString;

@property (nonatomic, weak) MenuBar *menuBarView;

@property (nonatomic, strong) NSMutableArray *allChannelsArray;

@property (nonatomic, strong) NSMutableArray *dicKeys;

@property (nonatomic, strong) NSMutableDictionary *searchDictionary;

@property (nonatomic, strong) ProgramProxy *programProxy;

@property (nonatomic, strong) ChannelProxy *channelProxy;

@property (nonatomic, strong) LoginProxy *loginProxy;

@property (nonatomic, weak) CategoryView *categoryView;


- (void) callFavoriteChannelProxy;

- (void) getListofFavoriteChannels;

- (void) configureFavoriteChannelView;

- (void)showSelectedMenu;

- (void)createMenuBar;

- (void)refreshChannelsIds;






- (void)createTableView;

- (void)getListofFavoriteChannels;

- (void)addEditButton;

- (void)addAddChannelButton;

- (void)addSearchBar;

- (void)createMenuBar;

- (void)callChannelProxyForReordering;

- (void)setLocalizedValues;

- (void)showProUserRequiredScreen;

- (void)showProgramListControllerWithProgramsForChannel:(int)cIndex;

- (BOOL)removeViews:(MenuBarButton)selectedMenu;

- (void)addSubViews:(MenuBarButton)buttonType;

- (void)showSummaryViewForProgram:(NSString*)progID andChannels:(Channel*)chan forPush:(BOOL)push;

- (void)changeRightBarButtonItemStatus;

- (void)showRecommendationView:(CGRect)frame;

- (void)showCategoryView:(CGRect)frame; 

- (void)showUserView:(CGRect)frame;

- (void)showPlanView:(CGRect)frame;


- (void)fetchAllChannels;

- (void)reorderChannelsLocally;

- (void)deleteChannelsLocally:(int)index;

- (void)showPushedProgramInSummaryScreen;

- (void)createChannelProxy;

- (void)createLoginProxy;

- (void)createProgramProxy;



-(void) editButtonTapped : (UIButton *) sender;
-(void) addButtonTapped : (UIButton *) sender;
-(void) saveButtonTapped : (UIButton *) sender;

@end
