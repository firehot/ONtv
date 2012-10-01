


#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"
#import "Constants.h"

@interface Proxy : NSObject {
    
    
    
}


@property (nonatomic, strong) ASIHTTPRequest *networkRequest;
@property (nonatomic, assign) BOOL cache;


-(void)requestDataWithURL:(NSString*)url UsingToken:(NSString*)key UsingData:(NSData *)data andRequestName:(NSString*)rName withRequestType:(NSString*)requestType;


-(void)postSuccess:(ASIHTTPRequest *)request;

-(void)postFailed:(ASIHTTPRequest *)request;

-(NSData *)dataFromDictionary:(NSDictionary *)dict;

@end