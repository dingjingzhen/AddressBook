//
//  MGAddressBookFooterView.h
//  AddressBook
//
//  Created by Apple on 2017/7/28.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGAddressBookFooterView : UITableViewHeaderFooterView

@property (nonatomic,strong) UIImageView *headImage;
@property (nonatomic,strong) UILabel *departmentName;
@property (nonatomic,strong) UIButton *topButton;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier  size:(CGSize)size;

@end
