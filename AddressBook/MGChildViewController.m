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

@interface MGChildViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *nomalContactArray;

@property (nonatomic,strong) NSMutableArray *contactArray;

@property (nonatomic,strong) NSMutableArray *groupArray;

@property(nonatomic, strong)NSMutableArray *selectedArray;//是否被点击

@end

@implementation MGChildViewController

-(void)initData{
    NSDictionary *parameters1 = @{@"contactId": @"597d517f7f2bf60245e2c136"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 申明请求的数据是json类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //获取常用联系人
    
    if ([self.title isEqualToString:@"常用联系人"]) {
        [manager GET:@"http://121.40.229.114/Contacts/contact/common" parameters:parameters1 progress:^(NSProgress * _Nonnull downloadProgress) {
            manager.requestSerializer.timeoutInterval = 2;
        } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            NSArray *resultArr = [responseObject objectForKey:@"contact_list"];
            self.nomalContactArray = [NSMutableArray array];
            
            for (NSDictionary *dic in resultArr) {
                MGContact *contact = [MGContact contactWithDict:dic];
                if (contact) {
                    [self.nomalContactArray addObject:contact];
                    //                [self.contactImageArray  addObject:contact.contactAvatar];
                    //                [self.contactidArray addObject:contact.contactId];
                }
            }
            
            [self.tableView reloadData];
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error); //打印错误信息
        }];
        
        

        
        

    }else{
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
                    //                [self.groupidArray addObject:group.groupId];
                }
            }
            [self.tableView reloadData];
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error); //打印错误信息
        }];

    }
    
    }

-(void)groupCelltag:(NSInteger)tag getDifferentgroup:(NSString *)groupId{
    NSDictionary *parameters = @{@"groupId": groupId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 申明请求的数据是json类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //获取常用联系人
    [manager GET:@"http://121.40.229.114/Contacts/contact/group" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        manager.requestSerializer.timeoutInterval = 2;
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSArray *resultArr = [responseObject objectForKey:@"contact_list"];
        self.contactArray = [NSMutableArray array];

        for (NSDictionary *dic in resultArr) {
            MGContact *contact = [MGContact contactWithDict:dic];
            if (contact) {
                [self.contactArray addObject:contact];
            }
        }
//        [self.tableView reloadData];
        if ([_selectedArray[tag - 1000] isEqualToString:@"0"]) {
            [_selectedArray replaceObjectAtIndex:tag - 1000 withObject:@"1"];
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:tag - 1000] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            [_selectedArray replaceObjectAtIndex:tag - 1000 withObject:@"0"];
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:tag - 1000] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        
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
    self.tableView.tableFooterView=[[UIView alloc]init];//去除下方空白cell
    [self.view addSubview:self.tableView];
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
            return  [_contactArray count];
        }
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID] ;
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:@"head"];
    
    if ([self.title  isEqualToString: @"常用联系人"]) {
        MGContact *contact = _nomalContactArray[indexPath.row];
        
        cell.textLabel.text = contact.contactName;
//        cell.imageView.image = [UIImage imageNamed:_contactImageArray[indexPath.row]];
        NSString *imagePath = contact.contactAvatar;
        NSURL *imageUrl = [NSURL URLWithString:imagePath];
        
        [cell.imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"head"] options:SDWebImageRetryFailed];
    }
    else{
        MGContact *groupContact = _contactArray[indexPath.row];
        cell.textLabel.text = groupContact.contactName;
        cell.imageView.image = [UIImage imageNamed:@"head"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell setEditing:YES];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma  mark --UITableViewDelegate

//展示表头
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([self.title isEqualToString:@"企业通讯录"]) {
        static NSString *headId = @"headid";
        MGAddressBookFooterView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headId ];
        if (!headView) {
            headView = [[MGAddressBookFooterView alloc]initWithReuseIdentifier:headId size:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 50)];
        }
        MGDepartment *group = _groupArray[section];
        headView.headImage.image = [UIImage imageNamed:@"head"];
        headView.departmentName.text = group.groupName;
        headView.topButton.tag = section + 1000;
        
        objc_setAssociatedObject(headView.topButton, "groupId", group.groupId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);   //实际上就是KVC
//        objc_setAssociatedObject(headView.topButton, "secondObject", otherObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
//        [headView.topButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
//            [self groupCelltag:headView.topButton.tag getDifferentgroup:group.groupId];
//        }];
        [headView.topButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        return headView;
    }else{
        return nil;
    }
}

//表头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self.title isEqualToString:@"企业通讯录"]) {
        return  50;
    }else{
        return 0;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"click");
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //只有常用联系人能进行删除操作
    if ([self.title isEqualToString:@"常用联系人"])  {
        return YES;

    }else{
        return NO;
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.nomalContactArray removeObjectAtIndex:indexPath.row];
    // 刷新
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

// 修改Delete按钮文字为“删除”
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//展开收缩cell
-(void)buttonAction:(UIButton*)sender{
    
    id groupId = objc_getAssociatedObject(sender, "groupId");
    NSString *str = groupId;
   
    
//    NSString *strUrl = [@"http://121.40.229.114/Contacts/contact/group?groupId=" stringByAppendingString:str];
//    NSLog(@"%@",strUrl);
//    NSURL *URL = [NSURL URLWithString:strUrl];
    NSDictionary *parameters = @{@"groupId":str};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 申明请求的数据是json类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //获取常用联系人
    [manager GET:@"http://121.40.229.114/Contacts/contact/group" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        manager.requestSerializer.timeoutInterval = 2;
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSArray *resultArr = [responseObject objectForKey:@"contact_list"];
        self.contactArray = [NSMutableArray array];
        
        for (NSDictionary *dic in resultArr) {
            MGContact *contact = [MGContact contactWithDict:dic];
            if (contact) {
                [self.contactArray addObject:contact];
            }
        }
        //        [self.tableView reloadData];
        if ([_selectedArray[sender.tag - 1000] isEqualToString:@"0"]) {
            [_selectedArray replaceObjectAtIndex:sender.tag - 1000 withObject:@"1"];
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag - 1000] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            [_selectedArray replaceObjectAtIndex:sender.tag - 1000 withObject:@"0"];
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag - 1000] withRowAnimation:UITableViewRowAnimationFade];
        }
        NSLog(@"%@",resultArr);
        
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error); //打印错误信息
    }];
    
}



@end
