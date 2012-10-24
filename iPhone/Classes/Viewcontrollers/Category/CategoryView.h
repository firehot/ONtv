

#import <UIKit/UIKit.h>
#import "CategoryProxy.h"

@interface CategoryView : UIView <UITableViewDataSource,UITableViewDelegate,CategoryProxyDelegate> {
    
    BOOL  noRecordFound;
}

@property (nonatomic, weak) UITableView *categoryTableView;
    
@property (nonatomic, strong) NSMutableArray *categoryArray; 

@property (nonatomic, strong) CategoryProxy *categoryProxy; 
- (NSString*)colorForCatgegoryType:(NSString*)type;
@end
