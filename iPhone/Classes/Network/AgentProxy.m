

#import "AgentProxy.h"
#import "CategoryDataModel.h"
#import "JSON.h"
#import "NSDictionary+NSNullHandler.h"
#import "NSString+utility.h"


@interface AgentProxy()

- (void)parseAgent:(NSString*)response;

- (Agents*)agentDetails:(NSDictionary*)dic;

- (id)proxyForAgent:(Agents*)agentsObj;


@end

@implementation AgentProxy 

@synthesize agentProxyDelegate = _agentProxyDelegate;


#pragma mark -
#pragma mark Life Cycle Method


#pragma mark -
#pragma mark  server request for categories

- (void)getAgents {
    
    
    AppDelegate_iPhone * appDelegate = DELEGATE;
    
	NSMutableString *url = [[NSMutableString alloc] initWithString:BASEURL];
    
	[url appendString:AGENT_URL];
  
    [url appendFormat:@"/%@",appDelegate.user.email];
    
    DLog(@"new url : %@",url);
    
    [super setCache:NO];

    [super requestDataWithURL:url UsingToken:appDelegate.authenticationToken UsingData:nil andRequestName:@"GetPlans" withRequestType:GET_REQUEST];
	
    
}



- (void)getAgentForAgentID:(NSString*)agentId {
    
    AppDelegate_iPhone * appDelegate = DELEGATE;
    
	NSMutableString *url = [[NSMutableString alloc] initWithString:BASEURL];
    
	[url appendString:AGENT_URL];
  
    [url appendFormat:@"/%@",appDelegate.user.email];
    
    [url appendFormat:@"/%@",agentId];
    
    DLog(@"new url : %@",url);
    
    [super setCache:NO];

    [super requestDataWithURL:url UsingToken:appDelegate.authenticationToken UsingData:nil andRequestName:@"GetSinglePlan" withRequestType:GET_REQUEST];
	
    
}

- (void)deleteAgents:(NSString*)agentId {
    
    AppDelegate_iPhone * appDelegate = DELEGATE;
    
	NSMutableString *url = [[NSMutableString alloc] initWithString:BASEURL];
    
	[url appendString:AGENT_URL];
   
    [url appendFormat:@"/%@",appDelegate.user.email];
    
    [url appendFormat:@"/%@",agentId];
    
    DLog(@"new url : %@",url);
    
    [super setCache:NO];

    [super requestDataWithURL:url UsingToken:appDelegate.authenticationToken UsingData:nil andRequestName:@"DeletePlans" withRequestType:DELETE_REQUEST];
	
    
}

- (void)addAgent:(Agents*)agentObj{
    
    AppDelegate_iPhone * appDelegate = DELEGATE;
    
    NSMutableString *url = [[NSMutableString alloc] initWithString:BASEURL];
	
    [url appendString:AGENT_URL];
    
    [url appendFormat:@"/%@",appDelegate.user.email];
    
    DLog(@"PLAN DIC %@", url);
    
    NSDictionary *dict = [self proxyForAgent:agentObj];    
    
    NSData *data = [super dataFromDictionary:dict];
    
    [super setCache:NO];
    
    [super requestDataWithURL:url UsingToken:appDelegate.authenticationToken UsingData:data andRequestName:@"AddPlan" withRequestType:POST_REQUEST];
    
    

}


#pragma mark -
#pragma mark  server responce for categoires 


- (void)postFailed:(ASIHTTPRequest *)request 
{	
    
	DLog(@"Error : %@",[request error]);
	//[UIUtils alertView:[[request error] localizedDescription] withTitle:@"Plans"];
    
    if ([[request responseString] isKindOfClass:[NSNull class]] || [request responseString] == nil) {
        
        [UIUtils alertView:[[request error] localizedDescription] withTitle:@"Agents"];
        
    } else {
        
        [UIUtils alertView:[request responseString] withTitle:@"Agents"];
        
    }
	
    if (self.agentProxyDelegate && [self.agentProxyDelegate respondsToSelector:@selector(agentRequestFailed:)]) {
        
        [self.agentProxyDelegate agentRequestFailed:nil];
    }
}



- (void)postSuccess:(ASIHTTPRequest *)request 
{
    
   // DLog(@"Error : %@",[request responseString]);
    
    
    if ([[request responseString] isEqualToString:@"the time attr should be in the future."]) {
        
        [UIUtils alertView:@"Please select future time for plan" withTitle:@"Error"];	
        
        return;
        
    } else if ([[request responseString] isEqualToString:@"We don't know the user's iphone token."]) {
        
        [UIUtils alertView:@"Please register device for Push Notification service from User Tab" withTitle:@"Push"];	
        
        return;
    } else if ([[request responseString] contains:@"Du kan ikke modtage SMS pÃ¥mindelser"]) {
        
        [UIUtils alertView:@"Please register mobile no. for SMS service" withTitle:@"SMS"];	
        
        /*'Du kan ikke modtage SMS pÃ¥mindelser. Du skal fÃ¸rst acceptere ONTV kan afsende SMS'er til dig. <a href="/ajax/inc.php?s=products.sms" class="ajax">LÃ¦s mere</a>.'*/
        return;
    } else  if ([[request responseString] contains:@"We currently only support filters on the title"]) {
        
        [UIUtils alertView:@"Please select Title filter" withTitle:@"Error"];	
        
        return;
    }   
    
    NSDictionary *userInfo = [request userInfo];
	NSString *reqName = [userInfo valueForKey:@"RequestName"];
	if ([reqName isEqualToString:@"GetPlans"]|| [reqName isEqualToString:@"GetSinglePlan"]) {		
		
        [self parseAgent:[request responseString]];
        
    } else if ([reqName isEqualToString:@"DeletePlans"]) {		
		
        if(self.agentProxyDelegate && [self.agentProxyDelegate respondsToSelector:@selector(agentDeletedSuccesfully)]) {
            
            [self.agentProxyDelegate agentDeletedSuccesfully];
        }
        
    } else if ([reqName isEqualToString:@"AddPlan"]) {
        
        if(self.agentProxyDelegate && [self.agentProxyDelegate respondsToSelector:@selector(agentAddedSuccesfully)]) {
            
            [self.agentProxyDelegate agentAddedSuccesfully];
        }
    }
    
}


#pragma mark -
#pragma mark parse categoires


- (void)parseAgent:(NSString*)response {
    
	NSDictionary *mainDict = [response JSONValue];
    
	id agentROOTObj = [mainDict objectForKey:@"agents"];
   
    if([agentROOTObj isDictionaryExist]) {
        
       agentROOTObj = [agentROOTObj objectForKey:@"agent"];
        
    } else {
        
       agentROOTObj = [mainDict objectForKey:@"agent"]; 
    }
    
    
	NSMutableArray *agentDetailsArray = [[NSMutableArray alloc] init];
    
	if([agentROOTObj isKindOfClass:[NSMutableArray class]]) {
        
		if([agentROOTObj count] != 0 && agentROOTObj != nil) {										
            
			for(NSDictionary *dict in agentROOTObj) {
                
                @autoreleasepool {
                
                Agents *agentsObj = [self agentDetails:dict];
                [agentDetailsArray addObject:agentsObj];
                
                }
                
			}						
		}
	}
    
    if ([agentROOTObj isKindOfClass:[NSDictionary class]]) {
        
        @autoreleasepool {
        
            Agents *agentsObj = [self agentDetails:agentROOTObj];
            [agentDetailsArray addObject:agentsObj];
        
        }
        
    }
    
    if ([agentDetailsArray count] > 0) {
    
        if(self.agentProxyDelegate && [self.agentProxyDelegate respondsToSelector:@selector(receivedAgent:)]) {
            
            [self.agentProxyDelegate receivedAgent:agentDetailsArray];
        }
 
    } else {
        
        if(self.agentProxyDelegate && [self.agentProxyDelegate respondsToSelector:@selector(noAgentRecordsFound)]) {
            
            [self.agentProxyDelegate noAgentRecordsFound];
        }
    }
    
    
}


- (Agents*)agentDetails:(NSDictionary*)dic{
    
    Agents *agents = [[Agents alloc] init];
    
    agents.agentID = [dic objectForKey:@"@id"];

    DLog(@"channels %@",agents.agentID);

    
    NSDictionary *reminderObj = [dic objectForKey:@"reminder"];

    if([reminderObj isDictionaryExist]) {
            
        agents.reminderType = [reminderObj objectForKey:@"@method"];
        
        NSDictionary *startObj = [reminderObj objectForKey:@"start"];
        
        if([startObj isDictionaryExist]) {
            
            agents.reminderStartTime = [startObj objectForKey:@"$"];
        }
           
    }
    

    NSDictionary *filterObj = [dic objectForKey:@"filter"];
    
    if([filterObj isDictionaryExist]) {
        
        agents.searchTargetCriteria = [filterObj objectForKey:@"@target"];

        agents.searchTypeCriteria = [filterObj objectForKey:@"@type"];

        agents.searchText = [filterObj objectForKey:@"$"];
        
    }
    

    NSDictionary *timefilterObj = [dic objectForKey:@"time-filter"];
    
    if([timefilterObj isDictionaryExist]) {
        
        agents.reminderDay = [timefilterObj objectForKey:@"@days"];

        agents.reminderHours = [timefilterObj objectForKey:@"@hours"];
        
    }
    
    
    NSDictionary *channelObj = [dic objectForKey:@"channel"];
    
    if([channelObj isDictionaryExist]) {
        
        agents.channelID = [channelObj objectForKey:@"@id"];
        
    } else {
        
        agents.channelID = @"0"; 
    }
    
    return agents;
     
}



- (id)proxyForAgent:(Agents*)agentsObj {
    
    
    NSDictionary *riminderDic = nil;
    
    if ([agentsObj.reminderType isStringPresent]) {
        
        if (![agentsObj.reminderType isEqualToString:@""] || agentsObj.reminderStartTime != nil) {
            
            
            
            NSDictionary *startTimeDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"delta", @"@format",
                                          agentsObj.reminderStartTime, @"$",   
                                          nil];
            
            riminderDic  = [NSDictionary dictionaryWithObjectsAndKeys:
                            agentsObj.reminderType, @"@method",
                            startTimeDic, @"start",nil];
            

        }
    }
    
    
    NSDictionary *filterDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  agentsObj.searchTargetCriteria, @"@target",
                                  agentsObj.searchTypeCriteria, @"@type",
                                  agentsObj.searchText, @"$",   
                                  nil];
    
    
    NSDictionary *timeFilterDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   agentsObj.reminderHours,@"@hours",
                                   agentsObj.reminderDay, @"@days",
                                   nil];
    
    
    DLog(@"%@",agentsObj.channelID);

    NSDictionary *channelDic  = [NSDictionary dictionaryWithObjectsAndKeys:
                    agentsObj.channelID, @"@id",nil];
        
    
    if (riminderDic) {
        
        
        NSDictionary *agentDic = [NSDictionary dictionaryWithObjectsAndKeys:riminderDic,@"reminder",filterDic,@"filter",timeFilterDic,@"time-filter",channelDic,@"channel",nil]; 
        
        DLog(@"PLAN DIC %@", agentDic);
        
        
       return [NSDictionary dictionaryWithObjectsAndKeys:agentDic,@"agent",nil];
        
        
    } else {
        
        NSDictionary *agentDic = [NSDictionary dictionaryWithObjectsAndKeys:filterDic,@"filter",timeFilterDic,@"time-filter",channelDic,@"channel",nil]; 
        
        DLog(@"PLAN DIC %@", agentDic);
        
        
       return [NSDictionary dictionaryWithObjectsAndKeys:agentDic,@"agent",nil];
    }
    
    return nil; 
    
}

@end
