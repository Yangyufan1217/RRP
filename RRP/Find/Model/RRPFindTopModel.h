//
//  RRPFindTopModel.h
//  RRP
//
//  Created by WangZhaZha on 16/3/8.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRPFindTopModel : NSObject
@property (nonatomic,copy)NSString *seperaterStr;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *classcodeArray;
//分享用的参数
@property (nonatomic, strong) NSString *content;//分享内容
@property (nonatomic, strong) NSString *download_link_ios;//app下载链接
@property (nonatomic, strong) NSString *download_share;//分享回调H5页面
@property (nonatomic, strong) NSString *imgurl;//app图标
@property (nonatomic, strong) NSString *title;//分享标题
@property (nonatomic, assign) NSInteger status;//屏蔽 1.不屏蔽  2.屏蔽
@property (nonatomic, strong) NSString *version_number;//版本号

//登录用的参数
@property (nonatomic, strong) NSString *password;//密码
@property (nonatomic, strong) NSString *mobile;//号码




+ (RRPFindTopModel *)shareRRPFindTopModel;
@end
