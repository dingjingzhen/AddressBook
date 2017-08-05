//
//  MGMineViewController.m
//  AddressBook
//
//  Created by Apple on 2017/7/26.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MGMineViewController.h"
#import "MGMineTableViewCell.h"
#import "MGMessageViewController.h"
#import "MGAddressBookViewController.h"
#import "MGBookshelfViewController.h"
#import <UIImageView+WebCache.h>

@interface MGMineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userTelephone;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *cellImage;//图标Array
@property (nonatomic,strong) NSArray *cellTitle;//title Array

@property (nonatomic,strong) NSArray *cellDetailTitle;//第三个section图标Array

@end

@implementation MGMineViewController
//数据
-(void)getData{
    self.cellImage1 = [NSArray arrayWithObjects:@"排行",@"time",@"最近阅读",@"书签", nil];
    self.cellTitle1 = [NSArray arrayWithObjects:@"阅读排行",@"学习时长",@"最近阅读",@"我的书签", nil];
    
    self.cellImage2 = [NSArray arrayWithObjects:@"书库",@"learn", nil];
    self.cellTitle2 = [NSArray arrayWithObjects:@"书库",@"在学课程", nil];
    
    self.cellImage3 = [NSArray arrayWithObjects:@"通讯录", nil];
    self.cellTitle3 = [NSArray arrayWithObjects:@"通讯录", nil];
    
    self.cellImage4 = [NSArray arrayWithObjects:@"二维码",@"咪咕阅读",@"xuetang", nil];
    self.cellTitle4 = [NSArray arrayWithObjects:@"二维码",@"咪咕阅读",@"咪咕学堂", nil];
    
    self.cellImage5 = [NSArray arrayWithObjects:@"使用帮助",@"信息", nil];
    self.cellTitle5 = [NSArray arrayWithObjects:@"使用帮助",@"关于", nil];
    
    
    
    [self.tableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = backButtonItem;
    
//    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    //    self.navigationController.navigationBarHidden = YES;
    [self getData];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults stringForKey:@"contactName"];
    NSString *accountName = [userDefaults stringForKey:@"contact_account_name"];
    NSString *image = [userDefaults stringForKey:@"contactAvatar"];
    
    NSString *groupName = [userDefaults stringForKey:@"groupName"];
    self.userName.text = userName;
    self.userTelephone.text = groupName;
    
    NSString *imagePath = image;
    NSURL *imageUrl = [NSURL URLWithString:imagePath];
    [self.headImage sd_setImageWithURL:imageUrl];
    
    
}


#pragma mark --UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSInteger *num;
    if (section == 0) {
        return [self.cellTitle1 count];
    }else{
        if (section == 1) {
            return [self.cellTitle2 count];
        }else{
            if (section == 2) {
                return [self.cellTitle3 count];
            }else{
                if (section == 3) {
                    return [self.cellTitle4 count];
                }
            }
        }
    }
    return [self.cellImage5 count];
   }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"MGMineTableViewCell";
    MGMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        // 创建cell的时候需要标示符(Identifier)是因为,当该cell出屏幕的时候需要根据标示符放到对应的集合中.
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MGMineTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
        
    }
    
    
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellImage.image = [UIImage imageNamed:_cellImage1[indexPath.row]];
        cell.cellTitle.text = _cellTitle1[indexPath.row];
//        cell.detailTitle.text = _cellDetailTitle[indexPath.row];
    }else{
        if (indexPath.section == 1) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.cellImage.image = [UIImage imageNamed:_cellImage2[indexPath.row]];
            cell.cellTitle.text = _cellTitle2[indexPath.row];
//            cell.detailTitle.text = _cellDetailTitle[indexPath.row];
        }else{
            if (indexPath.section == 2) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.cellImage.image = [UIImage imageNamed:_cellImage3[indexPath.row]];
                cell.cellTitle.text = _cellTitle3[indexPath.row];
//                cell.detailTitle.text = _cellDetailTitle[indexPath.row];
            }else{
                if (indexPath.section == 3) {
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.cellImage.image = [UIImage imageNamed:_cellImage4[indexPath.row]];
                    cell.cellTitle.text = _cellTitle4[indexPath.row];
//                    cell.detailTitle.text = _cellDetailTitle[indexPath.row];
                }else{
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.cellImage.image = [UIImage imageNamed:_cellImage5[indexPath.row]];
                    cell.cellTitle.text = _cellTitle5[indexPath.row];
//                    cell.detailTitle.text = _cellDetailTitle[indexPath.row];
                }
            }
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

#pragma mark --UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    if (indexPath.row == 2) {
        MGBookshelfViewController *bookshelfVC = [storyboard instantiateViewControllerWithIdentifier:@"MGBookshelfViewController"];
        self.hidesBottomBarWhenPushed = YES;
        bookshelfVC.navigationItem.title = @"我的书库";
        [self.navigationController pushViewController:bookshelfVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else{
        MGAddressBookViewController *addressbookVC = [storyboard instantiateViewControllerWithIdentifier:@"MGAddressBookViewController"];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addressbookVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }
    
}



- (IBAction)getMessage:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MGMessageViewController *messageVC = [storyboard instantiateViewControllerWithIdentifier:@"MGMessageViewController"];
    //    self.navigationController.navigationBarHidden = NO;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}




@end
