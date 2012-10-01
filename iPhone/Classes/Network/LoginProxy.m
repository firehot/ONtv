

#import "LoginProxy.h"
#import "JSON.h"
#import "FavoriteChannel.h"
#import "UIUtils.h"
#import "UserRepository.h"
#import "AppDelegate_iPhone.h"

@implementation LoginProxy
@synthesize loginProxyDelegate;

#pragma mark -
#pragma mark Life Cycle Method


- (void)getCredentialsWithUsername:(NSString *)username andBase64Value:(NSString *)password{
   
    NSString *url = BASEURL;	
	url = [url stringByAppendingString:@"/users/"];
	url = [url stringByAppendingString:username];	

    
    [super setCache:NO];
    [super requestDataWithURL:url UsingToken:password UsingData:nil andRequestName:@"Login" withRequestType:GET_REQUEST];
}

#pragma mark -
#pragma mark Post Methods

-(void)postUserWithKey:(NSString *)tokenKey andUsername : (NSString *)username andUser:
    (NSDictionary *)user {
	NSMutableString *url = [[NSMutableString alloc] initWithString:BASEURL];
	[url appendString:@"/users/"];
	[url appendString:username];	
	DLog(@"URL : %@",url);
	NSData *data = [super dataFromDictionary:user];
    
    [super setCache:NO];
    [super requestDataWithURL:url UsingToken:tokenKey UsingData:data andRequestName:@"PostUser" withRequestType:PUT_REQUEST];
    
}

#pragma mark -
#pragma mark Proxy Delegate Methods

-(void)postSuccess:(ASIHTTPRequest *)request
{
    
	NSLog(@"Response : %@",[request responseString]);
	
	NSDictionary *userInfo = [request userInfo];
	NSString *reqName = [userInfo valueForKey:@"RequestName"];
    
	if ([reqName isEqualToString:@"Login"]) {
	
        [self parseUser:[request responseString]];
	
    } else if ([reqName isEqualToString:@"PostUser"]) {
	
        [self postUser:[request responseString]];
	}
	
}
-(void)postFailed:(ASIHTTPRequest *)request {
    
    DLog(@"%@", [request responseString]);
    
	if (loginProxyDelegate) {
        
        if ([[request responseString] isKindOfClass:[NSNull class]] || [request responseString] == nil) {
            
            [UIUtils alertView:[[request error] localizedDescription] withTitle:@"Login"];
            
        } else {

            [UIUtils alertView:[request responseString] withTitle:@"Login"];

        }
        
        [loginProxyDelegate loginFailed:[request responseString]];

    } 

}

-(void)parseUser:(NSString *)responseStr{
    
	NSDictionary *mainDict = [responseStr JSONValue];
		
	if (mainDict != nil) {
        
		User *user = [User userFromDictionary:mainDict];
        
        DLog(@"Dict : %@",mainDict);


		NSDictionary *channelDict = [mainDict objectForKey:@"channels"];
        
		id channelArray = [channelDict objectForKey:@"channel"];
        
        if (channelArray != nil) {
            
            NSMutableArray *favoritechannelArray = [[NSMutableArray alloc] init];
            UserRepository *repository = [[UserRepository alloc] init];
            int userID;
            AppDelegate_iPhone * appDelegate = DELEGATE;
            if(appDelegate.isGuest == NO)
                userID = [repository getUserIdFromDBWithUserName:user.name];
            else
                userID = -1;
            
            if([channelArray isKindOfClass:[NSMutableArray class]]) {
                
                for(NSDictionary *dict in channelArray) {
                    
                    DLog(@"Dict : %@",[dict description]);
                    FavoriteChannel *favoriteChannel = [FavoriteChannel favoriteChannelFromDictionary:dict andUserId:userID];
                    [favoritechannelArray addObject:favoriteChannel];
                    
                }
            } else {
                    
                DLog(@"Dict : %@",channelArray);

                FavoriteChannel *favoriteChannel = [FavoriteChannel favoriteChannelFromDictionary:channelArray andUserId:userID];
                
                [favoritechannelArray addObject:favoriteChannel];
            }

            user.channels = [favoritechannelArray copy];
        
		}
		
		if (loginProxyDelegate) {
            
			[loginProxyDelegate loginSuccessful:user];
		}
	}
		
}


-(void)postUser:(NSString *)responseStr {
    
    if(loginProxyDelegate) {
        
        [loginProxyDelegate postDataSuccess:responseStr];
    }
}

@end
