
#import "DataBaseHelper.h"
#import "NSString+utility.h"
/*
 UPDATE table_name
 SET column1=value, column2=value2,...
 WHERE some_column=some_value 
*/


@implementation DataBaseHelper

- (id)init {
    if (self = [super init]) {
       
    }
    return self;
}

- (void)dealloc {
    
    [super dealloc];
}



#pragma mark -
#pragma mark get Table columns 

-(NSMutableArray *)getColumnListForTable:(NSString *)tableName {
	
	NSString *queryString = [NSString stringWithFormat:@"PRAGMA table_info(%@)", tableName];
	
	FMResultSet * resultSet = [db executeQuery:queryString];
	NSMutableArray *listOfColumns = [[[NSMutableArray alloc] init] autorelease];
	while ([resultSet next]) {
		
		[listOfColumns addObject:[resultSet stringForColumn:@"name"]];
		//DLog(@"tableName: %@ Column name: %@ ", tableName, [resultSet stringForColumn:@"name"]);
		
	}
	
	
	return listOfColumns;
	
}

#pragma mark -
#pragma mark get Table column DATA TYPES 

-(NSMutableArray *)getColumnDataTypeListForTable:(NSString *)tableName {
	
	NSString *queryString = [NSString stringWithFormat:@"PRAGMA table_info(%@)", tableName];
	
	FMResultSet * resultSet = [db executeQuery:queryString];
	NSMutableArray *listOfColumns = [[[NSMutableArray alloc] init] autorelease];
	while ([resultSet next]) {
		
		NSMutableDictionary *dataTypeForColumn = [[NSMutableDictionary alloc] init];
		
		NSString *value = [resultSet stringForColumn:@"type"];
		
		NSString *key = [resultSet stringForColumn:@"name"];
		
		[dataTypeForColumn setValue:value forKey:key];		
		
		[listOfColumns addObject: dataTypeForColumn];

		[dataTypeForColumn release];	
		
	}
	
	
	return listOfColumns;
}


#pragma mark -
#pragma mark get Select Query For Table 

-(NSString *)getSelectQueryForTable:(NSString *)tableName {

	NSMutableArray *columnsArray = [self getColumnListForTable:tableName];
	NSString *selectStr = @"SELECT";
	NSString *fromStr = [NSString stringWithFormat:@"FROM %@", tableName];
	NSString *queryBody = @"";
	
	for (int i = 0; i<[columnsArray count]; i++) {
		
			if (i == ([columnsArray count] - 1)) {
				
				queryBody = [NSString stringWithFormat:@"%@ %@ ", queryBody, [columnsArray objectAtIndex:i]];
				
			} else {

				queryBody = [NSString stringWithFormat:@"%@ %@, ", queryBody, [columnsArray objectAtIndex:i]];

				
			}


		
		
	}
	
	NSString *queryString = [NSString stringWithFormat:@"%@ %@%@", selectStr, queryBody, fromStr];	



	return queryString;

}


#pragma mark -
#pragma mark get insertQueryForTable 
-(NSString *)getInsertQueryForTable:(NSString *)tableName {
	
	
	NSMutableArray *columnsArray = [self getColumnListForTable:tableName];
	NSString *headStr = [NSString stringWithFormat:@"INSERT INTO %@ ", tableName];
	NSString *tellStr = @"VALUES";
	NSString *queryBody = @"(";
	NSString *valuesBody = @"(";
	
	for (int i = 0; i<[columnsArray count]; i++) {
		
		if (i == ([columnsArray count] - 1)) {
			
			queryBody = [NSString stringWithFormat:@"%@%@%@", queryBody, [columnsArray objectAtIndex:i], @")"];
			valuesBody = [valuesBody stringByAppendingString:@" ?"];
			valuesBody = [valuesBody stringByAppendingString:@" )"];
			
		} else {
			
			queryBody = [NSString stringWithFormat:@"%@%@, ", queryBody, [columnsArray objectAtIndex:i]];
			valuesBody = [valuesBody stringByAppendingString:@" ?,"];
			
		}
		
		
	
		
	}
	
	NSString *queryString = [NSString stringWithFormat:@"%@ %@ %@ %@", headStr, queryBody, tellStr, valuesBody];	

	
	
	return queryString;
	
}


#pragma mark -
#pragma mark get updateQueryForTable 

-(NSString *)getUpdateQueryForTable:(NSString *)tableName {
			
	NSMutableArray *columnsArray = [self getColumnListForTable:tableName];
	NSString *headStr = [NSString stringWithFormat:@"UPDATE %@ ", tableName];
	NSString *SetterBody = @"SET ";
		
	for (int i = 1; i<[columnsArray count]; i++) {
		
		if (i == ([columnsArray count] - 1)) {
			
			SetterBody = [SetterBody stringByAppendingString:[columnsArray objectAtIndex:i]];
			SetterBody = [SetterBody stringByAppendingString:@" = ?"];
			
			SetterBody = [SetterBody stringByAppendingString:@" WHERE "];
			
		} else {
			
			
			SetterBody = [SetterBody stringByAppendingString:[columnsArray objectAtIndex:i]];
			SetterBody = [SetterBody stringByAppendingString:@" = ?"];
			SetterBody = [SetterBody stringByAppendingString:@", "];
			
			
		}		
		
				
	}
	
		
	NSString *queryString = [NSString stringWithFormat:@"%@%@", headStr, SetterBody];	

	//DLog(@"UpdateQuery %@", queryString);
	
	return queryString;
	
}

#pragma mark -
#pragma mark get deleteQueryForTable 
-(NSString *)getDeleteQueryForTable:(NSString *)tableName {

	NSString *queryString = [NSString stringWithFormat:@"UPDATE SET record_status = 'D' FROM %@ WHERE ", tableName];
		
	return queryString ;
	
}




#pragma mark -
#pragma mark date Utilites 

-(NSDate*)dateFromString:(NSString *)dateString withDateFormat:(NSString *)dateFotmatString {
	
	NSDateFormatter *dateFormattor = [[NSDateFormatter alloc] init];
	
	if ([dateFotmatString isBlank] || (!dateFotmatString)) {
		dateFotmatString = defaultDateFormat;
	}
	[dateFormattor setDateFormat:dateFotmatString];
	
	NSDate *calculatedDate = [dateFormattor dateFromString:dateString];
	
	[dateFormattor release];
	return calculatedDate;
	
}

-(NSString*)stringFromDate:(NSDate *)theDate withDateFormat:(NSString *)dateFotmatString {
	
	NSDateFormatter *dateFormattor = [[NSDateFormatter alloc] init];
	
	if ([dateFotmatString isBlank] || (!dateFotmatString)){
		dateFotmatString = defaultDateFormat;
	}
	[dateFormattor setDateFormat:dateFotmatString];
	
	NSString *calculatedDate = [dateFormattor stringFromDate:theDate];
	
	[dateFormattor release];
	return calculatedDate;
	
}


-(NSDate *)dateFromDBStringDate:(NSString *)dateString {
	
	NSDateFormatter *fmt = [[NSDateFormatter alloc] init] ;
	[fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	[fmt setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
	NSDate *dateToReturn = nil;
	if(dateString != nil)
		dateToReturn = [fmt dateFromString:dateString] ;
	[fmt release];
	return dateToReturn;
}

+(NSDate *)dateFromDBStringDate:(NSString *)dateString {
	
	NSDateFormatter *fmt = [[NSDateFormatter alloc] init] ;
	[fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *dateToReturn = nil;
	if(dateString != nil)
		dateToReturn = [fmt dateFromString:dateString] ;
	[fmt release];
	return dateToReturn;
}
@end
