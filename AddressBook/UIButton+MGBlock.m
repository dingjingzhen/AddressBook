//
//  UIButton+MGBlock.m
//  AddressBook
//
//  Created by Apple on 2017/7/31.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "UIButton+MGBlock.h"

@implementation UIButton (MGBlock)
static char eventKey;


- (void) handleControlEvent:(UIControlEvents)event withBlock:(void (^)())action {
    objc_setAssociatedObject(self, &eventKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}

- (void)callActionBlock:(id)sender {
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &eventKey);
    if (block) {
        block();
    }
}
@end
