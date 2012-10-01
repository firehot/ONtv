

#import "PlanProxy.h"
#import "CategoryDataModel.h"
#import "JSON.h"
#import "Program.h"
#import "NSDictionary+NSNullHandler.h"
#import "NSString+utility.h"


@interface PlanProxy()

- (void)parsePlans:(NSString*)response;

- (Program*)planDetails:(NSDictionary*)dic;

- (id)proxyForPlan:(Program*)programObj;

@end

@implementation PlanProxy 

@synthesize planProxyDelegate = _planProxyDelegate;

#pragma mark -
#pragma mark Life Cycle Method



#pragma mark -
#pragma mark  server request for categories

- (void)getPlans {
    
    
    AppDelegate_iPhone * appDelegate = DELEGATE;
    
	NSMutableString *url = [[NSMutableString alloc] initWithString:BASEURL];
    
	[url appendString:PLAN_URL];
    [url appendFormat:@"/%@",appDelegate.user.email];
    
    
    DLog(@"new url : %@",url);
    
    [super setCache:NO];
    
    [super requestDataWithURL:url UsingToken:appDelegate.authenticationToken UsingData:nil andRequestName:@"GetPlans" withRequestType:GET_REQUEST];
	
    
}


- (void)getPlanForProgramID:(NSString*)programId {
    
    AppDelegate_iPhone * appDelegate = DELEGATE;
    
	NSMutableString *url = [[NSMutableString alloc] initWithString:BASEURL];
    
	[url appendString:PLAN_URL];
    [url appendFormat:@"/%@",appDelegate.user.email];
     [url appendFormat:@"/%@",programId];
    
    DLog(@"new url : %@",url);
    

    [super setCache:NO];

    [super requestDataWithURL:url UsingToken:appDelegate.authenticationToken UsingData:nil andRequestName:@"GetSinglePlan" withRequestType:GET_REQUEST];
	

}

- (void)deletePlans:(NSString*)programId {
    
    
    AppDelegate_iPhone * appDelegate = DELEGATE;
    
	NSMutableString *url = [[NSMutableString alloc] initWithString:BASEURL];
    
	[url appendString:PLAN_URL];
    [url appendFormat:@"/%@",appDelegate.user.email];
    [url appendFormat:@"/%@",programId];
    
    DLog(@"new url : %@",url);

    [super setCache:NO];
    
    [super requestDataWithURL:url UsingToken:appDelegate.authenticationToken UsingData:nil andRequestName:@"DeletePlans" withRequestType:DELETE_REQUEST];
	
    
}

- (void)addPlans:(Program*)programObj {
    
    AppDelegate_iPhone * appDelegate = DELEGATE;
    
    NSMutableString *url = [[NSMutableString alloc] initWithString:BASEURL];
	[url appendString:PLAN_URL];
    [url appendFormat:@"/%@",appDelegate.user.email];

    DLog(@"PLAN DIC %@", url);
    
    NSDictionary *dict = [self proxyForPlan:programObj];
    NSData *data = [super dataFromDictionary:dict];

    [super setCache:NO];

    [super requestDataWithURL:url UsingToken:appDelegate.authenticationToken UsingData:data andRequestName:@"AddPlan" withRequestType:POST_REQUEST];
    
    
     
    
}


#pragma mark -
#pragma mark  server responce for categoires 


- (void)postFailed:(ASIHTTPRequest *)request 
{	
    
	DLog(@"Error : %@",[request error]);
	//[UIUtils alertView:[[request error] localizedDescription] withTitle: NSLocalizedString(@"Plans"];
	
    if (self.planProxyDelegate && [self.planProxyDelegate respondsToSelector:@selector(planRequestFailed:)]) {
        
        [self.planProxyDelegate planRequestFailed:nil];
    }
    
    
    if ([[request responseString] isKindOfClass:[NSNull class]] || [request responseString] == nil) {
        
        [UIUtils alertView:[[request error] localizedDescription] withTitle: NSLocalizedString(@"Plans", nil)];
        
    } else {
        
        [UIUtils alertView:[request responseString] withTitle: NSLocalizedString(@"Plans", nil)];
        
    }
}


- (void)postSuccess:(ASIHTTPRequest *)request 
{
    
    //DLog(@"Error : %@",[request responseString]);
    
    
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
    } 
    
    NSDictionary *userInfo = [request userInfo];
	NSString *reqName = [userInfo valueForKey:@"RequestName"];
	if ([reqName isEqualToString:@"GetPlans"]|| [reqName isEqualToString:@"GetSinglePlan"]) {		
		
        [self parsePlans:[request responseString]];
        
    } else if ([reqName isEqualToString:@"DeletePlans"]) {		
		
        if(self.planProxyDelegate && [self.planProxyDelegate respondsToSelector:@selector(planDeletedSuccesfully)]) {
            
            [self.planProxyDelegate planDeletedSuccesfully];
        }
        
    } else if ([reqName isEqualToString:@"AddPlan"]) {
        
        if(self.planProxyDelegate && [self.planProxyDelegate respondsToSelector:@selector(planDeletedSuccesfully)]) {
            
            [self.planProxyDelegate planAddedSuccesfully];
        }
    }
    
}


#pragma mark -
#pragma mark parse categoires


- (void)parsePlans:(NSString*)response {
    
    
	NSDictionary *mainDict = [response JSONValue];
    
	id planArray = [mainDict objectForKey:@"program"];
    
	NSMutableArray *planDetailsArray = [[NSMutableArray alloc] init];
    
	if([planArray isKindOfClass:[NSMutableArray class]]) {
        
		if([planArray count] != 0 && planArray != nil) {										
            
			for(NSDictionary *dict in planArray) {
                
                @autoreleasepool {
                
                Program *programObj = [self planDetails:dict];
                [planDetailsArray addObject:programObj];
                
                }
                
			}						
		}
	}
    
    if ([planArray isKindOfClass:[NSDictionary class]]) {
        
        @autoreleasepool {
        
            Program *programObj = [self planDetails:planArray];
            [planDetailsArray addObject:programObj];
        
        }
        
    }
    
    
    if ([planDetailsArray count] > 0) {
        
        if(self.planProxyDelegate && [self.planProxyDelegate respondsToSelector:@selector(receivedPlan:)]) {
            
            [self.planProxyDelegate receivedPlan:planDetailsArray];
        }
        
    } else {
        
        if(self.planProxyDelegate && [self.planProxyDelegate respondsToSelector:@selector(noPlanRecordsFound)]) {
            
            [self.planProxyDelegate noPlanRecordsFound];
        }
    }
    

}


- (Program*)planDetails:(NSDictionary*)dic {
    
    Program *program = [[Program alloc] init];
    
    program.programId = [dic objectForKey:@"@id"];
    DLog(@"%@",program.programId);
    program.channel = [[dic objectForKey:@"@channel"] intValue];
    program.agentId = [[dic objectForKey:@"@agent"] intValue];
    
    id titleObj = [dic objectForKey:@"title"];
    
    if ([titleObj isKindOfClass:[NSArray class]]) {
        
        NSArray *titleArray = (NSArray*)titleObj;
        
        if ([titleArray count] > 0) {
            
            NSDictionary *titleDic = [titleArray objectAtIndex:0];
            
            if([titleDic isDictionaryExist]) {
                
                program.title = [titleDic objectForKey:@"$"];
            }
            
            if ([titleArray count] > 1) {
                
                NSDictionary *titleDic = [titleArray objectAtIndex:1];
                
                if([titleDic isDictionaryExist]) {
                    
                    program.originalTitle = [titleDic objectForKey:@"$"];
                }
                
            }
        }
        
        
    } else if ([titleObj isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *titleDic = (NSDictionary*)titleObj;
        
        if([titleDic isDictionaryExist]) {
            
            program.title = [titleDic objectForKey:@"$"];
        }
        
    }

    
    NSDictionary *startDateDict = [dic objectForKey:@"start"];
    
    if([startDateDict isDictionaryExist]) {
        
        program.start = [startDateDict objectForKey:@"$"];
    }
    
    
    NSDictionary *endDateDict = [dic objectForKey:@"end"];
    
    if([endDateDict isDictionaryExist]) {
        
        program.end = [endDateDict objectForKey:@"$"];
    }
    
    NSDictionary *reminderDict = [dic objectForKey:@"reminder"];
    
    if([reminderDict isDictionaryExist]) {
        
        program.remiderType = [reminderDict objectForKey:@"@method"];
        
        program.remiderProgramStartTime = [reminderDict objectForKey:@"@time"];
            
    }
    
    NSDictionary *agentDict = [dic objectForKey:@"agent"];
    
    if([agentDict isDictionaryExist]) {
        
        program.agentID = [agentDict objectForKey:@"@id"];
        
    }

    return program;
    
}


- (id)proxyForPlan:(Program*)programObj {
    
    
    NSDictionary *riminderDic = nil;
    
    if ([programObj.remiderType isStringPresent]) {
        
        if (![programObj.remiderType isEqualToString:@""]) {
            
            
            NSString *riminderDate1 = [NSString stringWithFormat:@"%@GMT",programObj.remiderProgramStartTime];
            
            NSString *riminderDate = [riminderDate1 stringByReplacingOccurrencesOfString:@" " withString:@"+"];
            
            DLog(@"riminderDate %@", riminderDate);
                        
            riminderDic  = [NSDictionary dictionaryWithObjectsAndKeys:
                            programObj.remiderType, @"@method",
                            riminderDate, @"@time",
                            @"user", @"@creator",   
                            nil];
       }
    }
    
    
    if (riminderDic) {
              
        NSDictionary *planDic = [NSDictionary dictionaryWithObjectsAndKeys:programObj.programId, @"@id",riminderDic,@"reminder",nil]; 
        
        DLog(@"PLAN DIC %@", planDic);
    
        
        return [NSDictionary dictionaryWithObjectsAndKeys:planDic,@"program",nil];

        
    } else {
        
        NSDictionary *planDic = [NSDictionary dictionaryWithObjectsAndKeys:programObj.programId,@"@id",nil]; 
        
         return [NSDictionary dictionaryWithObjectsAndKeys:planDic,@"program",nil];
    }
		
    return nil; 

}


@end
