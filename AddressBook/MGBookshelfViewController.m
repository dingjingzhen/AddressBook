//
//  MGBookshelfViewController.m
//  AddressBook
//
//  Created by Apple on 2017/7/27.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MGBookshelfViewController.h"
#import "MGBookShelfTableViewCell.h"

@interface MGBookshelfViewController ()
@property (weak, nonatomic) IBOutlet UITableView *bookTableView;

@end

@implementation MGBookshelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的书库";
    self.bookTableView.tableFooterView = [[UITableViewHeaderFooterView alloc]init];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"MGBookShelfTableViewCell";
    
    MGBookShelfTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:ID owner:nil options:nil];
        cell = [nibs lastObject];
    }
    
    
    return cell;
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"分享成功！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertview show];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
