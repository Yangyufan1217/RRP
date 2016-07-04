//
//  NetWorkManager.m
//  KMovie
//
//  Created by PP－mac001 on 15/7/14.
//  Copyright (c) 2015年 PP－mac001. All rights reserved.
//

#import "NetWorkManager.h"

@implementation NetWorkManager

+ (AFHTTPRequestOperationManager *)sharedManager
{
    static AFHTTPRequestOperationManager * manager;
    if (!manager) {
        manager = [AFHTTPRequestOperationManager manager];
        /**
         *  调用AFJSON方法, 处理的是json字符串
         */
//        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        /**
         *  设置请求头
         */
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain", nil]];
    }
    return manager;
}

+ (AFHTTPRequestOperationManager *)sharedHTTPManager {
    static AFHTTPRequestOperationManager * manager;
    if (!manager) {
        manager = [AFHTTPRequestOperationManager manager];
        /**
         *  调用的是AFHTTP方法, 处理的是数据流  一般上传图片用
         */
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken" ]forHTTPHeaderField:@"token"];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil]];
        
        [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
    }
    return manager;
}

+ (AFNetworkReachabilityManager *)sharedReachabilityManagerWithAlert
{
    AFNetworkReachabilityManager * manger = [AFNetworkReachabilityManager sharedManager];
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusReachableViaWWAN) {
            NSString * message = nil;
            if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
                message = @"正在使用数据网络，使用数据流量会产生费用";
            } else if (status == AFNetworkReachabilityStatusNotReachable) {
                message = @"无法连接，请检查网络设置";
            }
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:message delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alertView show];
        }
    }];
    [manger startMonitoring];
    return manger;
}

@end
