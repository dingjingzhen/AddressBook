//
//  MGUpvoteTableViewCell.h
//  AddressBook
//
//  Created by Apple on 2017/7/31.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGUpvoteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *emailIcon;
@property (weak, nonatomic) IBOutlet UIView *numberView;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UILabel *commentLab;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *messageCenter;


@end
