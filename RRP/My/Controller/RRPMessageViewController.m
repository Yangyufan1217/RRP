//
//  RRPMessageViewController.m
//  RRP
//
//  Created by WangZhaZha on 16/3/28.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPMessageViewController.h"
#import "RRPMessageCell.h"
#import "RRPMessageModel.h"
@interface RRPMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *messageArray;

@end

@implementation RRPMessageViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.messageArray = [@[] mutableCopy];
    //取消滚动视图的自适应
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"消息列表";
    self.tableView.dk_backgroundColorPicker = DKColorWithColors(IWColor(244, 244, 244), IWColor(200, 200, 200));
    [self.view addSubview:self.tableView];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPMessageCell" bundle:nil] forCellReuseIdentifier:@"RRPMessageCell"];
    //请求消息列表数据
    [self requestMessageListData:1];
    
}
//请求消息列表数据
- (void)requestMessageListData:(NSInteger)page
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"massage_list" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:user_id forKey:@"memberid"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"1" forKey:@"limit"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:MyMessageList parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSInteger code = [[dict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000)  {
            [self.messageArray removeAllObjects];
            for (NSDictionary *dic in dict[@"ResponseBody"]) {
                
                RRPMessageModel  *model = [RRPMessageModel mj_objectWithKeyValues:dic];
                [self.messageArray addObject:model];
                
            }
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];

}
- (UITableView *)tableView
{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64,RRPWidth, RRPHeight-64)];
        self.tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.showsVerticalScrollIndicator = NO;
                self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    RRPMessageModel *model = self.messageArray[indexPath.row];
    if ([model.status isEqualToString:@"1"]) {
        //支付成功
        RRPMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPMessageCell" forIndexPath:indexPath];
        //取消点击样式
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.titleLabel.text = @"支付成功";
        cell.firstLeftLabel.text = @"商品名称 :";
        cell.secondLeftLabel.text = @"商品单号 :";
        cell.thirdLeftLabel.text = @"出行日期 :";
        cell.forthLeftLabel.text = @"支付金额 :";
        if ([model.stdname length] > 0) {
            cell.firstRightLabel.text = model.stdname;
        }else
        {
           cell.firstRightLabel.text = model.ticketname;
        }
        cell.secondRightLabel.text = model.orderno;
        cell.thirdRightLabel.text = model.traveldate;
        cell.forthRightLabel.text = model.origin;
        //下单日期 时间戳转标准时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[model.createdtime intValue]];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        cell.dateTimeLabel.text =confromTimespStr;
        cell.fifthLeftLabel.hidden = YES;
        cell.fifthRightLabel.hidden = YES;

        return cell;
    }else if ([model.refundstatus isEqualToString:@"2"])
    {
        RRPMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPMessageCell" forIndexPath:indexPath];
        //取消点击样式
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.titleLabel.text = @"退款成功";
        cell.firstLeftLabel.text = @"商品名称 :";
        cell.secondLeftLabel.text = @"退款编号 :";
        cell.thirdLeftLabel.text = @"退票张数 :";
        cell.forthLeftLabel.text = @"退款金额 :";
        if ([model.stdname length] > 0) {
            cell.firstRightLabel.text = model.stdname;
        }else
        {
            cell.firstRightLabel.text = model.ticketname;
        }
        cell.secondRightLabel.text = model.orderno;
        cell.thirdRightLabel.text = model.traveldate;
        cell.forthRightLabel.text = model.origin;
        //下单日期 时间戳转标准时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[model.createdtime intValue]];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        cell.dateTimeLabel.text =confromTimespStr;
        cell.fifthLeftLabel.text = @"退款原因 :";
        cell.fifthRightLabel.text = model.refundremark;
        return cell;
    }else
    {
        return nil;
    }
}

//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
    
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RRPMessageModel *model = self.messageArray[indexPath.row];
    if ([model.status isEqualToString:@"1"]) {
        //支付成功
        return 487/2;
    }else if ([model.refundstatus isEqualToString:@"2"])
    {
       return 452/2+15;
    }else
    {
        return 0;
    }

}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
