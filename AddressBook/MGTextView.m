//
//  MGTextView.m
//  AddressBook
//
//  Created by Apple on 2017/8/8.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MGTextView.h"

@implementation MGTextView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, frame.size.width - 110, frame.size.height)];
        self.textField.borderStyle = UITextBorderStyleRoundedRect;
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        self.textField.placeholder = @"点这里发私信哟";
        [self.textField setValue:[UIColor colorWithRed:174/255.0 green:174/255.0 blue:174/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
        [self.textField setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
        
        
        [self addSubview:self.textField];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = CGRectMake(frame.size.width - 80, 0, 50, frame.size.height);
        [self.button setTitle:@"发送" forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.button setBackgroundColor:[UIColor blueColor]];
        self.button.layer.cornerRadius = 8;
        [self addSubview:self.button];
        
    }
    return self;
}

@end
