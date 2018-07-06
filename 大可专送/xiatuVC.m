//
//  xiatuVC.m
//  大可专送
//
//  Created by Mac on 18/2/8.
//  Copyright © 2018年 张允鹏. All rights reserved.
//

#import "xiatuVC.h"
@interface xiatuVC ()

@end

@implementation xiatuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"";
    self.view.backgroundColor=[UIColor whiteColor];
    UIImageView *imageview1=[UIImageView new];
    [self.view addSubview: imageview1];
    imageview1.image=_image;
    imageview1.sd_layout
    .widthIs(px_scale(400))
    .heightIs(px_scale(400))
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view,px_scale(150));
    
    UIButton *phonebut=[UIButton new];
    [self.view addSubview: phonebut];
    [phonebut setBackgroundColor:[UIColor blackColor]];
    [phonebut setTitle:@"下载图片" forState:0];
    phonebut.titleLabel.font=[UIFont systemFontOfSize:px_scale(24)];
    [phonebut setTitleColor:[UIColor whiteColor] forState:0];
    phonebut.sd_layout
    .topSpaceToView(imageview1,px_scale(30))
    .centerXEqualToView(self.view)
    .widthIs(px_scale(120))
    .heightIs(px_scale(60));
    [phonebut addTarget: self action:@selector(loadImageFinished) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}
-(void)loadImageFinished
{
    UIImageWriteToSavedPhotosAlbum(_image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [self showMsg:@"保存成功" andAnimationCompletion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
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
