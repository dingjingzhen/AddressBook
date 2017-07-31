//
//  MGContact.h
//  AddressBook
//
//  Created by Apple on 2017/7/31.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGContact : NSObject

@property (nonatomic, copy) NSString *contactId;

@property (nonatomic, copy) NSString *contactName;

@property (nonatomic, copy) NSString *contactAvatar;

@property (nonatomic,strong) NSString *contactScore;

@property (nonatomic,strong) NSString *contactGroupid;
+ (instancetype)contactWithDict:(NSDictionary *)dictionary;

@end
