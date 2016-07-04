//
//  RRPCityListHotCityView.h
//  RRP
//
//  Created by WangZhaZha on 16/3/23.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRPAllCityModel.h"
@interface RRPCityListHotCityView : UIView
@property (nonatomic,strong)NSMutableArray *hotCityArray;
@property (nonatomic,strong)RRPAllCityModel *hotCityModel;
@property (nonatomic,assign)CGFloat height;
- (instancetype)initWithFrame:(CGRect)frame;

@end
