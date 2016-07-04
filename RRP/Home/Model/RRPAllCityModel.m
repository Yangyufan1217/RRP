//
//  RRPAllCityModel.m
//  RRP
//
//  Created by WangZhaZha on 16/3/22.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPAllCityModel.h"

@implementation RRPAllCityModel

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.city_name forKey:@"city_name"];
    [aCoder encodeObject:self.city_code forKey:@"city_code"];
    [aCoder encodeObject:self.province_code forKey:@"province_code"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.city_name = [aDecoder decodeObjectForKey:@"city_name"];
        self.city_code = [aDecoder decodeObjectForKey:@"city_code"];
        self.province_code = [aDecoder decodeObjectForKey:@"province_code"];
    }
    return self;
}



@end
