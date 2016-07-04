//
//  RRPAllCityHandle.m
//  RRP
//
//  Created by WangZhaZha on 16/3/22.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPAllCityHandle.h"

@implementation RRPAllCityHandle
//单例
+ (RRPAllCityHandle *)shareAllCityHandle
{
    static RRPAllCityHandle *allCityHandle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allCityHandle = [[RRPAllCityHandle alloc] init];
    });
    return allCityHandle;
}
//类方法
+ (NSData *)image_TransForm_Data:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
    //几乎是按0.5图片大小就降到原来的一半
    return imageData;

}


@end
