

#import <Foundation/Foundation.h>

@protocol CustomDatePickerDelegate <NSObject>

- (void)getSelectedDateFromDatePicker:(NSDate*)date;

@end

@interface CustomDatePicker : UIDatePicker {
    id<CustomDatePickerDelegate> __weak customDatePickerDelegate;
    __weak UIToolbar *toolbar;
}

@property (nonatomic, weak) id<CustomDatePickerDelegate> customDatePickerDelegate;
@property (nonatomic, weak) UIToolbar *toolbar;

- (id)initWithFrame:(CGRect)frame;
-(void) createToolBarforDatePicker;

@end
