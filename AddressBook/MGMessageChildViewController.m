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

@interface MGMessageChildViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *headImage;
@property (nonatomic,strong) NSMutableArray *timeArray;
@property (nonatomic,strong) NSMutableArray *nomalContact;
@property (nonatomic,strong) NSMutableArray *companyContact;
@property(nonatomic, strong)NSMutableArray *selectedArray;//是否被点击

@end

@implementation MGMessageChildViewController

-(void)initData{
    _headImage = [NSMutableArray arrayWithObjects:@"head.jpg",@"migu.jpg",@"head.jpg",@"migu.jpg", nil];
    _timeArray = [NSMutableArray arrayWithObjects:@"7月29日",@"7月21日",@"7月17日",@"6月29日", nil];
    _nomalContact = [NSMutableArray arrayWithObjects:@"消息中心",@"贾慧云",@"陈艺清",@"姜春雨", nil];
    
//    _companyContact = [NSMutableArray arrayWithObjects:@"公司领导",@"应用开发部",@"技术支撑部", nil];
//    _selectedArray = [NSMutableArray arrayWithObjects:@"0",@"0",@"0", nil];//用于判断展开还是缩回当前section的cell
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
    if (section == 1) {
        return @"应用开发部";
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.title  isEqualToString: @"部门排行榜"]) {
        if (section == 1) {
            return  [_nomalContact count];

        }
        return 1;
    }
    else{
        
        if (section == 1) {
            return  [_nomalContact count];
            
        }
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cellID";
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID] ;
        }
    if (indexPath.section == 1) {
        cell.textLabel.text = _nomalContact[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.image = [UIImage imageNamed:@"head"];
        return cell;
    }else{
        cell.textLabel.text = _nomalContact[1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.image = [UIImage imageNamed:@"migu"];
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
