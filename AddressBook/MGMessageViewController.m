//
//  MGMessageViewController.m
//  AddressBook
//
//  Created by Apple on 2017/7/26.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MGMessageViewController.h"
#import "MGUpvoteTableViewCell.h"
#import "MGLeaderboardViewController.h"

#define naviHeight  (self.navigationController.navigationBar.frame.size.height)+([[UIApplication sharedApplication] statusBarFrame].size.height)


@interface MGMessageViewController ()
@property (nonatomic,strong) NSMutableArray *messageArray;
@property (nonatomic,strong) NSMutableArray *headImage;
@property (nonatomic,strong) NSMutableArray *timeArray;
@property (weak, nonatomic) IBOutlet UITableView *messageTableview;


@end

@implementation MGMessageViewController

-(void)initData{
    _headImage = [NSMutableArray arrayWithObjects:@"head.jpg",@"migu.jpg",@"head.jpg",@"migu.jpg", nil];
    _timeArray = [NSMutableArray arrayWithObjects:@"7月29日",@"7月21日",@"7月17日",@"6月29日", nil];
    _messageArray = [NSMutableArray arrayWithObjects:@"消息中心",@"贾慧云",@"陈艺清",@"姜春雨", nil];
}


- (void)viewDidLoad {
    [self initData];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"消息";
    self.messageTableview.tableFooterView = [[UITableViewHeaderFooterView alloc]init];
    self.messageTableview.rowHeight = 50;
}


#pragma mark --UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_messageArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"MGUpvoteTableViewCell";
    MGUpvoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:ID owner:nil options:nil];
        cell = [nibs lastObject];
    }
//    if (indexPath.row == 0) {
//        cell.backgroundColor = [UIColor blueColor];
//    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.headImage.image = [UIImage imageNamed:_headImage[indexPath.row]];
    cell.nameLab.text = _messageArray[indexPath.row];
    cell.timeLab.text = _timeArray[indexPath.row];
    cell.actionLab.text = @"";
    if (indexPath.row == 0) {
        cell.commentLab.text = @"你的排行榜更新啦！";
    }
    cell.commentLab.text = @"你好";
    cell.commentLab.textColor = [UIColor lightGrayColor];
    return cell;

}


#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] ;
        MGLeaderboardViewController * LVC = [storyboard instantiateViewControllerWithIdentifier:@"MGLeaderboardViewController"];
        [self.navigationController pushViewController:LVC animated:YES];
        
    }
}





@end

