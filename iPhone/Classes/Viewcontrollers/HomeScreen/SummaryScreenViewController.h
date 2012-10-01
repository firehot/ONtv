
#import <UIKit/UIKit.h>
#import "ProgramProxy.h"
#import "Program.h"
#import "Channel.h"
#import "MenuBar.h"
#import "PlanView.h"
#import "RecommendProxy.h"

#import <FacebookSDK/FacebookSDK.h>
#import "MBProgressHUD.h"

@interface SummaryScreenViewController : ONTVUIViewController <ProgramProxyDelegate, MenuBarDelegate, RecommendProxyDelegate, UIAlertViewDelegate,MBProgressHUDDelegate> {
    
      
    __weak UIImageView *programImage;
    CGRect programIVFrame;
    __weak UIScrollView *_summaryScrollView;

}
@property (strong, nonatomic) NSMutableDictionary *postParams;
@property (nonatomic, copy) NSString *programId;
@property (nonatomic, strong) Program *program;
@property (nonatomic, strong) Channel *channel;
@property (nonatomic, assign) BOOL fromSearch;
@property (nonatomic, assign) BOOL fromPush;

@property (nonatomic, strong) PlanView *planView;
@property (nonatomic, weak) UIButton *recommendedBtn;


@property (nonatomic, strong) ProgramProxy *programProxy;

@property (nonatomic, strong) RecommendProxy *recommendProxy;
@end
