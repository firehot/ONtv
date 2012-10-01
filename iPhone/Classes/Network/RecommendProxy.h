

#import <UIKit/UIKit.h>


#import "Proxy.h"
#import "Program.h"
@protocol RecommendProxyDelegate;

@interface RecommendProxy : Proxy 

@property (nonatomic, weak) id<RecommendProxyDelegate> recommendProxyDelegate;

- (void)getRecommendationForProgram:(NSString*)programId;

- (void)addRecommendationForProgram:(NSString*)programId;

- (void)deleteRecommendationForProgram:(NSString*)programId;


@end

@protocol RecommendProxyDelegate <NSObject>

- (void)recommendRequestFailed:(NSString *)error;

@optional

- (void)receivedRecommendation:(BOOL)recommend;

- (void)recommendationDeletedSuccesfully;

- (void)recommendationAddedSuccesfully;

@end