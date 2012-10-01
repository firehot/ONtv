

#import <Foundation/Foundation.h>
#import "Proxy.h"

@protocol CategoryProxyDelegate;

@interface CategoryProxy : Proxy 



@property (nonatomic, weak) id<CategoryProxyDelegate> categoryProxyDelegate;
- (void)getCategories;

@end


@protocol CategoryProxyDelegate <NSObject>

@required

- (void)categoryRequestFailed:(NSString *)error;

- (void)receivedCategory:(NSMutableArray*)array;

- (void)nocategoryRecordsFound;
@end
