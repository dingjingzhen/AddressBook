//
//  MGReadBookViewController.m
//  AddressBook
//
//  Created by Apple on 2017/8/11.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MGReadBookViewController.h"
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>
#import "MGBookShelfTableViewCell.h"
#import "MGBook.h"

@interface MGReadBookViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong) NSMutableArray *bookArray;
@property (nonatomic,strong) UILabel *promptLab;


@end

@implementation MGReadBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getBookdata];
    self.promptLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, 40)];
    self.promptLab.font = [UIFont systemFontOfSize:16];
    self.promptLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.promptLab];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"MGBookShelfTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MGBookShelfTableViewCell"];
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getBookdata];
        // 结束刷新
        [self.tableview.mj_header endRefreshing];
    }];
}
//获取用户书库信息
-(void)getBookdata{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId ;
 
        userId = [userDefaults stringForKey:@"contactId"];
 
    
    NSDictionary *parameters1 = @{@"userId": userId,@"count":@"10"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 申明请求的数据是json类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //获取常用联系人
    [manager GET:@"http://121.40.229.114/Contacts/user/shelf" parameters:parameters1 progress:^(NSProgress * _Nonnull downloadProgress) {
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
      if ([resultArr count] == 0) {
            self.promptLab.hidden = NO;
            self.promptLab.text = @"你的书库是空的，赶紧去书城添加吧！";
            self.tableview.hidden = YES;
        }
        [self.tableview reloadData];
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
}@end
