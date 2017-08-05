//
//  MGChildViewController.m
//  AddressBook
//
//  Created by Apple on 2017/7/26.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MGChildViewController.h"
#import "MGAddressBookFooterView.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "MGContact.h"
#import "MGDepartment.h"
#import "UIButton+MGBlock.h"
#import <objc/runtime.h>
#import "MGMessageTableViewCell.h"
#import <MBProgressHUD.h>
#import <MJRefresh.h>
#import "MGGroupCell.h"
#import "MGAddressBookHeaderView.h"
#import "MGIndexViewController.h"

@interface MGChildViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *nomalContactArray;

@property (nonatomic,strong) NSMutableArray *contactArray;

@property (nonatomic,strong) NSMutableArray *groupArray;

@property(nonatomic, strong)NSMutableArray *selectedArray;//是否被点击

//{"groupId":NSArray<Contact *>};
@property (nonatomic, strong) NSMutableDictionary *contactDictionary;

@end

@implementation MGChildViewController
//常用联系人
-(void)initData1{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults stringForKey:@"contactId"];
    
    NSDictionary *parameters1 = @{@"contactId": userId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 申明请求的数据是json类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //获取常用联系人
        [manager GET:@"http://121.40.229.114/Contacts/contact/common" parameters:parameters1 progress:^(NSProgress * _Nonnull downloadProgress) {
            manager.requestSerializer.timeoutInterval = 2;
        } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            NSArray *resultArr = [responseObject objectForKey:@"contact_list"];
            self.nomalContactArray = [NSMutableArray array];
            
            for (NSDictionary *dic in resultArr) {
                MGContact *contact = [MGContact contactWithDict:dic];
                if (contact) {
                    [self.nomalContactArray addObject:contact];
                }
            }
            [self.tableView reloadData];
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error); //打印错误信息
        }];
  
    
}

//企业联系人
-(void)initData2{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 申明请求的数据是json类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
        //获取部门信息
        
        [manager GET:@"http://121.40.229.114/Contacts/group/all" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            manager.requestSerializer.timeoutInterval = 2;
        } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            NSArray *resultArr = [responseObject objectForKey:@"group_list"];
            
            self.groupArray = [NSMutableArray array];
            self.selectedArray = [NSMutableArray array];
            for (NSDictionary *dic in resultArr) {
                [self.selectedArray  addObject:@"0"];
                MGDepartment *group = [MGDepartment groupWithDict:dic];
                if (group) {
                    [self.groupArray addObject:group];
                }
            }
            [self.tableView reloadData];
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error); //打印错误信息
        }];
        
    }

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData1];
    [self initData2];
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = backButtonItem;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 35 -70) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView=[[UIView alloc]init];//去除下方空白cell
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initData1];
        [self initData2];
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];

    self.contactDictionary = [NSMutableDictionary dictionary];
}

#pragma  mark --UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger num;
    if ([self.title  isEqualToString: @"企业通讯录"]) {
        num = [_groupArray count];
    }
    else{
        num = 1;
    }
    return num;}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.title  isEqualToString: @"常用联系人"]) {
        return  [_nomalContactArray count];
    }
    else{
        
        if ([_selectedArray[section] isEqualToString:@"1"]) {
            
            MGDepartment *department = self.groupArray[section];
            NSArray *contactArray = self.contactDictionary[department.groupId];
            return  [contactArray count];
        }
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"MGMessageTableViewCell";
    static NSString *ID1 = @"MGGroupCell";
        if ([self.title  isEqualToString: @"常用联系人"]) {
            MGMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell)
            {
                // 创建cell的时候需要标示符(Identifier)是因为,当该cell出屏幕的时候需要根据标示符放到对应的集合中.
                NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MGMessageTableViewCell" owner:nil options:nil];
                cell = [nibs lastObject];
                
                
            }

        MGContact *contact = _nomalContactArray[indexPath.row];
        
        cell.nameLab.text= contact.contactName;
        cell.nameLab.textColor = [UIColor colorWithRed:70/255.0 green:76/255.0 blue:86/255.0 alpha:1];
        NSString *imagePath = contact.contactAvatar;
        NSURL *imageUrl = [NSURL URLWithString:imagePath];
        
        [cell.avatarImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"head"] options:SDWebImageRetryFailed];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell setEditing:YES];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
    }
    else{
        MGGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
        if (!cell)
        {
            // 创建cell的时候需要标示符(Identifier)是因为,当该cell出屏幕的时候需要根据标示符放到对应的集合中.
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MGGroupCell" owner:nil options:nil];
            cell = [nibs lastObject];
            
            
        }

        MGDepartment *department = self.groupArray[indexPath.section];
        NSArray *contactArray = self.contactDictionary[department.groupId];
        MGContact *groupContact = contactArray[indexPath.row];
        cell.nameLab.text = groupContact.contactName;
        NSString *imagePath = groupContact.contactAvatar;
        NSURL *imageUrl = [NSURL URLWithString:imagePath];
        [cell.avatarImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"head"] options:SDWebImageRetryFailed];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell setEditing:YES];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
  
}
#pragma  mark --UITableViewDelegate

//展示表头
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([self.title isEqualToString:@"企业通讯录"]) {
        static NSString *headId1 = @"headid1";
         static NSString *headId = @"headid";
        if (section == 1) {
            MGAddressBookHeaderView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headId1 ];
            if (!headView) {
                headView = [[MGAddressBookHeaderView alloc]initWithReuseIdentifier:headId1 size:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 50)];
            }
     
            MGDepartment *group = _groupArray[section];
            headView.departmentName.text = group.groupName;
            headView.departmentName.textColor = [UIColor colorWithRed:70/255.0 green:76/255.0 blue:86/255.0 alpha:1];
            headView.topButton.tag = section + 1000;
            
            objc_setAssociatedObject(headView.topButton, "groupId", group.groupId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);   //实际上就是KVC
            [headView.topButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            return headView;

        }
        else{
            MGAddressBookFooterView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headId ];
            if (!headView) {
                headView = [[MGAddressBookFooterView alloc]initWithReuseIdentifier:headId size:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 50)];
            }
            if (section == 1) {
                headView.headView.hidden = YES;
                headView.headImage.hidden = NO;
            }
            headView.headView.hidden = NO;
            headView.headImage.hidden = YES;
            
            MGDepartment *group = _groupArray[section];
            headView.headView.backgroundColor = [self randomColor:section];
            
            NSString *imageLab = [group.groupName substringToIndex:1];
            
            headView.headLabel.text = imageLab;
            
            //        headView.headImage.image = [UIImage imageNamed:@"head"];
            headView.departmentName.text = group.groupName;
            headView.departmentName.textColor = [UIColor colorWithRed:70/255.0 green:76/255.0 blue:86/255.0 alpha:1];
            headView.topButton.tag = section + 1000;
            
            objc_setAssociatedObject(headView.topButton, "groupId", group.groupId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);   //实际上就是KVC
            [headView.topButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            return headView;
        }
        
        
        
    }else{
        return nil;
    }
}
//展示表尾
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if ([self.title isEqualToString:@"企业通讯录"]) {
        UIView *view  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
        view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:242/255.0];
            return view;
    }else{
        return nil;
    }
}
//表头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self.title isEqualToString:@"企业通讯录"]) {
        if (section == 0) {
            return 0;
        }
        return  50;
    }else{
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.title isEqualToString:@"企业通讯录"]) {
        return 44;
    }
    return 50;
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([self.title isEqualToString:@"企业通讯录"]) {
        if (section == 0) {
            return  20;
        }else{
            if (section == 1) {
                return 20;
            }
        }
        return  0;
    }else{
        return 0;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MGIndexViewController *indexVC = [storyboard instantiateViewControllerWithIdentifier:@"MGIndexViewController"];
    self.hidesBottomBarWhenPushed = YES;
    if ([self.title isEqualToString:@"常用联系人"]) {
        MGContact *contact = _nomalContactArray[indexPath.row];
        indexVC.userId = contact.contactId;
        indexVC.navigationItem.title = contact.contactName;
    }else{
        MGDepartment *department = self.groupArray[indexPath.section];
        NSArray *contactArray = self.contactDictionary[department.groupId];
        MGContact *groupContact = contactArray[indexPath.row];
        indexVC.userId = groupContact.contactId;
        indexVC.navigationItem.title = groupContact.contactName;
    }
    [self.navigationController pushViewController:indexVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
    
//    NSLog(@"click");
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults stringForKey:@"contactId"];
    if ([self.title isEqualToString:@"常用联系人"]) {
        
        MGContact *contact = _nomalContactArray[indexPath.row];
        NSString *contactId = contact.contactId;
        NSDictionary *parameters1 = @{@"contact_id": userId,@"delete_contact_id":contactId};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        //manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [manager POST:@"http://121.40.229.114/Contacts/contact/common/delete" parameters:parameters1 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertview show];
            
        }];
        
        
        [self.nomalContactArray removeObjectAtIndex:indexPath.row];
        // 刷新
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
    }else{
        MGDepartment *department = self.groupArray[indexPath.section];
        NSArray *contactArray = self.contactDictionary[department.groupId];
        MGContact *groupContact = contactArray[indexPath.row];
        //         NSString *addContactName = groupContact.contactName;
        NSString *addContactid = groupContact.contactId;
        
        NSDictionary *parameters1 = @{@"contact_id": userId,@"add_contact_id":addContactid};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:@"http://121.40.229.114/Contacts/contact/common/add" parameters:parameters1 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"添加成功！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertview show];
            //实时刷新
//            [self initData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertview show];
        }];
    }
    
}

// 修改Delete按钮文字为“删除”
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.title isEqualToString:@"常用联系人"]) {
        return @"删除";
    }
    return @"添加为常用";
}

//展开收缩cell
-(void)buttonAction:(UIButton*)sender{
    id groupId = objc_getAssociatedObject(sender, "groupId");
    NSString *str = groupId;
    NSDictionary *parameters = @{@"groupId":str};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 申明请求的数据是json类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //获取常用联系人
    [manager GET:@"http://121.40.229.114/Contacts/contact/group" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        manager.requestSerializer.timeoutInterval = 10;
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSArray *resultArr = [responseObject objectForKey:@"contact_list"];
        NSMutableArray *contactArray = [NSMutableArray array];
        for (NSDictionary *dic in resultArr) {
            MGContact *contact = [MGContact contactWithDict:dic];
            if (contact) {
                [contactArray addObject:contact];
            }
        }
        [self.contactDictionary setObject:contactArray forKey:groupId];
        if ([_selectedArray[sender.tag - 1000] isEqualToString:@"0"]) {
            [_selectedArray replaceObjectAtIndex:sender.tag - 1000 withObject:@"1"];
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag - 1000] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            [_selectedArray replaceObjectAtIndex:sender.tag - 1000 withObject:@"0"];
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag - 1000] withRowAnimation:UITableViewRowAnimationFade];
        }
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error); //打印错误信息
    }];
    
}
-(UIColor *)randomColor:(NSInteger)section{
    
    NSArray *rArray = [NSArray arrayWithObjects:@"247",@"23",@"95",@"247",@"242", nil];
    NSArray *gArray = [NSArray arrayWithObjects:@"181",@"194",@"112",@"181",@"114", nil];
 NSArray *bArray = [NSArray arrayWithObjects:@"94",@"149",@"167",@"94",@"94", nil];
    
    NSInteger tag = section%5;
    NSString *str = rArray[tag];
    CGFloat r1 = [str floatValue];
    NSString *str1 = gArray[tag];
    CGFloat g1 = [str1 floatValue];
    NSString *str2 = bArray[tag];
    CGFloat b1 = [str2 floatValue];
    
    
    CGFloat r= r1/255.0;
    CGFloat g= g1/255.0;
    CGFloat b= b1/255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}
@end
