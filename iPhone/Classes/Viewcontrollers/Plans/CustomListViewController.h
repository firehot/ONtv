

#import <UIKit/UIKit.h>

@protocol CustomListViewControllerDelegate;


@interface CustomListViewController : ONTVUIViewController <UITableViewDataSource,UITableViewDelegate> {
    
    __weak UITableView *_listTableView;
    
    NSMutableArray *_listArray;
    
}

@property (nonatomic, weak) id<CustomListViewControllerDelegate> customListViewControllerDelegate;

@property (nonatomic, copy) NSString *listType;

@property (nonatomic, copy) NSString *selectedListValue;

@end


@protocol CustomListViewControllerDelegate <NSObject>

- (void)selectedListValue:(id)rType For:(NSString*)type; 

@end
