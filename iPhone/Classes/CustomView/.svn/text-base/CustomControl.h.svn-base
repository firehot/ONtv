

#import <Foundation/Foundation.h>
#import "Program.h"
@protocol CustomControlDelegate

-(void) controlClickEvent : (id) sender;

@end


@interface CustomControl : UIControl<UITextViewDelegate> {
	__weak UIImageView *programlogoImageView;
	__weak UITextView *detailsTextView;
	NSString *imageUrlString;
    Program *programToDisplay;
	id<CustomControlDelegate>__weak customControlDelegate;
   
}

@property (nonatomic, weak) id<CustomControlDelegate>customControlDelegate;
@property (nonatomic, weak) UITextView *detailsTextView;
@property (nonatomic, copy) NSString *imageUrlString;


- (void)displayPhoto:(NSString*)programPhoto;
- (void)setProgramDescription : (NSString*) programDescription;
- (id)initWithFrame:(CGRect)frame andProgram:(Program *)theProgram;

@end
