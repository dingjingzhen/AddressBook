//
//  MGShareBookCell.h
//  AddressBook
//
//  Created by Apple on 2017/8/7.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGShareBookCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bookTitel;
@property (weak, nonatomic) IBOutlet UILabel *bookDescription;
@property (weak, nonatomic) IBOutlet UIImageView *bookLogo;

@end
