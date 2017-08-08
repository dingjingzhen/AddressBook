//
//  MGContact.h
//  AddressBook
//
//  Created by Apple on 2017/7/31.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGChatModel : NSObject

@property (nonatomic,copy) NSString *msg;
@property (nonatomic,assign) BOOL isRight;
@property (nonatomic,copy) NSString *toAvatar;
@property (nonatomic,copy) NSString *fromAvatar;
+ (instancetype)messageWithDict:(NSDictionary *)dictionary;

@end
