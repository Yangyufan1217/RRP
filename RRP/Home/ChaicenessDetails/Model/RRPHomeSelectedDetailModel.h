//
//  RRPHomeSelectedDetailModel.h
//  RRP
//
//  Created by WangZhaZha on 16/4/1.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRPHomeSelectedDetailModel : NSObject
@property (nonatomic,strong)NSString *address;//景区地址
//须知
@property (nonatomic,strong)NSString *businesshours;//开放时间
@property (nonatomic,strong)NSString *favouredpolicy;//特惠政策
@property (nonatomic,strong)NSString *reminder;//提醒
//经纬度
@property (nonatomic,strong)NSString *latitude;//纬度
@property (nonatomic,strong)NSString *longitude;//经度

@property (nonatomic,strong)NSString *avg_score;//星星
@property (nonatomic,strong)NSString *comment_count;//评论数
@property (nonatomic,strong)NSString *summary;//简介
@property (nonatomic,strong)NSString * collection_status;//收藏状态


@end
