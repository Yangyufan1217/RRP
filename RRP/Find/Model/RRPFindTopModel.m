//
//  RRPFindTopModel.m
//  RRP
//
//  Created by WangZhaZha on 16/3/8.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPFindTopModel.h"

@implementation RRPFindTopModel
+ (RRPFindTopModel *)shareRRPFindTopModel
{
    static RRPFindTopModel *findTopModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        findTopModel = [[RRPFindTopModel alloc] init];
    });
    return findTopModel;

}
@end
