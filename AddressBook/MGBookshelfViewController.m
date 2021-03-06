//
//  MGBookshelfViewController.m
//  AddressBook
//
//  Created by Apple on 2017/7/27.
//  Copyright © 2017年 Apple. All rights reserved.
//
//http://121.40.229.114/Contacts/user/shelf?userId=597d517f7f2bf60245e2c136&count=5
#import "MGBookshelfViewController.h"
#import "MGBookShelfTableViewCell.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "MGBook.h"
#import <MJRefresh.h>
#import <SwipeBack/SwipeBack.h>

@interface MGBookshelfViewController ()
@property (weak, nonatomic) IBOutlet UITableView *bookTableView;
@property (nonatomic,strong) NSMutableArray *bookArray;
//@property (nonatomic,weak) UILabel *promptLab;
@property (weak, nonatomic) IBOutlet UILabel *promptLab;

@end

@implementation MGBookshelfViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.swipeBackEnabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getBookdata];
     [self.bookTableView registerNib:[UINib nibWithNibName:@"MGBookShelfTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MGBookShelfTableViewCell"];
    self.bookTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getBookdata];
        // 结束刷新
        [self.bookTableView.mj_header endRefreshing];
    }];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.bookTableView.tableFooterView = [[UITableViewHeaderFooterView alloc]init];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
//获取用户书库信息
-(void)getBookdata{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId ;
    NSString *url;
    if ([self.mineOrhe isEqualToString: @"mine"]||[self.mineOrhe isEqualToString: @"my"]) {
        userId = [userDefaults stringForKey:@"contactId"];
        url = @"http://121.40.229.114/Contacts/user/shelf";
    }else if([self.mineOrhe isEqualToString: @"his"]){
        userId = self.contactId;
        url = @"http://121.40.229.114/Contacts/user/share";
    }
    
    NSDictionary *parameters1 = @{@"userId": userId,@"count":@"10"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 申明请求的数据是json类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //获取常用联系人
    [manager GET:url parameters:parameters1 progress:^(NSProgress * _Nonnull downloadProgress) {
        manager.requestSerializer.timeoutInterval = 2;
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSArray *resultArr = [responseObject objectForKey:@"book_list"];
        self.bookArray = [NSMutableArray array];
        
        for (NSDictionary *dic in resultArr) {
            MGBook *book = [MGBook bookWithDict:dic];
            if (book) {
                [self.bookArray addObject:book];
            }
        }
        if (([resultArr count] == 0)&&([self.mineOrhe isEqualToString: @"his"])) {
            self.promptLab.hidden = NO;
            self.promptLab.text = @"该用户从来没有分享过书籍";
            self.bookTableView.hidden = YES;
        }else if (([resultArr count] == 0)&&([self.mineOrhe isEqualToString: @"mine"])) {
            self.promptLab.hidden = NO;
            self.promptLab.text = @"你的书库是空的，赶紧去书城添加吧！";
            self.bookTableView.hidden = YES;
        }
        [self.bookTableView reloadData];
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error); //打印错误信息
    }];
    
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.bookArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"MGBookShelfTableViewCell";
    
    MGBookShelfTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    MGBook *book = self.bookArray[indexPath.row];
    cell.bookName.text = book.bookName;
    cell.bookAuthor.text = book.bookAuthor;
    cell.bookDescription.text = book.bookDescription;
    NSString *imagePath = book.bookLogo;
    NSURL *imageUrl = [NSURL URLWithString:imagePath];
    
    [cell.bookLogo sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"bookImage"] options:SDWebImageLowPriority];
    
    return cell;
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //我的书库，点击进行分享
    
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"分享成功！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertview show];
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.mineOrhe  isEqualToString: @"mine"]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *userId = [userDefaults stringForKey:@"contactId"];
        MGBook *book = self.bookArray[indexPath.row];
        NSDictionary *parameters1 = @{@"fromUserId": userId,@"toUserId":self.contactId,@"bookId":book.bookId};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:@"http://121.40.229.114/Contacts/share/add" parameters:parameters1 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSString *errorStr = [NSString stringWithFormat:@"%@",error];
            
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:errorStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertview show];
            
        }];
    }else {
        
    }
    
}

@end
