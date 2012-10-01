

#import <Foundation/Foundation.h>


@interface Image : NSObject {
	NSString *class;
	NSString *src;
}

@property (nonatomic, copy) NSString *class;
@property (nonatomic, copy) NSString *src;

-(NSDictionary *) jsonMapping;
+(Image *)imageFromDictionary:(NSDictionary *)dictionary;

@end
