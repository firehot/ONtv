//
//  DBUtils.h
//  FMDB
//
//  Created by Prasad Tandulwadkar on 18/12/09.
//  Copyright 2009 Mobisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"


@interface FMDBUtils : NSObject {
	FMDatabase * sharedDBObj;
	NSString *dbPath;
}

@property (nonatomic, retain) NSString * dbPath;

-(FMDatabase *) sharedDB;
-(FMDBUtils *) initWithDatabase:  (NSString *) dbFile;
-(void) startDatabase ;

@end
