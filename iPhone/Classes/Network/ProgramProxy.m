

#import "ProgramProxy.h"
#import "JSON.h"
#import "Program.h"
#import "AppDelegate_iPhone.h"
#import "UIUtils.h"
#import "NSDictionary+NSNullHandler.h"
#import "User.h"
#import "AppDelegate_iPhone.h"
#import "CacheRepository.h"
#import "NSString+utility.h"
#import "UIUtils.h"

@interface ProgramProxy () 


- (void)parseProgramsDetails:(NSString *)responseStr For:(NSString*)queryType;

- (Program*)programDetails:(NSDictionary*)dic;

- (BOOL)isProgramAlive:(Program*)program forType:(NSString*)type;

- (NSString*)getCacheDataFor:(NSString*)dataType;

- (void)addDataInCache:(NSString*)dataType forData:(NSString*)cacheDataString andEtag:(NSString*)expiryDate;

@end



@implementation ProgramProxy


@synthesize programProxyDelegate;


#pragma mark -
#pragma mark Life Cycle Method



- (void)getProgramsWithProgramName : (NSString *)programName andChannelIds : (NSMutableArray *) idArray andStartDate : (NSString *) startDate andEndtDate : (NSString *) endDate {
    
    DLog(@"getProgramsWithProgramName STARTDATE %@", startDate);
    
    DLog(@"getProgramsWithProgramName ENDDATE %@", endDate);
    
    NSString *channelIDString = [idArray componentsJoinedByString:@";"];
    
    DLog(@"%@", channelIDString);
    
	AppDelegate_iPhone * appDelegate = DELEGATE;
    
    
	NSMutableString *url = [[NSMutableString alloc] initWithString:BASEURL];
    
	[url appendString:@"/search?query="];
    
    NSString * program = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(__bridge CFStringRef)programName,NULL,(CFStringRef)@"!*'();￼&=+$,/?%#[]",kCFStringEncodingUTF8);
    
    [url appendFormat:@"%@&channels=%@",program,channelIDString];
	
    
	NSString *currentStartDate = startDate;
	if(startDate != nil) {
        currentStartDate = [currentStartDate stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [url appendFormat:@"&start=%@+GMT",currentStartDate];
    }
	
    NSString *currentEndDate = endDate;
    if(endDate != nil) {
        currentEndDate = [currentEndDate stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [url appendFormat:@"&end=%@+GMT",currentEndDate];
    }    
    
	DLog(@"new url : %@",url);
    
    
    [super setCache:NO];
    
    [super requestDataWithURL:url UsingToken:appDelegate.authenticationToken UsingData:nil andRequestName:@"SearchPrograms" withRequestType:GET_REQUEST];

    
}




- (void)getRecommendedProgramsForFavoriteChannelWithChannelId:(NSString*)channnelId AndStartDate:(NSString*)sDate AndEndDate:(NSString*)eDate {
    
    
	AppDelegate_iPhone * appDelegate = DELEGATE;
    
	NSMutableString *url = [[NSMutableString alloc] initWithString:BASEURL];
    
	[url appendString:@"/search?rating=1"];
    
	[url appendFormat:@"&channels=%@",channnelId];
    
    

    NSString *currentStartDate = sDate;
    
    if(currentStartDate != nil) {
        
        currentStartDate = [currentStartDate stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [url appendFormat:@"&start=%@+GMT",currentStartDate];
    }
    
    NSString *currentEndDate = eDate;
    
    if(currentEndDate != nil) {
        
        currentEndDate = [currentEndDate stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [url appendFormat:@"&end=%@+GMT",currentEndDate];
    }    
    
    DLog(@"new url : %@",url);
    

    [super setCache:NO];
    
    [super requestDataWithURL:url UsingToken:appDelegate.authenticationToken UsingData:nil andRequestName:@"GetAllPrograms" withRequestType:GET_REQUEST];

	
}



- (void)getProgramsForChannelId:(int)channnelId AndStartDate:(NSString*)sDate AndEndDate:(NSString*)eDate 
{
    
    
    NSDate *startdate = [UIUtils dateFromGivenGMTString:sDate WithFormat:@"EEEddMMMyyyy HH:mm:ss"];
    
    NSString *startDateString = [UIUtils stringFromGivenGMTDate:startdate WithFormat:@"EEEddMMMyyyy"];
    
    NSString *requestName = [NSString stringWithFormat:@"GetAllProgramsForChannel%d%@",channnelId,startDateString];
    
    
    NSString *cacheDataResponse = [self getCacheDataFor:requestName];
    
    
    DLog(@"%@", requestName);
    
    if ([cacheDataResponse isStringPresent]) {
        
        [self parseProgramsDetails:cacheDataResponse For:@"GetAllProgramsForChannel"];
        
    } else {
    
        AppDelegate_iPhone * appDelegate = DELEGATE;
        
        NSMutableString *url = [[NSMutableString alloc] initWithString:BASEURL];
        
        [url appendString:@"/search?"];
        
        [url appendFormat:@"channels=%d",channnelId];
        
        
        NSString *currentStartDate = sDate;
        
        if(currentStartDate != nil) {
            
            currentStartDate = [currentStartDate stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            [url appendFormat:@"&start=%@+GMT",currentStartDate];
        }
        
        NSString *currentEndDate = eDate;
        
        if(currentEndDate != nil) {
            
            currentEndDate = [currentEndDate stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            [url appendFormat:@"&end=%@+GMT",currentEndDate];
        }    
        
        DLog(@"new url : %@",url);
        
        [super setCache:NO];
        
        [super.networkRequest clearDelegatesAndCancel];
        
        [super requestDataWithURL:url UsingToken:appDelegate.authenticationToken UsingData:nil andRequestName:requestName withRequestType:GET_REQUEST];
        
    }
}



- (void)getProgramsForCategory:(NSString*)categoryType andFavoriteChannelIds:(NSString*)channnelId AndStartDate:(NSString*)sDate AndEndDate:(NSString*)eDate
{
    
    
    NSDate *startdate = [UIUtils dateFromGivenGMTString:sDate WithFormat:@"EEEddMMMyyyy HH:mm:ss"];
    
    NSString *startDateString = [UIUtils stringFromGivenGMTDate:startdate WithFormat:@"EEEddMMMyyyy"];

    
    NSString *requestName = [NSString stringWithFormat:@"GetAllProgramsForCategory%@%@",categoryType,startDateString];

    NSString *cacheDataResponse = [self getCacheDataFor:requestName];
    
    DLog(@"%@", requestName);
    
    if ([cacheDataResponse isStringPresent])
    {
        [self parseProgramsDetails:cacheDataResponse For:@"GetAllProgramsForCategory"];
    }
    else
    {
        AppDelegate_iPhone * appDelegate = DELEGATE;
        
        NSMutableString *url = [[NSMutableString alloc] initWithString:BASEURL];
        
        [url appendString:@"/search?"];

        [url appendFormat:@"categories=%@",categoryType];

        [url appendFormat:@"&channels=%@",channnelId];
        
        NSString *currentStartDate = sDate;
        
        if(currentStartDate != nil) {
            
            currentStartDate = [currentStartDate stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            [url appendFormat:@"&start=%@+GMT",currentStartDate];
        }
        
        NSString *currentEndDate = eDate;
        
        if(currentEndDate != nil) {
            
            currentEndDate = [currentEndDate stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
            [url appendFormat:@"&end=%@+GMT",currentEndDate];
        }    
        
        DLog(@"new url : %@",url);

        [super setCache:NO];
        
        [super.networkRequest clearDelegatesAndCancel];
        
        [super requestDataWithURL:url UsingToken:appDelegate.authenticationToken UsingData:nil andRequestName:requestName withRequestType:GET_REQUEST];
        

        
        
    }
    
}


- (void)getProgramDetails:(NSString*)programIDs forType:(NSString*)type forDate:(NSString*)startDate 

  {
      
    BOOL  callServerRequest = NO;
      
      
    NSString *requestName  = type;
      
    if ( ![type isEqualToString:@"GetProgramDetails"]) {
          
        NSDate *startdate = [UIUtils dateFromGivenGMTString:startDate WithFormat:@"EEEddMMMyyyy HH:mm:ss"];
        
        NSString *startDateString = [UIUtils stringFromGivenGMTDate:startdate WithFormat:@"EEEddMMMyyyy"];
        
        requestName = [NSString stringWithFormat:@"%@%@%@",type,programIDs,startDateString];
        
        NSString *cacheDataResponse = [self getCacheDataFor:requestName];
        
        if ([cacheDataResponse isStringPresent]) {
            
            [self parseProgramsDetails:cacheDataResponse For:type];
            
        } else {

            callServerRequest = YES;

        }        
    
    } else {
      
        callServerRequest = YES;
    }
      
      
      if (callServerRequest) {
          
          
          AppDelegate_iPhone * appDelegate = DELEGATE;
          
          NSMutableString *url = [[NSMutableString alloc] initWithString:BASEURL];
          
          [url appendString:@"/programs/"];
          
          [url appendFormat:@"%@", programIDs];
          
          DLog(@"getProgramDetails ******************** new url : %@",url);
          
          [super setCache:NO];
          
          
          [super requestDataWithURL:url UsingToken:appDelegate.authenticationToken UsingData:nil andRequestName:requestName withRequestType:GET_REQUEST];
          
          
      }
    
}



-(void)postFailed:(ASIHTTPRequest *)request {	
    
	DLog(@"Error : %@",[request error]);
    
    if ([[request responseString] isKindOfClass:[NSNull class]] || [request responseString] == nil) {
        
        [UIUtils alertView:[[request error] localizedDescription] withTitle:@"Programs"];
        
    } else {
        
        [UIUtils alertView:[request responseString] withTitle:@"Programs"];
        
    }
}

#pragma mark -
#pragma mark Proxy Delegate Methods

-(void)postSuccess:(ASIHTTPRequest *)request
{
    DLog(@"Requested URL: %@", [request.url absoluteString]);
    DLog(@"Original URL: %@", [request.originalURL absoluteString]);
    DLog(@"Request Headers: %@", request.requestHeaders);
    DLog(@"Post body: %@", request.postBody);
    
    //DLog(@"postSuccess : %@",[request responseString]);
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    NSString *proUserRequiredResponse = [[NSString alloc] initWithFormat:@"This resource requires you to authorize with a 'pro' or equivalent account. '<%@>' is not good enough.",appDelegate.user.email];

    
	DLog(@"Response : %@",[request responseString]);
	
	NSDictionary *userInfo = [request userInfo];
    
	NSString *reqName = [userInfo valueForKey:@"RequestName"];
    
    NSString *expiryTag = [[request responseHeaders] valueForKey:@"Expires"];
    
    DLog(@"expiryTag : %@",expiryTag);

    
	if ([reqName isEqualToString:@"SearchPrograms"]) {		
		        
        [self parseProgramsDetails:[request responseString] For:@"SearchPrograms"];
	
    } else if ([reqName isEqualToString:@"GetAllPrograms"]) {		
		
        [self parseProgramsDetails:[request responseString] For:@"GetAllPrograms"];
        
	} else if ([reqName isEqualToString:proUserRequiredResponse]) {
        
        [programProxyDelegate programProUserRequired];
        
    } else if ([reqName isEqualToString:@"GetProgramDetails"]) {
        
        [self parseProgramsDetails:[request responseString] For:@"GetProgramDetails"];
        
    } else {
        
        [self addDataInCache:reqName forData:[request responseString] andEtag:expiryTag];
        
        
        if ([reqName contains:@"GetAllProgramsForChannel"]) {		
            
            [self parseProgramsDetails:[request responseString] For:@"GetAllProgramsForChannel"];
            
        } else if ([reqName contains:@"GetAllProgramsForCategory"]) {	
            
            [self parseProgramsDetails:[request responseString] For:@"GetAllProgramsForCategory"];
            
        } else if ([reqName contains:@"GetProgramDetailsForChannel"]) {
            
            [self parseProgramsDetails:[request responseString] For:@"GetProgramDetailsForChannel"];
            
        } else if ([reqName contains:@"GetProgramDetailsForCategory"]) {
            
            [self parseProgramsDetails:[request responseString] For:@"GetProgramDetailsForCategory"];
        }
        
    }
        
}



#pragma mark -
#pragma mark Parse Programs data

- (void)parseProgramsDetails:(NSString *)responseStr For:(NSString*)queryType {
    

	NSDictionary *mainDict = [responseStr JSONValue];
    
	id programArray = [mainDict objectForKey:@"program"];
    
    BOOL deadProgramRemoved = NO;
    
	NSMutableArray *programsDetailsArray = [[NSMutableArray alloc] init];
    
	if([programArray isKindOfClass:[NSMutableArray class]]) {
        
		if([programArray count] != 0 && programArray != nil) {										
            
			for(NSDictionary *dict in programArray) {
                
                @autoreleasepool {

                Program *programObj = [self programDetails:dict];
                
                if (deadProgramRemoved == NO) {
                
                    if ([self isProgramAlive:programObj forType:queryType]) {
                     
                        [programsDetailsArray addObject:programObj];
                        
                        deadProgramRemoved = YES;
                    
                    } 
                    
                } else {
                    
                    [programsDetailsArray addObject:programObj];
                    
                }
                
                }
                
			}						
		}
	}
    
    if ([programArray isKindOfClass:[NSDictionary class]]) {
            
        @autoreleasepool {

                    Program *programObj = [self programDetails:programArray];
                                
                        if ([self isProgramAlive:programObj forType:queryType]) {
                            
                            [programsDetailsArray addObject:programObj];
                        }
                                        
                    
        }
    
     }

    
    if ([programsDetailsArray count] > 0) { 
 
        if(programProxyDelegate && [programProxyDelegate respondsToSelector:@selector(receivedProgramsForChannel:ForType:)]) {
                
                [programProxyDelegate receivedProgramsForChannel:programsDetailsArray ForType:queryType];
        }
    
    } else {
                
        if(programProxyDelegate && [programProxyDelegate respondsToSelector:@selector(noProgramRecordsFound)]) {
            
            [programProxyDelegate noProgramRecordsFound];
        }
        
    }
    
    

}


- (BOOL)isProgramAlive:(Program*)program forType:(NSString*)type {
    
    if ([type isEqualToString:@"SearchPrograms"] || [type isEqualToString:@"GetAllPrograms"] || [type isEqualToString:@"GetProgramDetails"]) {
        
        return YES;
        
    } else {
        
        
        NSDate *programEndDate = [UIUtils dateFromGivenGMTString:program.end WithFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
        
        NSString *todaysCurrentString = [UIUtils stringFromGivenGMTDate:[NSDate date] WithFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
        
        NSDate *currentDate = [UIUtils dateFromGivenGMTString:todaysCurrentString WithFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
        
        
        DLog(@"program.end  STRING GMT  %@",program.end);
        
        DLog(@"program.end DATE GMT  %@",programEndDate);
        
                
        DLog(@"TODAYS DATE STRING GMT   %@",todaysCurrentString);
        
        DLog(@"TODAYS DATE GMT   %@",currentDate);
        
        
        int  value = [programEndDate compare:currentDate];
        
        DLog(@"Date Value %d",value);
        
        if (value > 0) {
            
            return YES;
            
        } else {
            
            return NO;

        }
 
  }

}

- (Program*)programDetails:(NSDictionary*)dic {
    
    DLog(@"dic:%@",dic);
    
    Program *program = [[Program alloc] init];
    
    program.programId = [dic objectForKey:@"@id"];
    
    program.id = [[dic objectForKey:@"@id"] intValue];
    
    program.channel = [[dic objectForKey:@"@channel"] intValue];
    
    DLog(@"program.programId:%@",program.programId);
    
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
    
    
    NSDictionary *categoryDict = [dic objectForKey:@"category"];
    
    if([categoryDict isDictionaryExist]) {
        
        NSDictionary *typeDict = [categoryDict objectForKey:@"type"];
        program.type = [typeDict objectForKey:@"$"];
        
        NSDictionary *genreDict = [categoryDict objectForKey:@"genre"];
        
        if([genreDict isDictionaryExist]) {
            program.genre = [genreDict objectForKey:@"$"];
        }
        
    }
    
    
    
    NSDictionary *episodeDict = [dic objectForKey:@"episode"];
    
    if([episodeDict isDictionaryExist]) {
        
        program.episode = [episodeDict objectForKey:@"$"];
        
    } 
    
    
    NSDictionary *aboutDict = [dic objectForKey:@"about"];
    
    if([aboutDict isDictionaryExist]) {
        
        program.summary = [aboutDict objectForKey:@"$"];
        
    } 
    
    
    NSDictionary *teaserDict = [dic objectForKey:@"teaser"];
    
    if([teaserDict isDictionaryExist]) {
        
        program.teaser = [teaserDict objectForKey:@"$"];
    }
    
    
    NSDictionary *castDict = [dic objectForKey:@"cast"];
    
    if([castDict isDictionaryExist]) {
        
        program.cast = [castDict objectForKey:@"$"];
    }
    
    NSDictionary *yearDict = [dic objectForKey:@"year"];
    
    if([yearDict isDictionaryExist]) {
        
        program.year = [yearDict objectForKey:@"$"];
    }
    
    NSDictionary *countryDict = [dic objectForKey:@"country"];
    
    if([countryDict isDictionaryExist]) {
        
        program.country = [countryDict objectForKey:@"$"];
    }
    
    
    NSDictionary *linkDict = [dic objectForKey:@"link"];
    
    if([linkDict isDictionaryExist]) {
        
        program.link = [linkDict objectForKey:@"$"];
    }
    
    NSDictionary *imgDict = [dic objectForKey:@"img"];
    
    if([imgDict isDictionaryExist]) {
        
        program.imgSrc = [imgDict objectForKey:@"@src"];
    }
    
    
    return program;
    
}


#pragma mark -
#pragma mark Cache Data Method

- (NSString*)getCacheDataFor:(NSString*)dataType {
    
    CacheRepository *cacheRepository = [[CacheRepository alloc] init];
    
    NSString *cacheresponse = [cacheRepository getCacheDataForDataType:dataType];
    
    
    return cacheresponse;
}

- (void)addDataInCache:(NSString*)dataType forData:(NSString*)cacheDataString andEtag:(NSString*)expiryDate {
    
    CacheRepository *cacheRepository = [[CacheRepository alloc] init];
    
    [cacheRepository insertCacheDataForType:dataType andCacheDate:cacheDataString andExpiryTag:expiryDate];
    
    
}


@end
