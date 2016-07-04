//
//  RRPCommentCell.h
//  RRP
//
//  Created by WangZhaZha on 16/3/10.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRPHomeSelectedCommentModel;
@interface RRPCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *commentLogoView;
@property (weak, nonatomic) IBOutlet UILabel *commentLogoLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userHeadPic;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tabClassifyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *picContentView;
@property (weak, nonatomic) IBOutlet UIButton *usesButton;
@property (nonatomic, strong)UILabel *usesNumaberLabel;
@property (nonatomic, strong)UIImageView *usesImageView;
@property (nonatomic, strong)UILabel *usesLabel;
@property (nonatomic, strong)UIButton *labelButton;
@property (nonatomic, strong) NSMutableArray *historySearchArray;
//赋值
- (void)shoeDataWithModel:(RRPHomeSelectedCommentModel *)model;
@end
