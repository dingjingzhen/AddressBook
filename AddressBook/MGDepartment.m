//
//  MGDepartment.m
//  AddressBook
//
//  Created by Apple on 2017/7/31.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MGDepartment.h"

@implementation MGDepartment

+ (instancetype)groupWithDict:(NSDictionary *)dictionary
{
    if (dictionary) {
        MGDepartment *group = [[MGDepartment alloc] init];
        group.groupId = dictionary[@"group_id"];
        group.groupName = dictionary[@"group_name"];
        return group;
    }
    return nil;
}
@end
