//
//  WebViewController.m
//  大可专送
//
//  Created by 张允鹏 on 2018/4/27.
//  Copyright © 2018年 张允鹏. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WKWebView.h>
//#import "WKWebViewConfiguration.h"

@interface WebViewController ()<WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, strong) WKWebView * webView;
@end

@implementation WebViewController

- (instancetype)initWithURLString:(NSString *)url
{
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
    self.webView.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    self.webView.allowsBackForwardNavigationGestures = YES;
    
    // Do any additional setup after loading the view.
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"页面开始加载时调用");
    [SVProgressHUD showWithStatus:@"加载中"];
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"页面加载完成之后调用");
    [SVProgressHUD dismiss];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
//// 在收到响应后，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//
//    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
//    //允许跳转
//    decisionHandler(WKNavigationResponsePolicyAllow);
//    //不允许跳转
//    //decisionHandler(WKNavigationResponsePolicyCancel);
//}
//// 在发送请求之前，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
//
//    NSLog(@"%@",navigationAction.request.URL.absoluteString);
//    //允许跳转
//    decisionHandler(WKNavigationActionPolicyAllow);
//    //不允许跳转
//    //decisionHandler(WKNavigationActionPolicyCancel);
//}
//#pragma mark - WKUIDelegate
//// 创建一个新的WebView
//- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
//    return [[WKWebView alloc]init];
//}
//// 输入框
//- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
//    completionHandler(@"http");
//}
//// 确认框
//- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
//    completionHandler(YES);
//}
//// 警告框
//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
//    NSLog(@"%@",message);
//    completionHandler();
//}

-(BOOL)prefersStatusBarHidden{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
