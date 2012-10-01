
#import "Proxy.h"
#import "JSON.h"

@implementation Proxy

@synthesize networkRequest = _networkRequest;
@synthesize cache = _cache;

-(void)requestDataWithURL:(NSString *)url UsingToken:(NSString *)key UsingData:(NSData *)data andRequestName:(NSString *)rName withRequestType:(NSString*)requestType {
    
    
    @autoreleasepool {
	
        NSURL *URL = [NSURL URLWithString:url];
	
        ASIHTTPRequest *tempRequest = [[ASIHTTPRequest alloc]initWithURL:URL];
	
        self.networkRequest = tempRequest;
        
        
        //[ASIHTTPRequest setShouldThrottleBandwidthForWWAN:YES];

        if (self.cache) {
         
            [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];

            
            [self.networkRequest setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy| ASIFallbackToCacheIfLoadFailsCachePolicy];
            
            [self.networkRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];

        }
        
        NSDictionary *requestName = [[NSDictionary alloc] initWithObjectsAndKeys:rName,@"RequestName",nil];	
        
        @try {
            
            if ([requestType isEqualToString:PUT_REQUEST]) {
                
                [self.networkRequest setRequestMethod:@"PUT"];
                
                [self.networkRequest addRequestHeader:@"Content-Type" value:@"application/json"];
                
                [self.networkRequest appendPostData:data];
                
            } else if ([requestType isEqualToString:POST_REQUEST]) {
                
                [self.networkRequest setRequestMethod:@"POST"];
                
                [self.networkRequest addRequestHeader:@"Content-Type" value:@"application/json"];
                
                [self.networkRequest appendPostData:data];
                
            } else if ([requestType isEqualToString:DELETE_REQUEST]) {
                
                [self.networkRequest setRequestMethod:@"DELETE"];
                
                [self.networkRequest addRequestHeader:@"Content-Type" value:@"application/json"];
                
                [self.networkRequest appendPostData:data];
                
            } else if ([requestType isEqualToString:GET_REQUEST]) {
                
                [self.networkRequest setRequestMethod:@"GET"];
                
                [self.networkRequest addRequestHeader:@"Accept" value:@"application/json"];
            }
            
            
		[self.networkRequest setDelegate:self];
            
		[self.networkRequest setTimeOutSeconds:60];
            
            
		NSMutableString *url;
            
		if(key != nil) {
                
			url = [[NSMutableString alloc] initWithString:@"Token cm10u23r09u, Basic "];
                
			[url appendString:key];
                
		}
		else {
                
			url = [[NSMutableString alloc] initWithString:@"Token cm10u23r09u"];
		}
            
		DLog(@"url : %@",url);
            
		//@"Token qwifj90qfj9j3, Basic cHJvLXVzZXJAb250di5kazo1YTY5MGQ4NDI5MzVjNTFmMjZmNDczZTAyNWMxYjk3YQ=="
            
		[self.networkRequest addRequestHeader:@"Authorization" value:url];
            
		[self.networkRequest setUserInfo:requestName];
            
		[self.networkRequest setDidFinishSelector:@selector(postSuccess:)];
		
            [self.networkRequest setDidFailSelector:@selector(postFailed:)];
		
            [self.networkRequest startAsynchronous];
		
	}
	@catch (NSException * e) {
            
		DLog(@"Error = %@",[e reason]);
	}
	@finally {
            
            
	}
    
    
	}
    
    
}


-(void)postSuccess:(ASIHTTPRequest *)request {
}

-(void)postFailed:(ASIHTTPRequest *)request {
	
}

-(NSData *)dataFromDictionary : (NSDictionary *) dict {
	
	NSLog(@" dict %@", dict);
	
	SBJSON *jsonHelper = [[SBJSON alloc] init];
    
	jsonHelper.humanReadable = NO;
    
	NSString *jsonString = [jsonHelper stringWithObject:dict];
    
    
	DLog(@"getDataFromDict:%@",jsonString);
        
    NSData *data = [jsonString dataUsingEncoding: NSUTF8StringEncoding];

	return data;
}



- (void)dealloc {
    
    [_networkRequest clearDelegatesAndCancel];
    
    
}

@end
