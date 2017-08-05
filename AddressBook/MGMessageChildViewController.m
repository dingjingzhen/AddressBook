//
//  MGMessageChildViewController.m
//  AddressBook
//
//  Created by Apple on 2017/7/31.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MGMessageChildViewController.h"
#import "MGAddressBookFooterView.h"
#import "MGUpvoteTableViewCell.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "MGContact.h"
#import "MGRankTableViewCell.h"

@interface MGMessageChildViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
//@property (nonatomic,strong) NSMutableArray *headImage;
//@property (nonatomic,strong) NSMutableArray *timeArray;
@property (nonatomic,strong) NSMutableArray *contactArray;
@property (nonatomic,strong) NSMutableArray *userInfoArray;
//@property (nonatomic,strong) NSMutableArray *companyContact;
//@property(nonatomic, strong)NSMutableArray *selectedArray;//是否被点击

@end

@implementation MGMessageChildViewController

-(void)initData{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults stringForKey:@"contactId"];
    NSString *type;
    if ([self.title isEqualToString:@"部门排行榜"]) {
        type = @"2";
    }else{
        type = @"1";
    }
    
    NSDictionary *parameters1 = @{@"userId": userId,@"type":type};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 申明请求的数据是json类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //获取常用联系人
    [manager GET:@"http://121.40.229.114/Contacts/rank/all" parameters:parameters1 progress:^(NSProgress * _Nonnull downloadProgress) {
        manager.requestSerializer.timeoutInterval = 2;
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSArray *contactArr = [responseObject objectForKey:@"contact_list"];
        NSDictionary *userInfoDic = [responseObject objectForKey:@"contact_info"];
        self.contactArray = [NSMutableArray array];
        self.userInfoArray = [NSMutableArray array];
        for (NSDictionary *dic in contactArr) {
            MGContact *contact = [MGContact contactWithDict:dic];
            if (contact) {
                [self.contactArray addObject:contact];
            }
        }
            MGContact *contact2 = [MGContact contactWithDict:userInfoDic];
            if (contact2) {
                [self.userInfoArray addObject:contact2];
            }
        
        
        [self.tableView reloadData];
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error); //打印错误信息
    }];
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 35 -70) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    self.tableView.tableFooterView=[[UIView alloc]init];//去除下方空白cell
    [self.view addSubview:self.tableView];
}

#pragma  mark --UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([self.title isEqualToString:@"部门排行榜"]) {
        if (section == 1) {
            
            MGContact *contact = self.userInfoArray[0];
            return contact.groupName;
        }
        return nil;
    }else{
        if (section == 1) {
        
            return @"全公司";
    }
    return nil;
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    if ([self.title  isEqualToString: @"部门排行榜"]) {
    if (section == 1) {
        return  [_contactArray count];
        
    }
    return 1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"MGRankTableViewCell";
    
    MGRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:ID owner:nil options:nil];
        cell = [nibs lastObject];
    }
    
    MGContact *contact = self.contactArray[indexPath.row];
    MGContact *mineInfo = self.userInfoArray[0];
    
    if (indexPath.section == 0) {
        cell.contactName.text = mineInfo.contactName;
        NSString *rank = [NSString stringWithFormat:@"%@", mineInfo.contactRank];
        NSString *score = [NSString stringWithFormat:@"%@", mineInfo.contactScore];

        cell.rankLab.text = rank;
        [cell.rankLab setTextColor:[UIColor redColor]];
        NSString *imagePath = mineInfo.contactAvatar;
        NSURL *imageUrl = [NSURL URLWithString:imagePath];
        [cell.contactAvatar sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"head"] options:SDWebImageLowPriority];
        cell.contactScore.text = score;
        return cell;
    }else{
        NSString *rank = [NSString stringWithFormat:@"%ld", (long)indexPath.row+1];
        NSString *score = [NSString stringWithFormat:@"%@", contact.contactScore];
        cell.contactName.text = contact.contactName;
        cell.rankLab.text = rank;
//        [cell.rankLab setTextColor:[UIColor redColor]];
        NSString *imagePath = contact.contactAvatar;
        NSURL *imageUrl = [NSURL URLWithString:imagePath];
        [cell.contactAvatar sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"head"] options:SDWebImageLowPriority];
        cell.contactScore.text = score;
        
        if (indexPath.row == 0) {
            [cell.rankLab setFont:[UIFont systemFontOfSize:18]];
            [cell.rankLab setTextColor:[UIColor redColor]];
        }
        if (indexPath.row == 1) {
            [cell.rankLab setFont:[UIFont systemFontOfSize:17]];
            [cell.rankLab setTextColor:[UIColor yellowColor]];
        }
        if (indexPath.row == 2) {
            [cell.rankLab setFont:[UIFont systemFontOfSize:16]];
            [cell.rankLab setTextColor:[UIColor greenColor]];
        }
        
        return cell;

    }
    
    
    
}

#pragma  mark --UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"click");
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 50;
    }
    return 0;
}

@end
