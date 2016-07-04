//
//  RRPFindModel.m
//  RRP
//
//  Created by sks on 16/4/12.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPFindModel.h"

@implementation RRPFindModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

//取值
- (id)valueForUndefinedKey:(NSString *)key {
    return key;
}


@end
