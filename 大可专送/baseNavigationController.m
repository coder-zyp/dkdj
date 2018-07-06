//
//  baseNavigationController.m
//  大可专送
//
//  Created by 张允鹏 on 2016/12/5.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import "baseNavigationController.h"

@interface baseNavigationController ()

@end

@implementation baseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.tintColor=[UIColor lightGrayColor];
    // Do any additional setup after loading the view.
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    if (viewController.navigationItem.backBarButtonItem ==nil ) {
        viewController.navigationItem.backBarButtonItem = [self creatBackButton];
    }
}
-(UIBarButtonItem *)creatBackButton
{
//    return [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_back"]style:UIBarButtonItemStylePlain target:self action:@selector(popSelf)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @" ";
    backItem.tintColor=[UIColor grayColor];
    return backItem;
}
-(void)popSelf
{
    [self popViewControllerAnimated:YES];
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
