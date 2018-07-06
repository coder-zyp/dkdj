//
//  orderModel.h
//  大可专送
//
//  Created by 张允鹏 on 2016/12/2.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface orderModel : NSObject

@property (nonatomic,copy) NSString *orderid;//:订单编号,
@property (nonatomic,copy) NSString *dataid;//订单编号,
@property (nonatomic,copy) NSString *orderType;//订单分类,
@property (nonatomic,copy) NSString *qAddress;//取货地址,
@property (nonatomic,copy) NSString *sAddress;//送货地址,
@property (nonatomic,copy) NSString *dingdanzhuangtai;
@property (nonatomic,copy) NSString *qTell;//取货人电话,
@property (nonatomic,copy) NSString *sTell;//送货人电话,
@property (nonatomic,copy) NSString *orderStatus;
//订单状态(1;//等待审核;2;//审核通过;7;//已经调度;3;//处理成功;4;//处理失败;5;//订单取消;6;//订单失效;),
@property (nonatomic,copy) NSString *deliverName;//骑士名字,
@property (nonatomic,copy) NSString *deliverPhone;//骑士电话,
@property (nonatomic,copy) NSString *sendState;
//配送状态(配送状态：0：未配送，2：配送中，3：配送完成， 4：配送失败),
@property (nonatomic,copy) NSString *orderTime;//下单时间,
@property (nonatomic,copy) NSString *payState;//支付状态  0 未支付 1 成功,
@property (nonatomic,copy) NSString *TotalPrice;//订单总额,
@property (nonatomic,copy) NSString *IsShopSet;//商家接单状态 1接单 2取消

@end
