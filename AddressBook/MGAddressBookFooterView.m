//
//  MGAddressBookFooterView.m
//  AddressBook
//
//  Created by Apple on 2017/7/28.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MGAddressBookFooterView.h"

@implementation MGAddressBookFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier size:(CGSize)size{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
        _headImage.layer.masksToBounds = YES;
        _headImage.layer.cornerRadius = 7;
        
        [self.contentView addSubview:_headImage];
        
        _departmentName = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 200, 30)];
        [self.contentView addSubview:_departmentName];
        
        //在最上层添加一个透明的按钮
        _topButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 0, size.width-10, 50)];
        _topButton.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_topButton];
        
        
        CALayer *bottomBorder = [CALayer layer];
        
        float height=_topButton.frame.size.height-1.0f;
        float width=_topButton.frame.size.width;
        bottomBorder.frame = CGRectMake(0.0f, height, width, 1.0f);
        bottomBorder.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1].CGColor;
        [_topButton.layer addSublayer:bottomBorder];
    }
    return self;
}
@end
