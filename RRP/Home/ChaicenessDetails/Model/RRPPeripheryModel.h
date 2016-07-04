//
//  RRPPeripheryModel.h
//  RRP
//
//  Created by WangZhaZha on 16/4/13.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRPPeripheryModel : NSObject
@property (nonatomic,strong)NSString *comment_count;//评论个数
@property (nonatomic,strong)NSString *distance;//距离
@property (nonatomic,strong)NSString *grade;//星级
@property (nonatomic,strong)NSString *ID;//ID
@property (nonatomic,strong)NSURL *imgurl;//图片地址
@property (nonatomic,strong)NSString *label;//标签
@property (nonatomic,strong)NSString *sceneryname;//景点名称
@property (nonatomic,strong)NSString *sellerprice;//价格
@property (nonatomic,strong)NSString *satisfied;//满意度
@property (nonatomic,strong)NSURL *small_imgurl;//小图
@property (nonatomic,strong)NSString *marketprice;//原价

@end
