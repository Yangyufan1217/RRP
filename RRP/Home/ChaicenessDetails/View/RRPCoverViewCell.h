//
//  RRPCoverViewCell.h
//  RRP
//
//  Created by sks on 16/2/26.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RRPCoverViewDelegate <NSObject>

- (void)removeCoverViewFromSuperview;

@end

@interface RRPCoverViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UIButton *touchButton;

@property (nonatomic, weak) id<RRPCoverViewDelegate> delegate;

@end
