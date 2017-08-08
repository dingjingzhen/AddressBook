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
#import <MJRefresh.h>

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
    self.tableView.rowHeight = 85;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initData];
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
    self.tableView.tableFooterView=[[UIView alloc]init];//去除下方空白cell
    [self.view addSubview:self.tableView];
}

#pragma  mark --UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([self.title isEqualToString:@"部门排行榜"]) {
        UIView *view  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
        view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:242/255.0];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(14, 2, 200, 16)];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1];
        if (section == 0) {
            label.text = @"个人信息";
        }
        else{
            label.text = @"部门排行榜";
        }
        [view addSubview:label];
        return view;
    }else{
        UIView *view  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
        view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:242/255.0];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(14, 2, 200, 16)];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1];
        if (section == 0) {
            label.text = @"个人信息";
        }
        else{
            label.text = @"企业排行榜";
        }
        [view addSubview:label];
        return view;

    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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
        
        NSString *rank1 = @"第";
        NSString *rank2 = [NSString stringWithFormat:@"%@", mineInfo.contactRank];
        NSString *rank = [rank1 stringByAppendingString:rank2];
        rank = [rank stringByAppendingString:@"名"];
        cell.contactName.text = mineInfo.contactName;
        
        NSString *score = [NSString stringWithFormat:@"%@", mineInfo.contactScore];

        cell.rankLab.text = rank;
        NSString *imagePath = mineInfo.contactAvatar;
        NSURL *imageUrl = [NSURL URLWithString:imagePath];
        [cell.contactAvatar sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"head"] options:SDWebImageLowPriority];
        cell.contactScore.text = score;
        return cell;
    }else{
        NSString *rank1 = @"第";
        NSString *rank = [NSString stringWithFormat:@"%ld", (long)indexPath.row+1];
        rank = [rank1 stringByAppendingString:rank];
        rank = [rank stringByAppendingString:@"名"];
        NSString *score = [NSString stringWithFormat:@"%@", contact.contactScore];
        cell.contactName.text = contact.contactName;
        cell.rankLab.text = rank;
        NSString *imagePath = contact.contactAvatar;
        NSURL *imageUrl = [NSURL URLWithString:imagePath];
        [cell.contactAvatar sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"head"] options:SDWebImageLowPriority];
        cell.contactScore.text = score;
        
        if (indexPath.row == 0) {
            cell.rankLab.hidden = YES;
            cell.firstThreeImage.hidden = NO;
            cell.firstThreeLab.text = @"NO.1";
            cell.firstThreeImage.image = [UIImage imageNamed:@"pic_no1"];
        }
        if (indexPath.row == 1) {
            cell.rankLab.hidden = YES;
            cell.firstThreeImage.hidden = NO;
            cell.firstThreeLab.text = @"NO.2";
            cell.firstThreeImage.image = [UIImage imageNamed:@"pic_no2"];

        }
        if (indexPath.row == 2) {
            cell.rankLab.hidden = YES;
            cell.firstThreeImage.hidden = NO;
            cell.firstThreeLab.text = @"NO.3";
            cell.firstThreeImage.image = [UIImage imageNamed:@"pic_no2"];

        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        
        return cell;

    }
    
    
    
}

#pragma  mark --UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"click");
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
}

@end
