//
//  RRPSelectedTicketModel.h
//  RRP
//
//  Created by WangZhaZha on 16/4/1.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRPSelectedTicketModel : NSObject
//门票
@property (nonatomic,strong)NSString *advance_time;//预约时间
@property (nonatomic,strong)NSString *ID;//门票ID
@property (nonatomic,strong)NSString *marketprice;//原价
@property (nonatomic,strong)NSString *sellerprice;//现价
@property (nonatomic,strong)NSString *ticketname;//票名

@end
