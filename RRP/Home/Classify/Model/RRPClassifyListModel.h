//
//  RRPClassifyListModel.h
//  RRP
//
//  Created by WangZhaZha on 16/3/25.
//  Copyright © 2016年 sks. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface RRPClassifyListModel : NSObject
@property (nonatomic,strong)NSString  *ID;//ID
@property (nonatomic,strong)NSString *sceneryname;//景点名称
@property (nonatomic,strong)NSString  *sellerprice;//门票价格
@property (nonatomic,strong)NSURL *imgurl;//图片地址
@property (nonatomic,strong)NSURL *small_imgurl;//小图
@property (nonatomic,strong)NSString *comment_count;//评论个数
@property (nonatomic,strong)NSString *satisfied;//满意度
@property (nonatomic,strong)NSString *distance;//距离



@end
