//
//  RRPOrderView.m
//  RRP
//
//  Created by WangZhaZha on 16/3/11.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPOrderView.h"
#import "RRPOrderController.h"
#import "RRPmoneyCell.h"
#import "RRPOrderModel.h"
#import "RRPAllCityHandle.h"
@interface RRPOrderView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIView *cheatView;//点击预定出现的蒙层



@end
@implementation RRPOrderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //布局预定界面
        [self layoutOrderTicketView];
        //注册cell
        [self.moneyTableView registerNib:[UINib nibWithNibName:@"RRPmoneyCell" bundle:nil] forCellReuseIdentifier:@"RRPmoneyCell"];
        [self.moneyTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self addSubview:self.cheatView];
        [self.moneyTableView reloadData];
        //添加tableView
        [self.cheatView addSubview:_moneyTableView];
        
    }
    return self;
}

- (UIView *)cheatView {
    if (_cheatView == nil) {
        self.cheatView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, RRPHeight-49)];
        self.cheatView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToController:)];
        tap.numberOfTapsRequired = 1;
        //向视图添加手势
        [self.cheatView addGestureRecognizer:tap];
    }
    return  _cheatView;
}
//布局预定界面
- (void)layoutOrderTicketView
{
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, RRPHeight-49, RRPWidth, 49)];
    self.backView.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(200, 200, 200));
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, RRPWidth / 3, 49)];
    moneyLabel.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    moneyLabel.text = @"在线支付:";
    moneyLabel.font = [UIFont systemFontOfSize:15];
    moneyLabel.textAlignment = 2;
    moneyLabel.textColor = IWColor(73, 73, 73);
    [self.backView addSubview:moneyLabel];
    
    self.moneyNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(RRPWidth / 3, 0, RRPWidth / 3, 49)];

    self.moneyNumberLabel.text = @"";
    self.moneyNumberLabel.textAlignment = 0;
    self.moneyNumberLabel.font = [UIFont systemFontOfSize:15];
    self.moneyNumberLabel.textColor = IWColor(225, 65, 34);
    self.moneyNumberLabel.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    [self.backView addSubview:self.moneyNumberLabel];
    
    UIButton *moneyButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    moneyButton.frame = CGRectMake(RRPWidth / 3 *2, 0, RRPWidth / 3, 49);
    moneyButton.backgroundColor =IWColor(255, 104, 23);
    [moneyButton addTarget:self action:@selector(moneyButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [moneyButton setTitle:@"立即预定" forState:(UIControlStateNormal)];
    moneyButton.titleLabel.textAlignment = 1;
    moneyButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [moneyButton setTitleColor:IWColor(255, 255, 255) forState:(UIControlStateNormal)];
    [self.backView addSubview:moneyButton];
    [self addSubview:self.backView];

}
- (void) moneyButton:(UIButton *) sender {
    RRPOrderController *order = [[RRPOrderController alloc] init];
    order.passPrice = self.moneyNumberLabel.text;
    order.ticketname = self.orderModel.ticketname;
    UINavigationController *viewController = [self findViewController:self];
    [viewController pushViewController:order animated:YES];
    
    //发布通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"显示导航栏" object:nil];

}

//通过View找viewController
- (UINavigationController *)findViewController:(UIView *)sourceView
{
    id target= sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UINavigationController class]]) {
            break;
        }
    }
    return target;
    
}
//懒加载
- (UITableView *)moneyTableView {
    if (_moneyTableView == nil) {
        self.moneyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,RRPWidth, RRPHeight - 49)];
        self.moneyTableView.backgroundColor = [UIColor clearColor];
        self.moneyTableView.tableFooterView = [[UIView alloc] init];
        self.moneyTableView.showsVerticalScrollIndicator = NO;
        self.moneyTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        self.moneyTableView.delegate = self;
        self.moneyTableView.bounces = NO;
        self.moneyTableView.dataSource = self;
    }
    return _moneyTableView;
}
#pragma mark - UITableViewDelegate
//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 9;

}
//cell展示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        //取消点击样式
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((RRPWidth - 100)/2, 50, 100, 21)];
        nameLabel.text = @"[票型说明]";
        nameLabel.textColor = IWColor(225, 225, 225);
        nameLabel.font = [UIFont systemFontOfSize:21];
        [cell addSubview:nameLabel];
        //分割线
        UIView *wireView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nameLabel.frame)+10, RRPWidth, 1)];
        wireView.backgroundColor = IWColor(225, 225, 225);
        [cell addSubview:wireView];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(wireView.frame)+10, RRPWidth-20, 16)];
        titleLabel.textColor = IWColor(225, 225, 225);
        titleLabel.textAlignment = 1;
        titleLabel.text = @"";
        titleLabel.text = self.orderModel.ticketname;
        titleLabel.font = [UIFont systemFontOfSize:16];
        [cell addSubview:titleLabel];
        return cell;
    }else {
        RRPmoneyCell *cell  =[tableView dequeueReusableCellWithIdentifier:@"RRPmoneyCell" forIndexPath:indexPath];
        //取消点击样式
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
       
        if (indexPath.row == 1) {
            cell.RRPtitleLabel.text = @"1.门票名称";
            if ([self.orderModel.stdname length] > 0) {
                [cell showDataWithString:self.orderModel.stdname];
            }else
            {
                [cell showDataWithString:self.orderModel.ticketname];
            }
            return cell;
        }else if (indexPath.row == 2)
        {
            cell.RRPtitleLabel.text = @"2.门票类型";
            if ([self.orderModel.ticket_class isEqualToString:@"1"]) {
                [cell showDataWithString:@"平日票"];

            }else if ([self.orderModel.ticket_class isEqualToString:@"2"])
            {
               [cell showDataWithString:@"周末票"];

            }else if ([self.orderModel.ticket_class isEqualToString:@"3"])
            {
               [cell showDataWithString:@"节日票"];

            }else if ([self.orderModel.ticket_class isEqualToString:@"4"])
            {
              [cell showDataWithString:@"活动票"];
            }else
            {
              [cell showDataWithString:@"无"];
            }
            return cell;
        }else if (indexPath.row == 3)
        {
            cell.RRPtitleLabel.text = @"3.检票须知";
            [cell showDataWithString:self.orderModel.checkinnote];
            return cell;
        }else if (indexPath.row == 4)
        {
            cell.RRPtitleLabel.text = @"4.重点";
            [cell showDataWithString:self.orderModel.importentpoint];
            return cell;
        }else if (indexPath.row == 5)
        {
            cell.RRPtitleLabel.text = @"5.用户须知";
            [cell showDataWithString:self.orderModel.usenote];
            return cell;
        }else if (indexPath.row == 6)
        {
            cell.RRPtitleLabel.text = @"6.付款须知";
            [cell showDataWithString:self.orderModel.checkinnote];
            return cell;
        }else if (indexPath.row == 7)
        {
            cell.RRPtitleLabel.text = @"7.购票方式";
            [cell showDataWithString:self.orderModel.getticketmode];
            return cell;
        }else
        {
            cell.RRPtitleLabel.text = @"8.包含条款";
            [cell showDataWithString:self.orderModel.containeditems];
            return cell;
        }
    }
}
#pragma mark - UITableViewDataSource
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 125;
    }else {
        if (indexPath.row == 1) {
            if ([self.orderModel.stdname length] > 0) {
                return [RRPmoneyCell cellHeight:self.orderModel.stdname];
            }else
            {
                return [RRPmoneyCell cellHeight:self.orderModel.ticketname];
            }
            
        }else if(indexPath.row == 2)
        {
            return [RRPmoneyCell cellHeight:self.orderModel.ticket_class];
        }else if(indexPath.row == 3)
        {
            return [RRPmoneyCell cellHeight:self.orderModel.checkinnote];
        }else if(indexPath.row == 4)
        {
            return [RRPmoneyCell cellHeight:self.orderModel.importentpoint];
        }else if(indexPath.row == 5)
        {
            return [RRPmoneyCell cellHeight:self.orderModel.usenote];
        }else if(indexPath.row == 6)
        {
            return [RRPmoneyCell cellHeight:self.orderModel.chargenote];
        }else if(indexPath.row == 7)
        {
            return [RRPmoneyCell cellHeight:self.orderModel.getticketmode];
        }else
        {
            return [RRPmoneyCell cellHeight:self.orderModel.containeditems];
        }
    }
}
- (void)tapToController:(UITapGestureRecognizer *)tap {
    [self.cheatView removeFromSuperview];
    [self.backView removeFromSuperview];
    //发布通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"显示导航栏" object:nil];
}



@end
