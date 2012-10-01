

#import <UIKit/UIKit.h>
#import "HeaderView.h"
#import "CustomDatePicker.h"
#import "PlanProxy.h"
#import "PlanDetailViewController.h"
#import "AgentProxy.h"
#import "AgentsDetailsViewController.h"

@interface PlanView : UIView <UITableViewDataSource,UITableViewDelegate,PlanProxyDelegate, HeaderViewDelegate,PlanDetailDelegate,AgentProxyDelegate,AgentsDetailsDelegate,UIAlertViewDelegate> {
    
    __weak UITableView *_planTableUser;
    
    HeaderView *_planHeaderView;
    
    BOOL noRecordFound;
    
    NSString *selectedSegmentedControl;
    
}

@property (nonatomic, strong) NSMutableDictionary *planAgentDictionary;

@property (nonatomic, strong) NSMutableArray *dicKEYs;

@property (nonatomic, strong) PlanProxy *planProxy;

@property (nonatomic, strong) AgentProxy *agentProxy;



@end
