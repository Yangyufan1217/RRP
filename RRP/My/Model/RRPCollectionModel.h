//
//  RRPCollectionModel.h
//  RRP
//
//  Created by WangZhaZha on 16/4/19.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRPCollectionModel : NSObject
@property (nonatomic, strong) NSString *Praisepercentage;//满意度
@property (nonatomic, strong) NSString *cid;//收藏类型
@property (nonatomic, strong) NSString *Class;
@property (nonatomic, strong) NSString *classname;//类别名称
@property (nonatomic, strong) NSString *commentnum;//评论数
@property (nonatomic, strong) NSString *grade;//几A景区
@property (nonatomic, strong) NSURL *imgurl;//图片地址
@property (nonatomic, strong) NSString *sellerprice;//现价
@property (nonatomic, strong) NSString *sid;//景区id
@property (nonatomic, strong) NSString *sname;//景点名称
@property (nonatomic, strong) NSString *summary;//景点介绍


@end
