//
//  pickUpGoodsViewController.m
//  大可专送
//
//  Created by 张允鹏 on 2016/12/1.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import "pickUpGoodsViewController.h"
#import "mapViewTool.h"
#import "sendFreeModel.h"
#import "priceDetailViewController.h"
#import "UITextView+YLTextView.h"
#import "payWindow.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "YLButton.h"
#import "butmodel.h"
#import "shoplistVC.h"
#import "GoodModel.h"
#import <MMPickerView.h>
@interface pickUpGoodsViewController ()<MapToolDelegate,CNContactPickerDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) sendFreeModel * freeModel;

@property (nonatomic, strong) UIView * addressView;
@property (nonatomic, strong) UITextField * receiptAddressTextField;
@property (nonatomic, strong) UITextField * pickUpAddressTextField;
@property (nonatomic, strong) UIButton  * collectBtn1;
@property (nonatomic, strong) UIButton  * collectBtn2;

@property (nonatomic, strong) UIView * phoneView;
@property (nonatomic, strong) UITextField * phoneTextField1;
@property (nonatomic, strong) UITextField * phoneTextField2;

@property (nonatomic, strong) UIView * timeAndGoodTypeView;
@property (nonatomic, strong) UITextField * goodTypeTextField;
@property (nonatomic, strong) UITextView * noteTextView;
@property (nonatomic, strong) UITextField * timeTextField;

@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) UILabel * bottomDistanceLabel;
@property (nonatomic, strong) YLButton * bottomPriceBtn;

@property (nonatomic, strong) UIWindow * timeWindow;
@property (nonatomic, strong) NSArray * contactPhoneArr;
@property (nonatomic, assign) NSInteger  phoneIndex;//电话按钮选中tag

@property (nonatomic, strong) UIView * typeView;
@property (nonatomic, strong) NSMutableArray * btnModels;

@property (nonatomic, strong) GoodModel * goodModel;
@property (nonatomic, strong) NSArray <UITextField *>* GoodInfoTextFields;
@property (nonatomic, strong) UIView * goodInfoView;
@end

@implementation pickUpGoodsViewController
-(void)collectBtnClick:(UIButton *)btn{
    mapAddressModel * model= btn==_collectBtn1? _pickUpModel:_receiptModel;
    if (model==nil) {
        return;
    }
    NSString * detailAddress=model.buildName?model.buildName:@"";
    NSDictionary * dic=@{@"userid":APP_USERID,
                         @"poiName":model.poiName,
                         @"poiAddress":model.poiAddress,
                         @"detailAddress":detailAddress,
                         @"lat":model.lat,
                         @"lng":model.lng,
                         };
    NSMutableDictionary * param=[NSMutableDictionary dictionaryWithDictionary:dic];
    
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([[dic objectForKey:@"success"] boolValue]) {
                
                if (model.addressId) {
                    model.addressId=nil;
                }else{
                    model.addressId=[[dic objectForKey:@"data"]objectForKey:@"aid"];
                }
                if (btn==_collectBtn1) {
                    self.pickUpModel=[[mapAddressModel alloc]initWithModle:model];
                }else{
                    self.receiptModel=[[mapAddressModel alloc]initWithModle:model];
                }
            }else{
                [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"errorMsg"]];
            }
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error);
    }];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [mapViewTool shared].delegate=self;
}
-(void)setPickUpModel:(mapAddressModel *)pickUpModel{
    _pickUpModel =pickUpModel;
    if (_pickUpModel) {
        _pickUpAddressTextField.text=[NSString stringWithFormat:@"%@ %@",pickUpModel.poiName,pickUpModel.buildName];
    }else{
        _pickUpAddressTextField.text=@"";
    }
    if (pickUpModel.addressId) {
        [_collectBtn1 setSelected:YES];
    }else{
        [_collectBtn1 setSelected:NO];
    }
    [self checkAddress];
}

-(void)setReceiptModel:(mapAddressModel *)receiptModel{
    _receiptModel =receiptModel;
    if (receiptModel) {
        _receiptAddressTextField.text=[NSString stringWithFormat:@"%@ %@",receiptModel.poiName,receiptModel.buildName];
    }else{
        _receiptAddressTextField.text=@"";
    }
    if (receiptModel.addressId) {
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
    if (_receiptModel.location.latitude && _pickUpModel.location.latitude) {
        
        [[mapViewTool shared] getNaviWithStartLocation:_receiptModel.location withEndLocation:_pickUpModel.location];
    }else{
        self.freeModel=nil;
    }
}
-(void)calculateRouteSuccessWithDistance:(NSString *)distance{
    [self getpickUpFreeWithIsNearbuy:NO withDistance:distance];
}
-(void)getpickUpFreeWithIsNearbuy:(BOOL)nearbuy withDistance:(NSString *) distance{
    //
    
    if (!_pickUpModel || !_receiptModel) {
        self.freeModel=nil;
        return;
    }
    NSString * url=APP_URL @"GetSendfee.aspx";
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary * param=@{@"juli":distance,@"cityid":[mapViewTool shared].model.cityid,@"isnearbuy":@"0"};
    //    NSLog(@"%@",param);
    NSLog(@"%@",param);
    [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([[dic objectForKey:@"success"] boolValue]) {
            
            self.freeModel=[sendFreeModel mj_objectWithKeyValues:[dic objectForKey:@"feedata"]];
            NSLog(@"%@",[dic objectForKey:@"feedata"]);
        }else{
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"errorMsg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error);
    }];
}
-(void)changeAddressBtnClick{
    mapAddressModel * model= _receiptModel;
    self.receiptModel=_pickUpModel;
    self.pickUpModel=model;
}
-(void)changePhoneBtnClick{
    NSString * phone=self.phoneTextField1.text;
    self.phoneTextField1.text=self.phoneTextField2.text;
    self.phoneTextField2.text=phone;
}
-(void)addressBtnClick:(UIButton *)btn{
    MapDetailViewController * vc=[[MapDetailViewController alloc]init];
    vc.pushBtnTag=btn.tag;
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)timeBtnClick{
    _timeWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _timeWindow.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];;
    // 在window上面添加相关控件
    UIView * whiteView=[[UIView alloc]init];
    whiteView.backgroundColor=[UIColor whiteColor];
    [_timeWindow addSubview:whiteView];
    [whiteView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_timeWindow.mas_centerY).offset(-60);
        make.bottom.left.right.mas_equalTo(self);
    }];
}
-(void)priceDetailBtnClick{

    priceDetailViewController * vc=[[priceDetailViewController alloc]init];
    vc.model=self.freeModel;

    [self.navigationController pushViewController:vc animated:YES];
}
-(void)okBtnClickWith:(mapAddressModel *)model withBtnTag:(NSInteger)tag{
    
    mapAddressModel * Addressmodel = [[mapAddressModel alloc]initWithModle:model];
    if (tag==0) {
        if (Addressmodel.cityid != self.receiptModel.cityid) {
            [self getTypeBtnClickViewData];
        }
        self.receiptModel = Addressmodel;
    }else{
        if (Addressmodel.cityid != self.pickUpModel.cityid) {
            [self getTypeBtnClickViewData];
        }
        self.pickUpModel= Addressmodel;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"取东西";
    [self getGoodInfo];
    
    self.view.backgroundColor=[UIColor whiteColor];
    UIScrollView * scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-49-64)];
    [self.view addSubview:scrollView];
    scrollView.backgroundColor=[UIColor groupTableViewBackgroundColor];;
    
    _typeView=[[UIView alloc]init];
    _typeView.backgroundColor=[UIColor whiteColor];
    [scrollView addSubview:self.typeView];
    
    [self.typeView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(0);
    }];
    
    [self getTypeBtnClickViewData];
    
    [scrollView addSubview:self.addressView];
    [_addressView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeView.mas_bottom).offset(10);
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
    }];
    
    [scrollView addSubview:self.timeAndGoodTypeView];
    [_timeAndGoodTypeView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodInfoView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(90);
        make.bottom.mas_equalTo(scrollView.mas_bottom).inset(10);
    }];
    
    [self.view addSubview:self.bottomView];
    [_bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(49);
    }];
    
    // Do any additional setup after loading the view.
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
-(void)typeBtnClick:(UIButton *)btn{
    shoplistVC *shopvc=[[shoplistVC alloc]init];
    shopvc.butmodel=_btnModels[btn.tag-100];
    shopvc.lat=[mapViewTool shared].model.lat;
    shopvc.lng=[mapViewTool shared].model.lng;
    [self.navigationController pushViewController:shopvc animated:YES];
    
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
        [btn setTitleColor:WT_RGBColor(0x016bb7) forState:0];
        [btn setTitle:@"去支付" forState:0];
        [btn addTarget:self action:@selector(commitOrder) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(_bottomView);
            make.size.mas_equalTo(CGSizeMake(85, 49));
        }];
        
        self.freeModel=nil;
    }
    return _bottomView;
}
- (void)commitOrder{
    
    
    if (_pickUpModel.cityid==nil &&_receiptModel.cityid==nil) {
        [SVProgressHUD showErrorWithStatus:@"所选城市未开放"];
        return;
    }
    if (![_receiptModel.cityid isEqualToString: _pickUpModel.cityid]) {
        [SVProgressHUD showErrorWithStatus:@"不支持跨城服务"];
        return;
    }
    if (!_pickUpAddressTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请详选择收货地"];
        return;
    }
    if (!_receiptAddressTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请详细选择发货地"];
        return;
    }
    if (!_phoneTextField1.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请填写发货人电话"];
        return;
    }
    if (!_phoneTextField2.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请填写收货人电话"];
        return;
    }
    
    NSString *mark=[NSString stringWithFormat:@"%@,%@",_goodTypeTextField.text,_noteTextView.text];

    NSDictionary * dict=@{@"ordertype":@"3",
                           @"userid":APP_USERID,
                           @"lat2":_receiptModel.lat,
                           @"lng2":_receiptModel.lng,
                           @"lat1":_pickUpModel.lat,
                           @"lng1":_pickUpModel.lng,
                           @"source":@"3",
                           @"remark":mark,
                           @"address1":_pickUpAddressTextField.text,
                           @"address2":_receiptAddressTextField.text,
                           @"tel1":_phoneTextField1.text,
                           @"tel2":_phoneTextField2.text,
                           @"sendfee":_freeModel.qibufee,
                           @"lichengfee":_freeModel.lichengfee,
                           @"totalfee":_freeModel.totalfee,
                           @"juli":_freeModel.alljuli,
                           @"zhongliang":self.GoodInfoTextFields[0].text,
                           @"tiji":self.GoodInfoTextFields[1].text
                           };
    
    NSMutableDictionary * param = [NSMutableDictionary dictionaryWithDictionary:dict];
    for (CarInfo *model in self.goodModel.CarInfos) {
        if ([model.name isEqualToString:self.GoodInfoTextFields[2].text]) {
            param[@"cheid"]=model.id;//车辆ID，
            param[@"chename"]=model.name;//车名称，
            param[@"chemoney"]=model.mone ? model.mone : @""; //车辆的附加费
        }
    }
    NSLog(@"%@",param);
    [_pickUpModel saveToUserDefaults];
    [_receiptModel saveToUserDefaults];
    payWindow *window = [payWindow shareShowWindow];
    window.param=param;
    [window show];
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
-(UIView *)timeAndGoodTypeView{
    if (_timeAndGoodTypeView==nil) {
        _timeAndGoodTypeView=[[UIView alloc]init];
        _timeAndGoodTypeView.backgroundColor=[UIColor whiteColor];
        
        UILabel * label=[[UILabel alloc]init];
        [_timeAndGoodTypeView addSubview:label];
        label.text=@"物品类型";
        label.font=[UIFont systemFontOfSize:14];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_timeAndGoodTypeView);
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(_timeAndGoodTypeView.mas_centerY);
            make.width.mas_equalTo(100);
        }];
        
        label=[[UILabel alloc]init];
        [_timeAndGoodTypeView addSubview:label];
        label.text=@"备注信息";
        label.font=[UIFont systemFontOfSize:14];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_timeAndGoodTypeView);
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(_timeAndGoodTypeView.mas_centerY);
            make.width.mas_equalTo(100);
        }];
        
        UIImageView * imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_icon"]];
        [_timeAndGoodTypeView addSubview:imgView];
        [imgView makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_timeAndGoodTypeView.mas_top);
            make.right.mas_equalTo(_timeAndGoodTypeView).offset(0);
            make.size.mas_equalTo(CGSizeMake(30, 45));
        }];
        
        _goodTypeTextField = [[UITextField alloc]init];
        _goodTypeTextField.font= [UIFont systemFontOfSize:14];
        _goodTypeTextField.placeholder=@"请填写物品类型";
        [_timeAndGoodTypeView addSubview:_goodTypeTextField];
        [_goodTypeTextField makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_timeAndGoodTypeView);
            make.bottom.mas_equalTo(_timeAndGoodTypeView.mas_centerY);
            make.left.mas_equalTo(110);
            make.right.mas_equalTo(imgView.mas_left).offset(8);
        }];
        
        
        imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_icon"]];
        [_timeAndGoodTypeView addSubview:imgView];
        [imgView makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_timeAndGoodTypeView.mas_top);
            make.right.mas_equalTo(_timeAndGoodTypeView).offset(0);
            make.size.mas_equalTo(CGSizeMake(30, 45));
        }];
        
        _noteTextView = [[UITextView alloc]init];
        _noteTextView.font= [UIFont systemFontOfSize:14];
        _noteTextView.placeholder=@"订单信息补充";
        [_timeAndGoodTypeView addSubview:_noteTextView];
        [_noteTextView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_timeAndGoodTypeView);
            make.left.mas_equalTo(107);
            make.top.mas_equalTo(_timeAndGoodTypeView.mas_centerY);
            make.right.mas_equalTo(imgView.mas_left).offset(8);
        }];
        
        UIView * line=[[UIView alloc]init];
        line.backgroundColor=APP_GARY;
        [_timeAndGoodTypeView addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(40);
            make.centerY.right.mas_equalTo(_timeAndGoodTypeView);
            make.height.mas_equalTo(1);
        }];
        
        //        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        //        [btn addTarget:self action:@selector(timeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        //        [_timeAndGoodTypeView addSubview:btn];
        //        [btn makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.left.bottom.right.mas_equalTo(_timeTextField);
        //        }];
        
    }
    return _timeAndGoodTypeView;
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
        label.text=@"取货地";
        label.font=[UIFont systemFontOfSize:14];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_addressView);
            make.left.mas_equalTo(40);
            make.bottom.mas_equalTo(_addressView.mas_centerY);
            make.right.mas_equalTo(_addressView).offset(-60);
        }];
        
        label=[[UILabel alloc]init];
        [_addressView addSubview:label];
        label.text=@"收货地";
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
        [_collectBtn2 makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.mas_equalTo(_addressView).offset(0);
            make.size.mas_equalTo(CGSizeMake(40, 45));
        }];
        [_collectBtn1 addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_collectBtn2 addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView * imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_icon"]];
        [_addressView addSubview:imgView];
        [imgView makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_addressView.mas_top);
            make.right.mas_equalTo(_collectBtn1.mas_left).offset(0);
            make.size.mas_equalTo(CGSizeMake(30, 45));
        }];
        
        _pickUpAddressTextField = [[UITextField alloc]init];
        _pickUpAddressTextField.font= [UIFont systemFontOfSize:14];
        _pickUpAddressTextField.placeholder=@"请选择取货地址";
        [_addressView addSubview:_pickUpAddressTextField];
        [_pickUpAddressTextField makeConstraints:^(MASConstraintMaker *make) {
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
        
        _receiptAddressTextField = [[UITextField alloc]init];
        _receiptAddressTextField.font= [UIFont systemFontOfSize:14];
        _receiptAddressTextField.placeholder=@"请选择收货地址";
        _receiptAddressTextField.text=_receiptModel.poiName;
        [_addressView addSubview:_receiptAddressTextField];
        [_receiptAddressTextField makeConstraints:^(MASConstraintMaker *make) {
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
            make.top.left.bottom.right.mas_equalTo(_receiptAddressTextField);
        }];
        
        btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(addressBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=1;
        [_addressView addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(_pickUpAddressTextField);
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
        [changeAddressBtn addTarget:self action:@selector(changePhoneBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [changeAddressBtn setImage:[UIImage imageNamed:@"phone"] forState:0];
        [changeAddressBtn makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_phoneView);
            make.left.mas_equalTo(7);
            make.size.mas_equalTo(CGSizeMake(26, 70));
        }];
        
        UILabel * label=[[UILabel alloc]init];
        [_phoneView addSubview:label];
        label.text=@"取货人";
        label.font=[UIFont systemFontOfSize:14];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_phoneView);
            make.left.mas_equalTo(40);
            make.bottom.mas_equalTo(_phoneView.mas_centerY);
            make.right.mas_equalTo(_phoneView).offset(-60);
        }];
        
        label=[[UILabel alloc]init];
        [_phoneView addSubview:label];
        label.text=@"收货人";
        label.font=[UIFont systemFontOfSize:14];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_phoneView);
            make.left.mas_equalTo(40);
            make.top.mas_equalTo(_phoneView.mas_centerY);
            make.right.mas_equalTo(_phoneView).offset(-60);
        }];
        
        _phoneTextField1 = [[UITextField alloc]init];
        _phoneTextField1.font= [UIFont systemFontOfSize:14];
        _phoneTextField1.placeholder=@"请输入取货人电话";
        _phoneTextField1.keyboardType=UIKeyboardTypeDecimalPad;
        [_phoneView addSubview:_phoneTextField1];
        [_phoneTextField1 makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_phoneView);
            make.bottom.mas_equalTo(_phoneView.mas_centerY);
            make.left.mas_equalTo(110);
            make.right.mas_equalTo(_phoneView).offset(-110);
        }];
        
        _phoneTextField2 = [[UITextField alloc]init];
        _phoneTextField2.font= [UIFont systemFontOfSize:14];
        _phoneTextField2.placeholder=@"请输入收货人电话";
        _phoneTextField2.text=APP_NAME;
        _phoneTextField2.keyboardType=UIKeyboardTypeDecimalPad;
        [_phoneView addSubview:_phoneTextField2];
        [_phoneTextField2 makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_phoneView);
            make.top.mas_equalTo(_phoneView.mas_centerY);
            make.left.mas_equalTo(110);
            make.right.mas_equalTo(_phoneView).offset(-110);
        }];
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag=0;
        [btn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_phoneView addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(_phoneView);
            make.height.width.mas_equalTo(45);
        }];
        
        UIImageView * imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed: @"通讯录"]];
        [_phoneView insertSubview:imgView belowSubview:btn];
        [imgView makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(btn);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag=1;
        [btn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_phoneView addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.mas_equalTo(_phoneView);
            make.height.width.mas_equalTo(45);
        }];
        
        imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed: @"通讯录"]];
        [_phoneView insertSubview:imgView belowSubview:btn];
        [imgView makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(btn);
            make.size.mas_equalTo(CGSizeMake(30, 30));
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
-(void)phoneBtnClick:(UIButton *)btn{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该功能只支持iOS9 以上版本" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    _phoneIndex=btn.tag;
    CNContactPickerViewController* contactsPickerVC = [[CNContactPickerViewController alloc]init];
    contactsPickerVC.delegate = self;
    [self presentViewController:contactsPickerVC animated:YES completion:nil];
}
-(void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    
    NSMutableArray  * arr=[NSMutableArray array];
    for (CNLabeledValue * lable in contact.phoneNumbers) {
        CNPhoneNumber * phone = lable.value;
        NSString * number=[phone.stringValue stringByReplacingOccurrencesOfString:@" " withString:@""];
        number=[number stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [arr addObject:number];
    }
    if (arr.count==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没获取到号码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else if (arr.count==1){
        if (_phoneIndex==0) {
            _phoneTextField1.text=arr[0];
        }else{
            _phoneTextField2.text=arr[0];
        }
        
    }else{
        _contactPhoneArr=arr;
        UIActionSheet * sheet=[[UIActionSheet alloc]initWithTitle:@"请选择一个号码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:arr[0],arr[1], nil];
        [sheet showInView:self.view];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (_phoneIndex==0) {
        _phoneTextField1.text=_contactPhoneArr[buttonIndex];
    }else{
        _phoneTextField2.text=_contactPhoneArr[buttonIndex];
    }
}
- (BOOL)contactViewController:(CNContactViewController *)viewController shouldPerformDefaultActionForContactProperty:(CNContactProperty *)property{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue pickUper:(id)pickUper {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
