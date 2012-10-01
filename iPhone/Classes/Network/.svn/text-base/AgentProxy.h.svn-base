

#import <Foundation/Foundation.h>
#import "Proxy.h"
#import "Agents.h"

@protocol AgentProxyDelegate;

@interface AgentProxy : Proxy 

@property (nonatomic, weak) id<AgentProxyDelegate> agentProxyDelegate;

- (void)getAgents;

- (void)getAgentForAgentID:(NSString*)agentId;

- (void)deleteAgents:(NSString*)agentId;

- (void)addAgent:(Agents*)agentObj;

@end

@protocol AgentProxyDelegate <NSObject>

- (void)agentRequestFailed:(NSString *)error;

@optional

- (void)receivedAgent:(NSMutableArray*)array;

- (void)agentDeletedSuccesfully;

- (void)agentAddedSuccesfully;

- (void)noAgentRecordsFound;

@end