//
//  MGDetailMessageViewController.m
//  AddressBook
//
//  Created by Apple on 2017/8/1.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MGDetailMessageViewController.h"
#import "MGChatModel.h"
#import "MGDetailMessageTableViewCell.h"
#import <AFNetworking.h>
#import <MBProgressHUD.h>
#import "MGTextView.h"

@interface MGDetailMessageViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSouce;
@property (nonatomic,strong) MGTextView *inputView;

@end

static NSString *identify = @"MGDetailMessageTableViewCell";

@implementation MGDetailMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //返回按钮
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 66, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 45) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    self.tableView.scroll
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[MGDetailMessageTableViewCell class] forCellReuseIdentifier:identify];
    
    [self initData];
    
    
    
    
    // 小技巧，用了之后不会出现多余的Cell
    UIView *view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    // 底部输入栏
    self.inputView = [[MGTextView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 36)];
    self.inputView.backgroundColor = [UIColor whiteColor];
    self.inputView.textField.delegate = self;
    [self.inputView.button addTarget:self action:@selector(clickSengMsg:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.inputView];
    
    // 注册键盘的通知hide or show
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 增加手势，点击弹回
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [self.view addGestureRecognizer:tap];
}
- (void)click:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
// 监听键盘弹出
- (void)keyBoardShow:(NSNotification *)noti
{
    
    CGRect rec = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"%@",NSStringFromCGRect(rec));
    // 小于，说明覆盖了输入框
    if ([UIScreen mainScreen].bounds.size.height - rec.size.height < self.inputView.frame.origin.y + self.inputView.frame.size.height)
    {
        // 把我们整体的View往上移动
        CGRect tempRec = self.view.frame;
        tempRec.origin.y = - (rec.size.height);
        self.view.frame = tempRec;
    }
    // 由于可见的界面缩小了，TableView也要跟着变化Frame
    self.tableView.frame = CGRectMake(0, rec.size.height+64, self.view.bounds.size.width, self.view.bounds.size.height - 64 - rec.size.height - 50);
    if (self.dataSouce.count != 0)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSouce.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
// 监听键盘隐藏
- (void)keyboardHide:(NSNotification *)noti
{
    self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    self.tableView.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 50);
}

- (void)clickSengMsg:(UIButton *)btn
{
    //post
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults stringForKey:@"contactId"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parameters1 = @{@"fromUserId": userId,@"toUserId":self.fromUserId,@"text":self.inputView.textField.text};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://121.40.229.114/Contacts/message/add" parameters:parameters1 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //实时刷新
        [self initData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSString *errorStr = [NSString stringWithFormat:@"%@",error];
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:errorStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertview show];
    }];
    
    if (self.dataSouce.count != 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSouce.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
-(void)back{
    
    [self.delegate moveTag:1];
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSouce.count;
}


//显示表头
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    MGChatModel *model = self.dataSouce[section];
    NSString *time =  [model.time substringWithRange:NSMakeRange(5, 11)];
    
    label.text = time;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithRed:174.0/255 green:174.0/255 blue:174.0/255 alpha:1];
    label.backgroundColor = [UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGDetailMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    //    self.dataSouce.count-1-indexPath.row
    [cell refreshCell:self.dataSouce[indexPath.section]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGChatModel *model = self.dataSouce[indexPath.section];
    CGRect rec =  [model.msg boundingRectWithSize:CGSizeMake(200, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil];
    return rec.size.height + 45;
}

-(void)initData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults stringForKey:@"contactId"];
    NSDictionary *parameters1 = @{@"userId": userId,@"fromUserId": self.fromUserId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 申明请求的数据是json类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //获取常用联系人
    [manager GET:@"http://121.40.229.114/Contacts/message/detail/list" parameters:parameters1 progress:^(NSProgress * _Nonnull downloadProgress) {
        manager.requestSerializer.timeoutInterval = 2;
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSArray *resultArr1 = [responseObject objectForKey:@"message_list"];
        NSInteger num = [resultArr1 count];
        NSMutableArray *resultArr = [NSMutableArray array];
        for (NSInteger i = num-1; i>=0; i--) {
            [resultArr addObject:resultArr1[i]];
        }
        self.dataSouce = [NSMutableArray array];
        
        for (NSDictionary *dic in resultArr) {
            MGChatModel *message = [MGChatModel messageWithDict:dic];
            if (message) {
                [self.dataSouce addObject:message];
            }
        }
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error); //打印错误信息
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
}

- (NSMutableArray *)dataSouce
{
    if (_dataSouce == nil) {
        _dataSouce = [[NSMutableArray alloc] init];
    }
    return _dataSouce;
}

#pragma -mark 控制section不悬停

- (void)scrollViewDidScroll:(UIScrollView *)scrollView

{
    CGFloat sectionHeaderHeight = 20;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        
    }
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    //    {
    //        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
    //        [self.tableView setContentOffset:offset animated:YES];
    //    }
    
    
}


@end
