//
//  RRPTicketContactModel.h
//  RRP
//
//  Created by WangZhaZha on 16/4/25.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRPTicketContactModel : NSObject
@property (nonatomic, strong) NSString *memberid;//用户id
@property (nonatomic, strong) NSString *mr_id;//序列号id
@property (nonatomic, strong) NSString *r_idcardno;//身份证ID
@property (nonatomic, strong) NSString *r_mobile;//手机号
@property (nonatomic, strong) NSString *r_name;//姓名

@end
