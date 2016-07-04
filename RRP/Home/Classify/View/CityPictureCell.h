//
//  CityPictureCell.h
//  RRP
//
//  Created by sks on 16/2/29.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRPClassifyListModel;
@interface CityPictureCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cityPictureImage;
@property (weak, nonatomic) IBOutlet UIView *orderView;//底部蒙层
@property (weak, nonatomic) IBOutlet UILabel *cityName;//城市名

//赋值
- (void)showDataWithModel:(RRPClassifyListModel *)model;

@end
