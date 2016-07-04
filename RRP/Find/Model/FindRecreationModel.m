//
//  FindRecreationModel.m
//  RRP
//
//  Created by sks on 16/4/13.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "FindRecreationModel.h"

@implementation FindRecreationModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

//取值
- (id)valueForUndefinedKey:(NSString *)key {
    return key;
}


@end
