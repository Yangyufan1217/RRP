//
//  RRPCoverView.m
//  RRP
//
//  Created by sks on 16/2/26.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPCoverView.h"
#import "RRPCoverViewCell.h"

@interface RRPCoverView ()<UITableViewDataSource,UITableViewDelegate,RRPCoverViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end


@implementation RRPCoverView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.userInteractionEnabled = NO;
        
        [self addSubview:self.tableView];
        [self.tableView registerNib:[UINib nibWithNibName:@"RRPCoverViewCell" bundle:nil] forCellReuseIdentifier:@"RRPCoverViewCell"];
        
    }
    return self;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(15,(RRPHeight-210)/2,RRPWidth-30, 210)];
        self.tableView.backgroundColor = IWColor(246, 246, 246);
        self.tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.showsVerticalScrollIndicator = NO;
//        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        self.tableView.scrollEnabled =NO; //设置tableview 不能滚动
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RRPCoverViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPCoverViewCell" forIndexPath:indexPath];
    //取消点击样式
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.row == 0) {
        cell.headImageView.image = [UIImage imageNamed:@"scanWindow-phoneCall"];
        cell.nameLabel.text = @"电话客服";
        cell.numberLabel.text = @"4006-982-666";
        return cell;
    }else
    {
        cell.headImageView.image = [UIImage imageNamed:@"微信好友"];
        cell.nameLabel.text = @"微信客服";
        cell.numberLabel.text = @"微信服务号：rrpiao";
        cell.touchButton.hidden = YES;
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 65;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = IWColor(84, 90, 104);
    self.productNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.tableView.frame.size.width-20, 20)];
//    productNumberLabel.backgroundColor = [UIColor whiteColor];
    self.productNumberLabel.textAlignment = 1;
    self.productNumberLabel.text = [NSString stringWithFormat:@"景点编号:%@",[RRPAllCityHandle shareAllCityHandle].sceneryID ];
    self.productNumberLabel.textColor = IWColor(250, 250, 250);
    self.productNumberLabel.font = [UIFont systemFontOfSize:16];
    [view addSubview:self.productNumberLabel];
    
    UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.productNumberLabel.frame)+10, self.tableView.frame.size.width-20, 15)];
//    noticeLabel.backgroundColor = [UIColor whiteColor];
    noticeLabel.textAlignment = 1;
    noticeLabel.text = @"咨询时请告知客服景点编号";
    noticeLabel.textColor = IWColor(199, 199, 204);
    noticeLabel.font = [UIFont systemFontOfSize:12];
    [view addSubview:noticeLabel];
    return view;
}
- (void)removeCoverViewFromSuperview {
    [self.tableView removeFromSuperview];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}





@end
