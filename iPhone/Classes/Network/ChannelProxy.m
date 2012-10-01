

#import "ChannelProxy.h"
#import "JSON.h"
#import "Channel.h"
#import "Program.h"
#import "UIUtils.h"
#import "User.h"
#import "AppDelegate_iPhone.h"

@implementation ChannelProxy
@synthesize channelProxyDelegate;


#pragma mark -
#pragma mark Life Cycle Method


#pragma mark -
#pragma mark Get Methods

- (void)getChannelsFor:(NSString*)viewType {
    NSString *url = BASEURL;
	url = [url stringByAppendingString:@"/lists/channels"];
	//url = [url stringByAppendingString:@"?preview=3"];
    
    [super setCache:YES];
    
    if ([viewType isEqualToString:@"FavoriteView"]) {
        
         [super requestDataWithURL:url UsingToken:nil UsingData:nil andRequestName:@"FavoriteView" withRequestType:GET_REQUEST];
        
    } else {
                
        [super requestDataWithURL:url UsingToken:nil UsingData:nil andRequestName:@"Channels" withRequestType:GET_REQUEST];
        
    }
    
}

- (void)getChannelsWithChannelIds:(NSMutableArray *) idArray{
   
    NSString *url = BASEURL;
	url = [url stringByAppendingString:@"/lists/channels/"];
    
    NSString *channelIDString = [idArray componentsJoinedByString:@";"];
    
    url = [url stringByAppendingFormat:@"%@",channelIDString];

    //DLog(@"URL : %@",url);
    
	url = [url stringByAppendingString:@"?preview=3"];
    
    [super setCache:YES];

    [super requestDataWithURL:url UsingToken:nil UsingData:nil andRequestName:@"FavoriteChannels" withRequestType:GET_REQUEST];
}

- (void)getImageWithFilePath : (NSString *)filePath{
    
	NSMutableString *url = [[NSMutableString alloc] initWithString:BASEURL];
	[url appendString:filePath];
	
    [super setCache:YES];

    [super requestDataWithURL:url UsingToken:nil UsingData:nil andRequestName:@"Image" withRequestType:GET_REQUEST];
    
}



- (void)getDefaultFavoriteChannels {
    
    NSString *locale = [[NSLocale currentLocale] localeIdentifier];
    NSLog(@"current locale: %@", locale);
    
    NSArray *localArray = [locale componentsSeparatedByString:@"_"];
    
    NSLog(@"current locale: %@", [localArray objectAtIndex:1]);
    
    
    NSString *currentRegion = [localArray objectAtIndex:1];
    
    NSString *lowercase = [currentRegion lowercaseString];
    
    NSString *defaultChannelStrings = [NSString stringWithFormat:@"/lists/channels/%@favs",lowercase];

    NSString *url = BASEURL;
	url = [url stringByAppendingString:defaultChannelStrings];
    
    NSLog(@"current locale: %@", url);

	//url = [url stringByAppendingString:@"?preview=3"];
 
    [super setCache:YES];

    
    [super requestDataWithURL:url UsingToken:nil UsingData:nil andRequestName:@"DefaultFavorite" withRequestType:GET_REQUEST];
    
}

#pragma mark -
#pragma mark Post Methods

-(void)postChannelsWithSessionKey:(NSString *)sessionKey andUsername : (NSString *)username andChannels:(NSDictionary *)channels {
    
	NSMutableString *url = [[NSMutableString alloc] initWithString:BASEURL];
	[url appendString:@"/users/"];
	[url appendString:username];	
	//DLog(@"URL : %@",url);
	NSData *data = [super dataFromDictionary:channels];
	
    [super setCache:NO];
    
    [super requestDataWithURL:url UsingToken:sessionKey UsingData:data andRequestName:@"PostChannels" withRequestType:PUT_REQUEST];
    
}

-(void)deleteChannelsWithSessionKey:(NSString *)sessionKey andUsername : (NSString *)username andChannels:(NSDictionary *)channels {
    
	NSMutableString *url = [[NSMutableString alloc] initWithString:BASEURL];
	[url appendString:@"/users/"];
	[url appendString:username];	
	//DLog(@"URL : %@",url);
	NSData *data = [super dataFromDictionary:channels];
    
    [super setCache:NO];
    
    [super requestDataWithURL:url UsingToken:sessionKey UsingData:data andRequestName:@"DeleteChannels" withRequestType:PUT_REQUEST];
    
}

#pragma mark -
#pragma mark Proxy Delegate Methods

-(void)postSuccess:(ASIHTTPRequest *)request
{
    
    AppDelegate_iPhone *appDelegate = DELEGATE;

    NSString *proUserRequiredResponse = [[NSString alloc] initWithFormat:@"This resource requires you to authorize with a 'pro' or equivalent account. '<%@>' is not good enough.",appDelegate.user.email];
    
	//DLog(@"Response : %@",[request responseString]);
	
	NSDictionary *userInfo = [request userInfo];
	NSString *reqName = [userInfo valueForKey:@"RequestName"];
	if ([reqName isEqualToString:@"Channels"]) {
        
        [self parseChannels:[request responseString] forView:reqName];
        
	} else if ([reqName isEqualToString:@"PostChannels"]) {
		[self postChannels:[request responseString]];
	
    } else if ([reqName isEqualToString:@"FavoriteChannels"]) {
       
        [self parseChannels:[request responseString] forView:reqName];

	} else if ([reqName isEqualToString:@"DeleteChannels"]) {
		
        [self postChannels:[request responseString]];
	
    } else if ([reqName isEqualToString:proUserRequiredResponse]) {
        
        [channelProxyDelegate channelProUserRequired];
        
    } else if ([reqName isEqualToString:@"DefaultFavorite"]) {
        
        [self parseDefaultFavoriteChannels:[request responseString]];

    } else if ([reqName isEqualToString:@"FavoriteView"]) {
        
        [self parseChannels:[request responseString] forView:reqName];

    }
 	
}

-(void)postFailed:(ASIHTTPRequest *)request {

	//DLog(@"Error : %@",[request error]);
    
    
    if(channelProxyDelegate) {
        [channelProxyDelegate channelDataFailed:@"Error"];
    }
   
    
    if ([[request responseString] isKindOfClass:[NSNull class]] || [request responseString] == nil) {
        
        [UIUtils alertView:[[request error] localizedDescription] withTitle:@"Channels"];
        
    } else {
        
        [UIUtils alertView:[request responseString] withTitle:@"Channels"];
        
    }

}

-(void)parseChannels:(NSString *)responseStr forView:(NSString*)viewType {
    
	NSDictionary *mainDict = [responseStr JSONValue];

	id channelArray = [mainDict objectForKey:@"channel"];
	NSMutableArray *channelListArray = [[NSMutableArray alloc] init];
	
	if([channelArray isKindOfClass:[NSMutableArray class]]) {
		if([channelArray count] != 0 && channelArray != nil) {
			
			for(NSDictionary *channelDict in channelArray) {
				Channel *channel = [Channel channelFromDictionary:channelDict];
				NSDictionary *programsDict = [channelDict objectForKey:@"programs"];
				id programArray = [programsDict objectForKey:@"program"];
				NSMutableArray *getProgramsArray = [[NSMutableArray alloc] init];
				
				if(programArray != nil) {
					if([programArray isKindOfClass:[NSMutableArray class]]) {					
						for(NSDictionary *dict in programArray) {
							Program *program = [Program programFromDictionary:dict];
							[getProgramsArray addObject:program];
						}
					} else {
						Program *program = [Program programFromDictionary:programArray];
						[getProgramsArray addObject:program];
					}
				}
				channel.programs = getProgramsArray;
							
				id imageArray = [channelDict objectForKey:@"img"];
				NSMutableArray *getimages = [[NSMutableArray alloc] init];
				if(imageArray != nil) {
					if([imageArray isKindOfClass:[NSMutableArray class]]) {					
						for(NSDictionary *imageDict in imageArray) {
							Image *imageObject = [Image imageFromDictionary:imageDict];
							[getimages addObject:imageObject];
						}
					} else {
						Image *imageObject = [Image imageFromDictionary:imageArray];
						[getimages addObject:imageObject];
					}
				}
				channel.imageObjectsArray = getimages;

                
				[channelListArray addObject:channel];
			}
				
		}
	} else if([channelArray isKindOfClass:[NSDictionary class]]){
		Channel *channel = [Channel channelFromDictionary:channelArray];
		NSDictionary *programsDict = [channelArray objectForKey:@"programs"];
		id programArray = [programsDict objectForKey:@"program"];
		NSMutableArray *getProgramsArray = [[NSMutableArray alloc] init];
		
		if(programArray != nil) {
			if([programArray isKindOfClass:[NSMutableArray class]]) {					
				for(NSDictionary *dict in programArray) {
					Program *program = [Program programFromDictionary:dict];
					[getProgramsArray addObject:program];
				}
			} else {
				Program *program = [Program programFromDictionary:programArray];
				[getProgramsArray addObject:program];
			}
		}
		channel.programs = getProgramsArray;
        
        id imageArray = [channelArray objectForKey:@"img"];
        NSMutableArray *getimages = [[NSMutableArray alloc] init];
        if(imageArray != nil) {
            if([imageArray isKindOfClass:[NSMutableArray class]]) {					
                for(NSDictionary *imageDict in imageArray) {
                    Image *imageObject = [Image imageFromDictionary:imageDict];
                    [getimages addObject:imageObject];
                }
            } else {
                Image *imageObject = [Image imageFromDictionary:imageArray];
                [getimages addObject:imageObject];
            }
        }
        channel.imageObjectsArray = getimages;
        
		[channelListArray addObject:channel];
	} else {
        [UIUtils alertView:responseStr withTitle:@"Exception"];
    }
    
    
    if ([viewType isEqualToString:@"FavoriteView"]) {
        

        if ([channelListArray count] > 0) {
            
            if(channelProxyDelegate) {
                [channelProxyDelegate receivedAllChannnel:channelListArray];
            }	
        } 
        
    } else {
    
        if ([channelListArray count] > 0) {
        
            if(channelProxyDelegate) {
                [channelProxyDelegate getAllChannels:channelListArray];
            }	
        } else {
            
            if(channelProxyDelegate && [channelProxyDelegate respondsToSelector:@selector(noChannelsRecordsFound)]) {
                [channelProxyDelegate noChannelsRecordsFound];
            }

        }
        
    }   
	
}


- (void)parseDefaultFavoriteChannels:(NSString*)responseString {
    

    NSDictionary *mainDict = [responseString JSONValue];

	id channelArray = [mainDict objectForKey:@"channel"];
    
	NSMutableArray *channelIdsArray = [[NSMutableArray alloc] init];
	
	if([channelArray isKindOfClass:[NSMutableArray class]]) {
        
		if([channelArray count] != 0 && channelArray != nil) {
			
			for(NSDictionary *channelDict in channelArray) {

                NSString *channelId = [channelDict objectForKey:@"@id"];
                
                [channelIdsArray addObject:channelId];
                
			}
			
		}
        
	} else {
        
        if (channelArray) {
            
            NSString *channelId = [channelArray objectForKey:@"@id"];
            
            [channelIdsArray addObject:channelId];
        }    
	}
    

    if(channelProxyDelegate) {
        
            [channelProxyDelegate receivedDefaultFavoriteChannels:channelIdsArray];
    }
        

    
}

-(void)postChannels:(NSString *)responseStr {
	if(channelProxyDelegate) {
		[channelProxyDelegate postDataSuccess:responseStr];
	}
}






@end
