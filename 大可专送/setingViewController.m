//
//  setingViewController.m
//  大可专送
//
//  Created by 张允鹏 on 2016/12/3.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import "setingViewController.h"

@interface setingViewController ()

@end

@implementation setingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设置";
    
    self.view.backgroundColor=APP_GARY;
    
    UIView * backView=[[UIView alloc]init];
    [self.view addSubview:backView];
    
    [backView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(74);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(5*45+5);
    }];
    for (int i=0; i<5; i++) {
        UIView * view=[[UIView alloc]init];
        view.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:view];

    }
    
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
