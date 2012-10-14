

#import <UIKit/UIKit.h>
#import "Channel.h"
#import "HeaderView.h"
#import "ProUserRequiredScreen.h"
#import "ProgramProxy.h"
#import "MenuBar.h"
#import "CustomListViewController.h"

@interface ProgramListViewController : ONTVUIViewController<UIScrollViewDelegate,
    UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,MenuBarDelegate,ProgramProxyDelegate,CustomListViewControllerDelegate, UIGestureRecognizerDelegate> {

        
	int _index;
    int _menuSelected;
        
    BOOL  noRecordFound;
    BOOL tableBusy;
        
    __weak HeaderView *_programHeaderView;
}


@property (nonatomic, strong) NSMutableArray *channelArray;
@property (nonatomic, strong) NSMutableArray *programArray;
@property (nonatomic, strong) NSMutableArray *categoryArray;
@property (nonatomic, strong) ProgramProxy *programProxy;
@property (nonatomic, weak) UITableView *programTableView;

@property (nonatomic, strong) NSString *startDateString;
@property (nonatomic, strong) NSString *endDateString;


-(void) setArray:(NSMutableArray *)array AndCurrentSelectedIndex:(int)currentIndex AndSeletedMenuType:(MenuBarButton)type;

@end
