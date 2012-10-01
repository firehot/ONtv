//
//  TextFieldCell.m
//  OnTV
//
//  Created by Romain Briche on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TextFieldCell.h"

@interface TextFieldCell ()
@property (nonatomic, readwrite, weak) UITextField *textField;
@end

@implementation TextFieldCell
@synthesize textField = _textField;
@synthesize textFieldLeftInset = _textFieldLeftInset;

- (void)dealloc
{
    _textField = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.textLabel.backgroundColor = [UIColor clearColor];        
        self.textLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        self.textLabel.textColor = [UIColor lightGrayColor];
        
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
        textField.backgroundColor = [UIColor clearColor];	
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;           
        textField.borderStyle = UITextBorderStyleNone;
        textField.textAlignment = UITextAlignmentLeft;
        textField.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin;
        textField.font= [UIFont systemFontOfSize:15.0f];
        
        [self.contentView addSubview:textField];
        self.textField = textField;
        textField = nil;
        
        
        self.textFieldLeftInset = 20.0f;
    }
    return self;
}


- (void)setTextFieldLeftInset:(CGFloat)textFieldLeftInset
{
    _textFieldLeftInset = textFieldLeftInset;
    
    CGFloat margin = 0.0f;
    
    self.textField.frame = CGRectMake(margin + textFieldLeftInset, 6, self.contentView.bounds.size.width - textFieldLeftInset - 2.0f*margin, 30);
}


@end
