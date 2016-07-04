//
//  RRPNoPayModel.h
//  RRP
//
//  Created by WangZhaZha on 16/4/19.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRPNoPayModel : NSObject
@property (nonatomic, strong) NSString *createdtime;//下单时间 时间戳
@property (nonatomic, strong) NSString *distributorid;
@property (nonatomic, strong) NSURL *imgurl;//图片地址
@property (nonatomic, strong) NSString *oid;//订单ID
@property (nonatomic, strong) NSString *orderno;
@property (nonatomic, strong) NSString *origin;//价格
@property (nonatomic, strong) NSString *paystatus;
@property (nonatomic, strong) NSString *quantity;//张数
@property (nonatomic, strong) NSString *sceneryid;
@property (nonatomic, strong) NSString *status;//状态码
@property (nonatomic, strong) NSString *stdname;
@property (nonatomic, strong) NSString *ticketid;
@property (nonatomic, strong) NSString *ticketname;
@property (nonatomic, strong) NSString *traveldate;//游玩日期
@property (nonatomic, strong) NSString *type;//类型
@end
