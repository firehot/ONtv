//
//  UserCell.h
//  OnTV
//
//  Created by Kate on 10/17/12.
//
//

#import <UIKit/UIKit.h>



@interface UserCell : UITableViewCell

@property (nonatomic) IBOutlet UIImageView *userImage;
@property (nonatomic) IBOutlet UILabel *loggedInLabel;
@property (nonatomic) IBOutlet UILabel *userName;
@property (nonatomic) IBOutlet UIButton *logoutButton;



@end
