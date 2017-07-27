//
//  MGChildViewController.m
//  AddressBook
//
//  Created by Apple on 2017/7/26.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MGChildViewController.h"


@interface MGChildViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *nomalContact;
@property (nonatomic,strong) NSMutableArray *companyContact;

@end

@implementation MGChildViewController

-(void)initData{
    _nomalContact = [NSMutableArray arrayWithObjects:@"姜春雨",@"贾慧云",@"陈艺清", nil];
    _companyContact = [NSMutableArray arrayWithObjects:@"韩方宇",@"陈攀松",@"陆少华", nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView=[[UIView alloc]init];//去除下方空白cell
    [self.view addSubview:self.tableView];

}



#pragma  mark --UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num;
    if ([self.title  isEqualToString: @"常用联系人"]) {
        num = [_nomalContact count];
    }
    else{
        num = [_companyContact count];
    }
    return num;
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
         cell.textLabel.text = _nomalContact[indexPath.row];
    }
    else{
         cell.textLabel.text = _companyContact[indexPath.row];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell setEditing:YES];
    
//    cell.textLabel.text = _nomalContact[indexPath.row];
    return cell;
}
#pragma  mark --UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"click");
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除模型
    if ([self.title isEqualToString:@"常用联系人"]) {
        [self.nomalContact removeObjectAtIndex:indexPath.row];
    }else{
        [self.companyContact removeObjectAtIndex:indexPath.row];
    }
    
    
    // 刷新
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

/**
 *  修改Delete按钮文字为“删除”
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}




@end
