//
//  RRPDataRequestHandle.m
//  RRP
//
//  Created by WangZhaZha on 16/3/22.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPDataRequestHandle.h"
#import "RRPDataRequestModel.h"
@implementation RRPDataRequestHandle
+ (RRPDataRequestHandle *)shareDataRequestHandle
{
    static RRPDataRequestHandle *dataRequestHandle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataRequestHandle = [[RRPDataRequestHandle alloc] init];
    //赋值
        
    });

    return dataRequestHandle;
}



@end
