//
//  MHContactModel.h
//  读取通讯录
//
//  Created by LMH on 16/2/23.
//  Copyright © 2016年 LMH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHContactModel : NSObject
/** 联系人姓名 */
@property (nonatomic, retain) NSString *name;
/** 联系人电话号码(数组) */
@property (strong, nonatomic) NSMutableArray *telArray;

@property (nonatomic, assign) int recordID;
//@property (nonatomic, retain) NSString *tel;
@end
