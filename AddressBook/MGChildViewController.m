//
//  MGChildViewController.m
//  AddressBook
//
//  Created by Apple on 2017/7/26.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MGChildViewController.h"
#import "MGAddressBookFooterView.h"

@interface MGChildViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *nomalContact;
@property (nonatomic,strong) NSMutableArray *companyContact;
@property(nonatomic, strong)NSMutableArray *selectedArray;//是否被点击

@end

@implementation MGChildViewController

-(void)initData{
    _nomalContact = [NSMutableArray arrayWithObjects:@"姜春雨",@"贾慧云",@"陈艺清", nil];
    
    _companyContact = [NSMutableArray arrayWithObjects:@"公司领导",@"应用开发部",@"技术支撑部", nil];
    _selectedArray = [NSMutableArray arrayWithObjects:@"0",@"0",@"0", nil];//用于判断展开还是缩回当前section的cell
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger num;
    if ([self.title  isEqualToString: @"企业通讯录"]) {
        num = [_companyContact count];
    }
    else{
        num = 1;
    }
    return num;}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.title  isEqualToString: @"常用联系人"]) {
        return  [_nomalContact count];
    }
    else{
        
        if ([_selectedArray[section] isEqualToString:@"1"]) {
            return  [_companyContact count];
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
        cell.textLabel.text = _nomalContact[indexPath.row];
    }
    else{
        cell.textLabel.text = _companyContact[indexPath.row];
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
        headView.headImage.image = [UIImage imageNamed:@"head"];
        headView.departmentName.text = _companyContact[section];
        headView.topButton.tag = section + 1000;
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

// 修改Delete按钮文字为“删除”
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//展开收缩cell
-(void)buttonAction:(UIButton*)sender{
    if ([_selectedArray[sender.tag - 1000] isEqualToString:@"0"]) {
        
        //        for (NSInteger i = 0; i < _selectedArray.count; i++) {
        //            [_selectedArray replaceObjectAtIndex:i withObject:@"0"];
        //            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationFade];
        //        }
        //
        
        [_selectedArray replaceObjectAtIndex:sender.tag - 1000 withObject:@"1"];
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag - 1000] withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        [_selectedArray replaceObjectAtIndex:sender.tag - 1000 withObject:@"0"];
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag - 1000] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}



@end
