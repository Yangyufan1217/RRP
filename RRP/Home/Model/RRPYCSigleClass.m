//
//  RRPYCSigleClass.m
//  RRP
//
//  Created by sks on 16/4/5.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPYCSigleClass.h"

@implementation RRPYCSigleClass

+ (RRPYCSigleClass *)mapLatitudeLongitudePassByValue {
    static RRPYCSigleClass *sigleClass = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sigleClass = [[RRPYCSigleClass alloc] init];
    });
    return sigleClass;
}


@end
