//
//  RRPChDetailsCommentShowCell.h
//  RRP
//
//  Created by sks on 16/2/22.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRPHomeSelectedCommentModel;
@interface RRPChDetailsCommentShowCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *commentImageImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentContentLabel;
@property (weak, nonatomic) IBOutlet UIView *contentImageView;
@property (weak, nonatomic) IBOutlet UIButton *usesButton;
@property (nonatomic, strong)UIImageView *usesImageView;
@property (nonatomic, strong)UILabel *usesNumaberLabel;
@property (nonatomic, strong)UILabel *usesLabel;
//赋值
- (void)shoeDataWithModel:(RRPHomeSelectedCommentModel *)model CommentStatus:(NSInteger)commentStatus imageArr:(NSMutableArray *)imageArr;

+ (CGFloat)cellHeight:(NSInteger)imagecount;


@end
