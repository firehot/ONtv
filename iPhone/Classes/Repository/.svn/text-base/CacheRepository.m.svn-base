

#import "CacheRepository.h"
#import "UIUtils.h"
#import "NSString+utility.h"

@implementation CacheRepository


- (NSString*)getCacheDataForDataType:(NSString*)type  {
    
    
	NSString *query = @"SELECT cache_data ,expiry_tag FROM cache_all WHERE user = ? AND email = ? AND data_type = ?";
    
    AppDelegate_iPhone * appDelegate = DELEGATE;
    
    FMResultSet *rs;
    
    if ([appDelegate isGuest]) {
        
        rs = [db executeQuery:query,@"GUEST",@"GUEST",type];

        
    } else {
        
        rs = [db executeQuery:query,appDelegate.user.subscription,appDelegate.user.email,type];

    }

	
	if([db hadError]) {
		
		NSLog(@"Err %d: %@",[db lastErrorCode], [db lastErrorMessage]);
		
	} 
    
    NSString *cacheDataString  = nil;
    NSString *expiryTag = nil;	
    
	while ([rs next]) {
		        
        cacheDataString = [rs stringForColumn:@"cache_data"];
        
        expiryTag = [rs stringForColumn:@"expiry_tag"];
        
        if (![cacheDataString  isStringPresent] ) {
        
            [self deleteCacheDataForType:type];

            cacheDataString = nil;
            
        } 
        
        if ([cacheDataString  isEqualToString:@"{}"] ) {
            
            [self deleteCacheDataForType:type];
            
            cacheDataString = nil;
            
        } 
        
        if (![expiryTag isStringPresent]) {
            
            [self deleteCacheDataForType:type];

            expiryTag = nil;
        
        } 
    }
	
	[rs close];
    
    //Wed, 14 Mar 2012 19:35:00 GMT
    
    
    if  (expiryTag == nil) {
        
        return nil;
    
    } else {
    
         NSDate *expiryDate = [UIUtils dateFromGivenGMTString:expiryTag WithFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
        
         NSString *toDaysString = [UIUtils stringFromGivenGMTDate:[NSDate date] WithFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
        
         NSDate *toDaysDate = [UIUtils dateFromGivenGMTString:toDaysString WithFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
        
        
        DLog(@"Expiry DATE STRING GMT  %@",expiryTag);
        
        DLog(@"Expiry DATE GMT  %@",expiryDate);


        DLog(@"TODAYS DATE LOCAL   %@",[NSDate date]);

        DLog(@"TODAYS DATE STRING GMT   %@",toDaysString);

        DLog(@"TODAYS DATE GMT   %@",toDaysDate);


        int  value = [expiryDate compare:toDaysDate];
        
        DLog(@"Date Value %d",value);
        
            if (value > 0) {
                
                return cacheDataString; 

            } else {
                
                [self deleteCacheDataForType:type];
                
                return nil; 
            }
        
  }
    
}



- (void)deleteCacheDataForType:(NSString*)type {
    
        NSString *query = @"DELETE  FROM cache_all WHERE  user = ? AND email = ? AND data_type = ?";

        AppDelegate_iPhone * appDelegate = DELEGATE;

        if ([appDelegate isGuest]) {
            
            [db executeUpdate:query,@"GUEST",@"GUEST",type];
            
            
        } else {
            
            [db executeUpdate:query,appDelegate.user.subscription,appDelegate.user.email,type];
            
        }

        if ([db hadError]) {
            
            NSLog(@"Err %d: %@",[db lastErrorCode], [db lastErrorMessage]);
        }	
    
    
    
}


- (void)insertCacheDataForType:(NSString*)type andCacheDate:(NSString*)cacheDate andExpiryTag:(NSString*)expiryTag {
    
        NSString *query = @"INSERT  INTO  cache_all (user, email, data_type, cache_data, expiry_tag)  VALUES  (?,?,?,?,?)";
        
        AppDelegate_iPhone * appDelegate = DELEGATE;
        
        
        if ([appDelegate isGuest]) {
            
            [db executeUpdate:query,@"GUEST",@"GUEST",type,cacheDate,expiryTag];
            
            
        } else {
            
             [db executeUpdate:query,appDelegate.user.subscription,appDelegate.user.email,type,cacheDate,expiryTag];
            
        }
        
        if ([db hadError]) {
            
            NSLog(@"Err %d: %@",[db lastErrorCode], [db lastErrorMessage]);
        }	
    
}


@end
