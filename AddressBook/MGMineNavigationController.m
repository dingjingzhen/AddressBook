//
//  MGMineNavigationController.m
//  AddressBook
//
//  Created by Apple on 2017/8/3.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MGMineNavigationController.h"

@interface MGMineNavigationController ()

@end

@implementation MGMineNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor* color = [UIColor whiteColor];
    NSDictionary* dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
    self.navigationBar.titleTextAttributes= dict;
    
   
}

@end
