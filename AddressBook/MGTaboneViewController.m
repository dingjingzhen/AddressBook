//
//  MGTaboneViewController.m
//  AddressBook
//
//  Created by Apple on 2017/8/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MGTaboneViewController.h"
#import "MGCollectionViewCell.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "MGBook.h"
@interface MGTaboneViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *bookCollectionView;
@property (nonatomic,strong) NSMutableArray *bookArray;
@end

@implementation MGTaboneViewController

- (void)viewDidLoad
{
    [self getBookdata];
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

    [self.self.bookCollectionView registerNib:[UINib nibWithNibName:@"MGCollectionViewCell"bundle:nil]forCellWithReuseIdentifier:@"MGCollectionViewCell"];
    
    self.bookCollectionView.alwaysBounceHorizontal = YES;
    
    [self.view addSubview:self.bookCollectionView];
}

//获取用户书库信息
-(void)getBookdata{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId ;
    userId = [userDefaults stringForKey:@"contactId"];
   
    
    NSDictionary *parameters1 = @{@"userId": userId,@"count":@"100"};
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
        
      
        [self.bookCollectionView reloadData];
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error); //打印错误信息
    }];
    
}




#pragma mark - collectionView delegate
//设置分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}

//每个分区上的元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.bookArray.count;
}

//设置元素内容
- (UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"MGCollectionViewCell";
    MGCollectionViewCell *cell = (MGCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
    
    
    MGBook *book = self.bookArray[indexPath.row];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];   //在创建Xib的时候给了控件相应的tag值
    imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    imageView.layer.shadowOpacity = 0.6f;
    imageView.layer.shadowRadius = 4.f;
    imageView.layer.shadowOffset = CGSizeMake(2,2);
    UILabel *label = (UILabel *)[cell viewWithTag:2];
    
    NSString *imagePath = book.bookLogo;
    NSURL *imageUrl = [NSURL URLWithString:imagePath];
    [imageView sd_setImageWithURL:imageUrl];
    
//    [imageView setImage:[UIImage imageNamed:@"head"]];
//    [label setText:[self.dataArray objectAtIndex:indexPath.row]];
    label.text = book.bookName;
//    cell.backgroundColor = [UIColor redColor];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.view.bounds.size.width/3 - 23, 4*self.view.bounds.size.width/9 - 2);
}

//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 20;
}

//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}


@end
