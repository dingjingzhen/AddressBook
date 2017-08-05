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
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "MGMessage.h"
#import "MGDetailMessageViewController.h"

#define naviHeight  (self.navigationController.navigationBar.frame.size.height)+([[UIApplication sharedApplication] statusBarFrame].size.height)


@interface MGMessageViewController ()
@property (nonatomic,strong) NSMutableArray *messageArray;
@property (nonatomic,strong) NSMutableArray *messageCenter;
@property (nonatomic,strong) NSMutableArray *messageCentertime;
@property (weak, nonatomic) IBOutlet UITableView *messageTableview;


@end

@implementation MGMessageViewController

-(void)initData{
    _messageCentertime = [NSMutableArray arrayWithObjects:@"7月29日", nil];
    _messageCenter = [NSMutableArray arrayWithObjects:@"消息中心", nil];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults stringForKey:@"contactId"];
    
    NSDictionary *parameters1 = @{@"userId": userId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 申明请求的数据是json类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //获取常用联系人
    [manager GET:@"http://121.40.229.114/Contacts/message/recent/list" parameters:parameters1 progress:^(NSProgress * _Nonnull downloadProgress) {
        manager.requestSerializer.timeoutInterval = 2;
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSArray *resultArr = [responseObject objectForKey:@"message_list"];
        self.messageArray = [NSMutableArray array];
        
        for (NSDictionary *dic in resultArr) {
            MGMessage *message = [MGMessage messageWithDict:dic];
            if (message) {
                [self.messageArray addObject:message];
            }
        }
        
        [self.messageTableview reloadData];
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error); //打印错误信息
    }];

}


- (void)viewDidLoad {
    [self initData];
    
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backButtonItem;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"消息";
    self.messageTableview.tableFooterView = [[UITableViewHeaderFooterView alloc]init];
    self.messageTableview.rowHeight = 50;
}


#pragma mark --UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [_messageCenter count];
    }
    return [_messageArray count];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"MGUpvoteTableViewCell";
    MGUpvoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:ID owner:nil options:nil];
        cell = [nibs lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        cell.headImage.image = [UIImage imageNamed:@"migu"];
        cell.nameLab.text = _messageCenter[indexPath.row];
        cell.timeLab.text = _messageCentertime[indexPath.row];
        cell.actionLab.text = @"";
        cell.commentLab.text = @"你的排行榜更新啦！";
        cell.commentLab.textColor = [UIColor grayColor];
    }else{
        
        MGMessage *message = self.messageArray[indexPath.row];
        
        NSString *imagePath = message.userAvatar;
        NSURL *imageUrl = [NSURL URLWithString:imagePath];
        [cell.headImage sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"head"] options:SDWebImageCacheMemoryOnly];
        cell.nameLab.text = message.userName;
        NSString *time = [self format:message.messageTime];
        cell.timeLab.text = time;
        cell.actionLab.text = @"";
        cell.commentLab.text = message.messageText;
        cell.commentLab.textColor = [UIColor lightGrayColor];
    }
    
        return cell;

}


#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] ;
        MGLeaderboardViewController * LVC = [storyboard instantiateViewControllerWithIdentifier:@"MGLeaderboardViewController"];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:LVC animated:YES];
        
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] ;
        MGDetailMessageViewController * DVC = [storyboard instantiateViewControllerWithIdentifier:@"MGDetailMessageViewController"];
        self.hidesBottomBarWhenPushed = YES;
        MGMessage *message = self.messageArray[indexPath.row];
        DVC.fromUserId = message.userId;
        DVC.navigationItem.title = message.userName;
        [self.navigationController pushViewController:DVC animated:YES];
       
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
    return 7;
}






#pragma mark -- 时间转化为今天、昨天这种格式

- (NSString *)format:(NSString *)string{
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *inputDate = [inputFormatter dateFromString:string];
    //NSLog(@"startDate= %@", inputDate);
    
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //get date str
    NSString *str= [outputFormatter stringFromDate:inputDate];
    //str to nsdate
    NSDate *strDate = [outputFormatter dateFromString:str];
    //修正8小时的差时
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: strDate];
    NSDate *endDate = [strDate  dateByAddingTimeInterval: interval];
    //NSLog(@"endDate:%@",endDate);
    NSString *lastTime = [self compareDate:endDate];
//    NSLog(@"lastTime = %@",lastTime);
    return lastTime;
}

-(NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 224 * 660 * 60;
    
    //修正8小时之差
    NSDate *date1 = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date1];
    NSDate *localeDate = [date1  dateByAddingTimeInterval: interval];
    
    //NSLog(@"nowdate=%@\nolddate = %@",localeDate,date);
    NSDate *today = localeDate;
    NSDate *yesterday,*beforeOfYesterday;
    //今年
    NSString *toYears;
    
    toYears = [[today description] substringToIndex:4];
    
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    beforeOfYesterday = [yesterday dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString *todayString = [[today description] substringToIndex:10];
    NSString *yesterdayString = [[yesterday description] substringToIndex:10];
    NSString *beforeOfYesterdayString = [[beforeOfYesterday description] substringToIndex:10];
    
    NSString *dateString = [[date description] substringToIndex:10];
    NSString *dateYears = [[date description] substringToIndex:4];
    
    NSString *dateContent;
    if ([dateYears isEqualToString:toYears]) {//同一年
        //今 昨 前天的时间
        NSString *time = [[date description] substringWithRange:(NSRange){11,5}];
        //其他时间
        NSString *time2 = [[date description] substringWithRange:(NSRange){5,11}];
        if ([dateString isEqualToString:todayString]){
            dateContent = [NSString stringWithFormat:@"今天 %@",time];
            return dateContent;
        } else if ([dateString isEqualToString:yesterdayString]){
            dateContent = [NSString stringWithFormat:@"昨天 %@",time];
            return dateContent;
        }else if ([dateString isEqualToString:beforeOfYesterdayString]){
            dateContent = [NSString stringWithFormat:@"前天 %@",time];
            return dateContent;
        }else{
            return time2;
        }
    }else{
        return dateString;
    }
}



@end

