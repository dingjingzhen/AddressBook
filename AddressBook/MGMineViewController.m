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
//@property (nonatomic,strong) NSArray *fourthSectionImage;//第四个section图标Array
//@property (nonatomic,strong) NSArray *fifthSectionImage;//第五个section图标Array
//@property (nonatomic,strong) NSArray *firstSectionTitle;//第一个section title Array
//@property (nonatomic,strong) NSArray *secondSectionTitle;//第二个section title Array
//@property (nonatomic,strong) NSArray *thirdSectionTitle;//第三个section title Array
//@property (nonatomic,strong) NSArray *fourthSectionTitle;//第四个section title Array
//@property (nonatomic,strong) NSArray *fifthSectionTitle;//第五个section title Array
@end

@implementation MGMineViewController
//数据
-(void)getData{
    self.cellImage = [NSArray arrayWithObjects:@"信息",@"二维码",@"信息",@"二维码",@"信息",@"二维码",@"信息",@"二维码",@"信息",@"二维码", nil];
    self.cellTitle = [NSArray arrayWithObjects:@"最近阅读",@"通讯录",@"书库",@"我的书签",@"阅读排行",@"二维码",@"切换集团客户",@"咪咕阅读",@"使用帮助",@"关于", nil];
    self.cellDetailTitle = [NSArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"3.1.0", nil];
    
    [self.tableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backButtonItem;
    //    self.navigationController.navigationBarHidden = YES;
    [self getData];
    //    [self.navigationController setNavigationBarHidden:YES];
}


#pragma mark --UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.cellTitle count];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellImage.image = [UIImage imageNamed:_cellImage[indexPath.row]];
    cell.cellTitle.text = _cellTitle[indexPath.row];
    cell.detailTitle.text = _cellDetailTitle[indexPath.row];
    return cell;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark --UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    if (indexPath.row == 2) {
        MGBookshelfViewController *bookshelfVC = [storyboard instantiateViewControllerWithIdentifier:@"MGBookshelfViewController"];
        self.hidesBottomBarWhenPushed = YES;
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
