


#import <Foundation/Foundation.h>
#import "Proxy.h"

@protocol ChannelProxyDelegate <NSObject>
@required
-(void)channelDataFailed:(NSString *)error;

@optional

- (void)getAllChannelList :(BOOL)reloadTable;

- (void)getAllChannels :(NSMutableArray *)array;

- (void)getImage :(NSData *)data;

- (void)postDataSuccess : (NSString *) response;

- (void)channelProUserRequired;

- (void)noChannelsRecordsFound;

- (void)receivedDefaultFavoriteChannels:(NSMutableArray*)defaultFavoriteChannels;

- (void)receivedAllChannnel:(NSMutableArray*)channelArray; 

@end

@interface ChannelProxy : Proxy {
	id<ChannelProxyDelegate>__weak channelProxyDelegate;
}

@property (nonatomic, weak) id<ChannelProxyDelegate>channelProxyDelegate;

- (void)getChannelsFor:(NSString*)viewType;

- (void)getImageWithFilePath : (NSString *)filePath;

- (void)getChannelsWithChannelIds : (NSMutableArray *) idArray;

- (void)postChannelsWithSessionKey:(NSString *)sessionKey andUsername : (NSString *)username andChannels:(NSDictionary *)channels;

- (void)deleteChannelsWithSessionKey:(NSString *)sessionKey andUsername : (NSString *)username andChannels:(NSDictionary *)channels;

- (void)postChannels:(NSString *)responseStr;

- (void)getDefaultFavoriteChannels;

- (void)parseDefaultFavoriteChannels:(NSString*)responseString;

- (void)parseChannels:(NSString *)responseStr forView:(NSString*)viewType;

@end
