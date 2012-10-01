
#import <UIKit/UIKit.h>

#import "CustomListViewController.h"
#import "Agents.h"
#import "AgentProxy.h"
#import "CustomPickerViewController.h"

@protocol AgentsDetailsDelegate; 


@interface AgentsDetailsViewController : ONTVUIViewController <UITableViewDataSource,UITableViewDelegate,CustomListViewControllerDelegate,AgentProxyDelegate,CustomPickerViewDelegate,UITextFieldDelegate> {
    
    __weak UITableView *_agentDetailTableView;
    
    BOOL agentSwitchON;
    
    __weak UIView *_keyboardView;
}   

@property (nonatomic, weak) id<AgentsDetailsDelegate> agentsDetailsDelegate;

@property (nonatomic, strong) Agents *agent;

@property (nonatomic, strong) UITextField *searchTypeTextField;

@property (nonatomic, strong) UITextField *riminderTimeTypeTextField;

@property (nonatomic, copy) NSString *riminderTimeType;

@property (nonatomic, strong) AgentProxy *agentProxy;

@end



@protocol AgentsDetailsDelegate <NSObject>

- (void)editedAgentsSuccessfully;

@end

