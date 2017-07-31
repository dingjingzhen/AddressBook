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
#define naviHeight  (self.navigationController.navigationBar.frame.size.height)+([[UIApplication sharedApplication] statusBarFrame].size.height)


@interface MGAddressBookViewController ()<FSPageContentViewDelegate,FSSegmentTitleViewDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) FSPageContentView *pageContentView;
@property (nonatomic,strong) FSSegmentTitleView *titleView;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) NSMutableArray *testArray;//测试搜索用的数据
@property (nonatomic,strong) UIView *contentView;//用来存放titleview和pageContentView，便于隐藏等操作
@property (nonatomic,assign) BOOL showSearchbar;//用来判断是否显示searchbar
@property (nonatomic,strong) UITableView *searchTableView;//用了显示搜索到的数据

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
    
    _testArray = [NSMutableArray arrayWithObjects:@"姜春雨",@"贾慧云",@"陈艺清",@"姜春雨",@"贾慧云",@"陈艺清",@"姜春雨",@"贾慧云",@"陈艺清",@"姜春雨",@"贾慧云",@"陈艺清",@"姜春雨",@"贾慧云",@"陈艺清",@"姜春雨",@"贾慧云",@"陈艺清",@"姜春雨",@"贾慧云",@"陈艺清", nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"通讯录";
    
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentView];
    
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 35) titles:@[@"常用联系人",@"企业通讯录"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.titleView.titleSelectFont = [UIFont systemFontOfSize:17];
    self.titleView.selectIndex = 0;
    [self.contentView addSubview:_titleView];
    [self searchTableView];
    [self searchBar];
    
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    for (NSString *title in @[@"常用联系人",@"企业通讯录"]) {
        MGChildViewController *vc = [[MGChildViewController alloc]init];
        vc.title = title;
        [childVCs addObject:vc];
    }
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0,38, CGRectGetWidth(self.view.bounds), self.contentView.bounds.size.height - 38) childVCs:childVCs parentVC:self delegate:self];
    self.pageContentView.contentViewCurrentIndex = 0;
    self.pageContentView.backgroundColor = [UIColor whiteColor];
    self.pageContentView.contentViewCanScroll = NO;//设置滑动属性
    [self.contentView addSubview:_pageContentView];

    //搜索按钮
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search)];
    self.navigationItem.rightBarButtonItem = searchBtn;
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

#pragma mark -- UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    _contentView.hidden = YES;
    _searchTableView.hidden = NO;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_searchBar resignFirstResponder];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_testArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierId = @"searchcellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierId];
    }
    cell.imageView.image = [UIImage imageNamed:@"head"];
    cell.textLabel.text = _testArray[indexPath.row];
    return cell;
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
