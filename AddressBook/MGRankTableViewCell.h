//
//  MGRankTableViewCell.h
//  AddressBook
//
//  Created by Apple on 2017/8/2.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGRankTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rankLab;
@property (weak, nonatomic) IBOutlet UIImageView *contactAvatar;
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UILabel *contactScore;

@end
