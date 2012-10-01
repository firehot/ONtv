

#import "User.h"
#import "NSDictionary+NSNullHandler.h"
#import "UserRepository.h"

@implementation User

@synthesize user_id;

@synthesize email;

@synthesize name;

@synthesize phone;

@synthesize password;

@synthesize subscription;

@synthesize channels;

@synthesize deviceSummaryListing = _deviceSummaryListing;

@synthesize defaultReminderType = _defaultReminderType;

@synthesize defaultReminderTime = _defaultReminderTime;

@synthesize defaultReminderbeforeType = _defaultReminderbeforeType;

@synthesize defaultHoursType = _defaultHoursType;

@synthesize defaultDaysType = _defaultDaysType;



-(NSDictionary *) jsonMapping {
	
	return [[NSDictionary alloc] initWithObjectsAndKeys:
			 @"email",@"email",
			 @"name",@"name",
			 @"phone",@"phone",
			 @"password",@"password",
			 @"subscription",@"subscription",			  
			 nil];
}	

-(NSString *)description {	
    
	return [NSString stringWithFormat:
			@"\nuserId /nemail : %d \nname : %@ \nemail : %@ \nphone : %@ \npassword : %@ \nsubscription : %@"
			,self.user_id,self.email,self.name,self.phone,self.password,self.subscription];
}


+(User *)userFromDictionary:(NSDictionary *)dictionary {
	
	if ([dictionary isDictionaryExist]) {
		User *user = [[User alloc] init];
		NSDictionary *mapping = [user jsonMapping];
		for (NSString *attribute in [mapping allKeys]){
			NSString *classProperty = [mapping objectForKey:attribute];			
			NSDictionary *dict = [dictionary objectForKey:attribute];
			NSString *attributeValue = [dict objectForKey:@"$"];
			if (attributeValue!=nil&&!([attributeValue isKindOfClass:[NSNull class]])) {
				[user setValue:attributeValue forKeyPath:classProperty];
			}			
		}		
        
        NSDictionary *subscriptionDict = [dictionary objectForKey:@"subscription"];
		user.subscription = [subscriptionDict objectForKey:@"@type"];
		DLog(@"User : %@",[user description]);
        
    
        NSDictionary *settingsDict = [dictionary objectForKey:@"settings"];
		NSDictionary *settingInnerDict = [settingsDict objectForKey:@"setting"];
        user.deviceSummaryListing = [settingInnerDict objectForKey:@"@value"];
        
        
        NSDictionary *reminderDict = [dictionary objectForKey:@"reminder"];
        
        if ([reminderDict isDictionaryExist]) {
		
            user.defaultReminderType = [reminderDict objectForKey:@"@method"];
            
            user.defaultReminderTime = [reminderDict objectForKey:@"@before"];
            
            user.defaultReminderbeforeType = [reminderDict objectForKey:@"@multiplier"];
            
            user.defaultHoursType = [reminderDict objectForKey:@"@hours"];
            
            user.defaultDaysType = [reminderDict objectForKey:@"@days"]; 
            
        }
        
    
		DLog(@"User : %@",[user description]);
        
		[user save];
        
		return user;
	}
	else {
		return nil;
	}	
}


-(BOOL)save {
    
	UserRepository *repository = [[UserRepository alloc] init];
	
	BOOL temp = [repository saveNewUser:self];
	
	
	return temp;
	
}

+(NSArray *)getUserFromDB {
	
	UserRepository *repository = [[UserRepository alloc] init];
    
	NSArray *usersArray = [repository getUsersFromDB];
	
	
	return usersArray;
	
}

+(void)deleteUser:(NSString *)theUserName {
	
	UserRepository *repository = [[UserRepository alloc] init];
	
	[repository deleteUser:theUserName];
	
	
}

@end
