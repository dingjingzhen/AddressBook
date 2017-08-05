//
//  MGDetailMessageViewController.m
//  AddressBook
//
//  Created by Apple on 2017/8/1.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MGDetailMessageViewController.h"
#import "MGDetailMessageTableViewCell.h"
//#import "MGDetailMessageTableViewCell.h"
#import <AFNetworking.h>
#import "MGMessage.h"

@interface MGDetailMessageViewController ()
@property (weak, nonatomic) IBOutlet UITableView *detailMessageTableview;
@property (nonatomic,strong) MGDetailMessageTableViewCell *detailCell;
@property (nonatomic,strong) NSMutableArray *messageArray;

@end

@implementation MGDetailMessageViewController
//获取跟某个人的相互消息
-(void)getDetailMessagedata{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults stringForKey:@"contactId"];
//    NSString *str = @"597d4b3c7f2bf60245e2c118";
    NSDictionary *parameters1 = @{@"userId": userId,@"fromUserId":self.fromUserId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 申明请求的数据是json类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //获取常用联系人
    [manager GET:@"http://121.40.229.114/Contacts/message/detail/list" parameters:parameters1 progress:^(NSProgress * _Nonnull downloadProgress) {
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
        
        [self.detailMessageTableview reloadData];
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error); //打印错误信息
    }];

}


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    [self getDetailMessagedata];
    self.detailMessageTableview.estimatedRowHeight = 80.0f;
    self.detailMessageTableview.rowHeight = UITableViewAutomaticDimension;
    self.detailMessageTableview.tableFooterView = [[UITableViewHeaderFooterView alloc]init];
}
#pragma mark --UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *headId = @"headid";
    UITableViewHeaderFooterView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headId ];
    if (!headView) {
        headView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:headId];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 15,[UIScreen mainScreen].bounds.size.width-32, 15)];
        [label setFont:[UIFont systemFontOfSize:12]];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
//        label.text =[headerViewArray objectAtIndex:section];
        MGMessage *message = self.messageArray[section];
        
        NSString *time = [self format:message.messageTime];
        label.text = time;
        [headView addSubview:label];
    }
    headView.contentView.backgroundColor = [UIColor whiteColor];
    return headView;
}

//表头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

#pragma mark --UITableViewDataSource


//- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    MGMessage *message = self.messageArray[section];
//    
//    NSString *time = [self format:message.messageTime];
//    
//    return time;
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"MGDetailMessageTableViewCell";
    MGDetailMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:ID owner:nil options:nil];
        cell = [nibs lastObject];
    }
    MGMessage *message = self.messageArray[indexPath.section];
    cell.messaLab.text = message.messageText;
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.messageArray count];
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
