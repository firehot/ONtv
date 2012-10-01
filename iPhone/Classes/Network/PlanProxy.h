
#import <Foundation/Foundation.h>
#import "Proxy.h"
#import "Program.h"
@protocol PlanProxyDelegate;

@interface PlanProxy : Proxy 

@property (nonatomic, weak) id<PlanProxyDelegate> planProxyDelegate;

- (void)getPlans;

- (void)getPlanForProgramID:(NSString*)programId;

- (void)deletePlans:(NSString*)programId;

- (void)addPlans:(Program*)ProgramObj;

@end

@protocol PlanProxyDelegate <NSObject>

- (void)planRequestFailed:(NSString *)error;

@optional

- (void)receivedPlan:(NSMutableArray*)array;

- (void)planDeletedSuccesfully;

- (void)planAddedSuccesfully;

- (void)noPlanRecordsFound;

@end