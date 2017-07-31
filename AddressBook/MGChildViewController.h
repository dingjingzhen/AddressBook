//
//  MGChildViewController.h
//  AddressBook
//
//  Created by Apple on 2017/7/26.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGChildViewController : UIViewController
// 用typef宏定义来减少冗余代码
typedef void(^ButtonClick)(UIButton * sender);// 这里的index是参数，我传递的是button的tag值，当然你可以自己决定传递什么参数
//下一步就是声明属性了，注意block的声明属性修饰要用copy
@property (nonatomic,copy) ButtonClick buttonAction;


@end
