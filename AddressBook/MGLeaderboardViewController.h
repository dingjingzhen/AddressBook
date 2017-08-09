//
//  MGLeaderboardViewController.h
//  AddressBook
//
//  Created by Apple on 2017/7/31.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol moveTagDelegate <NSObject>

-(void)moveTag;
@end
@interface MGLeaderboardViewController : UIViewController
@property(nonatomic)id<moveTagDelegate>delegate;
@end
