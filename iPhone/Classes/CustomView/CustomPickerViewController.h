

#import <UIKit/UIKit.h>

@protocol CustomPickerViewDelegate <NSObject>

- (void)doneClicked:(NSString *)selectedHours;

@end

@interface CustomPickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource > {
    id<CustomPickerViewDelegate> customPickerViewDelegate;
}

@property(nonatomic,assign) id<CustomPickerViewDelegate> customPickerViewDelegate;

@property(nonatomic) UIPickerView *picker;
@property(nonatomic, copy) NSString *selectedHoursFirstComponent;
@property(nonatomic, copy) NSString *selectedHoursSecondComponent;
@property(nonatomic, strong) NSMutableArray *hoursArrayOne;
@property(nonatomic, strong) NSMutableArray *hoursArrayTwo;

- (void)designView;

@end




