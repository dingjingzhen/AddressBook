//
//  UIButton+MGBlock.h
//  AddressBook
//
//  Created by Apple on 2017/7/31.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
typedef void (^ActionBlock)();

@interface UIButton (MGBlock)
- (void) handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)action;
@end
