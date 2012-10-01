

#import <UIKit/UIKit.h>

@protocol CustomPickerViewDelegate;

@interface CustomPickerViewController : ONTVUIViewController <UIPickerViewDelegate, UIPickerViewDataSource > {

}

@property(nonatomic,weak) id<CustomPickerViewDelegate> customPickerViewDelegate;

@property(nonatomic, weak) UIPickerView *picker;
@property(nonatomic, copy) NSString *selectedHoursFirstComponent;
@property(nonatomic, copy) NSString *selectedHoursSecondComponent;
@property(nonatomic, strong) NSMutableArray *hoursArrayOne;
@property(nonatomic, strong) NSMutableArray *hoursArrayTwo;

- (void)designView;

@end


@protocol CustomPickerViewDelegate <NSObject>

- (void)doneClicked:(NSString *)selectedHours;

@end
