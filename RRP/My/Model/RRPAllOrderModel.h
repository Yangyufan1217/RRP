//
//  RRPAllOrderModel.h
//  RRP
//
//  Created by WangZhaZha on 16/4/18.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRPAllOrderModel : NSObject
@property (nonatomic, strong) NSString *distributorid;//经销商ID
@property (nonatomic, strong) NSString *oid;//订单ID
@property (nonatomic, strong) NSString *orderno;
@property (nonatomic, strong) NSString *origin;//价格
@property (nonatomic, strong) NSString *quantity;//票数
@property (nonatomic, strong) NSString *sceneryid;//景点ID
@property (nonatomic, strong) NSString *stdname;//
@property (nonatomic, strong) NSString *ticketid;//票ID
@property (nonatomic, strong) NSString *ticketname;//票名
@property (nonatomic, strong) NSString *traveldate;//游玩日期
@property (nonatomic, strong) NSString *createdtime;//下单时间
@property (nonatomic, strong) NSString *status;//订单出行状态
@property (nonatomic, strong) NSString *comment_staus;//订单评价状态
@property (nonatomic, strong) NSString *paystatus;//订单付款状态

@end
