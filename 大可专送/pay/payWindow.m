//
//  payWindow.m
//  大可专送
//
//  Created by 张允鹏 on 2016/12/1.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import "payWindow.h"
#import "AliPayModel.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "payRequsestHandler.h"
#import "WXApi.h"
//合作者身份
//#define AliPartner @"2088421279495661"
//帐号
//#define AliSeller @"dakedaojia@126.com"
//授权域名
//#define HOST @"dakedaojia.com"
//商户私钥
//#define AliPrivateKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMhPaTDenPqCgHX30X3krf5ltMDivslscEAX36ocanbVjw9BIEPXqLW4ub4MI8lRRRoFQ+n7rSyjKbiK0rH42JN2XrEgXWdke3M3aMqkm72e+KJOLimJSLcd5GBw5lm1AZU9g2KUdUtYJrAwWut9ILftrjzuSxBOd4Z681ODtNJfAgMBAAECgYEAg3B4WfT5lPglS0N+V9nCwngCj7856foZ/jSsM3fJ9IhWA3B8t4e/0N6SIz7cDLIjYduqoNLg47V9HvcZImdj1NV0R7GvTgFmNoCWtGDPnD7tLTlHmTyaEDVNEaazkhDfDUmXHmPTPWM3rrfrsKdWU151fWMUjBPid+CX3ddmMAECQQD0zhsBisMYMa+3snvJJL7Sx7HcLUZ1mHN32ZV51mgJnXVDvBVxwdQwvlopoRld7tvm7lTogz4n9WK4o6jj0gYBAkEA0XhpINpPnohXbK3rqRRKE0K/4Onkykf2ycCN13sLbmD4CiKAGVVUlqZOdN1YMA8+spHtQf0qCXd5M31rDTSYXwJAVafkFScLWmTQOfNOkrOzvSa4WfTRiYX9KPtN7OKTZoHcrQWbb0FF0IRaIeTHbnGMKgJMXUrGrc6Ta02AY65yAQJAay6PrG3Im7fr9AIyOXvWQ3C+Odm0ZgTYtHdAnOeq+7nGcXkhztSoycUjFA1GWKEUVc7xdfiSj/GAJOah5knpRQJBAOcQs86ivkcNhA1UaF+aKCN9w9hgN8k6zjpD/+dRX/RU5qq/6lZz2X+uN8SOfqfwt5aUrDolBivcgM43RyJDJ7U="

@interface payWindow ()
@property (nonatomic,strong) UILabel * payMoneyLabel;
@property (nonatomic,weak) UIButton * WXPayBtn;
@property (nonatomic,weak) UIButton * aliPayBtn;
@property (nonatomic, assign) float money;
@property (nonatomic, strong) NSString * orderid;
@end
@implementation payWindow

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setParam:(NSDictionary *)param{
    _param=param;
    _money=[[param objectForKey:@"totalfee"] floatValue] + [[param objectForKey:@"chemoney"]floatValue];
    _orderid=[param objectForKey:@"orderid"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *qian=[defaults objectForKey:@"money"];
    NSString *isjiaoyi=[defaults objectForKey:@"isjiaoyi"];
    if (isjiaoyi) {
        _payMoneyLabel.text=[NSString stringWithFormat:@"%.2f元",_money-[qian doubleValue]];
    }else
    {
        _payMoneyLabel.text=[NSString stringWithFormat:@"%.2f元",_money];
    }
}
+ (payWindow *)shareShowWindow
{
    static payWindow *window = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (window == nil) {
            window = [[payWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        }
    });
    return window;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {//
        self.backgroundColor =[UIColor clearColor];
        // 在window上面添加相关控件
        
        UIImage * image=[UIImage imageNamed:@"pay_wx_n"];
        CGFloat h=image.size.height*DEVICE_WIDTH/image.size.width;
        UIView * whiteView=[[UIView alloc]init];
        whiteView.backgroundColor=[UIColor whiteColor];
        [self addSubview:whiteView];
        [whiteView makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_centerY).offset(-h);
            make.bottom.left.right.mas_equalTo(self);
        }];
        
        UILabel * label=[[UILabel alloc]init];
        label.text=@"付款详情";
        label.font=[UIFont systemFontOfSize:21];
        label.textAlignment=NSTextAlignmentCenter;
        [whiteView addSubview:label];
        
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(whiteView);
            make.height.mas_equalTo(60);
        }];

        UIView * lineHorizontal=[[UIView alloc]init];
        lineHorizontal.backgroundColor=APP_GARY;
        [whiteView addSubview:lineHorizontal];
        [lineHorizontal makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(lineHorizontal.superview);
            make.left.mas_equalTo(lineHorizontal.superview).offset(8);
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(label).offset(0);
        }];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.adjustsImageWhenHighlighted = NO;
        [closeBtn setImage:[UIImage imageNamed:@"pay_close"] forState:0];
        [closeBtn addTarget:self action:@selector(closeBtnClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        [closeBtn makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(whiteView);
            make.bottom.mas_equalTo(label).offset(-2);
            make.width.mas_equalTo(60);
        }];
        
        label=[[UILabel alloc]init];
        label.text=@"需支付金额";
        label.textAlignment=NSTextAlignmentCenter;
        [whiteView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(closeBtn.mas_bottom).offset(20);
            make.left.right.mas_equalTo(whiteView);
            make.height.mas_equalTo(20);
        }];
        
        
        _payMoneyLabel=[[UILabel alloc]init];
        _payMoneyLabel.font=[UIFont boldSystemFontOfSize:32];
        _payMoneyLabel.textColor=APP_ORAGNE;
        _payMoneyLabel.textAlignment=NSTextAlignmentCenter;
        [whiteView addSubview:_payMoneyLabel];
        
        [_payMoneyLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(label).offset(35);
            make.left.right.mas_equalTo(whiteView);
            make.height.mas_equalTo(32);
        }];
        
        
        
        UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [payBtn setBackgroundColor:APP_ORAGNE];
        [payBtn addTarget:self action:@selector(payBtnClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [payBtn setTitle:@"确认付款" forState:0];
        [whiteView addSubview:payBtn];
        [payBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(whiteView);
            make.height.mas_equalTo(50);
        }];
        
       
        UIButton * WXPay=[UIButton buttonWithType:UIButtonTypeCustom];
        WXPay.tag=0;
        self.WXPayBtn=WXPay;
        [WXPay addTarget:self action:@selector(payModeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [WXPay setImage:[UIImage imageNamed:@"pay_wx_n"] forState:0];
        WXPay.adjustsImageWhenHighlighted = NO;
        [WXPay setImage:[UIImage imageNamed:@"pay_wx_s"] forState:UIControlStateSelected];
        [WXPay setImage:[UIImage imageNamed:@"pay_wx_s"] forState:UIControlStateHighlighted];
        [whiteView addSubview:WXPay];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *isjiaoyi=[defaults objectForKey:@"isjiaoyi"];
        if (isjiaoyi) {
            [WXPay makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(whiteView);
                make.bottom.mas_equalTo(payBtn.mas_top).offset(-h);//payBtn.mas_top
                make.height.mas_equalTo(h);
            }];
        }else
        {
        [WXPay makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(whiteView);
            make.bottom.mas_equalTo(payBtn.mas_top);//payBtn.mas_top
            make.height.mas_equalTo(h);
        }];
        }
        
        
        UIButton * aliPayBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        aliPayBtn.tag=1;
        self.aliPayBtn=aliPayBtn;
        [aliPayBtn addTarget:self action:@selector(payModeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [aliPayBtn setBackgroundImage:[UIImage imageNamed:@"pay_ali_n"] forState:0];
        aliPayBtn.adjustsImageWhenHighlighted = NO;
        [aliPayBtn setBackgroundImage:[UIImage imageNamed:@"pay_ali_s"] forState:UIControlStateHighlighted];
        [aliPayBtn setBackgroundImage:[UIImage imageNamed:@"pay_ali_s"] forState:UIControlStateSelected];
        [whiteView addSubview:aliPayBtn];
        [aliPayBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(whiteView);
            make.bottom.mas_equalTo(_WXPayBtn.mas_top);
            make.height.mas_equalTo(h);
        }];
        [aliPayBtn setSelected:YES];
        
        UIButton * shadowBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        shadowBtn.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [shadowBtn addTarget:self action:@selector(closeBtnClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shadowBtn];
        [shadowBtn makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self);
            make.bottom.mas_equalTo(whiteView.mas_top);
        }];
        
        
        NSString *isshow= [defaults objectForKey:@"money"];
        if (isshow) {
            UIImageView *hongbao=[UIImageView new];
            [whiteView addSubview: hongbao];
            hongbao.image=[UIImage imageNamed:@"red_pg"];
            hongbao.sd_layout
            .leftSpaceToView(whiteView,10)
            .bottomSpaceToView(aliPayBtn,15)
            .widthIs(25).heightIs(25);
            hongbao.contentMode=UIViewContentModeScaleAspectFit;
            
            UILabel *hongbaolab=[UILabel new];
            [whiteView addSubview: hongbaolab];
            
            hongbaolab.text=[NSString stringWithFormat:@"红包金额：%.1f元",isshow.floatValue];
            hongbaolab.textColor=[UIColor blackColor];
            hongbaolab.font=[UIFont systemFontOfSize:14];
            hongbaolab.sd_layout
            .leftSpaceToView(hongbao,5)
            .heightIs(h)
            .rightSpaceToView(whiteView,0)
            .centerYEqualToView(hongbao);
        }
        
    }
    return self;
}
-(void)hongBtnClick:(UIButton *)but
{

}
-(void)payModeBtnClick:(UIButton *)sender{
    
    if (sender==self.aliPayBtn) {
        [_aliPayBtn setSelected:YES];
        [_WXPayBtn setSelected:NO];
    }else{
        [_aliPayBtn setSelected:NO];
        [_WXPayBtn setSelected:YES];
    }
}
- (void)closeBtnClickBtn:(UIButton *)sender
{
    self.hidden = YES;
}
-(void)close{
    self.hidden = YES;
}
- (void)show
{
    [self makeKeyWindow];
    self.hidden = NO;
}
- (void)payBtnClickBtn:(UIButton *)sender
{
    if (!_orderid.length) {
        NSString * url=@"http://www.gjqb110.com/App/Cpaotui/SubmitOrder.aspx";
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:url parameters:_param progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD hideHUDForView:self animated:YES];
                NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"请求失败：===================%@",dic);

                if ([[dic objectForKey:@"success"] boolValue]) {
                    NSString *orderid =[[dic objectForKey:@"data"] objectForKey:@"orderid"];
                    if (_aliPayBtn.selected) {
                      //阿里支付
                     [self payWithType:@"1" andOrderId:orderid andMoney:_money];
                    }else{
                      //微信支付
                     [self payWithType:@"2" andOrderId:orderid andMoney:_money];
                    }
                }else{
                    [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"errorMsg"]];
                }
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败：%@",error);
        }];
    }else{
        if (_aliPayBtn.selected) {
         //阿里支付
           [self payWithType:@"1" andOrderId:_orderid andMoney:_money];
        }else{
         //微信支付
           [self payWithType:@"2" andOrderId:_orderid andMoney:_money];
        }
    }
}

-(void)payWithType:(NSString *)type andOrderId:(NSString *)orderId andMoney:(CGFloat )money
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [AFRequstManager getUrlStr:[NSString stringWithFormat:@"http://www.gjqb110.com/App/Android/getWxAlipay.aspx?type=%@&name=user",type]  andParms:nil andCompletion:^(id obj) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *xmlJsStr = obj;
            NSRange range =[xmlJsStr rangeOfString:@"<"];
            NSRange jsonRange = NSMakeRange(0, range.location);
            NSString *jsonStr = [xmlJsStr substringWithRange:jsonRange];
            NSLog(@"----输出成功--------%@-------------",jsonStr);
            NSDictionary *dic = [NSDictionary jsonStrToDic:jsonStr];
            if (dic) {
                if ([type isEqualToString:@"1"]) {
                    //支付宝
                    [self aliPay:orderId money:_money withDic:dic];
                }else{
                    //微信
                    [self WXsendPay:orderId payid:orderId price:money andDic:dic];
                }
            }
        }
    } Error:^(NSError *errror) {
        NSLog(@"----输出错误--------%@-------------",errror);
    }];

}
-(void)aliPay:(NSString *)odid money:(float)payMoney  withDic:(NSDictionary *)dic{
    NSDictionary *msgDic = dic[@"data"][0];
//    NSString *money = [NSString stringWithFormat:@"%@",msgDic[@"红包金额"]];
//    NSString *dayCount = [NSString stringWithFormat:@"%@",msgDic[@"有效天数"]];
    NSString *alipayShenfen = [NSString stringWithFormat:@"%@",msgDic[@"合作者身份"]];
//    NSString *aliAppId =  [NSString stringWithFormat:@"%@",msgDic[@"APPID"]];
    NSString *aliPrividKey = [NSString stringWithFormat:@"%@",msgDic[@"商户私钥"]];
    NSString *aliZhangHao = [NSString stringWithFormat:@"%@",msgDic[@"帐号"]];
    NSString *aliHost = [NSString stringWithFormat:@"%@",msgDic[@"授权域名"]];
    if (!(alipayShenfen&&aliPrividKey&&aliZhangHao&&aliHost)) {
        NSLog(@"阿里支付有参数不正确");
        return;
    }
    AliPayModel *order = [[AliPayModel alloc] init];
    //支付宝账户
    order.partner = alipayShenfen;//AliPartner;
    order.seller = aliZhangHao;//AliSeller;
    order.tradeNO = odid; //订单ID（由商家自行制定）
    order.productName = [NSString stringWithFormat:@"%@%@", @"国警骑兵支付",odid]; //商品标题
    order.productDescription = [NSString stringWithFormat:@"订单编号：%@",odid]; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",payMoney]; //商品价格
    //回调地址
    order.notifyURL = aliHost;//@"http://www.dakedaojia.com/Alipay/iosnotify.aspx";
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    //    NSLog(@"orderSpec = %@",orderSpec);
    //    self.payId = nil;//每次支付都要重新获取
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    //这里面放置私钥
    id<DataSigner> signer = CreateRSADataSigner(aliPrividKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        NSString *appScheme = @"dakekuaipaoAliPay";
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSString* strMsg;
            int state = [[resultDic objectForKey:@"resultStatus"] intValue];
            if (state == 9000) {
                strMsg=@"支付成功";
            }else if(state == 6001){
                strMsg=@"支付已取消";
            }else{
                strMsg=@"支付异常";
            }
            [self close];
            
        }];
        
    }
    [self close];
}

- (void)WXsendPay:(NSString *)odid payid:(NSString *)pid price:(float)moeny andDic:(NSDictionary *)dic
{
NSDictionary *msgDic = dic[@"data"][0];
    // NSString *wxusername = dic[@"wxusername"];
    //  NSString *wxpwd = dic[@"wxpwd"];
    NSString *appId = msgDic[@"AppId"];
    NSLog(@"==========%@",appId);
    NSString *appSecret = msgDic[@"AppSecret"];
    NSLog(@"==========%@",appSecret);
    NSString *partnerid = msgDic[@"partnerid"];
    NSLog(@"==========%@",partnerid);
    NSString *apikey = msgDic[@"apikey"];
    NSLog(@"==========%@",apikey);
    NSString *domain =[NSString stringWithFormat:@"%@/wx/userNotify.aspx",msgDic[@"domain"]];
    NSLog(@"==========%@",domain);

    if (!(appId&&partnerid&&apikey&&domain)) {
        NSLog(@"微信支付有参数不正确");
        return;
    }
    //创建支付签名对象
    payRequsestHandler *req = [[payRequsestHandler alloc] init];
    //初始化支付签名对象
    [req init:appId mch_id:partnerid];
    //设置密钥
    [req setKey:apikey];

    NSMutableDictionary *dict = [req sendPay:@"国警用户" odid:pid payid:odid moeny:moeny andNotiUrlStr:domain];
    if(dict != nil){
        NSMutableString *retcode = [dict objectForKey:@"retcode"];
        if (retcode.intValue == 0){
            NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
            NSLog(@"--999999999--%@",dict);
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.openID              = [dict objectForKey:@"appid"];
            req.partnerId           = [dict objectForKey:@"partnerid"];
            req.prepayId            = [dict objectForKey:@"prepayid"];
            req.package             = [dict objectForKey:@"package"];
            req.nonceStr            = [dict objectForKey:@"noncestr"];
            req.timeStamp           = stamp.intValue;
            req.sign                = [dict objectForKey:@"sign"];
            [WXApi sendReq:req];
            //日志输出
        }else{
            
        }
    }else{
        NSLog(@"服务器返回错误，未获取到json对象");
    }
    [self close];
    
}




@end
