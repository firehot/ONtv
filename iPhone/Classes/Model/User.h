

#import <Foundation/Foundation.h>


@interface User : NSObject {
    
	int user_id;
	
    NSString *email;
	
    NSString *name;
	
    NSString *phone;
	
    NSString *password;
	
    NSString *subscription;
    
    NSArray *channels;
    
    NSString *img;
}

@property (nonatomic, assign) int user_id;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *password;

@property (nonatomic, copy) NSString *subscription;

@property (nonatomic, copy) NSArray *channels;

@property (nonatomic, copy) NSString *deviceSummaryListing;

@property (nonatomic, copy) NSString *defaultReminderType;

@property (nonatomic, copy) NSString *defaultReminderTime;

@property (nonatomic, copy) NSString *defaultReminderbeforeType;

@property (nonatomic, copy) NSString *defaultHoursType;

@property (nonatomic, copy) NSString *defaultDaysType;



-(NSDictionary *) jsonMapping;

+(User *)userFromDictionary:(NSDictionary *)dictionary;

-(BOOL)save;

+(NSArray *)getUserFromDB;

+(void)deleteUser:(NSString *)theUserName;

@end
