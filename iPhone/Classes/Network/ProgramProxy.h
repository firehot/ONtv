

#import <Foundation/Foundation.h>
#import "Proxy.h"

@protocol ProgramProxyDelegate <NSObject>
@required

- (void)programDataFailed:(NSString *)error;


@optional

- (void)receivedProgramsForChannel:(id)objects ForType:(NSString*)queryType; 

- (void)programProUserRequired;

- (void)noProgramRecordsFound;

@end

@interface ProgramProxy : Proxy {
    
	id<ProgramProxyDelegate>__weak programProxyDelegate;
    
}

@property (nonatomic, weak) id<ProgramProxyDelegate>programProxyDelegate;


- (void)getProgramsWithProgramName : (NSString *) programName andChannelIds : (NSMutableArray *) idArray  andStartDate : (NSString *) startDate  andEndtDate : (NSString *) endDate;

- (void)getProgramDetails:(NSString*)programIDs forType:(NSString*)type forDate:(NSString*)startDate;


- (void)getProgramsForChannelId:(int)channnelId AndStartDate:(NSString*)sDate AndEndDate:(NSString*)eDate;


- (void)getRecommendedProgramsForFavoriteChannelWithChannelId:(NSString*)channnelId AndStartDate:(NSString*)sDate AndEndDate:(NSString*)eDate;

- (void)getProgramsForCategory:(NSString*)categoryType andFavoriteChannelIds:(NSString*)channnelId AndStartDate:(NSString*)sDate AndEndDate:(NSString*)eDate;



@end
