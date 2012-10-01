

#import <Foundation/Foundation.h>
#import "AbstractRepository.h"
#import "FMDBUtils.h"
#import "FMDatabaseAdditions.h"
#define defaultDateFormat @"yyyy-MM-dd HH:mm:ss"
@interface DataBaseHelper : AbstractRepository {

}



// returns array of dictioneries contains DATATYPE as value and COLUMN NAME as key
-(NSMutableArray *)getColumnDataTypeListForTable:(NSString *)tableName ;

// returns Column list for table 
-(NSMutableArray *)getColumnListForTable:(NSString *)tableName ;

// returns SELECT query for given Table without any conditional clause 
-(NSString *)getSelectQueryForTable:(NSString *)tableName ;

// Returns insert Query For table 
-(NSString *)getInsertQueryForTable:(NSString *)tableName ;

//Returns Update Query For Table 
/*
  Plaese Update the WHERE Clause Manually 
*/
-(NSString *)getUpdateQueryForTable:(NSString *)tableName ;

/*
DELETE query for table Please apend condition clause Manualy  
*/
-(NSString *)getDeleteQueryForTable:(NSString *)tableName;

/*
 
 returns the date object from DB 
 
 */

-(NSDate *)dateFromDBStringDate:(NSString *)dateString ;
+(NSDate *)dateFromDBStringDate:(NSString *)dateString ;
-(NSDate*)dateFromString:(NSString *)dateString withDateFormat:(NSString *)dateFotmatString ;
-(NSString*)stringFromDate:(NSDate *)theDate withDateFormat:(NSString *)dateFotmatString ;
@end
