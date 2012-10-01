

#import <Foundation/Foundation.h>
#import "Image.h"

@interface Channel : NSObject {
	int  id;
	NSString *lang;
	NSString *region;
	NSString *title;
	Image *imageObject;
	NSArray *programs;
	NSArray *imageObjectsArray;
}

@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString *lang;
@property (nonatomic, copy) NSString *region;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) Image *imageObject;
@property (nonatomic, copy) NSArray *programs;
@property (nonatomic, copy) NSArray *imageObjectsArray;

-(NSDictionary *) jsonMapping;
+(Channel *)channelFromDictionary:(NSDictionary *)dictionary;

@end
