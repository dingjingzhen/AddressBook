//
//  MGContact.h
//  AddressBook
//
//  Created by Apple on 2017/7/31.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MGChatModel.h"

@implementation MGChatModel
+ (instancetype)messageWithDict:(NSDictionary *)dictionary
{
    if (dictionary) {
        MGChatModel *message = [[MGChatModel alloc] init];
        message.msg = dictionary[@"message_text"];
        message.isRight = [dictionary[@"sendByMe"] boolValue];
        message.toAvatar = dictionary[@"to_user_avatar"];
        message.fromAvatar = dictionary[@"from_user_avatar"];
        return message;
    }
    return nil;
}
@end
