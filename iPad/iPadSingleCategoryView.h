//
//  iPadSingleCategoryView.h
//  OnTV
//
//  Created by Andreas Hirszhorn on 31/7/12.
//  Copyright (c) 2012 Touch Logic I/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryDataModel.h"

@interface iPadSingleCategoryView : UIView

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *headerLbl;
@property (nonatomic, strong) UIImageView  *accessoryImageView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *logoBackgroundImageView;
@property (nonatomic, strong) CategoryDataModel *category; 

- (id)initWithFrame:(CGRect)frame andCategory:(CategoryDataModel*)category;

@end
