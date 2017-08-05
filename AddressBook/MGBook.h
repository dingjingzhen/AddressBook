//
//  MGBook.h
//  AddressBook
//
//  Created by Apple on 2017/8/1.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGBook : NSObject
@property (nonatomic, copy) NSString *bookAuthor;

@property (nonatomic, copy) NSString *bookcontentId;

@property (nonatomic, copy) NSString *bookId;

@property (nonatomic,copy) NSString *bookLogo;

@property (nonatomic,copy) NSString *bookName;

@property (nonatomic,copy) NSString *bookDescription;
+ (instancetype)bookWithDict:(NSDictionary *)dictionary;
@end
