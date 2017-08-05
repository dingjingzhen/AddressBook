//
//  MGMessage.m
//  AddressBook
//
//  Created by Apple on 2017/8/1.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MGMessage.h"

@implementation MGMessage
+ (instancetype)messageWithDict:(NSDictionary *)dictionary
{
    if (dictionary) {
        MGMessage *message = [[MGMessage alloc] init];
        message.messageText = dictionary[@"message_text"];
        message.messageTime = dictionary[@"message_time"];
        message.userId = dictionary[@"user_id"];
        message.userName = dictionary[@"user_name"];
        message.userAvatar = dictionary[@"user_avatar"];
        return message;
    }
    return nil;
}

@end
