//
//  MGBook.m
//  AddressBook
//
//  Created by Apple on 2017/8/1.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MGBook.h"

@implementation MGBook
+ (instancetype)bookWithDict:(NSDictionary *)dictionary
{
    if (dictionary) {
        MGBook *book = [[MGBook alloc] init];
        book.bookAuthor = dictionary[@"book_author"];
        book.bookcontentId = dictionary[@"book_content_id"];
        book.bookId = dictionary[@"book_id"];
        book.bookLogo = dictionary[@"book_logo"];
        book.bookName = dictionary[@"book_name"];
        book.bookDescription = dictionary[@"book_des"];
        return book;
    }
    return nil;
}

@end
