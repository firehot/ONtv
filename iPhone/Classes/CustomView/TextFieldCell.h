//
//  TextFieldCell.h
//  OnTV
//
//  Created by Romain Briche on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldCell : UITableViewCell
@property (nonatomic, readonly, weak) UITextField *textField;
@property (nonatomic, assign) CGFloat textFieldLeftInset;

@end
