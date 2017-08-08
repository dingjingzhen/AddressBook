//
//  ViewController.m
//  WKWebViewDemo
//
//  Created by Admin on 17/3/30.
//  Copyright © 2016年 Admin. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import <MBProgressHUD.h>
#import "MGIndexViewController.h"
#import "MGBookshelfViewController.h"

@interface MGIndexViewController ()<WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate>
//webView
@property(nonatomic,strong)WKWebView *webView;
@property (nonatomic,strong) MBProgressHUD *hu;
@end

@implementation MGIndexViewController

#pragma mark----- VC 生命周期-----

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //移除监听
    [self.webView removeObserver:self forKeyPath:@"loading"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //添加KVO监听
    [self.webView addObserver:self
                   forKeyPath:@"loading"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    [self.webView addObserver:self
                   forKeyPath:@"title"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    [self creatWebView];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    self.navigationItem.leftBarButtonItem = leftBtn;
}

#pragma mark----- 导航按钮响应事件-----

- (void)goback{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        NSLog(@"back");
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


//创建webView
- (void)creatWebView{
    
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    //初始化偏好设置属性：preferences
    config.preferences = [WKPreferences new];
    //The minimum font size in points default is 0;
    config.preferences.minimumFontSize = 10;
    //是否支持JavaScript
    config.preferences.javaScriptEnabled = YES;
    //不通过用户交互，是否可以打开窗口
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    //通过JS与webView内容交互
    config.userContentController = [WKUserContentController new];
    // 注入JS对象名称senderModel，当JS通过senderModel来调用时，我们可以在WKScriptMessageHandler代理中接收到
    [config.userContentController addScriptMessageHandler:self name:@"senderModel"];
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) configuration:config];
//    NSString *urlStr =@"http://121.40.229.114/Contacts/page/index.html#/home/597d4b3c7f2bf60245e2c113";
//    NSURL *url = [NSURL URLWithString:urlStr];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    //    [self.webView loadRequest:[NSURLRequest requestWithURL:path]];
    NSString *urlStr = @"http://121.40.229.114/Contacts/page/index.html#/home/";
    urlStr = [urlStr stringByAppendingString:self.userId];
    // 设置访问的URL
    NSURL *url = [NSURL URLWithString:urlStr];
    // 根据URL创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60];
    // WKWebView加载请求
    [self.webView loadRequest:request];
    
    self.webView.scrollView.delegate = self;
    
    [self.view addSubview:self.webView];
    
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
}


- (IBAction)pushTo:(UIButton *)sender
{
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SecondViewController"] animated:YES];
    
}

#pragma mark - KVO监听函数
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"title"]) {
//        self.title = self.webView.title;
    }else if([keyPath isEqualToString:@"loading"]){
        NSLog(@"loading");
    }
    else if ([keyPath isEqualToString:@"estimatedProgress"]){
        
    }
    
    if (!self.webView.loading) {
        [UIView animateWithDuration:0.5 animations:^{
        }];
    }
    
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    //这里可以通过name处理多组交互
    if ([message.name isEqualToString:@"senderModel"]) {
        //body只支持NSNumber, NSString, NSDate, NSArray,NSDictionary 和 NSNull类型
        NSLog(@"%@",message.body);
        if ([message.body isKindOfClass:[NSString class]]) {
            if ([message.body isEqualToString:@"pushNextVC"]) {
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                MGBookshelfViewController *bVC = [storyboard instantiateViewControllerWithIdentifier:@"MGBookshelfViewController"];
                bVC.mineOrhe = @"mine";
                bVC.contactId = self.userId;
                bVC.navigationItem.title = @"我的书库";
//                BVC.contactId = self.userId;
                [self.navigationController pushViewController:bVC animated:YES];
                
            }else if ([message.body isEqualToString:@"bookShelf"]) {
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                MGBookshelfViewController *bVC = [storyboard instantiateViewControllerWithIdentifier:@"MGBookshelfViewController"];
                bVC.mineOrhe = @"his";
                bVC.contactId = self.userId;
                bVC.navigationItem.title = @"Ta的分享";
                [self.navigationController pushViewController:bVC animated:YES];
                
            }
        }
        
    }
    
}

#pragma mark = WKNavigationDelegate
//在响应完成时，调用的方法。如果设置为不允许响应，web内容就不会传过来

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    decisionHandler(WKNavigationResponsePolicyAllow);
}
//接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}

//开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    _hu = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [_hu setMode:MBProgressHUDModeIndeterminate];
}
//当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
//页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"title:%@",webView.title);
     [_hu hideAnimated:YES];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    [_hu hideAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;}

@end
