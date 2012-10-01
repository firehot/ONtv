//
//  iPadCategoryView.h
//  OnTV
//
//  Created by Andreas Hirszhorn on 31/7/12.
//  Copyright (c) 2012 Touch Logic I/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryProxy.h"
#import "CategoryDataModel.h"


@interface iPadCategoryView : UIView <CategoryProxyDelegate> {
    
    BOOL  noRecordFound;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *categoryArray; 
@property (nonatomic, strong) CategoryProxy *categoryProxy; 


@end
