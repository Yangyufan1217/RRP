//
//  RRPFindSaleListModel.m
//  RRP
//
//  Created by sks on 16/4/19.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPFindSaleListModel.h"

@implementation RRPFindSaleListModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

//取值
- (id)valueForUndefinedKey:(NSString *)key {
    return key;
}


@end
