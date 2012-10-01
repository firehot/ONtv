

#import <Foundation/Foundation.h>
#import "AbstractRepository.h"

@interface CacheRepository : AbstractRepository {
    
    
}

- (NSString*)getCacheDataForDataType:(NSString*)type;

- (void)deleteCacheDataForType:(NSString*)type;

- (void)insertCacheDataForType:(NSString*)type andCacheDate:(NSString*)cacheDate andExpiryTag:(NSString*)expiryTag;

@end
