


#import "ONTVUIViewController.h"
#import "LoginProxy.h"
#import "ChannelProxy.h"

@interface CreateNewAccountViewController : ONTVUIViewController <LoginProxyDelegate, ChannelProxyDelegate> 
{
    
    __weak UIButton *backButton;    
    __weak UIButton *createButton;
    
}

@property (nonatomic, strong) NSMutableArray *defaultFavoriteChannelArray;

@property (nonatomic, strong) LoginProxy *loginProxy;

@property (nonatomic, strong) ChannelProxy *channelProxy;

@end
