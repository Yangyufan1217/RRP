//
//  RRPHomeSelected.h
//  RRP
//
//  Created by WangZhaZha on 16/3/29.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRPHomeSelected : NSObject
@property (nonatomic,strong)NSString *sceneryid;//景点ID
@property (nonatomic,strong)NSString *grade;//星级
@property (nonatomic,strong)NSString *sceneryname;//景点名称
@property (nonatomic,strong)NSString *summary;//简介
@property (nonatomic,strong)NSURL *imgurl;//图片地址
@property (nonatomic,strong)NSURL *small_imgurl;//小图
@property (nonatomic,strong)NSString *sellerprice;//价格
@property (nonatomic,strong)NSString *address;//地址
@property (nonatomic,strong)NSString *distance;//距离 需要自己取.2f
@property (nonatomic,strong)NSString *h5tag;
@property (nonatomic,strong)NSString *latitude;//纬度
@property (nonatomic,strong)NSString *longitude;//经度
@property (nonatomic,strong)NSURL *link;
@property (nonatomic,strong)NSString *marketprice;//市场价
@property (nonatomic,strong)NSString *scenery_class;
@property (nonatomic,strong)NSString *soldnum;
@property (nonatomic,strong)NSString *source;
@property (nonatomic,strong)NSString *comment_count;//评论条数
@property (nonatomic,strong)NSString *label;//标签
@property (nonatomic,strong)NSString *satisfied;//满意度






@end
