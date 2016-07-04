//
//  RRPFindModel.h
//  RRP
//
//  Created by sks on 16/4/12.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRPFindModel : NSObject

//分类
@property (nonatomic, strong) NSString *classcode;//分类ID
@property (nonatomic, strong) NSString *name;//分类名字

//列表
@property (nonatomic, assign) NSInteger city;
@property (nonatomic, assign) NSInteger city_code;//城市代码
@property (nonatomic, strong) NSString *city_name;//城市名字
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString *imgurl;
@property (nonatomic, assign) NSInteger province;
@property (nonatomic, assign) NSInteger province_code;
@property (nonatomic, strong) NSString *province_name;
@property (nonatomic, strong) NSString *sceneryname;
@property (nonatomic, strong) NSString *summary;//简介



@end
