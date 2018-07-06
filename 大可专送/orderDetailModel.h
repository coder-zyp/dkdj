//
//  orderDetailModel.h
//  大可专送
//
//  Created by 张允鹏 on 2016/12/3.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface orderDetailModel : NSObject


@property (nonatomic,copy) NSString *dingdanzhuangtai;
@property (nonatomic,strong) NSString *orderid;//订单编号,
@property (nonatomic,strong) NSString *orderType;//订单分类,
@property (nonatomic,strong) NSString *qAddress;//取货地址,
@property (nonatomic,strong) NSString *sAddress;//送货地址,
@property (nonatomic,strong) NSString *qTell;//取货人电话,
@property (nonatomic,strong) NSString *sTell;//送货人电话,
@property (nonatomic,strong) NSString *orderStatus;//订单状态(1;//等待审核;2;//审核通过;7;//已经调度;3;//处理成功;4;//处理失败;5;//订单取消;6;//订单失效;),
@property (nonatomic,strong) NSString *deliverName;//骑士名字,
@property (nonatomic,strong) NSString *deliverPhone;//骑士电话,
@property (nonatomic,strong) NSString *sendState;//配送状态(配送状态：0：未配送，2：配送中，3：配送完成， 4：配送失败),

@property (nonatomic,strong) NSString *payState;//支付状态  0 未支付 1 成功,
@property (nonatomic,strong) NSString *totalPrice;//订单总额,
@property (nonatomic,strong) NSString *isShopSet;//商家接单状态 1接单 2取消,
@property (nonatomic,strong) NSString *remark;//备注,
@property (nonatomic,strong) NSString *isNearbuy;//是否就近买,
@property (nonatomic,strong) NSString *isKnowfee;//是否知道商品金额,
@property (nonatomic,strong) NSString *foodFee;//商品金额,
@property (nonatomic,strong) NSString *sendFee;//配送费,
@property (nonatomic,strong) NSString *lichengFee;//里程费,
@property (nonatomic,strong) NSString *juLi;//距离,
@property (nonatomic,strong) NSString *isdaishouFee;//是否代收货款,
@property (nonatomic,strong) NSString *daishouFee;//代收货款金额,
@property (nonatomic,strong) NSString *qLat;//取货地址lat,
@property (nonatomic,strong) NSString *qLng;// 取货地址lng,
@property (nonatomic,strong) NSString *sLat;//收货地址lat,
@property (nonatomic,strong) NSString *sLng;//收货地址lat

@property (nonatomic,strong) NSString *orderTime;//下单时间,
@property (nonatomic,strong) NSString *sendTime;//发货时间,
@property (nonatomic,strong) NSString *DeliverQiangDate;//: 骑士抢单时间,
@property (nonatomic,strong) NSString *DeliverDaoDate;//: s骑士到商家,
@property (nonatomic,strong) NSString *DeliverZouDate;//: 骑士离开商家,
@property (nonatomic,strong) NSString *sLngDeliverWanDate;//: 骑士送餐完成,


@end
