//
//  cityListViewController.m
//  大可专送
//
//  Created by 张允鹏 on 2016/12/5.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import "cityListViewController.h"
#import "mapViewTool.h"
#import "ViewController.h"
#import "ChineseString.h"
@interface cityListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property(nonatomic,strong)NSMutableArray *indexArray;
@property(nonatomic,strong)NSMutableArray *letterResultArr;


//@property (nonatomic, strong) UILabel *sectionTitleView;
//@property (nonatomic, strong) NSTimer *timer;
@end

@implementation cityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"选择城市";
    UITableView * tableView=[[UITableView alloc]init];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView=tableView;
    [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    NSMutableArray * stringsToSort = [NSMutableArray array];
    for (cityListModel * model in [mapViewTool shared].cityListModelArr) {
        [stringsToSort addObject:model.cname];
    }
    self.indexArray = [ChineseString IndexArray:stringsToSort];
    self.letterResultArr = [ChineseString LetterSortArray:stringsToSort];
    
    
//    self.sectionTitleView = ({
//        UILabel *sectionTitleView = [[UILabel alloc] initWithFrame:CGRectMake((DEVICE_WIDTH-100)/2, (DEVICE_HEIGHT-100)/2,100,100)];
//        sectionTitleView.textAlignment = NSTextAlignmentCenter;
//        sectionTitleView.font = [UIFont boldSystemFontOfSize:60];
//        sectionTitleView.textColor = [UIColor blueColor];
//        sectionTitleView.backgroundColor = [UIColor whiteColor];
//        sectionTitleView.layer.cornerRadius = 6;
//        sectionTitleView.layer.borderWidth = 1.f/[UIScreen mainScreen].scale;
//        _sectionTitleView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
//        sectionTitleView;
//    });
//    [self.navigationController.view addSubview:self.sectionTitleView];
//    self.sectionTitleView.hidden = YES;
    
    // Do any additional setup after loading the view.
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexArray;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = [self.indexArray objectAtIndex:section];
    return key;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.indexArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.letterResultArr objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{

    MBProgressHUD * progressHUD =[MBProgressHUD showHUDAddedTo:self.view animated:YES];// [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.label.text = title;
    progressHUD.mode = MBProgressHUDModeText;
    progressHUD.label.font = [UIFont systemFontOfSize:25];
    progressHUD.label.textColor = [UIColor blueColor];
    [progressHUD hideAnimated:YES afterDelay:1];

    return index;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *lab = [UILabel new];
    lab.text = [self.indexArray objectAtIndex:section];
    lab.font = [UIFont boldSystemFontOfSize:18];
    lab.textColor = [UIColor blueColor];
    lab.frame = CGRectMake(15, 0, 100, 30);
    [view addSubview:lab];
    return view;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return [self.indexArray objectAtIndex:section];
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cityName = [[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
    for (cityListModel * model in [mapViewTool shared].cityListModelArr) {
        if ([model.cname isEqualToString:cityName]) {
            
            [mapViewTool shared].deliverCount=nil;
//            [mapViewTool shared].model = model;
            [[mapViewTool shared] setMapCenterWithLocation:[AMapGeoPoint locationWithLatitude:model.lat.floatValue longitude:model.lng.floatValue]];
            [self.navigationController popViewControllerAnimated:YES];

            break;
        }
    }
    
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
