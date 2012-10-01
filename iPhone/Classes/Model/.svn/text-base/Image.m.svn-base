

#import "Image.h"
#import "NSDictionary+NSNullHandler.h"

@implementation Image
@synthesize class;
@synthesize src;


-(NSDictionary *) jsonMapping {
	
	return [[NSDictionary alloc] initWithObjectsAndKeys:
			 @"class",@"@class",
			 @"src",@"@src",					  
			 nil];
}	

+(Image *)imageFromDictionary:(NSDictionary *)dictionary {
	
	if ([dictionary isDictionaryExist]) {
		Image *imageObject = [[Image alloc] init];
		NSDictionary *mapping = [imageObject jsonMapping];
		for (NSString *attribute in [mapping allKeys]){
			NSString *classProperty = [mapping objectForKey:attribute];			
			NSString *attributeValue = [dictionary objectForKey:attribute];
			if (attributeValue!=nil&&!([attributeValue isKindOfClass:[NSNull class]])) {
				[imageObject setValue:attributeValue forKeyPath:classProperty];
			}			
		}		
		return imageObject;
	}
	else {
		return nil;
	}	
}


@end
