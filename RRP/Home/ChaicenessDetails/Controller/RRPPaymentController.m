//
//  RRPPaymentController.m
//  RRP
//
//  Created by sks on 16/3/6.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPPaymentController.h"
#import "RRPExplainCell.h"
#import "RRPPaymentTypeCell.h"
#import "PaymentController.h"

@interface RRPPaymentController ()<UITableViewDataSource,UITableViewDelegate>{
    BOOL click;
    BOOL cellClick;
    BOOL deadline;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *moreButton;
@property (nonatomic, strong) UIView *backView;//预定view
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) NSInteger type;//判断
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) NSDate *futureTime;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *pleaseLabel;
@property (nonatomic, strong) UILabel *elseLabel;

@end

@implementation RRPPaymentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = IWColor(247, 247, 247);
    self.title = @"收银台";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPExplainCell" bundle:nil] forCellReuseIdentifier:@"RRPExplainCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPPaymentTypeCell" bundle:nil] forCellReuseIdentifier:@"RRPPaymentTypeCell"];
    [self.view addSubview:self.tableView];
    [self tabBarControl];
    /**
     *  type = 0 代表可以使用支付宝 微信  银联支付
     *  type = 1 代表不可以使用支付宝 微信  银联支付
     */
    self.type = 1;
    
    
}

- (void)tabBarControl {
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), RRPWidth, 49)];
    self.backView.backgroundColor =[UIColor whiteColor];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, RRPWidth / 3, 49)];
    moneyLabel.backgroundColor = [UIColor whiteColor];
    moneyLabel.text = @"订单金额:";
    moneyLabel.font = [UIFont systemFontOfSize:15];
    moneyLabel.textAlignment = 2;
    moneyLabel.textColor = IWColor(73, 73, 73);
    [self.backView addSubview:moneyLabel];
    
    UILabel *moneyNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(RRPWidth / 3, 0, RRPWidth / 3, 49)];
    moneyNumberLabel.backgroundColor = [UIColor whiteColor];
    moneyNumberLabel.text = [NSString stringWithFormat:@"￥%.2f",self.money];
    moneyNumberLabel.textAlignment = 0;
    moneyNumberLabel.font = [UIFont systemFontOfSize:15];
    moneyNumberLabel.textColor = IWColor(225, 65, 34);
    [self.backView addSubview:moneyNumberLabel];
    
    UIButton *moneyButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    moneyButton.frame = CGRectMake(RRPWidth / 3 *2, 0, RRPWidth / 3, 49);
    moneyButton.backgroundColor =IWColor(255, 104, 23);
    [moneyButton addTarget:self action:@selector(moneyButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [moneyButton setTitle:@"立即支付" forState:(UIControlStateNormal)];
    moneyButton.titleLabel.textAlignment = 1;
    moneyButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [moneyButton setTitleColor:IWColor(255, 255, 255) forState:(UIControlStateNormal)];
    [self.backView addSubview:moneyButton];
    [self.view addSubview:self.backView];
}

//支付按钮
- (void) moneyButton:(UIButton *) sender {
    if (self.number == 0) {
        //统计:支付方式点击
        NSDictionary *dict = @{@"paytype":@"applePay"};
        [MobClick event:@"29" attributes:dict];
        PaymentController *payment = [[PaymentController alloc] init];
        payment.orderno = self.orderno;
        payment.name = self.name;
        payment.dataDic = self.dataDic;
        payment.money = [NSString stringWithFormat:@"%.2f",self.money];
        [self.navigationController pushViewController:payment animated:YES];
    }else if (self.number == 1) {
        //统计:支付方式点击
        NSDictionary *dict = @{@"paytype":@"支付宝"};
        [MobClick event:@"29" attributes:dict];
//        NSLog(@"支付宝");
    }else if (self.number == 2) {
        //统计:支付方式点击
        NSDictionary *dict = @{@"paytype":@"微信"};
        [MobClick event:@"29" attributes:dict];
        //        NSLog(@"微信");
    }else if (self.number == 3) {
        //统计:支付方式点击
        NSDictionary *dict = @{@"paytype":@"银联"};
        [MobClick event:@"29" attributes:dict];
//        NSLog(@"银联");
    }
}



//懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,RRPWidth, RRPHeight-49)];
        self.tableView.backgroundColor = IWColor(247, 247, 247);
        self.tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        if (click == NO) {
            return 0;
        }else {
            return 1;
        }
    }else if (section == 2) {
         return 4;
    }else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        RRPExplainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPExplainCell" forIndexPath:indexPath];
        //取消点击样式
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor whiteColor];
        cell.explainNameLabel.text = self.name;
        cell.timeContentLabel.text = self.time;
        cell.validLabel.text = [NSString stringWithFormat:@"%ld张",(long)self.ticketNumber];
        if (self.ticketNumber != 0) {
            cell.moneyNumberLabel.text = [NSString stringWithFormat:@"￥%.2f（在线支付）",self.money/self.ticketNumber];
        }
        return cell;
    }else if (indexPath.section == 2) {
        RRPPaymentTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPPaymentTypeCell" forIndexPath:indexPath];
        //取消点击样式
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor whiteColor];
        
        /**
         *  type = 0 代表可以使用支付宝 微信  银联支付
         *  type = 1 代表不可以使用支付宝 微信  银联支付
         */
        if (indexPath.row == 0) {
            if (self.type == 0) {
                cell.headImageView.image = [UIImage imageNamed:@"Apple_Pay_mark_small_"];
                cell.nameLabel.text = @"Apple pey支付";
                cell.explainLabel.text = @"推荐使用，方便快捷安全简单";
                cell.selectImage.image = [UIImage imageNamed:@"已选择"];
                self.number = 0;
            }else {
                cell.headImageView.image = [UIImage imageNamed:@"Apple_Pay_mark_small_"];
                cell.nameLabel.text = @"Apple pay支付";
                cell.explainLabel.text = @"推荐使用，方便快捷安全简单";
                cell.selectImage.image = [UIImage imageNamed:@"已选择"];
                self.number = 0;
            }
        }else if (indexPath.row == 1) {
            if (self.type == 0) {
                cell.headImageView.image = [UIImage imageNamed:@"支付宝"];
                cell.nameLabel.text = @"支付宝支付";
                cell.explainLabel.text = @"推荐开通了支付宝支付的用户使用";
            }else {
                cell.headImageView.image = [UIImage imageNamed:@"支付宝_灰"];
                cell.nameLabel.textColor = cell.explainLabel.textColor = IWColor(174, 174, 174);
                cell.nameLabel.text = @"支付宝支付";
                cell.explainLabel.text = @"暂不支持该支付方式";
            }
        }else if (indexPath.row == 2) {
            if (self.type == 0) {
                cell.headImageView.image = [UIImage imageNamed:@"微信支付"];
                cell.nameLabel.text = @"微信支付";
                cell.explainLabel.text = @"推荐开通了微信支付的用户使用";
            }else {
                cell.headImageView.image = [UIImage imageNamed:@"微信支付_灰"];
                cell.nameLabel.textColor = cell.explainLabel.textColor = IWColor(174, 174, 174);
                cell.nameLabel.text = @"微信支付";
                cell.explainLabel.text = @"暂不支持该支付方式";
            }

        }else {
            if (self.type == 0) {
                cell.headImageView.image = [UIImage imageNamed:@"银联支付_亮"];
                cell.nameLabel.text = @"银连支付";
                cell.explainLabel.text = @"仅支持境内信用卡或储蓄卡支付";
            }else {
                cell.headImageView.image = [UIImage imageNamed:@"银联支付_灰"];
                cell.nameLabel.textColor = cell.explainLabel.textColor = IWColor(174, 174, 174);
                cell.nameLabel.text = @"银连支付";
                cell.explainLabel.text = @"暂不支持该支付方式";
            }
        }
        
        return cell;
    }else {
        return nil;
    }
    
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 120;
    }else if (indexPath.section == 2) {
        return 67;
    }else {
        return 0;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 37;
    }else if (section == 1) {
        return 50;
    }else{
        return 0;
    }
}


- (void)timerFire:(NSTimer *)timer
{
    
    //年
    NSDateFormatter *YFormatter = [[NSDateFormatter alloc] init];
    [YFormatter setDateStyle:NSDateFormatterShortStyle];
    [YFormatter setDateFormat:@"yyyy"];
    //月
    NSDateFormatter *Mformatter = [[NSDateFormatter alloc] init];
    [Mformatter setDateStyle:NSDateFormatterShortStyle];
    [Mformatter setDateFormat:@"MM"];
    //日
    NSDateFormatter *Dformatter = [[NSDateFormatter alloc] init];
    [Dformatter setDateStyle:NSDateFormatterShortStyle];
    [Dformatter setDateFormat:@"dd"];
    //时
    NSDateFormatter *Hformatter = [[NSDateFormatter alloc] init];
    [Hformatter setDateStyle:NSDateFormatterShortStyle];
    [Hformatter setDateFormat:@"HH"];
    //分
    NSDateFormatter *mformatter = [[NSDateFormatter alloc] init];
    [mformatter setDateStyle:NSDateFormatterShortStyle];
    [mformatter setDateFormat:@"mm"];
    //秒
    NSDateFormatter *sformatter = [[NSDateFormatter alloc] init];
    [sformatter setDateStyle:NSDateFormatterShortStyle];
    [sformatter setDateFormat:@"ss"];
    NSDate *today = [NSDate date];//当前时间
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:[[YFormatter stringFromDate:self.futureTime] integerValue]];
    [components setMonth:[[Mformatter stringFromDate:self.futureTime] integerValue]];
    [components setDay:[[Dformatter stringFromDate:self.futureTime] integerValue]];
    [components setHour:[[Hformatter stringFromDate:self.futureTime] integerValue]];
    [components setMinute:[[mformatter stringFromDate:self.futureTime] integerValue]];
    [components setSecond:[[sformatter stringFromDate:self.futureTime] integerValue]];
    NSDate *fireDate = [calendar dateFromComponents:components];//目标时间
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *d = [calendar components:unitFlags fromDate:today toDate:fireDate options:0];//计算时间差
    self.timeLabel.text = [NSString stringWithFormat:@"%ld分%ld秒", (long)[d minute], [d second]];//倒计时显示
    //倒计时结束
    if ([self.timeLabel.text isEqualToString:@"0分0秒"]) {
        [self.timer invalidate];
        self.pleaseLabel.hidden = YES;
        self.timeLabel.hidden = YES;
        self.elseLabel.text = @"订单已过期，请重新下单";
        self.elseLabel.textColor = IWColor(255, 96, 0);
        deadline = YES;
    }
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = IWColor(254, 247, 220);
        
        self.pleaseLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12.5, 25, 12)];
        self.pleaseLabel.text = @"请在";
        self.pleaseLabel.font = [UIFont systemFontOfSize:12];
        [view addSubview:self.pleaseLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.pleaseLabel.frame), 10, 67.5, 15)];
        self.timeLabel.text = @"30分00秒";
        self.timeLabel.font = [UIFont systemFontOfSize:15];
        //////每隔一秒执行一次
        self.timer  = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFire:) userInfo:nil repeats:YES];
        
        //半个小时的时间
        NSTimeInterval secondsPerDay = 0.5*60*60;
        self.futureTime = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
        [view addSubview:self.timeLabel];
        
        self.elseLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.timeLabel.frame), 12.5, 250, 12)];
        self.elseLabel.text = @"内完成支付，否则系统将取消本次订单";
        self.elseLabel.font = [UIFont systemFontOfSize:12];
        [view addSubview:self.elseLabel];
        
        self.pleaseLabel.textColor = self.elseLabel.textColor = IWColor(148, 143, 111);
        self.timeLabel.textColor = IWColor(255, 96, 0);
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 36, RRPWidth, 1)];
        lineView.backgroundColor = IWColor(218, 218, 218);
        [view addSubview:lineView];
        return view;
    }else if (section == 1) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *onlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 17.5, 70, 15)];
        onlineLabel.text = @"在线支付:";
        onlineLabel.textColor = IWColor(48, 48, 48);
        onlineLabel.font = [UIFont systemFontOfSize:15];
        [view addSubview:onlineLabel];
        
        UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(onlineLabel.frame), 17.5, 150, 15)];
        moneyLabel.textColor = IWColor(255, 96, 0);
        moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",self.money];
        moneyLabel.font = [UIFont systemFontOfSize:15];
        [view addSubview:moneyLabel];
        
        self.moreButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.moreButton.frame = CGRectMake(RRPWidth - 40 , 5, 40, 40);
        if (click == YES) {
            [self.moreButton setBackgroundImage:[UIImage imageNamed:@"订单展开"] forState:(UIControlStateNormal)];
        }else {
            [self.moreButton setBackgroundImage:[UIImage imageNamed:@"订单收起"] forState:(UIControlStateNormal)];
        }
        [self.moreButton addTarget:self action:@selector(moreButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:self.moreButton];
        return view;
    }else {
        return nil;
    }
}

- (void)moreButton:(UIButton *) sender {
    if (click == YES) {
        [self.moreButton setBackgroundImage:[UIImage imageNamed:@"add"] forState:(UIControlStateNormal)];
        click = NO;
        [self.tableView reloadData];
    }else {
        [self.moreButton setBackgroundImage:[UIImage imageNamed:@"home-middleList-more"] forState:(UIControlStateNormal)];
        click = YES;
        [self.tableView reloadData];

    }
}
//区尾
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 20;
    }else {
        return 0;
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = IWColor(240, 244, 247);
        UIView *lineHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, 1)];
        lineHeadView.backgroundColor = IWColor(218, 218, 218);
        [view addSubview:lineHeadView];
        UIView *lineFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, RRPWidth, 1)];
        lineFooterView.backgroundColor = IWColor(218, 218, 218);
        [view addSubview:lineFooterView];
        return view;
    }else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == 0) {
        if (indexPath.section == 2) {
            for (int i = 0; i < 4; i++) {
                //第一分区的第i个cell
                NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:2];
                RRPPaymentTypeCell *cell = [tableView cellForRowAtIndexPath:index];
                cell.selectImage.image = [UIImage imageNamed:@"可选择"];
            }
            RRPPaymentTypeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.selectImage.image = [UIImage imageNamed:@"已选择"];
            self.number = indexPath.row;
        }
    }else {
        if (indexPath.section == 2 && indexPath.row == 2) {
            RRPPaymentTypeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (cellClick == NO) {
                cell.selectImage.image = [UIImage imageNamed:@"已选择"];
                self.number = indexPath.row;
                cellClick = YES;
            }else {
                cell.selectImage.image = [UIImage imageNamed:@"可选择"];
                self.number = 5;
                cellClick = NO;
            }
            
            
        }
    }
}



- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
