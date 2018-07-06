//
//  BuyViewController.m
//  国警骑士
//
//  Created by 张允鹏 on 2016/11/30.
//  Copyright © 2016年 张允鹏. All rights reserved.
//
#import "BuyViewController.h"
#import "UITextView+YLTextView.h"
#import "mapViewTool.h"
#import "sendFreeModel.h"
#import "priceDetailViewController.h"
#import "payWindow.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "YLButton.h"
#import "AdjustTextView.h"
#import "shoplistVC.h"
#import "UITextView+WZB.h"
#import "GoodModel.h"
#import <MMPickerView.h>
@interface BuyViewController ()<MapToolDelegate,CNContactPickerDelegate,CNContactViewControllerDelegate,UIActionSheetDelegate>
{
    UIScrollView * scrollView;
}
//@property (nonatomic, strong) UILabel * choosedLabel;
@property (nonatomic, strong) UITextField * textView;
@property (nonatomic, strong) NSArray * placeholderArr;
@property (nonatomic, strong) NSString * noteStr;
@property (nonatomic, strong) UIButton  * checkBtn1;
@property (nonatomic, strong) UIButton  * collectBtn1;
@property (nonatomic, strong) UIButton  * collectBtn2;
@property (nonatomic, strong) UIButton  * noPriceBtn;
@property (nonatomic, strong) UIView * typeView;
@property (nonatomic, strong) UIView * noteView;
@property (nonatomic, strong) UIView * addressView;
@property (nonatomic, strong) UIView * phoneView;
@property (nonatomic, strong) UIView * goodInfoView;
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) UILabel * bottomDistanceLabel;
@property (nonatomic, strong) YLButton * bottomPriceBtn;
@property (nonatomic, strong) UITextField * buyAddressTextField;
@property (nonatomic, strong) UITextField * sendAddressTextField;
@property (nonatomic, strong) UITextField * phoneTextField;
@property (nonatomic, strong) UITextField * priceTextField;
@property (nonatomic, strong) sendFreeModel * freeModel;
@property (nonatomic, strong) CNContactPickerViewController *contactsPickerVC;
@property (nonatomic, strong) NSArray * contactPhoneArr;
@property (nonatomic, strong) NSMutableArray * btnModels;
@property (nonatomic, strong) GoodModel * goodModel;
@property (nonatomic, strong) NSArray <UITextField *>* GoodInfoTextFields;
@end

@implementation BuyViewController
-(void)viewWillAppear:(BOOL)animated{
    [mapViewTool shared].delegate=self;
//    if (![self.adress isEqualToString:@""]) {
//
//        _buyAddressTextField.text=self.adress;
//    }
    if (self.lat2) {
    //double distens= [self distanceBetweenOrderBy:[[_buyModel.lat doubleValue] :[_lat2 doubleValue]:[_buyModel.lng doubleValue]:[_lng2 doubleValue]];
    double distens=[self distanceBetweenOrderBy:[_buyModel.lat doubleValue] :[_lat2 doubleValue] :[_buyModel.lng doubleValue] :[_lng2 doubleValue]];
    [self getSendFreeWithIsNearbuy:NO withDistance:[NSString stringWithFormat:@"%f",distens]];
    }
    [self checkAddress];
}
-(void)setSendModel:(mapAddressModel *)sendModel{
    _sendModel=sendModel;
    if (sendModel) {
        _sendAddressTextField.text=[NSString stringWithFormat:@"%@ %@",sendModel.poiName,sendModel.buildName];
    }else{
        _sendAddressTextField.text=@"";
    }
    
    if (sendModel.addressId) {
        [_collectBtn2 setSelected:YES];
    }else{
        [_collectBtn2 setSelected:NO];
    }
    [self checkAddress];
}
-(void)setBuyModel:(mapAddressModel *)buyModel{
    
    _buyModel =buyModel;
    if (buyModel) {
        _buyAddressTextField.text=[NSString stringWithFormat:@"%@ %@",buyModel.poiName,buyModel.buildName];
    }else{
        _buyAddressTextField.text=@"";
    }
    if (buyModel.addressId) {
        [_collectBtn1 setSelected:YES];
    }else{
        [_collectBtn1 setSelected:NO];
    }
    [self checkAddress];
}
-(void)setFreeModel:(sendFreeModel *)freeModel{
    _freeModel=freeModel;
    if (freeModel==nil) {
        _bottomPriceBtn.hidden=YES;
        _bottomDistanceLabel.text=@"";
        //        [_bottomPriceBtn setTitle:@"" forState:0];
    }else{
        _bottomPriceBtn.hidden=NO;
        _bottomDistanceLabel.text=[NSString stringWithFormat:@"%@km",freeModel.alljuli];
        NSString *str=[NSString stringWithFormat:@"￥%.2f",[freeModel.totalfee floatValue]];
        [_bottomPriceBtn setTitle:str forState:0];
    }
}

-(void)checkAddress{
    if (_buyModel && _sendModel) {
        if (_checkBtn1.isSelected) {
            [_checkBtn1 setSelected:NO];
        }
        [[mapViewTool shared] getNaviWithStartLocation:_buyModel.location withEndLocation:_sendModel.location];
    }else{
        if (_sendModel && !_buyModel) {
            if (_checkBtn1.isSelected) {
                [self getSendFreeWithIsNearbuy:YES withDistance:@"0"];
            }
            
        }else{
            self.freeModel=nil;
        }
    }
}
//两点之前距离
-(double)distanceBetweenOrderBy:(double) lat1 :(double) lat2 :(double) lng1 :(double) lng2{
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    double  distance  = [curLocation distanceFromLocation:otherLocation];
    return  distance/10000000;
}
-(void)calculateRouteSuccessWithDistance:(NSString *)distance{
    [self getSendFreeWithIsNearbuy:NO withDistance:distance];
}

- (void)commitOrder{
    
    if (!_sendAddressTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请详选择送货地址"];
        return;
    }
    
    if (self.sendModel.cityid==nil) {
        [SVProgressHUD showErrorWithStatus:@"所选城市未开放"];
        return;
    }
    if (_textView.text.length<2) {
        [SVProgressHUD showErrorWithStatus:@"请详细填写购买物品"];
        return;
    }
    
    if (!_phoneTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请填写电话"];
        return;
    }
    if (!_priceTextField.text.length&& self.noPriceBtn.isSelected==NO) {
        [SVProgressHUD showErrorWithStatus:@"请填写价格"];
        return;
    }
    
    if (![mapViewTool shared].model.city) {
        [SVProgressHUD showErrorWithStatus:@"当前城市服务未开通"];
        return;
    }
    
    
    NSString *mark=[NSString stringWithFormat:@"%@",_textView.text];
    NSString *nearbuy=_checkBtn1.isSelected ?@"1":@"0";
    NSString *isknow=_noPriceBtn.isSelected ?@"0":@"1";

    NSMutableDictionary *mdic=[[NSMutableDictionary alloc]init];
    [mdic setObject:@"1" forKey:@"ordertype"];
    [mdic setObject:APP_USERID forKey:@"userid"];
    if (_buyModel) {
        [mdic setObject:_buyModel.lat forKey:@"lat1"];
        [mdic setObject:_buyModel.lng forKey:@"lng1"];
    }

    [mdic setObject:_sendModel.lat forKey:@"lat2"];
    [mdic setObject:_sendModel.lng forKey:@"lng2"];
    [mdic setObject:@"3" forKey:@"source"];
    [mdic setObject:mark forKey:@"remark"];
    [mdic setObject:nearbuy forKey:@"nearbuy"];
    [mdic setObject:_buyAddressTextField.text forKey:@"address1"];
    [mdic setObject:_sendAddressTextField.text forKey:@"address2"];
    [mdic setObject:_phoneTextField.text forKey:@"tel2"];
    [mdic setObject:@"" forKey:@"tel1"];
    [mdic setObject:isknow forKey:@"isknow"];
    [mdic setObject:_priceTextField.text forKey:@"foodfee"];
    [mdic setObject:_freeModel.qibufee forKey:@"sendfee"];
    [mdic setObject:_freeModel.lichengfee forKey:@"lichengfee"];
    [mdic setObject:_freeModel.totalfee forKey:@"totalfee"];
    [mdic setObject:[self getordid] forKey:@"orderid"];
    [mdic setObject:_freeModel.alljuli forKey:@"juli"];
    
    [mdic setObject:[mapViewTool shared].model.cityid forKey:@"cityid"];
    
    mdic[@"zhongliang"]=self.GoodInfoTextFields[0].text;//重量名字，
    mdic[@"tiji"]=self.GoodInfoTextFields[1].text; // 体积名字，

    for (CarInfo *model in self.goodModel.CarInfos) {
        if ([model.name isEqualToString:self.GoodInfoTextFields[2].text]) {
            mdic[@"cheid"]=model.id;//车辆ID，
            mdic[@"chename"]=model.name;//车名称，
            mdic[@"chemoney"]=model.mone ? model.mone : @""; //车辆的附加费
        }
    }
    
    
    [_sendModel saveToUserDefaults];
    payWindow *window = [payWindow shareShowWindow];
    window.param=mdic;
    [window show];
}
-(NSString *)getordid
{
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < 32; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }

    }
    return string;
}
-(void)getSendFreeWithIsNearbuy:(BOOL)nearbuy withDistance:(NSString *) distance{
    //
    
    if (!_sendModel) {
        self.freeModel=nil;
        return;
    }
    if (![mapViewTool shared].model.cityid) {
        return;
    }
    NSString * url=APP_URL @"GetSendfee.aspx";
    //[SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary * param=@{@"juli":distance,@"cityid":[mapViewTool shared].model.cityid,@"isnearbuy":nearbuy==YES?@"1":@"0"};
    [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([[dic objectForKey:@"success"] boolValue]) {

            self.freeModel=[sendFreeModel mj_objectWithKeyValues:[dic objectForKey:@"feedata"]];
        }else{
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"errorMsg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"买东西";
    
    self.view.backgroundColor=[UIColor whiteColor];
    UIScrollView * scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-49-64)];
    [self.view addSubview:scrollView];
    scrollView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    [self getGoodInfo];
    [scrollView addSubview:self.typeView];

    [self.typeView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(0);
    }];
    
    [self getTypeBtnClickViewData];
    
    [scrollView addSubview:self.noteView];
    [_noteView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_typeView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(85);
    }];
    
    [scrollView addSubview:self.addressView];
    [_addressView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_noteView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(90);
    }];
    
    [scrollView addSubview:self.phoneView];
    [_phoneView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_addressView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(90);
    }];
    
    [scrollView addSubview:self.goodInfoView];
    [self.goodInfoView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_phoneView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(135);
        make.bottom.mas_equalTo(scrollView.mas_bottom).inset(10);
    }];

    
    [self.view addSubview:self.bottomView];
    [_bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(49);
    }];
   
    // Do any additional setup after loading the view.
}

-(UIView *)bottomView{
    if (_bottomView==nil) {
        _bottomView=[[UIView alloc]init];
        _bottomView.backgroundColor= [UIColor whiteColor];
        
        _bottomPriceBtn=[YLButton buttonWithType:UIButtonTypeCustom];
        [_bottomPriceBtn addTarget:self action:@selector(priceDetailBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomPriceBtn setFrame:CGRectMake(0, 0, 73, 49)];
        [_bottomPriceBtn setBackgroundColor:[UIColor clearColor]];
        [_bottomPriceBtn setTitleColor:APP_BLUE forState:0];
        [_bottomPriceBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_bottomPriceBtn setImage:[UIImage imageNamed:@"资费标准"] forState:0];
        _bottomPriceBtn.imageRect=CGRectMake(3, 15, 20, 20);
        _bottomPriceBtn.titleRect=CGRectMake(24, 0, 50, 49);
        [_bottomView addSubview:_bottomPriceBtn];
        
        
        UIView * lineVertical=[[UIView alloc]init];
        lineVertical.backgroundColor=APP_BLUE;
        [_bottomPriceBtn addSubview:lineVertical];
        [lineVertical makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lineVertical.superview).offset(5);
            make.bottom.mas_equalTo(lineVertical.superview).offset(-5);
            make.left.mas_equalTo(lineVertical.superview.mas_right).offset(0);
            make.width.mas_equalTo(0.5);
        }];
        _bottomDistanceLabel =[[UILabel alloc]init];
        _bottomDistanceLabel.font=[UIFont systemFontOfSize:13];
        _bottomDistanceLabel.textColor=[UIColor lightGrayColor];
        [_bottomDistanceLabel setFrame:CGRectMake(80, 0, 80, 49)];
        [_bottomView addSubview:_bottomDistanceLabel ];
        
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor=WT_RGBColor(0xffffff);
        [btn setTitle:@"去支付" forState:0];
        [btn addTarget:self action:@selector(commitOrder) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(_bottomView);
            make.size.mas_equalTo(CGSizeMake(85, 49));
        }];
        [btn setTitleColor: WT_RGBColor(0x016bb7) forState:0];
        self.freeModel=nil;
    }
    return _bottomView;
}
-(UIView *)typeView{
    if (_typeView==nil) {
        _typeView=[[UIView alloc]init];
        _typeView.backgroundColor=[UIColor whiteColor];
    }
    return _typeView;
}
-(UIView *)noteView{
    if (_noteView==nil) {
        _noteView=[[UIView alloc]init];
        _noteView.backgroundColor=[UIColor whiteColor];
        
        
        UIImageView * imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"随意购"]];
        [_noteView addSubview:imgView];
        [imgView makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.left.mas_equalTo(8);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        UIView * line=[[UIView alloc]init];
        line.backgroundColor=APP_GARY;
        [_noteView addSubview:line];
        line.sd_layout.leftSpaceToView(imgView, 5)
        .rightSpaceToView(_noteView, 0)
        .heightIs(1).topSpaceToView(_noteView, 50);
        
        _textView=[UITextField new];
        _textView.font = [UIFont systemFontOfSize:13];
        _textView.placeholder = @"填写您要购买的商品";
        _textView.clearsOnBeginEditing = YES;
        _textView.clearButtonMode = UITextFieldViewModeWhileEditing;

        [_noteView insertSubview:_textView atIndex:0 ];
        _textView.sd_layout
        .leftSpaceToView(imgView,10)
        .rightSpaceToView(_noteView,px_scale(20))
        .centerYEqualToView(imgView)
        .heightIs(18);

        
        UILabel * label=[[UILabel alloc]init];
        [_noteView addSubview:label];
        label.text=@"特殊要求";
        label.font=[UIFont systemFontOfSize:14];
        label.textColor=[UIColor lightGrayColor];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line);
            make.left.mas_equalTo(40);
            make.width.mas_equalTo(60);
            make.bottom.mas_equalTo(_noteView);
        }];
        
        _checkBtn1=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [_checkBtn1 setImage:[UIImage imageNamed:@"取消勾选框"] forState:UIControlStateSelected];
        [_checkBtn1 setImage:[UIImage imageNamed:@"勾选框"] forState:0];
        [_checkBtn1 addTarget:self action:@selector(checkbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _checkBtn1.tag=1;
        [_noteView addSubview:_checkBtn1];
        [_checkBtn1 makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(label);
            make.left.mas_equalTo(110);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
        
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_noteView addSubview:btn];
        btn.tag=1;
        [btn addTarget:self action:@selector(checkbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"任意地址购买" forState:0];
        btn.titleLabel.textAlignment=NSTextAlignmentLeft;
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn setTitleColor:[UIColor lightGrayColor] forState:0];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line);
            make.left.mas_equalTo(_checkBtn1.mas_right).and.with.offset(-3);
            make.width.mas_equalTo(100);
            make.bottom.mas_equalTo(_noteView);
        }];
    }
    return _noteView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 点击事件
-(void)checkbtnClick:(UIButton *)btn{
    if (btn.tag==1) {
        [_checkBtn1 setSelected:![_checkBtn1 isSelected]];
        if (_checkBtn1.isSelected) {
            self.buyModel=nil;
        }else{
            self.freeModel=nil;
        }
        [self checkAddress];
    }
    else if (btn.tag==2){
        //        [_checkBtn2 setSelected:![_checkBtn2 isSelected]];
    }
}
-(void)changeAddressBtnClick{
    mapAddressModel * model= self.buyModel;
    self.buyModel=_sendModel;
    self.sendModel=model;
}
-(void)getTypeBtnClickViewData{
    
    if (![mapViewTool shared].model.cityid) {
        return;
    }
    NSString * url=@"http://www.gjqb110.com/App/Cpaotui/getShopFenlei.aspx";
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:@{@"cityid":[mapViewTool shared].model.cityid} progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSArray *arr=[dic objectForKey:@"data"];
        [self.typeView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        if (dic && [[dic objectForKey:@"state"] intValue]==1 && arr.count) {
            [self.typeView updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(90);
            }];
            _btnModels = [NSMutableArray array];
            self.typeView.hidden = NO;
            
            CGFloat space = 10;
            CGFloat width = (DEVICE_WIDTH- space*5)/4;
            int i = 0;
            for (NSDictionary *dic in arr) {
                butmodel *btnModel=[[butmodel alloc]init];
                btnModel.classname=[dic objectForKey:@"classname"];
                btnModel.butid=[dic objectForKey:@"id"];
                [self.btnModels addObject:btnModel];

                UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(space +(space+width)*(i%4), 10 +40*(i/4), width, 30);
                btn.tag=100+i;
                [btn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn.layer setCornerRadius:5];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
                [btn setTitleColor:[UIColor blackColor] forState:0];
                [_typeView addSubview:btn];
                [btn setBackgroundColor:[UIColor colorWithRed:250/255.0 green:217/255.0 blue:0 alpha:1]];
                [btn setTitle:btnModel.classname forState:0];
                i++;
            }
            [SVProgressHUD dismiss];
        }else{
            [self.typeView makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
            self.typeView.hidden = YES;
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"errorMsg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error);
    }];
}
-(void)getGoodInfo{
    if (![mapViewTool shared].model.cityid) {
        return;
    }
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET: APP_URL @"getTJzlLx.aspx" parameters:@{@"cityid":[mapViewTool shared].model.cityid} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        if ([[dic objectForKey:@"state"] intValue]  == 1 ) {
            self.goodModel  = [GoodModel mj_objectWithKeyValues:responseObject];
            
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
}
-(void)addressBtnClick:(UIButton *)btn{
    MapDetailViewController * vc=[[MapDetailViewController alloc]init];
    vc.pushBtnTag=btn.tag;
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}
//代理方法
-(void)okBtnClickWith:(mapAddressModel *)model withBtnTag:(NSInteger)tag{
    
    mapAddressModel * Addressmodel = [[mapAddressModel alloc]initWithModle:model];
    if (tag==0) {
        if (Addressmodel.cityid != self.buyModel.cityid) {
            [self getTypeBtnClickViewData];
        }
        self.buyModel = Addressmodel;
    }else{
        if (Addressmodel.cityid != self.sendModel.cityid) {
            [self getTypeBtnClickViewData];
        }
        self.sendModel= Addressmodel;
    }
}

-(void)collectBtnClick:(UIButton *)btn{
    mapAddressModel * model= btn==_collectBtn1? _buyModel:_sendModel;
    if (model==nil&&model.poiName==nil) {
        return;
    }
    NSString * detailAddress=model.buildName?model.buildName:@"";
    NSMutableDictionary * param=[NSMutableDictionary dictionaryWithDictionary:
                                 @{@"userid":APP_USERID,
                                   @"poiName":model.poiName,
                                   @"poiAddress":model.poiAddress,
                                   @"detailAddress":detailAddress,
                                   @"lat":model.lat,
                                   @"lng":model.lng,
                                }];

    if (model.addressId) {
        [param setObject:model.addressId forKey:@"aid"];
        [param setObject:@"-1" forKey:@"op"];
    }else{
        [param setObject:@"1" forKey:@"op"];
    }
    
    NSString * url=APP_URL @"AddMyaddress.aspx";
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([[dic objectForKey:@"success"] boolValue]) {
            
            if (model.addressId) {
                model.addressId=nil;
            }else{
                model.addressId=[[dic objectForKey:@"data"]objectForKey:@"aid"];
            }
            if (btn==_collectBtn1) {
                self.buyModel=[[mapAddressModel alloc]initWithModle:model];
            }else{
                self.sendModel=[[mapAddressModel alloc]initWithModle:model];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"errorMsg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error);
    }];
    
}
-(void)priceDetailBtnClick{
    if (!self.bottomPriceBtn.titleLabel.text.length) {
        return;
    }
    priceDetailViewController * vc=[[priceDetailViewController alloc]init];
    vc.model=self.freeModel;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)noPriceBtnClick:(UIButton *)btn{
    [btn setSelected:!btn.isSelected];
}
-(void)typeBtnClick:(UIButton *)btn{
    shoplistVC *shopvc=[[shoplistVC alloc]init];
    shopvc.butmodel=_btnModels[btn.tag-100];
    shopvc.lat=[mapViewTool shared].model.lat;
    shopvc.lng=[mapViewTool shared].model.lng;
    [self.navigationController pushViewController:shopvc animated:YES];

}

-(UIView *)addressView{
    if (!_addressView) {
        _addressView =[[UIView alloc]init];
        _addressView.backgroundColor=[UIColor whiteColor];
        
        UIButton * changeAddressBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_addressView addSubview:changeAddressBtn];
        [changeAddressBtn addTarget:self action:@selector(changeAddressBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [changeAddressBtn setImage:[UIImage imageNamed:@"address"] forState:0];
        changeAddressBtn.frame=CGRectMake(9, 11, 22, 70);
        
        UILabel * label=[[UILabel alloc]init];
        [_addressView addSubview:label];
        label.text=@"购买地址";
        label.font=[UIFont systemFontOfSize:14];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_addressView);
            make.left.mas_equalTo(40);
            make.bottom.mas_equalTo(_addressView.mas_centerY);
            make.right.mas_equalTo(_addressView).offset(-60);
        }];
        
        label=[[UILabel alloc]init];
        [_addressView addSubview:label];
        label.text=@"收获地址";
        label.font=[UIFont systemFontOfSize:14];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_addressView);
            make.left.mas_equalTo(40);
            make.top.mas_equalTo(_addressView.mas_centerY);
            make.right.mas_equalTo(_addressView).offset(-60);
        }];
        
        _collectBtn1=[UIButton buttonWithType:UIButtonTypeCustom];
        [_collectBtn1 setImage:[UIImage imageNamed:@"collect_nomal"] forState:0];
        [_collectBtn1 setImage:[UIImage imageNamed:@"collect_select"] forState:UIControlStateSelected];
        [_collectBtn1 addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_addressView addSubview:_collectBtn1];
        [_collectBtn1 makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_addressView).offset(0);
            make.right.mas_equalTo(_addressView).offset(0);
            make.size.mas_equalTo(CGSizeMake(40, 45));
        }];
        
        _collectBtn2=[UIButton buttonWithType:UIButtonTypeCustom];
        [_collectBtn2 setImage:[UIImage imageNamed:@"collect_nomal"] forState:0];
        [_collectBtn2 setImage:[UIImage imageNamed:@"collect_select"] forState:UIControlStateSelected];
        [_addressView addSubview:_collectBtn2];
        [_collectBtn2 addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_collectBtn2 makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.mas_equalTo(_addressView).offset(0);
            make.size.mas_equalTo(CGSizeMake(40, 45));
        }];
        
        UIImageView * imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_icon"]];
        [_addressView addSubview:imgView];
        [imgView makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_addressView.mas_top);
            make.right.mas_equalTo(_collectBtn1.mas_left).offset(0);
            make.size.mas_equalTo(CGSizeMake(30, 45));
        }];
        
        _buyAddressTextField = [[UITextField alloc]init];
        _buyAddressTextField.font= [UIFont systemFontOfSize:14];
        _buyAddressTextField.placeholder=@"请选择购买地址";
        [_addressView addSubview:_buyAddressTextField];
        [_buyAddressTextField makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_addressView);
            make.bottom.mas_equalTo(_addressView.mas_centerY);
            make.left.mas_equalTo(110);
            make.right.mas_equalTo(imgView.mas_left).offset(0);
        }];
        
        
        imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_icon"]];
        [_addressView addSubview:imgView];
        [imgView makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_addressView.mas_centerY);
            make.right.mas_equalTo(_collectBtn1.mas_left).offset(0);
            make.size.mas_equalTo(CGSizeMake(30, 45));
        }];
        
        _sendAddressTextField = [[UITextField alloc]init];
        _sendAddressTextField.font= [UIFont systemFontOfSize:14];
        _sendAddressTextField.placeholder=@"请选择收货地址";
        _sendAddressTextField.text=_sendModel.poiName;
        [_addressView addSubview:_sendAddressTextField];
        [_sendAddressTextField makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_addressView);
            make.left.mas_equalTo(110);
            make.top.mas_equalTo(_addressView.mas_centerY);
            make.right.mas_equalTo(imgView.mas_left).offset(0);
        }];
        
        UIView * line=[[UIView alloc]init];
        line.backgroundColor=APP_GARY;
        [_addressView addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(40);
            make.centerY.right.mas_equalTo(_addressView);
            make.height.mas_equalTo(1);
        }];
        
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(addressBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=0;
        [_addressView addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(_buyAddressTextField);
        }];
        
        btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(addressBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=1;
        [_addressView addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(_sendAddressTextField);
        }];
    }
    
    return _addressView;
}
-(UIView *)goodInfoView{
    if (_goodInfoView == nil) {
        _goodInfoView = [UIView new];
        _goodInfoView.backgroundColor=[UIColor whiteColor];
        
        NSArray * images = @[@"随意购",@"随意购",@"随意购"];
        NSArray * titles = @[@"商品重量",@"商品体积",@"车辆类型"];
        self.GoodInfoTextFields = @[[UITextField new],[UITextField new],[UITextField new]];
        for (int i =0 ; i<3; i++) {
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, i*45, DEVICE_WIDTH, 45)];
            [_goodInfoView addSubview:view];
            
            
            UIImageView * icon =[[UIImageView alloc]initWithImage:[UIImage imageNamed:images[i]]];// buttonWithType:UIButtonTypeCustom];
            [view addSubview:icon];
            icon.frame=CGRectMake(13, 15, 15, 15);
            
            UILabel * label=[[UILabel alloc]init];
            [view addSubview:label];
            label.text=titles[i];
            label.font=[UIFont systemFontOfSize:14];
            label.frame = CGRectMake(40, 0, 150, 45);
            
            UITextField * text = self.GoodInfoTextFields[i];
            text.font= [UIFont systemFontOfSize:14];
            text.placeholder= [NSString stringWithFormat:@"请选择%@",titles[i]];
            [view addSubview:text];
            [text makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.right.mas_equalTo(view);
                make.left.mas_equalTo(110);
            }];
            
            UIButton * btn= [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = view.bounds;
            btn.tag = i;
            [view addSubview:btn];
            [btn addTarget: self action:@selector(goodInfoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            if (i<2) {
                UIView * line=[[UIView alloc]init];
                line.backgroundColor=APP_GARY;
                [view addSubview:line];
                [line makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(40);
                    make.bottom.right.mas_equalTo(view);
                    make.height.mas_equalTo(1);
                }];
            }
            
        }
    }
    return _goodInfoView;
}
-(void)goodInfoBtnClick:(UIButton *)btn{
    if (self.goodModel == nil) {
        return;
    }
    NSMutableArray * arr = [NSMutableArray array];
    switch (btn.tag) {
        case 0:
            for (GoodWeight * model in self.goodModel.GoodWeights) {
                [arr addObject:model.name];
            }
            break;
        case 1:
            for (GoodVolume * model in self.goodModel.GoodVolumes) {
                [arr addObject:model.name];
            }
            break;
        case 2:
            for (CarInfo * model in self.goodModel.CarInfos) {
                [arr addObject:model.name];
            }
            break;
        default:
            break;
    }
    
    [MMPickerView showPickerViewInView:self.view withStrings:arr withOptions:nil completion:^(NSString *selectedString) {
        self.GoodInfoTextFields[btn.tag].text = selectedString;
    }];
    
}
-(UIView *)phoneView{
    if (!_phoneView) {
        _phoneView =[[UIView alloc]init];
        _phoneView.backgroundColor=[UIColor whiteColor];
        
        UIButton * changeAddressBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_phoneView addSubview:changeAddressBtn];
        [changeAddressBtn setImage:[UIImage imageNamed:@"phone_money"] forState:0];
        changeAddressBtn.frame=CGRectMake(2, 0, 36, 90);
        
        UILabel * label=[[UILabel alloc]init];
        [_phoneView addSubview:label];
        label.text=@"联系电话";
        label.font=[UIFont systemFontOfSize:14];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_phoneView);
            make.left.mas_equalTo(40);
            make.bottom.mas_equalTo(_phoneView.mas_centerY);
            make.right.mas_equalTo(_phoneView).offset(-60);
        }];
        
        label=[[UILabel alloc]init];
        [_phoneView addSubview:label];
        label.text=@"商品金额";
        label.font=[UIFont systemFontOfSize:14];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_phoneView);
            make.left.mas_equalTo(40);
            make.top.mas_equalTo(_phoneView.mas_centerY);
            make.right.mas_equalTo(_phoneView).offset(-60);
        }];
        
        
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"other_phone"] forState:0];
        [_phoneView addSubview:btn];
        [btn addTarget: self action:@selector(phoneBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(_phoneView);
            make.bottom.mas_equalTo(_phoneView.mas_centerY);
            make.width.mas_equalTo(103);
        }];
        
        btn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.noPriceBtn=btn;
        [btn addTarget:self action:@selector(noPriceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"no_price"] forState:0];
        [btn setImage:[UIImage imageNamed:@"no_price_clicked"] forState:UIControlStateSelected];
        [_phoneView addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.mas_equalTo(_phoneView);
            make.width.mas_equalTo(100);
            make.top.mas_equalTo(_phoneView.mas_centerY);
        }];
        
        _phoneTextField = [[UITextField alloc]init];
        _phoneTextField.font= [UIFont systemFontOfSize:14];
        _phoneTextField.placeholder=@"请输入电话";
        _phoneTextField.text=APP_NAME;
        _phoneTextField.keyboardType=UIKeyboardTypeDecimalPad;
        [_phoneView addSubview:_phoneTextField];
        [_phoneTextField makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_phoneView);
            make.bottom.mas_equalTo(_phoneView.mas_centerY);
            make.left.mas_equalTo(110);
            make.right.mas_equalTo(_phoneView).offset(-110);
        }];
        
        _priceTextField = [[UITextField alloc]init];
        _priceTextField.font= [UIFont systemFontOfSize:14];
        _priceTextField.placeholder=@"请输入商品金额(元)";
        _phoneTextField.keyboardType=UIKeyboardTypeDecimalPad;
        [_phoneView addSubview:_priceTextField];
        [_priceTextField makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_phoneView);
            make.left.mas_equalTo(110);
            make.top.mas_equalTo(_phoneView.mas_centerY);
            make.right.mas_equalTo(_phoneView).offset(-110);
        }];
        
        UIView * line=[[UIView alloc]init];
        line.backgroundColor=APP_GARY;
        [_phoneView addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(40);
            make.centerY.right.mas_equalTo(_phoneView);
            make.height.mas_equalTo(1);
        }];
        
    }
    return _phoneView;
}
#pragma mark - 通讯录
- (void)phoneBtnClicked:(UIButton *)sender {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        [SVProgressHUD showErrorWithStatus:@"该功能只支持iOS9 以上版本"];
        return;
    }
    _contactsPickerVC = [[CNContactPickerViewController alloc]init];
    _contactsPickerVC.delegate = self;
    
    [self presentViewController:_contactsPickerVC animated:YES completion:nil];
    
}
//4.
-(void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
  
    NSMutableArray  * arr=[NSMutableArray array];
    for (CNLabeledValue * lable in contact.phoneNumbers) {
        CNPhoneNumber * phone = lable.value;
        NSString * number=[phone.stringValue stringByReplacingOccurrencesOfString:@" " withString:@""];
        number=[number stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [arr addObject:number];
    }
    if (arr.count==0) {
        [SVProgressHUD showErrorWithStatus:@"没获取到号码"];//
    }else if (arr.count==1){
        _phoneTextField.text=arr[0];
    }else{
        _contactPhoneArr=arr;
        UIActionSheet * sheet=[[UIActionSheet alloc]initWithTitle:@"请选择一个号码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:arr[0],arr[1], nil];
        [sheet showInView:self.view];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        _phoneTextField.text=_contactPhoneArr[0];
    }else{
        _phoneTextField.text=_contactPhoneArr[1];
    }
}
- (BOOL)contactViewController:(CNContactViewController *)viewController shouldPerformDefaultActionForContactProperty:(CNContactProperty *)property{
    return YES;
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
