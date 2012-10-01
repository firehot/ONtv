
#import "RecommendProxy.h"

#import "JSON.h"
#import "NSDictionary+NSNullHandler.h"
#import "NSString+utility.h"


@interface RecommendProxy()

- (void)parseRecommendation:(NSString*)response;

- (id)proxyForRecommendation:(NSString*)programID;

- (id)proxyForRecommendation:(NSString*)programID;

@end

@implementation RecommendProxy 

@synthesize recommendProxyDelegate = _recommendProxyDelegate;


#pragma mark -
#pragma mark Life Cycle Method



#pragma mark -
#pragma mark  server request for categories



- (void)getRecommendationForProgram:(NSString*)programId {
    
    AppDelegate_iPhone * appDelegate = DELEGATE;
    
	NSMutableString *url = [[NSMutableString alloc] initWithString:BASEURL];
    
	[url appendString:LIKE_URL];
    [url appendFormat:@"/%@",appDelegate.user.email];
    [url appendFormat:@"/%@",programId];
    
    DLog(@"new url : %@",url);
    
    [super setCache:NO];
   
    [super requestDataWithURL:url UsingToken:appDelegate.authenticationToken UsingData:nil andRequestName:@"GetRecommendation" withRequestType:GET_REQUEST];
    
    
}

- (void)deleteRecommendationForProgram:(NSString*)programId {
    
    
    AppDelegate_iPhone * appDelegate = DELEGATE;
    
	NSMutableString *url = [[NSMutableString alloc] initWithString:BASEURL];
    
	[url appendString:LIKE_URL];
    [url appendFormat:@"/%@",appDelegate.user.email];
    [url appendFormat:@"/%@",programId];
    
    DLog(@"new url : %@",url);
    

    [super setCache:NO];
    
    [super requestDataWithURL:url UsingToken:appDelegate.authenticationToken UsingData:nil andRequestName:@"DeleteRecommendation" withRequestType:DELETE_REQUEST];
    
    
}

- (void)addRecommendationForProgram:(NSString*)programId; {
    
    AppDelegate_iPhone * appDelegate = DELEGATE;
    
    NSMutableString *url = [[NSMutableString alloc] initWithString:BASEURL];
	[url appendString:LIKE_URL];
    [url appendFormat:@"/%@",appDelegate.user.email];
    
    DLog(@"PLAN DIC %@", url);

    
    NSDictionary *dict = [self proxyForRecommendation:programId];
     NSData *data = [super dataFromDictionary:dict];
    

    [super setCache:NO];

    [super requestDataWithURL:url UsingToken:appDelegate.authenticationToken UsingData:data andRequestName:@"AddRecommendation" withRequestType:POST_REQUEST];
    

}


#pragma mark -
#pragma mark  server responce for categoires 


- (void)postFailed:(ASIHTTPRequest *)request 
{	
    
	DLog(@"Error : %@",[request error]);
	//[UIUtils alertView:[[request error] localizedDescription] withTitle: NSLocalizedString(@"Plans",nil)];
	
    if (self.recommendProxyDelegate && [self.recommendProxyDelegate respondsToSelector:@selector(recommendRequestFailed:)]) {
        
        [self.recommendProxyDelegate recommendRequestFailed:nil];
    }
    
    
    if ([[request responseString] isKindOfClass:[NSNull class]] || [request responseString] == nil) {
        
        [UIUtils alertView:[[request error] localizedDescription] withTitle: NSLocalizedString(@"Recommendation",nil)];
        
    } else {
        
        [UIUtils alertView:[request responseString] withTitle:NSLocalizedString(@"Recommendation",nil)];
        
    }
}



- (void)postSuccess:(ASIHTTPRequest *)request 
{
    
    //DLog(@"Error : %@",[request responseString]);
    

    NSDictionary *userInfo = [request userInfo];
	NSString *reqName = [userInfo valueForKey:@"RequestName"];
    
	if ([reqName isEqualToString:@"GetRecommendation"]) {		
		
        [self parseRecommendation:[request responseString]];
        
    } else if ([reqName isEqualToString:@"DeleteRecommendation"]) {		
		
        if(self.recommendProxyDelegate && [self.recommendProxyDelegate respondsToSelector:@selector(recommendationDeletedSuccesfully)]) {
            
            [self.recommendProxyDelegate recommendationDeletedSuccesfully];
        }
        
    } else if ([reqName isEqualToString:@"AddRecommendation"]) {
        
        if(self.recommendProxyDelegate && [self.recommendProxyDelegate respondsToSelector:@selector(recommendationAddedSuccesfully)]) {
            
            [self.recommendProxyDelegate recommendationAddedSuccesfully];
        }
    }
    
}


#pragma mark -
#pragma mark parse categoires


- (void)parseRecommendation:(NSString*)response {
    
	NSDictionary *mainDict = [response JSONValue];
    
	id recommendation = [mainDict objectForKey:@"program"];
    
    BOOL recommended = NO;
    
    if (recommendation) {
        recommended = YES;
    }
    
    if(self.recommendProxyDelegate && [self.recommendProxyDelegate respondsToSelector:@selector(receivedRecommendation:)]) {
        
        [self.recommendProxyDelegate receivedRecommendation:recommended];
    }
}


- (id)proxyForRecommendation:(NSString*)programID {

  return [NSDictionary dictionaryWithObjectsAndKeys:programID,@"@id",nil];
       
}

@end
