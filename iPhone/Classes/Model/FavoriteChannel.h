

#import <Foundation/Foundation.h>


@interface FavoriteChannel : NSObject {
	int favorite_id;
	int user_id;
	int channel_id;
	int channel_order;
}

@property (nonatomic, assign) int favorite_id;
@property (nonatomic, assign) int user_id;
@property (nonatomic, assign) int channel_id;
@property (nonatomic, assign) int channel_order;

-(NSDictionary *) jsonMapping;
+(FavoriteChannel *)favoriteChannelFromDictionary:(NSDictionary *)dictionary andUserId:(int) userId;

@end
