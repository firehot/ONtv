

#import <UIKit/UIKit.h>
#import "Channel.h"
#import "HeaderView.h"
#import "ProUserRequiredScreen.h"
#import "ProgramProxy.h"
#import "CustomListViewController.h"


@interface RecommendationView : UIView <UIScrollViewDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,ProgramProxyDelegate, CustomListViewControllerDelegate> {
    
    __weak HeaderView *_RecommendationHeaderView;
    
    __weak UITableView *_recommendationProgramTableView;
    
    BOOL  noRecordFound;

}

@property (nonatomic, strong) NSMutableArray *channelArray;

@property (nonatomic, strong) NSMutableArray *programArray;

@property (nonatomic, strong) ProgramProxy *programProxy;

- (void)createUI;

- (void)channelArray:(NSMutableArray *)cArray;

@end
