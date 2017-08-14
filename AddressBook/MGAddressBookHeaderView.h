//
//  MGAddressBookHeaderView.h
//  AddressBook
//
//  Created by Apple on 2017/8/3.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGAddressBookHeaderView : UITableViewHeaderFooterView
@property (nonatomic,strong) UIImageView *headImage;
@property (nonatomic,strong) UILabel *departmentName;
@property (nonatomic,strong) UIButton *topButton;
@property (nonatomic,strong) UIImageView *upOrdown;


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier  size:(CGSize)size;

@end
