//
//  RRPChDetilsCommentCell.m
//  RRP
//
//  Created by sks on 16/2/22.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPChDetilsCommentCell.h"

@implementation RRPChDetilsCommentCell

- (void)awakeFromNib {
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    self.commentImageView.image = [UIImage imageNamed:@"sign-list-evaluate"];
    self.rankOneImageView.image = self.rankTwoImageView.image = self.rankThreeImageView.image = self.rankFourImageView.image = self.rankFiveImageView.image = [UIImage imageNamed:@"sign-list-evaluate-good"];
    self.comNumberLabel.backgroundColor = [UIColor clearColor];
    self.comNumberLabel.font = [UIFont systemFontOfSize:14];
    self.comNumberLabel.text = @"342条点评";
    self.moreImageView.image = [UIImage imageNamed:@"home-middleList-more"];
}
//赋值
- (void)showDataWithStar:(NSString *)avg_score CommentCount:(NSString *)comment_count
{
    if (avg_score == nil) {
        self.rankOneImageView.image = self.rankTwoImageView.image = self.rankThreeImageView.image = self.rankFourImageView.image = self.rankFiveImageView.image = [UIImage imageNamed:@"sign-list-evaluate-ok"];
    }else if ([avg_score isEqualToString:@"1"])
    {
         self.rankOneImageView.image = [UIImage imageNamed:@"sign-list-evaluate-good"];
         self.rankTwoImageView.image = self.rankThreeImageView.image = self.rankFourImageView.image = self.rankFiveImageView.image = [UIImage imageNamed:@"sign-list-evaluate-ok"];
    
    }else if ([avg_score isEqualToString:@"2"])
    {
        self.rankOneImageView.image = self.rankTwoImageView.image = [UIImage imageNamed:@"sign-list-evaluate-good"];
        self.rankThreeImageView.image = self.rankFourImageView.image = self.rankFiveImageView.image = [UIImage imageNamed:@"sign-list-evaluate-ok"];
    
    }else if ([avg_score isEqualToString:@"3"])
    {
        self.rankOneImageView.image = self.rankTwoImageView.image = self.rankThreeImageView.image = [UIImage imageNamed:@"sign-list-evaluate-good"];
        self.rankFourImageView.image = self.rankFiveImageView.image = [UIImage imageNamed:@"sign-list-evaluate-ok"];
        
    }else if ([avg_score isEqualToString:@"4"])
    {
        self.rankOneImageView.image = self.rankTwoImageView.image = self.rankThreeImageView.image = self.rankFourImageView.image = [UIImage imageNamed:@"sign-list-evaluate-good"];
        self.rankFiveImageView.image = [UIImage imageNamed:@"sign-list-evaluate-ok"];
    }else
    {
        self.rankOneImageView.image = self.rankTwoImageView.image = self.rankThreeImageView.image = self.rankFourImageView.image = self.rankFiveImageView.image = [UIImage imageNamed:@"sign-list-evaluate-good"];
    }
    
    if (comment_count == nil) {
        self.comNumberLabel.text = @"0条点评";
    }else
    {
        self.comNumberLabel.text = [NSString stringWithFormat:@"%@条点评",comment_count]; 
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
