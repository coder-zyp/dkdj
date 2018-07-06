//
//  orderDetailViewController.m
//  大可专送
//
//  Created by 张允鹏 on 2016/12/3.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import "orderDetailViewController.h"
#import "ZJScrollPageView.h"
#import "orderInfoViewController.h"
#import "orderStateViewController.h"
#import "ZJScrollPageView.h"
@interface orderDetailViewController ()<ZJScrollPageViewDelegate>

@property(strong, nonatomic)NSArray<NSString *> *titles;

@property(strong, nonatomic)NSArray<UIViewController<ZJScrollPageViewChildVcDelegate> *> *childVcs;


@end

@implementation orderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"订单";
    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.childVcs = [self setupChildVc];
    [self setupSegmentView];
    
    // Do any additional setup after loading the view.
}
- (void)setupSegmentView {
    self.titles=@[@"订单详细",@"订单状态"];
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示滚动条
    style.showLine = YES;
    style.scrollLineColor=APP_ORAGNE;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    style.autoAdjustTitlesWidth=YES;
    style.selectedTitleColor=[UIColor colorWithRed:0.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1];
    // 初始化
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 64.0, self.view.bounds.size.width, self.view.bounds.size.height - 64.0) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    
    [self.view addSubview:scrollPageView];

}

- (NSArray *)setupChildVc {
    NSMutableArray * arr=[NSMutableArray array];
    orderInfoViewController * vc=[[orderInfoViewController alloc] init];
    vc.dataid=_orderid;

    [arr addObject:vc];
    orderStateViewController * vc2=[[orderStateViewController alloc] init];

    vc2.dataid=_orderid;
    [arr addObject:vc2];
    return arr;
}

- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    if (!childVc) {
        childVc = self.childVcs[index];
    }
    return childVc;
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
