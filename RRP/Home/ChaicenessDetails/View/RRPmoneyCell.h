//
//  RRPmoneyCell.h
//  RRP
//
//  Created by sks on 16/3/3.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRPmoneyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *RRPtitleLabel;
@property (nonatomic, strong) UILabel *RRPcontentLabel;

//赋值
- (void)showDataWithString:(NSString *)str;
//cell高度
+ (CGFloat)cellHeight:(NSString *)str;


@end
