//
//  RRPCDCommmentCell.h
//  RRP
//
//  Created by sks on 16/2/25.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRPAllCommentModel;
@interface RRPCDCommmentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) UILabel *commentContentLabel;
@property (weak, nonatomic) IBOutlet UIView *contentImageView;
@property (weak, nonatomic) IBOutlet UIButton *usesButton;
@property (nonatomic, strong)RRPAllCommentModel *model;
@property (nonatomic, strong)UILabel *usesNumaberLabel;
@property (nonatomic, strong)UIImageView *usesImageView;
@property (nonatomic, strong)UILabel *usesLabel;
@property (nonatomic, strong)NSString *commentString;
@property (nonatomic, strong)NSMutableArray *imageURLArr;


+ (CGFloat)cellHeight:(RRPAllCommentModel *)model;
//赋值
- (void)shoeDataWithModel:(RRPAllCommentModel *)model;

@end
