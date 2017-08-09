//
//  MGDetailMessageController.h
//  AddressBook
//
//  Created by Apple on 2017/8/8.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol moveTagsDelegate <NSObject>

-(void)moveTags;
@end


@interface MGDetailMessageController : UIViewController
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,assign) NSInteger row;
@property (nonatomic,assign) NSInteger section;
@property(nonatomic)id<moveTagsDelegate>delegate;
@end
