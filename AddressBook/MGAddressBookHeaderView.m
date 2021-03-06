//
//  MGAddressBookHeaderView.m
//  AddressBook
//
//  Created by Apple on 2017/8/3.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MGAddressBookHeaderView.h"

@implementation MGAddressBookHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier size:(CGSize)size{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
//        self.contentView.
        _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 9, 32, 32)];
        _headImage.layer.masksToBounds = YES;
        _headImage.layer.cornerRadius = 16;
//        _headImage.hidden = YES;
        _headImage.image = [UIImage imageNamed:@"gongsi"];
        [self.contentView addSubview:_headImage];
        _departmentName = [[UILabel alloc]initWithFrame:CGRectMake(67, 10, 200, 30)];
        [_departmentName setFont:[UIFont systemFontOfSize:16]];
        [_departmentName setTextColor:[UIColor colorWithRed:70/255 green:76/255 blue:86/255 alpha:1]];
        [self.contentView addSubview:_departmentName];
        //用来标识section的展开和关闭
        _upOrdown = [[UIImageView alloc]initWithFrame:CGRectMake(size.width-34, (size.height-7)/2, 14, 7)];
        [self.contentView addSubview:_upOrdown];
        
        //在最上层添加一个透明的按钮
        _topButton = [[UIButton alloc]initWithFrame:CGRectMake(9, 0, size.width-18, 50)];
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
