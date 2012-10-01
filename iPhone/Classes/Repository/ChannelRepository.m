
#import "ChannelRepository.h"
#import "FavoriteChannel.h"

@implementation ChannelRepository


- (id) init
{
	self = [super init];
    
	if (self != nil) {
 
	}
	return self;
}






-(void)deleteDefaultFavoriteChannelFromDB:(int)channelId {
    
    NSString *query = @"DELETE FROM DefaultFavorite WHERE channel_id = ?";

	
	[db executeUpdate:query,[NSNumber numberWithInt:channelId]];
    
    if ([db hadError]) {
        
        NSLog(@"Err %d: %@",[db lastErrorCode], [db lastErrorMessage]);
    }
	
}


- (NSMutableArray*)getDefaultFavoriteChannelFromDB  {

    
	NSString *query = @"Select * FROM DefaultFavorite";
	
	FMResultSet *rs  = [db executeQuery:query];
	
	
	if([db hadError]) {
		
		NSLog(@"Err %d: %@",[db lastErrorCode], [db lastErrorMessage]);
		
	} 
    
	NSMutableArray *channelArray = [[NSMutableArray alloc]init];
	
	while ([rs next]) {
		
                
            FavoriteChannel *favoriteChannel = [[FavoriteChannel  alloc]init];
            
            favoriteChannel.channel_id = [rs intForColumn:@"channel_id"];
            favoriteChannel.channel_order = [rs intForColumn:@"channel_order"];
            
            [channelArray addObject:favoriteChannel];
    }
	
	[rs close];
	
	return channelArray; 
	
}	



- (void)updateDefaultFavoriteChannelFromDB:(int)channelID andChannelOrder:(int)channelOrder {
    
    NSString *query = @"UPDATE DefaultFavorite SET channel_order = ? WHERE channel_id = ?";
    
	[db executeUpdate:query,[NSNumber numberWithInt:channelOrder],[NSNumber numberWithInt:channelID]];
    
    if ([db hadError]) {
        
        NSLog(@"Err %d: %@",[db lastErrorCode], [db lastErrorMessage]);
    }
    
}


- (void)addDefaultFavoriteChannelFromDB:(int)channelID andChannelOrder:(int)channelOrder {
    
    NSString *query = @"INSERT INTO DefaultFavorite(channel_order,channel_id) VALUES(?,?)";
    
	[db executeUpdate:query,[NSNumber numberWithInt:channelOrder],[NSNumber numberWithInt:channelID]];
    
    if ([db hadError]) {
        
        NSLog(@"Err %d: %@",[db lastErrorCode], [db lastErrorMessage]);
    }
    
}


@end
