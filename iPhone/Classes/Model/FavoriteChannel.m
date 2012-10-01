

#import "FavoriteChannel.h"
#import "NSDictionary+NSNullHandler.h"
#import "AppDelegate_iPhone.h"

@implementation FavoriteChannel

@synthesize channel_id;
@synthesize channel_order;
@synthesize user_id;
@synthesize favorite_id;


-(NSDictionary *) jsonMapping {
	
	return [[NSDictionary alloc] initWithObjectsAndKeys:
			 @"channel_id",@"@id",
			 @"channel_order",@"@order",					  
			 nil];
}	

+(FavoriteChannel *)favoriteChannelFromDictionary:(NSDictionary *)dictionary andUserId:(int) userId {
	
	if ([dictionary isDictionaryExist]) {
		FavoriteChannel *favoriteChannel = [[FavoriteChannel alloc] init];
		NSDictionary *mapping = [favoriteChannel jsonMapping];
		for (NSString *attribute in [mapping allKeys]){
			NSString *classProperty = [mapping objectForKey:attribute];			
			NSString *attributeValue = [dictionary objectForKey:attribute];
			if (attributeValue!=nil&&!([attributeValue isKindOfClass:[NSNull class]])) {
				[favoriteChannel setValue:attributeValue forKeyPath:classProperty];
			}			
		}		
		favoriteChannel.user_id = userId;
		return favoriteChannel;
	}
	else {
		return nil;
	}	
}


@end
