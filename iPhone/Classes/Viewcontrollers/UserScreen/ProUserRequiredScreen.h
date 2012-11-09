


#import <UIKit/UIKit.h>
#import "MenuBar.h"
#import "ONTVUIViewController.h"

@interface ProUserRequiredScreen : ONTVUIViewController <MenuBarDelegate,UITableViewDelegate, UITableViewDataSource> {
    NSString *headerLine;
    NSString *functionLine;
    NSString *firstLine;
    NSString *secondLine;
    NSString *thirdLine;
    NSString *fourthLine;
    NSString *fifthLine;
    NSString *sixLine;
    NSString *sevenLine;
    NSString *eightLine;
    NSArray *tableStrings;
    
}

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UITableView *tableView;

@end


