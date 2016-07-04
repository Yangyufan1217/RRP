//
//  RRPMapController.h
//  RRP
//
//  Created by sks on 16/3/28.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@interface RRPMapController : UIViewController

@property (nonatomic, assign) CLLocationDegrees afferentLatitude;//纬度
@property (nonatomic, assign) CLLocationDegrees afferentLongitude;//经度
@property (nonatomic, assign) CLLocationDegrees selfLatitude;//纬度
@property (nonatomic, assign) CLLocationDegrees selfLongitude;//经度

@end


