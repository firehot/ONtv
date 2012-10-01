

#import <UIKit/UIKit.h>
#import "ChannelProxy.h"
#import "MBProgressHUD.h"
#import "Channel.h"
#import "ProUserRequiredScreen.h"
#import "ONTVUIViewController.h"

@interface AddChannelsViewController : ONTVUIViewController<UITableViewDelegate,UITableViewDataSource,ChannelProxyDelegate,UISearchBarDelegate> {
    
	__weak UITableView *channelsTableView;
	
    NSMutableArray *channelArray;
	
    NSMutableArray *addChannelsArray;
	
    __weak UISearchBar *searchBarForChannels;
	
    NSMutableArray *channelNamesArray;
	
    NSMutableArray *searchArray;
	
    NSMutableArray *displayArray;
	
    __weak MBProgressHUD *progressHUD;
    
    BOOL noRecordFound;

}

@property (nonatomic, weak) UITableView *channelsTableView;

@property (nonatomic, strong) NSMutableArray *channelArray;

@property (nonatomic, strong) NSMutableArray *addChannelsArray;

@property (nonatomic, weak) UISearchBar *searchBarForChannels;

@property (nonatomic, strong) NSMutableArray *searchArray;

@property (nonatomic, strong) NSMutableArray *channelNamesArray;

@property (nonatomic, strong) NSMutableArray *displayArray;

@property (nonatomic, weak) MBProgressHUD *progressHUD;

@property (nonatomic, strong) ChannelProxy *channelProxy;


- (void)callChannelListAPI;

- (BOOL)elementToBeDeletedAlreadyPresent:(Channel *) objChannel;

- (void)removeChannelElement:(int)channelId;

- (void)addButtonOnNavigationBar;

@end
