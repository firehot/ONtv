

#import "Channel.h"
#import "NSDictionary+NSNullHandler.h"

@implementation Channel
@synthesize id;
@synthesize lang;
@synthesize region;
@synthesize title;
@synthesize imageObject;
@synthesize programs;
@synthesize imageObjectsArray;


-(NSDictionary *) jsonMapping {
	
	return [[NSDictionary alloc] initWithObjectsAndKeys:
			 @"id",@"@id",
			 @"lang",@"@lang",
			 @"region",@"@region",
			 @"title",@"title",
			 nil];
}	

+(Channel *)channelFromDictionary:(NSDictionary *)dictionary {
	
	if ([dictionary isDictionaryExist]) {
		Channel *channel = [[Channel alloc] init];
		NSDictionary *mapping = [channel jsonMapping];
		for (NSString *attribute in [mapping allKeys]){
			NSString *classProperty = [mapping objectForKey:attribute];	
			NSDictionary *dict;
			NSString *attributeValue;
			if([[dictionary objectForKey:attribute] isKindOfClass:[NSDictionary class]]) {
				dict = [dictionary objectForKey:attribute];
				attributeValue = [dict objectForKey:@"$"];
			} else {
				attributeValue =[dictionary objectForKey:attribute];
			}

			if (attributeValue!=nil&&!([attributeValue isKindOfClass:[NSNull class]])) {
				[channel setValue:attributeValue forKeyPath:classProperty];
			}			
		}		

		return channel;
	}
	else {
		return nil;
	}	
}




@end
