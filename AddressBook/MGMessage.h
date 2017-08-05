//
//  MGMessage.h
//  AddressBook
//
//  Created by Apple on 2017/8/1.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGMessage : NSObject
@property (nonatomic, copy) NSString *userAvatar;

@property (nonatomic, copy) NSString *messageTime;

@property (nonatomic, copy) NSString *messageText;

@property (nonatomic,copy) NSString *userId;

@property (nonatomic,copy) NSString *userName;
+ (instancetype)messageWithDict:(NSDictionary *)dictionary;
@end
