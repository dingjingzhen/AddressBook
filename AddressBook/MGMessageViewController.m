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
#import "MGDetailMessageController.h"
#import <MJRefresh.h>
#import <MBProgressHUD.h>
#import <SwipeBack/SwipeBack.h>

#define naviHeight  (self.navigationController.navigationBar.frame.size.height)+([[UIApplication sharedApplication] statusBarFrame].size.height)


@interface MGMessageViewController ()<moveTagDelegate,moveTagsDelegate>
@property (nonatomic,strong) NSMutableArray *messageArray;
@property (nonatomic,strong) NSMutableArray *messageCenter;
@property (nonatomic,strong) NSMutableArray *messageCentertime;
@property (weak, nonatomic) IBOutlet UITableView *messageTableview;
//@property (nonatomic,copy) NSMutableArray *testArray;

@end

@implementation MGMessageViewController

-(void)initData{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.tabBarController.tabBar.hidden = YES;
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
        NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"messageTime" ascending:NO]];
        [self.messageArray sortUsingDescriptors:sortDescriptors];
        [self.messageTableview reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error); //打印错误信息
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

- (void)viewDidLoad {
    [self initData];
    self.tabBarController.tabBar.hidden = YES;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"消息";
    self.messageTableview.tableFooterView = [[UITableViewHeaderFooterView alloc]init];
    self.messageTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.messageTableview.rowHeight = 85;
   [self.messageTableview registerNib:[UINib nibWithNibName:@"MGUpvoteTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MGUpvoteTableViewCell"];
    self.messageTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initData];
        // 结束刷新
        [self.messageTableview.mj_header endRefreshing];
    }];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *tag1 = [userDefaults stringForKey:@"tag1"];
    NSString *tag2 = [userDefaults stringForKey:@"tag2"];
    NSString *tag3 = [userDefaults stringForKey:@"tag3"];
    
 
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        cell.messageCenter.text = @"消息中心";
        if (![tag1  isEqual: @"0"]) {
            cell.numberLab.text = tag1;
        }else{
            cell.numberView.hidden = YES;
        }
        
        
        //        cell.headImage.image = [UIImage imageNamed:@"ic_email"];
        cell.headImage.backgroundColor = [UIColor colorWithRed:0 green:196.0/255.0 blue:198.0/255.0 alpha:1];
        cell.commentLab.text = @"";
    }else{
//        NSInteger num = [self.messageArray count];
        MGMessage *message = self.messageArray[indexPath.row];
        NSString *imagePath = message.userAvatar;
        NSURL *imageUrl = [NSURL URLWithString:imagePath];
        [cell.headImage sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"head"] options:SDWebImageCacheMemoryOnly];
        cell.nameLab.text = message.userName;
        cell.emailIcon.hidden = YES;
        cell.commentLab.text = message.messageText;
        if (indexPath.row == 0) {
            if (![tag2 isEqual:@"0"]) {
                cell.numberLab.text = tag2;
            }else{
                cell.numberView.hidden = YES;
            }
        }else{
            if (indexPath.row == 1) {
                if (![tag3 isEqual:@"0"]) {
                    cell.numberLab.text = tag3;
                }else{
                    cell.numberView.hidden = YES;
                }
            }else{
                cell.numberView.hidden = YES;
            }
        }
    }
    return cell;
    
}


#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] ;
        MGLeaderboardViewController * LVC = [storyboard instantiateViewControllerWithIdentifier:@"MGLeaderboardViewController"];
        self.hidesBottomBarWhenPushed = YES;
        LVC.delegate = self;
        [self.navigationController pushViewController:LVC animated:YES];
        
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] ;
        MGDetailMessageController * DVC = [storyboard instantiateViewControllerWithIdentifier:@"MGDetailMessageController"];
        
        
        self.hidesBottomBarWhenPushed = YES;
//        NSInteger num = [self.messageArray count];
        MGMessage *message = self.messageArray[indexPath.row];
        DVC.userId = message.userId;
        DVC.row = indexPath.row;
        DVC.section = indexPath.section;
        DVC.delegate = self;
        
        DVC.navigationItem.title = message.userName;
        [self.navigationController pushViewController:DVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //    if (section == 0) {
    //        return 3;
    //    }
    return 0;
}



-(void)moveTags{
    //    self.row = row;
    [self.messageTableview reloadData];
}

-(void)moveTag{
    //    self.row = row;
    [self.messageTableview reloadData];
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

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.swipeBackEnabled = YES;
    self.tabBarController.tabBar.hidden = YES;
}

@end

