

#import "UserRepository.h"
#import "User.h"

@implementation UserRepository

- (id) init
{
	self = [super init];
	if (self != nil) {
		SELECT_QUERY = [self getSelectQueryForTable:UserTable];
		
		INSERT_QUERY = [self getInsertQueryForTable:UserTable];	
		
		UPDATE_QUERY = [self getUpdateQueryForTable:UserTable];		
		
		DELETE_QUERY = [self getDeleteQueryForTable:UserTable];
	}
	return self;
}


- (void) dealloc
{
	SELECT_QUERY = nil ;
	INSERT_QUERY = nil ; 
	UPDATE_QUERY = nil ;
	DELETE_QUERY = nil ;
}

#pragma mark -
#pragma mark User from ResultSet

-(User *) userFromResultSet: (FMResultSet *) resultSet {
	
	User *user = [[User alloc] init];
	[user setUser_id:[resultSet intForColumn:@"user_id"]];
	[user setName:[resultSet stringForColumn:@"name"]];
	[user setEmail:[resultSet stringForColumn:@"email"]];
	[user setPhone:[resultSet stringForColumn:@"phone"]];
	[user setPassword:[resultSet stringForColumn:@"password"]];
	[user setSubscription:[resultSet stringForColumn:@"subscription"]];
    [user setDeviceSummaryListing:[resultSet stringForColumn:@"deviceSummaryListing"]];
    [user setDefaultReminderType:[resultSet stringForColumn:@"defaultReminderType"]];
    [user setDefaultReminderTime:[resultSet stringForColumn:@"defaultReminderTime"]];
    [user setDefaultReminderbeforeType:[resultSet stringForColumn:@"defaultReminderbeforeType"]];
    [user setDefaultHoursType:[resultSet stringForColumn:@"defaultHoursType"]];
    [user setDefaultDaysType:[resultSet stringForColumn:@"defaultDaysType"]];


    
	
	return user;
	
}

+(User *) resultSetForUser:(FMResultSet *) resultSet {

	User *user = [[User alloc] init];
	[user setUser_id:[resultSet intForColumn:@"user_id"]];
	[user setName:[resultSet stringForColumn:@"name"]];
	[user setEmail:[resultSet stringForColumn:@"email"]];
	[user setPhone:[resultSet stringForColumn:@"phone"]];
	[user setPassword:[resultSet stringForColumn:@"password"]];
	[user setSubscription:[resultSet stringForColumn:@"subscription"]];
    [user setDeviceSummaryListing:[resultSet stringForColumn:@"deviceSummaryListing"]];
    [user setDefaultReminderType:[resultSet stringForColumn:@"defaultReminderType"]];
    [user setDefaultReminderTime:[resultSet stringForColumn:@"defaultReminderTime"]];
    [user setDefaultReminderbeforeType:[resultSet stringForColumn:@"defaultReminderbeforeType"]];
    [user setDefaultHoursType:[resultSet stringForColumn:@"defaultHoursType"]];
    [user setDefaultDaysType:[resultSet stringForColumn:@"defaultDaysType"]];

	
	return user;
	
}


#pragma mark -
#pragma mark Get user from Db with userName 


-(BOOL)getUserFromDBWithUserName:(NSString *)theUserName {
	
	NSString *selectQueryWithParameter = [NSString stringWithFormat:@"%@ WHERE name = ?", SELECT_QUERY];
	DLog(@"selectQueryWithParameter : %@",selectQueryWithParameter);
	FMResultSet * resultSet = [db executeQuery:selectQueryWithParameter, theUserName];
	
	BOOL isRecordPresent = NO;
	
	if ([resultSet next]) {
		isRecordPresent = YES;
	}
	
	return isRecordPresent ;
}


-(int)getUserIdFromDBWithUserName:(NSString *)theUserName {
	
    
	NSString *selectQueryWithParameter = [NSString stringWithFormat:@"%@ WHERE name = ?", SELECT_QUERY];
	DLog(@"selectQueryWithParameter : %@",selectQueryWithParameter);
	FMResultSet * resultSet = [db executeQuery:selectQueryWithParameter, theUserName];
	
	int searchedUser = -1;
	
	if ([resultSet next]) {
		
		searchedUser = [resultSet intForColumn:@"user_id"];
		
	}
	
	return searchedUser ;
}


-(void)updateUserSummaryListingStatus:(NSString *)status {
	
    AppDelegate_iPhone *appDelegate = DELEGATE;

    
    NSString *query = @"UPDATE User SET deviceSummaryListing = ? WHERE email = ?";
    
	[db executeUpdate:query,status,appDelegate.user.email];
    
    if ([db hadError]) {
        
        NSLog(@"Err %d: %@",[db lastErrorCode], [db lastErrorMessage]);
    } else {
        
        appDelegate.user.deviceSummaryListing = status;
        
    }
}

#pragma mark -
#pragma mark Get User from DB 

-(NSMutableArray *)getUsersFromDB {
	
	
	FMResultSet * resultSet = [db executeQuery:SELECT_QUERY];
	NSMutableArray *usersArray = [[NSMutableArray alloc] init];
	while ([resultSet next]) {
		
		[usersArray addObject:[self userFromResultSet:resultSet]];
		
	}	
	return usersArray;
	
}


#pragma mark -
#pragma mark Add new User 

-(BOOL) saveNewUser:(User *)newUser {	
	
	BOOL result = NO;

	BOOL checkUser = [self getUserFromDBWithUserName:newUser.name];
	DLog(@"INSERT_QUERY %@", INSERT_QUERY);
    
    DLog(@"%@",newUser.subscription);

	if (checkUser) {		
		
		NSString *updateQueryForUser = [NSString stringWithFormat:@"%@ user_id = ? ", UPDATE_QUERY];
		result = [db executeUpdate:updateQueryForUser, 
				  newUser.name, 
				  newUser.email, 
				  newUser.phone,
				  newUser.password,
				  newUser.subscription,
                  newUser.deviceSummaryListing,
                  newUser.defaultReminderType,
                  newUser.defaultReminderTime,
                  newUser.defaultReminderbeforeType,
                  newUser.defaultHoursType,
                  newUser.defaultDaysType,
				  [NSNumber numberWithInt:1]];		
		
	} else {
		
		result = [db executeUpdate:INSERT_QUERY,				  
				  newUser.user_id, 
				  newUser.name, 
				  newUser.email, 
				  newUser.phone,
				  newUser.password,
				  newUser.subscription,
                  newUser.deviceSummaryListing,
                  newUser.defaultReminderType,
                  newUser.defaultReminderTime,
                  newUser.defaultReminderbeforeType,
                  newUser.defaultHoursType,
                  newUser.defaultDaysType];		
	}	
    
    
	return result;
	
}

-(void)deleteUser:(NSString *)theUserName {
	
	[db executeUpdate:@"DELETE FROM User WHERE name = ?", theUserName];
	
}

@end
