//
//  MGLeaderboardViewController.m
//  AddressBook
//
//  Created by Apple on 2017/7/31.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MGLeaderboardViewController.h"
#import "MGChildViewController.h"
#import "MGMessageChildViewController.h"
#import <FSScrollContentView.h>
#define naviHeight  (self.navigationController.navigationBar.frame.size.height)+([[UIApplication sharedApplication] statusBarFrame].size.height)


@interface MGLeaderboardViewController ()<FSPageContentViewDelegate,FSSegmentTitleViewDelegate>
@property (nonatomic,strong) FSPageContentView *pageContentView;
@property (nonatomic,strong) FSSegmentTitleView *titleView;

@property (nonatomic,strong) UIView *contentView;//用来存放titleview和pageContentView，便于隐藏等操作


@end

@implementation MGLeaderboardViewController




- (void)viewDidLoad {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"排行榜";
    
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentView];
    
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 35) titles:@[@"部门排行榜",@"企业排行榜"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.titleView.titleSelectFont = [UIFont systemFontOfSize:17];
    self.titleView.selectIndex = 0;
    [self.contentView addSubview:_titleView];
    
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    for (NSString *title in @[@"部门排行榜",@"企业排行榜"]) {
        MGMessageChildViewController *vc = [[MGMessageChildViewController alloc]init];
        vc.title = title;
        [childVCs addObject:vc];
    }
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0,38, CGRectGetWidth(self.view.bounds), self.contentView.bounds.size.height - 38) childVCs:childVCs parentVC:self delegate:self];
    self.pageContentView.contentViewCurrentIndex = 0;
    self.pageContentView.backgroundColor = [UIColor whiteColor];
    self.pageContentView.contentViewCanScroll = YES;//设置滑动属性
    [self.contentView addSubview:_pageContentView];
    
    
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
