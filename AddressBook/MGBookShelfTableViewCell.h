//
//  MGBookShelfTableViewCell.h
//  AddressBook
//
//  Created by Apple on 2017/7/27.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGBookShelfTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bookLogo;
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthor;
@property (weak, nonatomic) IBOutlet UILabel *bookDescription;

@end
