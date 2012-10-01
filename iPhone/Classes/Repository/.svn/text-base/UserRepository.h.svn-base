

#import <Foundation/Foundation.h>
#import "DataBaseHelper.h"

@class User;

#define UserTable @"User"

@interface UserRepository : DataBaseHelper {
	NSString *SELECT_QUERY;
	NSString *INSERT_QUERY;
	NSString *UPDATE_QUERY;
	NSString *DELETE_QUERY;	
}

-(BOOL) saveNewUser:(User *)newUser;

-(NSMutableArray *)getUsersFromDB;

-(int)getUserIdFromDBWithUserName:(NSString *)theUserName;

-(void)deleteUser:(NSString *)theUserName;

-(void)updateUserSummaryListingStatus:(NSString *)status;

@end
