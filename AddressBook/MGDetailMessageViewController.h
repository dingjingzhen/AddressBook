//
//  MGDetailMessageViewController.h
//  AddressBook
//
//  Created by Apple on 2017/8/1.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RefreshDelegate <NSObject>

-(void)moveTag:(NSInteger )row;
@end

@interface MGDetailMessageViewController : UIViewController
@property (nonatomic,copy) NSString *fromUserId;
@property (nonatomic,assign) NSInteger row;
@property(nonatomic)id<RefreshDelegate>delegate;
@end
