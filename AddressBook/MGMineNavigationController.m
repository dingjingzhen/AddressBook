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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
