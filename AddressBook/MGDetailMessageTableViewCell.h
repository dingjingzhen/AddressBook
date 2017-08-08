//
//  MGDetailMessageTableViewCell.h
//  AddressBook
//
//  Created by Apple on 2017/8/1.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGChatModel.h"
@interface MGDetailMessageTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headImageView; // 用户头像
@property (nonatomic,strong) UIImageView *backView; // 气泡
@property (nonatomic,strong) UILabel *contentLabel; // 气泡内文本

- (void)refreshCell:(MGChatModel *)model; // 安装我们的cell
@end
