//
//  MGContact.m
//  AddressBook
//
//  Created by Apple on 2017/7/31.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MGContact.h"

@implementation MGContact

+ (instancetype)contactWithDict:(NSDictionary *)dictionary
{
    if (dictionary) {
        MGContact *contact = [[MGContact alloc] init];
        contact.contactId = dictionary[@"contact_id"];
        contact.contactAvatar = dictionary[@"contact_avatar"];
        contact.contactName = dictionary[@"contact_name"];
        contact.contactScore = dictionary[@"contact_score"];
        contact.contactGroupid = dictionary[@"group_id"];
        contact.contactRank = dictionary[@"rank"];
        contact.groupName = dictionary[@"group_name"];
        
        if (contact.contactName) {
            contact.chinese = contact.contactName;
            
            NSMutableString *hanziString = [NSMutableString stringWithString:contact.chinese];
            CFStringTransform((CFMutableStringRef)hanziString, NULL, kCFStringTransformToLatin, false);
            CFStringTransform((CFMutableStringRef)hanziString, NULL, kCFStringTransformStripDiacritics, false);
            contact.pinyin = hanziString;
        }
        return contact;
    }
    return nil;
}
@end
