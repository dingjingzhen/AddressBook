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

@interface MGMineViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userTelephone;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property(nonatomic,weak) UINavigationController *navController;

@property (nonatomic,strong) NSArray *cellImage;//图标Array
@property (nonatomic,strong) NSArray *cellTitle;//title Array

@property (nonatomic,strong) NSArray *cellDetailTitle;//第三个section图标Array

@end

@implementation MGMineViewController
//数据
-(void)getData{
    self.cellImage1 = [NSArray arrayWithObjects:@"ic_1",@"ic_2",@"ic_3",@"ic_4", nil];
    self.cellTitle1 = [NSArray arrayWithObjects:@"阅读排行",@"学习时长",@"最近阅读",@"我的书签", nil];
    
    self.cellImage2 = [NSArray arrayWithObjects:@"ic_5",@"ic_6", nil];
    self.cellTitle2 = [NSArray arrayWithObjects:@"书库",@"在学课程", nil];
    
    self.cellImage3 = [NSArray arrayWithObjects:@"ic_7", nil];
    self.cellTitle3 = [NSArray arrayWithObjects:@"通讯录", nil];
    
    self.cellImage4 = [NSArray arrayWithObjects:@"ic_8",@"ic_9",@"ic_10", nil];
    self.cellTitle4 = [NSArray arrayWithObjects:@"二维码",@"咪咕阅读",@"咪咕学堂", nil];
    
    self.cellImage5 = [NSArray arrayWithObjects:@"ic_11",@"ic_12", nil];
    self.cellTitle5 = [NSArray arrayWithObjects:@"使用帮助",@"关于", nil];
    
    
    
    [self.tableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImage *colorImage = [self imageWithColor:[UIColor colorWithRed:248.0/255 green:248.0/255 blue:249.0/255 alpha:1] size:CGSizeMake(self.view.frame.size.width, 0.5)];
    [self.navigationController.navigationBar setBackgroundImage:colorImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[self imageWithColor:[UIColor colorWithRed:226.0/255 green:226.0/255 blue:255.0/255 alpha:1] size:CGSizeMake(self.view.frame.size.width, 0.5)]];
//
    
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.hidden = NO;
    [self getData];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults stringForKey:@"contactName"];
    NSString *image = [userDefaults stringForKey:@"contactAvatar"];
    NSString *groupName = [userDefaults stringForKey:@"groupName"];
    
    self.userName.text = userName;
    self.userTelephone.text = groupName;
    
    NSString *imagePath = image;
    NSURL *imageUrl = [NSURL URLWithString:imagePath];
    [self.headImage sd_setImageWithURL:imageUrl];
    self.headImage.layer.borderWidth = 2;
    self.headImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MGMineTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MGMineTableViewCell"];
}
-(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <=0 || size.height <=0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size,NO, 0);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


#pragma mark --UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    NSInteger *num;
    if (section == 0) {
        
    }else if (section == 1) {
    }
    
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 0:
            cell.cellImage.image = [UIImage imageNamed:_cellImage1[indexPath.row]];
            cell.cellTitle.text = _cellTitle1[indexPath.row];
            break;
        case 1:
            cell.cellImage.image = [UIImage imageNamed:_cellImage2[indexPath.row]];
            cell.cellTitle.text = _cellTitle2[indexPath.row];
            break;
        case 2:
            cell.cellImage.image = [UIImage imageNamed:_cellImage3[indexPath.row]];
            cell.cellTitle.text = _cellTitle3[indexPath.row];
            break;
        case 3:
            cell.cellImage.image = [UIImage imageNamed:_cellImage4[indexPath.row]];
            cell.cellTitle.text = _cellTitle4[indexPath.row];
            break;
        case 4:
            cell.cellImage.image = [UIImage imageNamed:_cellImage5[indexPath.row]];
            cell.cellTitle.text = _cellTitle5[indexPath.row];
            break;
            
        default:
            break;
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
    
    if ((indexPath.row == 0)&&(indexPath.section == 1)) {
        MGBookshelfViewController *bookshelfVC = [storyboard instantiateViewControllerWithIdentifier:@"MGBookshelfViewController"];
        self.hidesBottomBarWhenPushed = YES;
        bookshelfVC.navigationItem.title = @"我的书库";
        bookshelfVC.mineOrhe = @"my";
        [self.navigationController pushViewController:bookshelfVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else{
        if (indexPath.section == 2) {
            
            MGAddressBookViewController *addressbookVC = [storyboard instantiateViewControllerWithIdentifier:@"MGAddressBookViewController"];
            [self.navigationController setNavigationBarHidden: YES animated: YES];
            [self.navigationController pushViewController:addressbookVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else{
            
        }
        
        
        
    }
    
}



- (IBAction)getMessage:(UIButton *)sender {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"0" forKey:@"haveNewMessage"];
    
    
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
    [self.navigationController setNavigationBarHidden: YES animated: YES];
    //    self.navigationController.navigationBarHidden = YES;
//    [self.navigationController setNavigationBarHidden:YES];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *havaNewMessage = [userDefaults stringForKey:@"haveNewMessage"];
    
    if ([havaNewMessage isEqualToString:@"0"]) {
        _messageView.hidden = YES;
    }
    
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //很重要，每次要显示之前都将delegate设置为自己
    self.navigationController.delegate=self;
    _navController=self.navigationController;
    

}




@end
