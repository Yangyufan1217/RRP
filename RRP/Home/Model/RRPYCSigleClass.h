//
//  RRPYCSigleClass.h
//  RRP
//
//  Created by sks on 16/4/5.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRPYCSigleClass : NSObject

@property (nonatomic,strong) NSString *latitude;//纬度
@property (nonatomic,strong) NSString *longitude;//经度


//单例
+ (RRPYCSigleClass *)mapLatitudeLongitudePassByValue;


@end
