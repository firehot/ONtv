
#import "NSDictionary+NSNullHandler.h"


@implementation NSDictionary (addition)

+(BOOL)valueForKeyInDict :(NSDictionary *)dict WithKey:(NSString *)key {
	BOOL result = YES;
	if ([[dict valueForKey:key] isEqual:[NSNull null]] || [dict valueForKey:key] == nil) {
		result = NO;
	}
	return result;
}

-(BOOL)isDictionaryExist {
	
	if (self!=nil || !([self isKindOfClass:[NSNull class]])) {
	
		return YES;
	}
	else {
		return NO;
	}

	
}

@end
