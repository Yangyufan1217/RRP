//
//  RRPDailySelectModel.m
//  RRP
//
//  Created by sks on 16/4/21.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPDailySelectModel.h"

@implementation RRPDailySelectModel


+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id", @"desc" : @"description"};
}

//取值
- (id)valueForUndefinedKey:(NSString *)key {
    return key;
}

@end
