
#import <UIKit/UIKit.h>
#import "DeviceProxy.h"
#import "LoginProxy.h"

@interface UserView : UIView <UITableViewDataSource, UITableViewDelegate,DeviceProxyDelegate, LoginProxyDelegate> {
        
    __weak UITableView *_userTableView; 
 
    __weak UISwitch *summarySwitch;
}

@property (nonatomic, strong) NSMutableArray *deviceIdArray;

@property (nonatomic, strong) LoginProxy *loginProxy;

@property (nonatomic, strong) DeviceProxy *deviceProxy;

@end
