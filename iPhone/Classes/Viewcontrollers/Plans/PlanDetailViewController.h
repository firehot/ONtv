

#import "ONTVUIViewController.h"
#import "CustomListViewController.h"
#import "Program.h"
#import "PlanProxy.h"
#import "AgentProxy.h"
#import "Agents.h"
#import "CustomPickerViewController.h"

@protocol PlanDetailDelegate; 

@interface PlanDetailViewController : ONTVUIViewController <UITableViewDataSource,UITableViewDelegate,CustomListViewControllerDelegate,PlanProxyDelegate,AgentProxyDelegate, CustomPickerViewDelegate> {

    __weak UITableView *_planDetailTableView;
    
    BOOL remindMeSwitchON;
    
    BOOL planWhenAiredSwitchON;
    
    __weak UIView *_keyboardView;
    
   
}   

@property (nonatomic, strong) Program *program;  

@property (nonatomic, copy) NSString *riminderTimeType;

@property (nonatomic, strong) UITextField *riminderTimeTypeTextField;

@property (nonatomic, assign) BOOL fromPlanEditScreen;

@property (nonatomic, weak) id<PlanDetailDelegate> planDetailDelegate;

@property (nonatomic, strong) Agents *agent;

@property (nonatomic, strong) PlanProxy *planProxy;

@property (nonatomic, strong) AgentProxy *agentProxy;

@end



@protocol PlanDetailDelegate <NSObject>

- (void)editedPlanSuccessfully;

@end
