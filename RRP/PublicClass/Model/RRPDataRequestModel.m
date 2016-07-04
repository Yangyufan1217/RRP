//
//  RRPDataRequestModel.m
//  RRP
//
//  Created by WangZhaZha on 16/3/22.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPDataRequestModel.h"

@implementation RRPDataRequestModel
+ (RRPDataRequestModel *)shareDataRequestModel
{
    static RRPDataRequestModel *dataRequest = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataRequest = [[RRPDataRequestModel alloc] init];

    });
    return dataRequest;
}

- (NSMutableDictionary *)dataPortMessageDic
{
    if (! _dataPortMessageDic) {
        _dataPortMessageDic = [NSMutableDictionary dictionary];
    }
    return _dataPortMessageDic;
}



@end
