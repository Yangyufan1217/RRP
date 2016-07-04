//
//  NetWorkManager.h
//  KMovie
//
//  Created by PP－mac001 on 15/7/14.
//  Copyright (c) 2015年 PP－mac001. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AFNetworking.h"
#import "AFNetworking.h"
//#import "AFNetworking-prefix.pch"
@interface NetWorkManager : NSObject

+ (AFHTTPRequestOperationManager *)sharedManager;

+ (AFHTTPRequestOperationManager *)sharedHTTPManager;

+ (AFNetworkReachabilityManager *)sharedReachabilityManagerWithAlert;

@end
