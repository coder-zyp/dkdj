//
//  HTMLViewController.m
//  大可专送
//
//  Created by 张允鹏 on 2016/12/2.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import "HTMLViewController.h"

@interface HTMLViewController ()
@property (nonatomic,strong) NSURLRequest * urlReq;
@end

@implementation HTMLViewController
- (instancetype)initWithUrl:(NSString *)urlStr
{
    self = [super init];
    if (self) {
        _urlReq=[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *webView=[[UIWebView alloc]init];
    [self.view addSubview:webView];
    webView.backgroundColor=[UIColor whiteColor];
    [webView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [webView loadRequest:_urlReq];
    // Do any additional setup after loading the view.
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
