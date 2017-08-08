//
//  ViewController.m
//  WKWebViewDemo
//
//  Created by Admin on 17/3/30.
//  Copyright © 2016年 Admin. All rights reserved.
//

#import "ViewController.h"
#import <MBProgressHUD.h>
#import "MGDetailMessageController.h"

@interface MGDetailMessageController ()<UIWebViewDelegate>
//webView
@property (nonatomic,strong) MBProgressHUD *hu;
@end

@implementation MGDetailMessageController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
//    [self creatWebView];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    NSString *urlStr = @"http://121.40.229.114/Contacts/page/index.html#/message/";
    webView.delegate = self;
    urlStr = [urlStr stringByAppendingString:self.userId];
    // 设置访问的URL
    NSURL *url = [NSURL URLWithString:urlStr];
    // 根据URL创建请求
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60];
        // WKWebView加载请求
        [webView loadRequest:request];
    [self.view addSubview:webView];

}

//#pragma mark----- 导航按钮响应事件-----
//
- (void)goback{
    
        [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView

{
    _hu = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [_hu setMode:MBProgressHUDModeIndeterminate];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView

{
    [_hu hideAnimated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error

{
    [_hu hideAnimated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

@end