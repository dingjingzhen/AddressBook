//
//  MGDepartment.h
//  AddressBook
//
//  Created by Apple on 2017/7/31.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGDepartment : NSObject
@property (nonatomic, copy) NSString *groupId;

@property (nonatomic, copy) NSString *groupName;


+ (instancetype)groupWithDict:(NSDictionary *)dictionary;
@end
