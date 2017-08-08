//
//  MGAddressBookViewController.m
//  AddressBook
//
//  Created by Apple on 2017/7/26.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MGAddressBookViewController.h"
#import "MGChildViewController.h"
#import <FSScrollContentView.h>
#import <AFNetworking.h>
#import "MGContact.h"
#import "MGMessageTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "MGIndexViewController.h"
#import <MBProgressHUD.h>

#define naviHeight  (self.navigationController.navigationBar.frame.size.height)+([[UIApplication sharedApplication] statusBarFrame].size.height)


@interface MGAddressBookViewController ()<FSPageContentViewDelegate,FSSegmentTitleViewDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) FSPageContentView *pageContentView;
@property (nonatomic,strong) FSSegmentTitleView *titleView;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) NSMutableArray *testArray;//测试搜索用的数据
@property (nonatomic,strong) UIView *contentView;//用来存放titleview和pageContentView，便于隐藏等操作
@property (nonatomic,assign) BOOL showSearchbar;//用来判断是否显示searchbar
@property (nonatomic,strong) UITableView *searchTableView;//用了显示搜索到的数据
//@property (weak, nonatomic) IBOutlet UILabel *promptLab;
@property (nonatomic,strong) UILabel *promptLab;
@end

@implementation MGAddressBookViewController

//懒加载searchBar
-(UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width , 40)];
        _searchBar.backgroundColor = [UIColor whiteColor];
        _searchBar.placeholder = @"搜一搜~~";
        _searchBar.barTintColor = [UIColor whiteColor];
        _searchBar.delegate = self;
        _showSearchbar = NO;
        [_searchBar setSearchBarStyle:UISearchBarStyleMinimal];
        [self.view addSubview:_searchBar];
    }
    return _searchBar;
}
-(UITableView *)searchTableView{
    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 + 40, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-40-64) style:UITableViewStylePlain];
        [self.view addSubview:_searchTableView];
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
        _searchTableView.tableFooterView= [[UIView alloc]init];
        _searchTableView.hidden = YES;
    }
    return _searchTableView;
}

- (void)viewDidLoad {
    
    self.navigationItem.hidesBackButton = true;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = backButtonItem;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"通讯录";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1]}];
    
    self.promptLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 120, self.view.bounds.size.width-20, 35)];
    self.promptLab.text = @"该用户不存在";
    self.promptLab.textColor = [UIColor grayColor];
    self.promptLab.textAlignment = NSTextAlignmentCenter;
    [self.promptLab setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:self.promptLab];
    
    
    //    self.promptLab.hidden = YES;
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    self.contentView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:242/255.0];
    [self.view addSubview:self.contentView];
    
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 45) titles:@[@"常用联系人",@"企业通讯录"] delegate:self indicatorType:FSIndicatorTypeDefault];
    self.titleView.titleSelectFont = [UIFont systemFontOfSize:17];
    self.titleView.indicatorColor = [UIColor colorWithRed:18/255.0 green:191/255.0 blue:195/255.0 alpha:1];
    self.titleView.backgroundColor = [UIColor whiteColor];
    self.titleView.selectIndex = 0;
    self.titleView.titleNormalColor = [UIColor colorWithRed:70/255.0 green:76/255.0 blue:86/255.0 alpha:1];
    self.titleView.titleSelectColor = [UIColor colorWithRed:18/255.0 green:191/255.0 blue:195/255.0 alpha:1];
    
    [self.contentView addSubview:_titleView];
    [self searchTableView];
    [self searchBar];
    //    self.contentView.hidden = YES;
    
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    for (NSString *title in @[@"常用联系人",@"企业通讯录"]) {
        MGChildViewController *vc = [[MGChildViewController alloc]init];
        vc.title = title;
        [childVCs addObject:vc];
    }
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0,45, CGRectGetWidth(self.view.bounds), self.contentView.bounds.size.height - 45) childVCs:childVCs parentVC:self delegate:self];
    self.pageContentView.contentViewCurrentIndex = 0;
    self.pageContentView.backgroundColor = [UIColor whiteColor];
    self.pageContentView.contentViewCanScroll = NO;//设置滑动属性
    [self.contentView addSubview:_pageContentView];
    
    //搜索按钮
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search)];
    self.navigationItem.rightBarButtonItem = searchBtn;
    //返回按钮
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}




-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)search{
    [UIView animateWithDuration:0.4 animations:^{
        if (_showSearchbar == YES) {
            _searchTableView.hidden = YES;
            _contentView.hidden = NO;//点击收回搜索框，显示原始数据
            [_searchBar resignFirstResponder];
            _searchBar.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width , 40);
            _contentView.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64);
            _showSearchbar = NO;
        }else{
            _searchBar.frame = CGRectMake(0, 64,[UIScreen mainScreen].bounds.size.width , 40);
            _contentView.frame = CGRectMake(0, 64+40, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) -64- 40);
            _showSearchbar = YES;
        }
    } completion:^(BOOL finished) {
    }];
    
}
-(void)turnBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (![searchText  isEqual: @""]) {
        //  执行搜索操作
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *parameters = @{@"key": searchText};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        // 申明请求的数据是json类型
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        //获取常用联系人
        [manager GET:@"http://121.40.229.114/Contacts/contact/search" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            NSArray *resultArr = [responseObject objectForKey:@"contact_list"];
            self.testArray = [NSMutableArray array];
            NSInteger arrCount = [resultArr count];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (arrCount == 0) {
                _promptLab.hidden = NO;
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                _contentView.hidden = YES;
                _searchTableView.hidden = YES;
            }else{
                _promptLab.hidden = YES;
                _contentView.hidden = YES;
                _searchTableView.hidden = NO;
                for (NSDictionary *dic in resultArr) {
                    MGContact *contact = [MGContact contactWithDict:dic];
                    if (contact) {
                        [self.testArray addObject:contact];
                    }
                }
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.searchTableView reloadData];
            }
            
            
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];                NSLog(@"%@",error); //打印错误信息
        }];
    }else{
        _contentView.hidden = NO;
        _searchTableView.hidden = YES;
    }
    
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_searchBar resignFirstResponder];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_testArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierId = @"MGMessageTableViewCell";
    MGMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierId];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MGMessageTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    
    MGContact *contact = _testArray[indexPath.row];
    
    cell.nameLab.text= contact.contactName;
    NSString *imagePath = contact.contactAvatar;
    NSURL *imageUrl = [NSURL URLWithString:imagePath];
    
    [cell.avatarImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"head"] options:SDWebImageRetryFailed];
    return cell;
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MGContact *contact = _testArray[indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MGIndexViewController *indexVC = [storyboard instantiateViewControllerWithIdentifier:@"MGIndexViewController"];
    self.hidesBottomBarWhenPushed = YES;
    indexVC.userId = contact.contactId;
    indexVC.navigationItem.title = contact.contactName;
    [self.navigationController pushViewController:indexVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}


#pragma mark --
- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.pageContentView.contentViewCurrentIndex = endIndex;
}

- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.titleView.selectIndex = endIndex;
}


@end
