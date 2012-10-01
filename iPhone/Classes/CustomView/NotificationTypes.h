

#import <Foundation/Foundation.h>

@interface NotificationTypes : NSObject

+ (NSString*)getReminderType:(NSString*)type;
+ (NSString*)getReminderTypeForServer:(NSString*)type;

+ (NSString*)getAgentSearchTitleCriteriaType:(NSString*)type;
+ (NSString*)getAgentSearchTitleCriteriaTypeForServer:(NSString*)type;

+ (NSString*)getAgentSearchTypeCriteriaType:(NSString*)type;
+ (NSString*)getAgentSearchTypeCriteriaTypeForServer:(NSString*)type; 

+ (NSString*)getProUserAgentDayType:(NSString*)type;
+ (NSString*)getProUserAgentDayTypeForServer:(NSString*)type;

@end
