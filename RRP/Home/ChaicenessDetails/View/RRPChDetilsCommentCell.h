//
//  RRPChDetilsCommentCell.h
//  RRP
//
//  Created by sks on 16/2/22.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRPChDetilsCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rankOneImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rankTwoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rankThreeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rankFourImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rankFiveImageView;

@property (weak, nonatomic) IBOutlet UILabel *comNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;
//赋值
- (void)showDataWithStar:(NSString *)avg_score CommentCount:(NSString *)comment_count;

@end
