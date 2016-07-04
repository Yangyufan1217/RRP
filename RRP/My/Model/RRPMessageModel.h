//
//  RRPMessageModel.h
//  RRP
//
//  Created by WangZhaZha on 16/4/29.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRPMessageModel : NSObject
@property (nonatomic, strong) NSString *createdtime;//创建时间 时间戳格式 需要转
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *orderno;//订单号
@property (nonatomic, strong) NSString *origin;//总价
@property (nonatomic, strong) NSString *paystatus;
@property (nonatomic, strong) NSString *price;//单价
@property (nonatomic, strong) NSString *quantity;//数量
@property (nonatomic, strong) NSString *refundno;
@property (nonatomic, strong) NSString *refundqty;
@property (nonatomic, strong) NSString *refundremark;//退款原因
@property (nonatomic, strong) NSString *refundstatus;//2 退款成功
@property (nonatomic, strong) NSString *refundtime;
@property (nonatomic, strong) NSString *status;//1 支付成功
@property (nonatomic, strong) NSString *stdname;//景区名 如果有就用这个
@property (nonatomic, strong) NSString *ticketname;//景区名
@property (nonatomic, strong) NSString *traveldate;//出行时间 2016-04-07











@end
