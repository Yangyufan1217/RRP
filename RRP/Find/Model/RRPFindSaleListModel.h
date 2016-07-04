//
//  RRPFindSaleListModel.h
//  RRP
//
//  Created by sks on 16/4/19.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRPFindSaleListModel : NSObject

@property (nonatomic, assign) NSInteger ID;//景区ID
@property (nonatomic, strong) NSString *imgurl;//封面图
@property (nonatomic, strong) NSString *sceneryname;//景区名字
@property (nonatomic, strong) NSString *marketprice;//原价
@property (nonatomic, assign) NSInteger sceneryid;//景区ID
@property (nonatomic, strong) NSString *sellerprice;//销售价
@property (nonatomic, strong) NSString *stdname;//票名（注：后台改动以这个参数为主）
@property (nonatomic, strong) NSString *ticketname;//票名 （注：要用这个名字，首先判断上一个名字是否有）
@property (nonatomic, strong) NSString *stopselldate;//截止时间


@end
