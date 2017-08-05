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

@property (nonatomic,copy) id contactScore;

@property (nonatomic,copy) NSString *contactGroupid;

@property (nonatomic,copy) NSString *groupName;

@property (nonatomic,copy) id contactRank;

+ (instancetype)contactWithDict:(NSDictionary *)dictionary;

@end
