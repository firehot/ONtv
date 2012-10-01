
#import <Foundation/Foundation.h>


@interface Program : NSObject {
	int id;
    NSString *programId;
	int channel;
	NSString *type;
	NSString *start;
	NSString *end;
	NSString *title;
}

@property (nonatomic, assign) int id;
@property (nonatomic, assign) int channel;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *start;
@property (nonatomic, copy) NSString *end;
@property (nonatomic, copy) NSString *title;


@property (nonatomic, copy) NSString  *programId;
@property (nonatomic, copy) NSString *teaser;
@property (nonatomic, copy) NSString *imgSrc;
@property (nonatomic, copy) NSString *genre;
@property (nonatomic, copy) NSString *originalTitle;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *cast;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *episode;
@property (nonatomic, copy) NSString *remiderType;
@property (nonatomic, copy) NSString *remiderProgramStartTime;
@property (nonatomic, copy) NSString *agentID;


@property (nonatomic, assign) int agentId;



+(Program *)programFromDictionary:(NSDictionary *)dictionary;
+(Program *)searchedProgramsFromDictionary:(NSDictionary *)dictionary;

- (NSInteger) lengthOfProgramInMins;
- (NSInteger) timeOfProgramSinceNowInMins;

@end
