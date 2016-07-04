//
//  RRPDataRequestModel.h
//  RRP
//
//  Created by WangZhaZha on 16/3/22.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRPDataRequestModel : NSObject
@property (nonatomic,strong)NSMutableDictionary *dataPortMessageDic;


+ (RRPDataRequestModel *)shareDataRequestModel;

@end
