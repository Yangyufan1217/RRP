//
//  RRPOrderController.m
//  RRP
//
//  Created by sks on 16/3/2.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPOrderController.h"
#import "RRPCollectTicketCell.h"
#import "RRPCollectTicketNameCell.h"
#import "RRPContactController.h"
#import "RRPPaymentController.h"
#import "RRPAllCityHandle.h"
#import "RRPOrderView.h"
#import "RRPDateCanlenderModel.h"
#import "RRPTicketContactModel.h"
@interface RRPOrderController ()<UITableViewDataSource,UITableViewDelegate,RRPContactControllerDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) UIView *backView;//预定view
@property ( nonatomic, strong)RRPOrderView *orderView;
@property (nonatomic, strong) UIView *oneSectionView;//一分区区头View
@property (nonatomic, strong) UIView *twoSectionView;//
@property (nonatomic, strong) UIView *threeSectionView;//
@property (nonatomic, strong) UILabel *nameLabel;//景区名字
@property (nonatomic, strong) UILabel *moneyLabel;//价格
@property (nonatomic, strong) UIButton *todayButton;//今天
@property (nonatomic, strong) UILabel *todayLabel;
@property (nonatomic, strong) UILabel *todayTimeLabel;
@property (nonatomic, strong) UIButton *tomorrowButton;//明天
@property (nonatomic, strong) UILabel *tomorrowLabel;
@property (nonatomic, strong) UILabel *tomorrowTimeLabel;
@property (nonatomic, strong) UIButton *moreButton;//跟多日期
@property (nonatomic, strong) UIButton *addButton;//添加人数
@property (nonatomic, strong) UIButton *minusButton;//减少人数
@property (nonatomic, strong) UILabel *numberLabel;//购票人数
@property (nonatomic, strong) UILabel *moneyNumberLabel;
@property (nonatomic, strong) NSDictionary *priceCanlenderDic;
@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic, strong) NSString *todayStr;
@property (nonatomic, strong) NSString *tomorrowStr;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *month;
@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSMutableDictionary *datePriceDic;
@property (nonatomic, strong) NSMutableArray *canlenderArray;
@property (nonatomic, strong) UILabel *travelDate;//出行日期
@property (nonatomic, strong) NSString *travelDateStr;
@property (nonatomic, strong) NSString *bottomPriceStr;
@property (nonatomic, assign) NSInteger ticketCount;//票数
@property (nonatomic, strong) UILabel *timeLabel;//出行日期
@property (nonatomic, strong) NSString *ycMoneyNumber;//单价
@property (nonatomic, strong) NSMutableArray *contactShowArr;
@property (nonatomic, strong) NSString *contact;//联系人信息字符串
@property (nonatomic, strong) NSString *orderno;


@end

@implementation RRPOrderController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dateArray = [@[] mutableCopy];
    self.canlenderArray = [@[] mutableCopy];
    self.contactShowArr = [@[] mutableCopy];
    self.view.dk_backgroundColorPicker = DKColorWithColors(IWColor(242, 245, 247), IWColor(200, 200, 200));
    self.title = @"订单填写";
    //左侧返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStyleDone) target:self action:@selector(returnAction:)];
    //请求价格日历数据
    [self requestPriceCanlenderData];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPCollectTicketCell" bundle:nil] forCellReuseIdentifier:@"RRPCollectTicketCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPCollectTicketNameCell" bundle:nil] forCellReuseIdentifier:@"RRPCollectTicketNameCell"];
    
    [self tabBarControl];
    //赋值
    [self setValue];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNavigationBar:) name:@"显示导航栏" object:nil];
    
}
//返回
- (void)returnAction:(UIBarButtonItem *)bt
{
    [self.navigationController popViewControllerAnimated:YES];
}
//数量改变
- (NSString *)ticketCountWithString:(NSString *)str
{
    if (self.ticketCount == 0) {
        self.ticketCount = 1;
    }
    CGFloat price = [str floatValue]*(CGFloat)self.ticketCount;
    NSString *priceStr = [NSString stringWithFormat:@"%.2f",price];
    return priceStr;
}
//请求价格日历数据
- (void)requestPriceCanlenderData
{
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"get_price" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:[RRPAllCityHandle shareAllCityHandle].ticketid forKey:@"ticketid"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:GetPriceCanlender parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //检查字典中是否含有：“<NULL>”这样的字符串，有就改为“”
        NSDictionary * nullDict = [RRPPrintObject nullDic:dict];
        self.priceCanlenderDic = [[NSDictionary alloc] init];
        self.priceCanlenderDic = nullDict;
        NSInteger code = [[self.priceCanlenderDic[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000)  {
            for (NSMutableDictionary *dic in self.priceCanlenderDic[@"ResponseBody"])
            {
                [self.dateArray addObject:dic];
            }
            [RRPAllCityHandle shareAllCityHandle].dateArray = self.dateArray;
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];

}
- (void)tabBarControl {
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), RRPWidth, 49)];
    self.backView.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, RRPWidth / 3, 49)];
    moneyLabel.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    moneyLabel.text = @"订单金额:";
    moneyLabel.font = [UIFont systemFontOfSize:15];
    moneyLabel.textAlignment = 2;
    moneyLabel.textColor = IWColor(73, 73, 73);
    [self.backView addSubview:moneyLabel];
    
    self.moneyNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(RRPWidth / 3, 0, RRPWidth / 3, 49)];
    self.moneyNumberLabel.backgroundColor = [UIColor whiteColor];
    self.moneyNumberLabel.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    self.moneyNumberLabel.text = self.bottomPriceStr;
    self.moneyNumberLabel.textAlignment = 0;
    self.moneyNumberLabel.font = [UIFont systemFontOfSize:15];
    self.moneyNumberLabel.textColor = IWColor(225, 65, 34);
    [self.backView addSubview:self.moneyNumberLabel];
    
    UIButton *moneyButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    moneyButton.frame = CGRectMake(RRPWidth / 3 *2, 0, RRPWidth / 3, 49);
    moneyButton.backgroundColor =IWColor(255, 104, 23);
    [moneyButton addTarget:self action:@selector(moneyButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [moneyButton setTitle:@"提交订单" forState:(UIControlStateNormal)];
    moneyButton.titleLabel.textAlignment = 1;
    moneyButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [moneyButton setTitleColor:IWColor(255, 255, 255) forState:(UIControlStateNormal)];
    [self.backView addSubview:moneyButton];
    [self.view addSubview:self.backView];
}
- (void)moneyButton:(UIButton*)sender {
    
    //订单信息
    if (self.ticketCount == 0) {
        self.ticketCount = 1;
    }
    if ([self.timeLabel.text length] > 5) {
        if(
           [[RRPAllCityHandle shareAllCityHandle].orderModel.isrealname isEqualToString:@"0"]) {
            //取票人 判断实名制和非实名制方案
            //非实名制 只需添加一名取票人
            if (self.contactShowArr.count > 1 ) {
                [[MyAlertView sharedInstance]showFrom:@"只需添加一名取票人!"];
            }else if(self.contactShowArr.count == 0)
            {
                [[MyAlertView sharedInstance]showFrom:@"取票人不能为空!"];
                
            }else
            {
                [self requestOrderformData];
                //统计:提交订单点击
                [MobClick event:@"26"];
            }
        }else
        {  //实名制 购买几张票就需添加几名取票人
            if (self.contactShowArr.count != self.ticketCount) {
                [[MyAlertView sharedInstance]showFrom:@"此票为实名制验票,请添加相应个数取票人!"];
            }else
            {
                RRPPaymentController *payment = [[RRPPaymentController alloc] init];
                payment.money = [[NSString stringWithFormat:@"%@",self.moneyNumberLabel.text] floatValue];
                NSArray *urlArray = [self.timeLabel.text componentsSeparatedByString:@":"];
                payment.time = urlArray[1];
                payment.name = [RRPAllCityHandle shareAllCityHandle].orderModel.ticketname;
                payment.ticketNumber = self.ticketCount;
                [self requestOrderformData];
                //统计:提交订单点击
                [MobClick event:@"26"];
                [self.navigationController pushViewController:payment animated:YES];
                
            }
        }
    }else if ([self.timeLabel.text length] <= 5){
        //出行日期必填
        [[MyAlertView sharedInstance]showFrom:@"请选择出行日期"];
    }
}
- (void)requestOrderformData
{
    //请求提交订单接口
    //订单信息
    if (self.ticketCount == 0) {
        self.ticketCount = 1;
    }
    self.contact = @"";
    if([[RRPAllCityHandle shareAllCityHandle].orderModel.isrealname isEqualToString:@"0"]){
        //非实名制 只需穿姓名和手机号
        //取票人信息
        if (![[RRPAllCityHandle shareAllCityHandle].orderModel.isneedidcard isEqualToString:@"0"]) {
            //取票人信息
            for (int i = 0; i < self.contactShowArr.count; i++) {
                //实名制
                RRPTicketContactModel *model = self.contactShowArr[i];
                NSString *contactStr = [NSString stringWithFormat:@"%@,%@,%@|",model.r_name,model.r_mobile,model.r_idcardno];
                self.contact = [self.contact stringByAppendingString:contactStr];
            }
        }else {
            //非实名
            //取票人信息
            for (int i = 0; i < self.contactShowArr.count; i++) {
                RRPTicketContactModel *model = self.contactShowArr[i];
                NSString *contactStr = [NSString stringWithFormat:@"%@,%@|",model.r_name,model.r_mobile];
                self.contact = [self.contact stringByAppendingString:contactStr];
            }
        }
        
    }else {
        if ([[RRPAllCityHandle shareAllCityHandle].orderModel.isneedidcard isEqualToString:@"0"]) {
            //取票人信息
            for (int i = 0; i < self.contactShowArr.count; i++) {
                RRPTicketContactModel *model = self.contactShowArr[i];
                NSString *contactStr = [NSString stringWithFormat:@"%@,%@|",model.r_name,model.r_mobile];
                self.contact = [self.contact stringByAppendingString:contactStr];
            }
        }else {
            //取票人信息
            for (int i = 0; i < self.contactShowArr.count; i++) {
                RRPTicketContactModel *model = self.contactShowArr[i];
                NSString *contactStr = [NSString stringWithFormat:@"%@,%@,%@|",model.r_name,model.r_mobile,model.r_idcardno];
                self.contact = [self.contact stringByAppendingString:contactStr];
            }
        }
    }    NSString *user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"ticket_order" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:[self.contact substringWithRange:NSMakeRange(0, [self.contact length]-1)] forKey:@"contact"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:[RRPAllCityHandle shareAllCityHandle].ticketid forKey:@"ticketid"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:user_id forKey:@"memberid"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:[NSString stringWithFormat:@"%@",self.moneyNumberLabel.text] forKey:@"origin"];//总价
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:[RRPAllCityHandle shareAllCityHandle].orderModel.sceneryid forKey:@"sceneryid"];
    NSArray *urlArray = [self.timeLabel.text componentsSeparatedByString:@":"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:urlArray[1] forKey:@"traveldate"];
    CGFloat price = [self.moneyNumberLabel.text floatValue]/(float)self.ticketCount;
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:[NSString stringWithFormat:@"%.2f",price] forKey:@"price"];//单价
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:[NSString stringWithFormat:@"%ld",(long)self.ticketCount] forKey:@"quantity"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:HomeOrderSubmit parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //检查字典中是否含有：“<NULL>”这样的字符串，有就改为“”
        NSDictionary * nullDict = [RRPPrintObject nullDic:dict];
        self.priceCanlenderDic = [[NSDictionary alloc] init];
        self.priceCanlenderDic = nullDict;
        NSInteger code = [self.priceCanlenderDic[@"ResponseBody"][@"code"] integerValue];
        if (code == 2000)  {
            if (price != 0) {
                self.orderno = self.priceCanlenderDic[@"ResponseBody"][@"orderno"];
                RRPPaymentController *payment = [[RRPPaymentController alloc] init];
                payment.money = [[NSString stringWithFormat:@"%@",self.moneyNumberLabel.text] floatValue];
                NSArray *urlArray = [self.timeLabel.text componentsSeparatedByString:@":"];
                payment.time = urlArray[1];
                payment.name = [RRPAllCityHandle shareAllCityHandle].orderModel.ticketname;
                payment.ticketNumber = self.ticketCount;
                payment.orderno = self.orderno;
                payment.dataDic = self.priceCanlenderDic[@"ResponseBody"][@"data"];
                [self.navigationController pushViewController:payment animated:YES];
            }else {
                [[MyAlertView sharedInstance]showFrom:@"您选择了无票的日期"];
            }
        }else {
            [[MyAlertView sharedInstance]showFrom:@"订单未授权，请联系客服"];
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}
//懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,RRPWidth, RRPHeight-49)];
        self.tableView.dk_backgroundColorPicker = DKColorWithColors(IWColor(246, 246, 246), IWColor(200, 200, 200));
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
    if (section == 3) {
        return 1+self.contactShowArr.count;
    }else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        RRPCollectTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPCollectTicketCell" forIndexPath:indexPath];
        //取消点击样式RRPCollectTicketNameCell
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }else {
        RRPCollectTicketNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPCollectTicketNameCell" forIndexPath:indexPath];
        //取消点击样式
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        RRPTicketContactModel *model = self.contactShowArr[indexPath.row-1];
        [cell showDataWithModel:model];
        return cell;
    }
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 65;
    }else if (section == 2) {
        return 54;
    }else if (section == 3) {
        return 0.1;
    }else {
        return 44;
    }
}
//获取今天明天日期
- (void)getTodayAndTomorrowDate
{
    NSDate *date = [NSDate date];
    //1.创建日期格式类对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //3.设置日期风格
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //5.使用设置好的格式 进行转化
    NSString *dateStr = [formatter stringFromDate:date];
    //获取东八区明天时间
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
    [components setDay:([components day]+1)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSString *tomorrow = [formatter stringFromDate:beginningOfWeek];
    self.todayStr = dateStr;
    self.tomorrowStr = tomorrow;

}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    
    if (section == 0) {
        self.oneSectionView = [[UIView alloc] init];
        self.oneSectionView.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 18, RRPWidth - 30, 15)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.text =self.ticketname;
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        self.nameLabel.textColor = IWColor(73, 73, 73);
        [self.oneSectionView addSubview:self.nameLabel];
        self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.nameLabel.frame)+5, 70, 19)];
        self.moneyLabel.textColor = IWColor(247, 106, 37);
        self.moneyLabel.text = self.passPrice;
        self.ycMoneyNumber = self.passPrice;
        self.moneyLabel.backgroundColor = [UIColor clearColor];
        self.moneyLabel.font = [UIFont systemFontOfSize:19];
        [self.oneSectionView addSubview:self.moneyLabel];
        UIButton *explainButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        explainButton.frame = CGRectMake(CGRectGetMaxX(self.moneyLabel.frame), CGRectGetMaxY(self.nameLabel.frame)+5, 50, 19);
        explainButton.backgroundColor = [UIColor clearColor];
        [explainButton setTitle:@"票型说明>" forState:(UIControlStateNormal)];
        [explainButton setTitleColor:IWColor(170, 170, 170) forState:(UIControlStateNormal)];
        explainButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [explainButton addTarget:self action:@selector(explainButton:) forControlEvents:(UIControlEventTouchUpInside)];
        explainButton.titleLabel.textAlignment = 0;
        [self.oneSectionView addSubview:explainButton];
        
        UIView *wireView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, RRPWidth, 1)];
        wireView.backgroundColor = IWColor(240, 240, 240);
        [self.oneSectionView addSubview:wireView];
        
        return self.oneSectionView;
    }else if (section == 1) {

        [self getTodayAndTomorrowDate];
        self.twoSectionView = [[UIView alloc] init];
        self.twoSectionView.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 14, 104, 15)];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.textColor = IWColor(98, 98, 98);
        self.timeLabel.text = @"出行日期:";
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.timeLabel.adjustsFontSizeToFitWidth = YES;
        self.timeLabel.font = [UIFont systemFontOfSize:15];
        [self.twoSectionView addSubview:self.timeLabel];
              //底层View
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(RRPWidth - 182.5, 0, 182.5, 44)];
        backView.backgroundColor = [UIColor whiteColor];
        backView.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
        [self.twoSectionView addSubview:backView];
        
        self.todayButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.todayButton.frame = CGRectMake(0, 6, 50, 32);
        self.todayButton.layer.borderWidth = 1;
        self.todayButton.layer.borderColor = IWColor(240, 240, 240).CGColor;
        self.todayButton.layer.masksToBounds = YES;
        self.todayButton.layer.cornerRadius = 1;
        self.todayButton.backgroundColor = [UIColor whiteColor];
        [self.todayButton addTarget:self action:@selector(todayButton:) forControlEvents:(UIControlEventTouchUpInside)];
        self.todayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 16)];
        self.todayLabel.text = @"今天";
        self.todayLabel.textAlignment = 1;
        self.todayLabel.textColor = IWColor(98, 98, 98);
        self.todayLabel.font = [UIFont systemFontOfSize:10];
        [self.todayButton addSubview:self.todayLabel];
        self.todayTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, 50, 16)];
        self.todayTimeLabel.text = @"99-99";
        self.todayTimeLabel.adjustsFontSizeToFitWidth = YES;
        self.todayTimeLabel.textAlignment = 1;
        self.todayTimeLabel.textColor = IWColor(98, 98, 98);
        self.todayTimeLabel.font = [UIFont systemFontOfSize:10];
        [self.todayButton addSubview:self.todayTimeLabel];
        [backView addSubview:self.todayButton];
        
        self.tomorrowButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.tomorrowButton.frame = CGRectMake(CGRectGetMaxX(self.todayButton.frame)+7, 6, 50, 32);
        self.tomorrowButton.layer.borderWidth = 1;
        self.tomorrowButton.layer.borderColor = IWColor(240, 240, 240).CGColor;
        self.tomorrowButton.layer.masksToBounds = YES;
        self.tomorrowButton.layer.cornerRadius = 1;
        self.tomorrowButton.backgroundColor = [UIColor whiteColor];
        [self.tomorrowButton addTarget:self action:@selector(tomorrowButton:) forControlEvents:(UIControlEventTouchUpInside)];
        self.tomorrowLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 16)];
        self.tomorrowLabel.text = @"明天";
        self.tomorrowLabel.textAlignment = 1;
        self.tomorrowLabel.textColor = IWColor(98, 98, 98);
        self.tomorrowLabel.font = [UIFont systemFontOfSize:10];
        [self.tomorrowButton addSubview:self.tomorrowLabel];
        self.tomorrowTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, 50, 16)];
        self.tomorrowTimeLabel.text = @"99-99";
        self.tomorrowTimeLabel.adjustsFontSizeToFitWidth = YES;
        self.tomorrowTimeLabel.textAlignment = 1;
        self.tomorrowTimeLabel.textColor = IWColor(98, 98, 98);
        self.tomorrowTimeLabel.font = [UIFont systemFontOfSize:10];
        [self.tomorrowButton addSubview:self.tomorrowTimeLabel];
        [backView addSubview:self.tomorrowButton];
        
        self.moreButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.moreButton.frame = CGRectMake(CGRectGetMaxX(self.tomorrowButton.frame)+7, 6, 50, 32);
        self.moreButton.layer.borderWidth = 1;
        self.moreButton.layer.borderColor = IWColor(240, 240, 240).CGColor;
        self.moreButton.layer.masksToBounds = YES;
        self.moreButton.layer.cornerRadius = 1;
        self.moreButton.backgroundColor = [UIColor whiteColor];
        [self.moreButton addTarget:self action:@selector(moreButton:) forControlEvents:(UIControlEventTouchUpInside)];
        UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 16)];
        moreLabel.text = @"更多";
        moreLabel.textAlignment = 1;
        moreLabel.textColor = IWColor(98, 98, 98);
        moreLabel.font = [UIFont systemFontOfSize:10];
        [self.moreButton addSubview:moreLabel];
        UILabel *moreTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, 50, 16)];
        moreTimeLabel.text = @"日期";
        moreTimeLabel.textAlignment = 1;
        moreTimeLabel.textColor = IWColor(98, 98, 98);
        moreTimeLabel.font = [UIFont systemFontOfSize:10];
        [self.moreButton addSubview:moreTimeLabel];
        [backView addSubview:self.moreButton];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.moreButton.frame)+2, 15, 15, 15)];
        imageView.image = [UIImage imageNamed:@"home-middleList-more"];
        [backView addSubview:imageView];
        
        UIView *wireView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, RRPWidth, 1)];
        wireView.backgroundColor = IWColor(240, 240, 240);
        [self.twoSectionView addSubview:wireView];
        NSMutableDictionary *todayDic = [NSMutableDictionary dictionary];
        if (self.dateArray.count == 0) {
            self.todayTimeLabel.text = @"无票";
            self.tomorrowTimeLabel.text = @"无票";
        }else
        {
            todayDic =[RRPAllCityHandle shareAllCityHandle].dateArray[0];
            NSMutableDictionary *tomorrowDic = [RRPAllCityHandle shareAllCityHandle].dateArray[1];
            if ([todayDic[@"date"] isEqualToString:self.todayStr]) {
                self.todayTimeLabel.text = [NSString stringWithFormat:@"%@",todayDic[@"price"]];
                if ([tomorrowDic[@"date"] isEqualToString:self.tomorrowStr]) {
                    self.tomorrowTimeLabel.text = [NSString stringWithFormat:@"%@",tomorrowDic[@"price"]];
                }else
                {
                    self.tomorrowTimeLabel.text = @"无票";
                }
            }else{
                self.todayTimeLabel.text = @"无票";
                if ([todayDic[@"date"] isEqualToString:self.tomorrowStr]) {
                    self.tomorrowTimeLabel.text = [NSString stringWithFormat:@"%@",tomorrowDic[@"price"]];
                }else
                {
                    self.tomorrowTimeLabel.text = @"无票";
                }
            }
        }
        self.bottomPriceStr = self.tomorrowTimeLabel.text;
        return self.twoSectionView;
    }else if(section == 2){
        self.threeSectionView = [[UIView alloc] init];
        self.threeSectionView.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 14, 30, 15)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = IWColor(98, 98, 98);
        nameLabel.text = @"数量";
        nameLabel.font = [UIFont systemFontOfSize:15];
        [self.threeSectionView addSubview:nameLabel];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(RRPWidth - 105, 7, 100, 30)];
        imageView.image = [UIImage imageNamed:@"形状-2"];
        imageView.userInteractionEnabled = YES;
        [self.threeSectionView addSubview:imageView];
        self.minusButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.minusButton.frame = CGRectMake(2, 2, 31, 26);
        [self.minusButton addTarget:self action:@selector(minusButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [imageView addSubview:self.minusButton];
        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.minusButton.frame)+2, 2, 30, 26)];
        self.numberLabel.backgroundColor = [UIColor whiteColor];
        self.numberLabel.text = @"1";
        self.numberLabel.textAlignment = 1;
        self.numberLabel.font = [UIFont systemFontOfSize:15];
        self.numberLabel.textColor = IWColor(73, 73, 73);
        [imageView addSubview:self.numberLabel];

        if ([self.numberLabel.text isEqualToString:@"1"]) {
            [self.minusButton setBackgroundImage:[UIImage imageNamed:@"min1"] forState:(UIControlStateNormal)];
        }else {
            [self.minusButton setBackgroundImage:[UIImage imageNamed:@"min2"] forState:(UIControlStateNormal)];
        }
        
        
        self.addButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.addButton.frame = CGRectMake(CGRectGetMaxX(self.numberLabel.frame)+2, 2, 31, 26);
        [self.addButton setBackgroundImage:[UIImage imageNamed:@"add"] forState:(UIControlStateNormal)];
        [self.addButton addTarget:self action:@selector(addButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [imageView addSubview:self.addButton];
        
        UIView *wireView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, RRPWidth, 1)];
        wireView.backgroundColor = IWColor(240, 240, 240);
        [self.threeSectionView addSubview:wireView];
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(wireView.frame), RRPWidth, 10)];
        baseView.backgroundColor = IWColor(242, 245, 247);
        [self.threeSectionView addSubview:baseView];
        return self.threeSectionView;
    }else
    {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
}
//赋值
- (void)setValue
{
    self.bottomPriceStr = self.passPrice;
    self.moneyNumberLabel.text = self.bottomPriceStr;
    
}

//cell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3 && indexPath.row == 0) {
        RRPContactController *contact = [[RRPContactController alloc] init];
        contact.personCount = [NSString stringWithFormat:@"%ld",self.ticketCount];
        contact.delegate = self;
        //统计:取票人更多点击
        [MobClick event:@"25"];
        [self.navigationController pushViewController:contact animated:YES];
    }
}
//实现代理方法
- (void)passValueWithArray:(NSMutableArray *)contactShowArray
{
    self.contactShowArr = contactShowArray;
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
    [self.tableView reloadSections:indexSet withRowAnimation:(UITableViewRowAnimationAutomatic)];
}
//票型说明点击方法
- (void)explainButton:(UIButton *)sender {
    [self popTickrtOrderView];
  
}
#pragma mark - 弹出订购页面
- (void)popTickrtOrderView
{
   self.navigationController.navigationBar.hidden = YES;
   [self.orderView removeFromSuperview];
   self.orderView = [[RRPOrderView alloc] initWithFrame:CGRectMake(0,0, RRPWidth, RRPHeight)];
    self.orderView.backView.hidden = YES;
    self.orderView.orderModel = [RRPAllCityHandle shareAllCityHandle].orderModel;
    [self.view addSubview:self.orderView];
    
}
//显示导航栏
- (void)showNavigationBar:(NSNotification *)notification
{
    self.navigationController.navigationBar.hidden = NO;
    //之前移除导航栏 响应者链被破坏 重新显示导航栏的时候需要重新加载页面 才能恢复响应者链
    [self.view addSubview:self.tableView];
    [self tabBarControl];
    [self setValue];
    self.moneyNumberLabel.text  = self.moneyLabel.text;
    
}

//选择今天
- (void)todayButton:(UIButton *) sender {
    
    //自己需要改变的
    self.todayButton.layer.borderColor = IWColor(37, 171, 61).CGColor;
    self.todayButton.backgroundColor = IWColor(230, 255, 237);
    self.todayLabel.textColor = IWColor(37, 171, 61);
    self.todayTimeLabel.textColor = IWColor(37, 171, 61);
    //其他控件需要改变的
    self.tomorrowButton.layer.borderColor = IWColor(240, 240, 240).CGColor;
    self.tomorrowButton.backgroundColor = [UIColor whiteColor];
    self.tomorrowLabel.textColor = IWColor(98, 98, 98);
    self.tomorrowTimeLabel.textColor = IWColor(98, 98, 98);
    self.timeLabel.text = [NSString stringWithFormat:@"出行日期:%@",self.todayStr];
    self.moneyNumberLabel.text = self.todayTimeLabel.text;
    self.ycMoneyNumber = self.todayTimeLabel.text;
    self.moneyLabel.text = self.todayTimeLabel.text;
    self.numberLabel.text = @"1";
    [self.minusButton setBackgroundImage:[UIImage imageNamed:@"min1"] forState:(UIControlStateNormal)];
    
    //统计:日期选择
    NSDictionary *dict = @{@"date":self.todayTimeLabel.text};
    [MobClick event:@"24" attributes:dict];

}
//选择明天
- (void)tomorrowButton:(UIButton *)sender {
    
    //其他控件需要改变的
    self.todayButton.layer.borderColor = IWColor(240, 240, 240).CGColor;
    self.todayButton.backgroundColor = [UIColor whiteColor];
    self.todayLabel.textColor = IWColor(98, 98, 98);
    self.todayTimeLabel.textColor = IWColor(98, 98, 98);
    //自己需要改变的
    self.tomorrowButton.layer.borderColor = IWColor(37, 171, 61).CGColor;
    self.tomorrowButton.backgroundColor = IWColor(230, 255, 237);
    self.tomorrowLabel.textColor = IWColor(37, 171, 61);
    self.tomorrowTimeLabel.textColor = IWColor(37, 171, 61);
    
    self.timeLabel.text = [NSString stringWithFormat:@"出行日期:%@",self.tomorrowStr];
    
//    self.travelDateStr = self.tomorrowStr;
    self.moneyNumberLabel.text = self.tomorrowTimeLabel.text;
    self.moneyLabel.text = self.tomorrowTimeLabel.text;
    self.ycMoneyNumber = self.tomorrowTimeLabel.text;
    self.numberLabel.text = @"1";
    [self.minusButton setBackgroundImage:[UIImage imageNamed:@"min1"] forState:(UIControlStateNormal)];
    //统计:日期选择
    NSDictionary *dict = @{@"date":self.tomorrowTimeLabel.text};
    [MobClick event:@"24" attributes:dict];

}
//选择更多
- (void)moreButton:(UIButton *) sender {
    
    //其他控件需要改变的
    self.todayButton.layer.borderColor = IWColor(240, 240, 240).CGColor;
    self.todayButton.backgroundColor = [UIColor whiteColor];
    self.todayLabel.textColor = IWColor(98, 98, 98);
    self.todayTimeLabel.textColor = IWColor(98, 98, 98);
    self.tomorrowButton.layer.borderColor = IWColor(240, 240, 240).CGColor;
    self.tomorrowButton.backgroundColor = [UIColor whiteColor];
    self.tomorrowLabel.textColor = IWColor(98, 98, 98);
    self.tomorrowTimeLabel.textColor = IWColor(98, 98, 98);
    
    //跳转
    RMCalendarController *calendar = [RMCalendarController calendarWithDays:90 showType:CalendarShowTypeMultiple];
    //组建日历需要数组
    for (NSMutableDictionary *dic in self.dateArray) {
        //年
        self.year = [dic[@"date"] substringWithRange:NSMakeRange(0, 4)];
        //月
        NSString *monthStr = [dic[@"date"] substringWithRange:NSMakeRange(5, 1)];
        if ([monthStr isEqualToString:@"0"]) {
            self.month = [dic[@"date"] substringWithRange:NSMakeRange(6, 1)];
        }else
        {
           self.month = [dic[@"date"] substringWithRange:NSMakeRange(5, 2)];
        }
        //日
        NSString *dayStr = [dic[@"date"] substringWithRange:NSMakeRange(8, 1)];
        if ([dayStr isEqualToString:@"0"]) {
            self.day = [dic[@"date"] substringWithRange:NSMakeRange(9, 1)];
        }else
        {
            self.day = [dic[@"date"] substringWithRange:NSMakeRange(8, 2)];
        }
        //价格
        self.price = [NSString stringWithFormat:@"%@",dic[@"price"]];
        self.datePriceDic = [[NSMutableDictionary alloc] init];
        [self.datePriceDic setValue:self.month forKey:@"month"];
        [self.datePriceDic setValue:self.day forKey:@"day"];
        [self.datePriceDic setValue:self.year forKey:@"year"];
        [self.datePriceDic setValue:@"1" forKey:@"ticketCount"];
        [self.datePriceDic setValue:self.price forKey:@"ticketPrice"];
        [self.canlenderArray addObject:self.datePriceDic];
    }
    // 此处用到MJ大神开发的框架，根据自己需求调整是否需要
    calendar.modelArr = [TicketModel objectArrayWithKeyValuesArray:self.canlenderArray]; //最后一条数据ticketCount 为0时不显示
    calendar.isEnable = YES;
    calendar.title = @"日期选择";
    calendar.calendarBlock = ^(RMCalendarModel *model) {
        if (model.ticketModel) {
//            NSLog(@"%lu-%lu-%lu-票价%.1f",(unsigned long)model.year,(unsigned long)model.month,(unsigned long)model.day, model.ticketModel.ticketPrice);
            self.moneyNumberLabel.text = [NSString stringWithFormat:@"%.2f",model.ticketModel.ticketPrice];
            self.ycMoneyNumber = [NSString stringWithFormat:@"%.2f",model.ticketModel.ticketPrice];
            self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",model.ticketModel.ticketPrice];
//            self.travelDateStr = [NSString stringWithFormat:@"%ld-%lu-%lu",(unsigned long)model.year,(unsigned long)model.month,(unsigned long)model.day];
            
            self.timeLabel.text = [NSString stringWithFormat:@"出行日期:%ld-%ld-%ld",model.year,model.month,model.day];
//            [self.tableView reloadData];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
//            NSLog(@"%lu-%lu-%lu",(unsigned long)model.year,(unsigned long)model.month,(unsigned long)model.day);
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    [self.navigationController pushViewController:calendar animated:YES];
    self.numberLabel.text = @"1";
    [self.minusButton setBackgroundImage:[UIImage imageNamed:@"min1"] forState:(UIControlStateNormal)];
    
    //统计:日期选择
    NSDictionary *dict = @{@"date":self.timeLabel.text};
    [MobClick event:@"24" attributes:dict];

}
//减数量
- (void)minusButton:(UIButton *) sender {
    if ([self.numberLabel.text integerValue] > 1) {
        self.numberLabel.text = [NSString stringWithFormat:@"%ld",[self.numberLabel.text integerValue]-1];
        if ([self.numberLabel.text integerValue] == 1) {
            [self.minusButton setBackgroundImage:[UIImage imageNamed:@"min1"] forState:(UIControlStateNormal)];
        }
        
        self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",[self.ycMoneyNumber floatValue]*[self.numberLabel.text integerValue]];
        self.moneyNumberLabel.text = [NSString stringWithFormat:@"%.2f",[self.ycMoneyNumber floatValue]*[self.numberLabel.text integerValue]];
        
        self.ticketCount = [self.numberLabel.text integerValue];
    }
}
//加数量
- (void)addButton:(UIButton *) sender {
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",[self.numberLabel.text integerValue]+1];
    [self.minusButton setBackgroundImage:[UIImage imageNamed:@"min2"] forState:(UIControlStateNormal)];
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",[self.ycMoneyNumber floatValue]*[self.numberLabel.text integerValue]];
    self.moneyNumberLabel.text = [NSString stringWithFormat:@"%.2f",[self.ycMoneyNumber floatValue]*[self.numberLabel.text integerValue]];
    self.ticketCount = [self.numberLabel.text integerValue];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
//    [RRPAllCityHandle shareAllCityHandle].topPrice = self.moneyNumberLabel.text;

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
