//
//  RRPAllCityModel.h
//  RRP
//
//  Created by WangZhaZha on 16/3/22.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRPAllCityModel : NSObject<NSCoding>
@property (nonatomic,strong)NSString *city_code;//城市ID
@property (nonatomic,strong)NSString *city_name;//城市名称
@property (nonatomic,strong)NSString *province_code;//省编码


@end
