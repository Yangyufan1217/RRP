//
//  FindRecreationModel.h
//  RRP
//
//  Created by sks on 16/4/13.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindRecreationModel : NSObject

@property (nonatomic, strong) NSString *sceneryname;//景区名字
@property (nonatomic, assign) NSInteger ID;//景区ID
@property (nonatomic, strong) NSString *summary;//景区介绍；
@property (nonatomic, strong) NSString *scenery_class;//景区类型
@property (nonatomic, strong) NSString *imgurl;//景区封面图


@end
