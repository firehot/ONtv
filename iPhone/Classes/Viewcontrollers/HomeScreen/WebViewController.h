

#import <UIKit/UIKit.h>

@interface WebViewController : ONTVUIViewController <UIWebViewDelegate>


@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, copy) NSString *linkType;

@end
