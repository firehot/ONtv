

#import "Program.h"
#import "NSDictionary+NSNullHandler.h"

@implementation Program

@synthesize start;
@synthesize end;
@synthesize title;
@synthesize id;
@synthesize channel;
@synthesize type;

@synthesize teaser = _teaser;
@synthesize imgSrc = _imgSrc;
@synthesize programId = _programId;


@synthesize genre = _genre;
@synthesize originalTitle = _originalTitle;
@synthesize summary = _summary;
@synthesize cast = _cast;
@synthesize year = _year;
@synthesize country = _country;
@synthesize link = _link;
@synthesize episode = _episode;
@synthesize remiderType = _remiderType;
@synthesize remiderProgramStartTime = _remiderProgramStartTime;
@synthesize agentId = _agentId;

@synthesize agentID = _agentID;



- (id)init
{
    self = [super init]; 
    return self;
}

-(NSDictionary *) jsonMapping {
	
	return [[NSDictionary alloc] initWithObjectsAndKeys:
			 @"start",@"start",
			 @"end",@"end",
			 @"title",@"title",						  
			 nil];
}	

+(Program *)programFromDictionary:(NSDictionary *)dictionary {
	
	if ([dictionary isDictionaryExist]) {
		Program *program = [[Program alloc] init];
		NSDictionary *mapping = [program jsonMapping];
		for (NSString *attribute in [mapping allKeys]){
			NSString *classProperty = [mapping objectForKey:attribute];			
			NSDictionary *dict = [dictionary objectForKey:attribute];
			NSString *attributeValue = [dict objectForKey:@"$"];
			if (attributeValue!=nil&&!([attributeValue isKindOfClass:[NSNull class]])) {
				[program setValue:attributeValue forKeyPath:classProperty];
			}			
		}		
		DLog(@"Program : %@",[program description]);
		//BOOL result = [user save];
		//[user release];
		return program;
	}
	else {
		return nil;
	}	
}

#pragma mark -
#pragma mark Parsing for searched programs

-(NSDictionary *) keyValueMapping {
	
	return [[NSDictionary alloc] initWithObjectsAndKeys:
			 @"id",@"@id",
			 @"channel",@"@channel",			
			 @"start",@"start",
			 @"end",@"end",
			 @"title",@"title",						  
			 nil];
}	

+(Program *)searchedProgramsFromDictionary:(NSDictionary *)dictionary {
	
	if ([dictionary isDictionaryExist]) {
		Program *program = [[Program alloc] init];
		NSDictionary *mapping = [program keyValueMapping];
		for (NSString *attribute in [mapping allKeys]){
            
			NSString *classProperty = [mapping objectForKey:attribute];			
			NSDictionary *dict; //= [dictionary objectForKey:attribute];
			NSString *attributeValue;
			if([[dictionary objectForKey:attribute] isKindOfClass:[NSDictionary class]]) {
				dict = [dictionary objectForKey:attribute];
				attributeValue = [dict objectForKey:@"$"];
			} else {
				attributeValue =[dictionary objectForKey:attribute];
			}
			
			if (attributeValue!=nil&&!([attributeValue isKindOfClass:[NSNull class]])) {
				[program setValue:attributeValue forKeyPath:classProperty];
			}			
		}		
		DLog(@"Program : %@",[program description]);		
		return program;
	}
	else {
		return nil;
	}	
}

-(NSString *)description {	
	return [NSString stringWithFormat:
			@"\nId : %d /nChannel : %d \nType : %@ \nStart : %@ \nEnd : %@ \nTitle : %@" 
			,self.id,self.channel,self.type,self.start,self.end,self.title];
}


#pragma mark -
#pragma mark Helper Methods

- (NSInteger) lengthOfProgramInMins{
    NSLog(@"start:%@   end:%@",start,end);
    NSDate *startDate = [UIUtils dateFromGivenGMTString:start WithFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
    NSDate *endDate = [UIUtils dateFromGivenGMTString:end WithFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
    
    NSInteger timeInSecs = [endDate timeIntervalSince1970] - [startDate timeIntervalSince1970];    
    return timeInSecs/60;
}

- (NSInteger) timeOfProgramSinceNowInMins{
    NSLog(@"start:%@   end:%@", start, end);
    NSDate *startDate = [UIUtils dateFromGivenGMTString:start WithFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
    NSDate *endDate = [NSDate date];
    
    NSInteger timeInSecs = [endDate timeIntervalSince1970] - [startDate timeIntervalSince1970];    
    return timeInSecs/60;
}

@end
