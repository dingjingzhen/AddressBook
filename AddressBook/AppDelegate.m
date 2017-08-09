//
//  AppDelegate.m
//  AddressBook
//
//  Created by Apple on 2017/7/24.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1]];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:248/255.0 green:248/255.0 blue:249/255.0 alpha:1]];
    

   
    //存储用户的信息到nsuserdefault
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"597d4b3c7f2bf60245e2c113" forKey:@"contactId"];
    [userDefaults setObject:@"应用开发部" forKey:@"groupName"];
    [userDefaults setObject:@"周杰伦" forKey:@"contactName"];
    [userDefaults setObject:@"5982c05eded72d600238a059" forKey:@"groupId"];
    [userDefaults setObject:@"Jay Chou" forKey:@"contact_account_name"];
    [userDefaults setObject:@"http://imgcache.qq.com/music/photo/mid_singer_150/P/4/0025NhlN2yWrP4.jpg" forKey:@"contactAvatar"];
    [userDefaults setObject:@"1" forKey:@"tag1"];
    [userDefaults setObject:@"3" forKey:@"tag2"];
    [userDefaults setObject:@"1" forKey:@"tag3"];
////
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:@"597d517f7f2bf60245e2c136" forKey:@"contactId"];
//    [userDefaults setObject:@"应用开发部" forKey:@"groupName"];
//    [userDefaults setObject:@"韩方宇" forKey:@"contactName"];
//    [userDefaults setObject:@"5982c05eded72d600238a059" forKey:@"groupId"];
//    [userDefaults setObject:@"Bad Boy" forKey:@"contact_account_name"];
//    [userDefaults setObject:@"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2487013681,3283313649&fm=117&gp=0.jpg" forKey:@"contactAvatar"];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:@"1" forKey:@"tag1"];
//    [userDefaults setObject:@"3" forKey:@"tag2"];
//    [userDefaults setObject:@"1" forKey:@"tag3"];
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:@"597d4b3c7f2bf60245e2c11d" forKey:@"contactId"];
//    [userDefaults setObject:@"财务部" forKey:@"groupName"];
//    [userDefaults setObject:@"邓紫棋" forKey:@"contactName"];
//    [userDefaults setObject:@"5982c05eded72d600238a053" forKey:@"groupId"];
//    [userDefaults setObject:@"Gloria Tang Tsz-Kei" forKey:@"contact_account_name"];
//    [userDefaults setObject:@"http://imgcache.qq.com/music/photo/mid_singer_150/F/N/001fNHEf1SFEFN.jpg" forKey:@"contactAvatar"];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
