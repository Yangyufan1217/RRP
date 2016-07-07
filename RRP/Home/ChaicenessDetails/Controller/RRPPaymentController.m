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
//微信支付
#import "getIPhoneIP.h"
#import "DataMD5.h"
#import <CommonCrypto/CommonDigest.h>
#import "XMLDictionary.h"
//支付宝支付
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

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
    self.type = 0;
    
    
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
        [self AliPay];
        //统计:支付方式点击
        NSDictionary *dict = @{@"paytype":@"支付宝"};
        [MobClick event:@"29" attributes:dict];
//        NSLog(@"支付宝");
    }else if (self.number == 2) {
        
        [self WeiChatPay];
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

#pragma mark - 微信支付
//************************微信支付*****************************//
// 生成15位随机订单号
- (NSString *)generateTradeNumber {
    static int kNumber = 15;
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++) {
        unsigned index = rand() % [sourceStr length];
        NSString *oneChar = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneChar];
    }
    return resultStr;
}

// 将订单号使用md5加密
- (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16]= "0123456789abcdef";
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
- (void)WeiChatPay
{
    NSString *appid, *mch_id, *nonce_str, *out_trade_no, *body, *total_fee, *spbill_create_ip, *notify_url, *trade_type, *partner, *sign;
    
    // 1.微信分配的公众账号APPID
    appid = @"wxe6dd197ef305900d";
    
    // 2.微信支付分配的商户号
    mch_id = @"1343768401";
    
    // 产生随机字符串，这里最好使用和安卓端一致的生成逻辑
    NSString *num =[self generateTradeNumber];
    nonce_str = num;
    
    // 3.随机产生订单号用于测试，正式使用请换成你从自己服务器获取的订单号
    out_trade_no = self.orderno;
    
    // 4.订单描述
    //    body = @"这里用作订单描述";
    body = @"人人票支付";
    
    //    [[NSUserDefaults standardUserDefaults] setObject:num forKey:@"trade_no"];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 5.交易价格赋值1表示0.01元，赋值10表示0.1元(一定要输入整数)
    //    CGFloat totalFee = [self.order.count floatValue];
    //    total_fee = [NSString stringWithFormat:@"%.f", totalFee * 100];
    //    NSLog(@"微信支付金额：totalFee = %.f    total_fee = %@", totalFee, total_fee);
    total_fee = @"1";
    
    // 6.获取本机IP地址，请在WIFI环境下测试，否则获取的ip地址为error，正确格式应该是8.8.8.8
    spbill_create_ip = [getIPhoneIP getIPAddress];
    
    // 7.交易结果通知网站，此处用于测试，随意填写，正式使用时填写正确网站 (接收微信支付异步通知回调地址)
    notify_url = @"www.baidu.com";
    
    // 8.交易类型 JSAPI--公众号支付、NATIVE--原生扫码支付、APP--app支付、WAP--手机浏览器H5支付
    trade_type = @"APP";
    
    // 9.商户密钥
    partner = @"e48da717d690e3037e239a91d73fe4f5";
    
    // 10.获取sign签名
    DataMD5 *data = [[DataMD5 alloc] initWithAppid:appid body:body mch_id:mch_id nonce_str:nonce_str notify_url:notify_url out_trade_no:out_trade_no partner_id:partner spbill_create_ip:spbill_create_ip total_fee:total_fee trade_type:trade_type];
    sign = [data getSignForMD5];
    
    // 设置参数并转化成xml格式
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:appid forKey:@"appid"]; // 公众账号ID
    [dic setValue:mch_id forKey:@"mch_id"]; // 商户号
    [dic setValue:nonce_str forKey:@"nonce_str"]; // 随机字符串
    [dic setValue:sign forKey:@"sign"]; // 签名
    [dic setValue:body forKey:@"body"]; // 商品描述
    [dic setValue:out_trade_no forKey:@"out_trade_no"]; // 订单号
    [dic setValue:total_fee forKey:@"total_fee"]; // 金额
    [dic setValue:spbill_create_ip forKey:@"spbill_create_ip"]; // 终端IP
    [dic setValue:notify_url forKey:@"notify_url"]; // 通知地址
    [dic setValue:trade_type forKey:@"trade_type"]; // 交易类型
    
    NSString *string = [dic XMLString];
    [self payRequest:string];
    
}
- (void)payRequest:(NSString *)xml {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 这里传入的xml字符串只是形似xml，但是不是正确是xml格式，需要使用AF方法进行转义
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"https://api.mch.weixin.qq.com/pay/unifiedorder" forHTTPHeaderField:@"SOAPAction"];
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return xml;
    }];
    // 发起请求 先调用该接口生成预支付交易单，返回正确的预支付交易回话标识后再按扫码、JSAPI、APP等不同场景生成交易串调起支付。
    [manager POST:@"https://api.mch.weixin.qq.com/pay/unifiedorder" parameters:xml success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"responseString is %@",responseString);
        // 将微信返回的xml数据解析转义成字典
        NSDictionary *dic = [NSDictionary dictionaryWithXMLString:responseString];
        NSLog(@"%@",dic);
        // 判断返回的许可
        if ([[dic objectForKey:@"result_code"] isEqualToString:@"SUCCESS"] && [[dic objectForKey:@"return_code"] isEqualToString:@"SUCCESS"] ) {
            // 发起微信支付，设置参数
            PayReq *request = [[PayReq alloc] init];
            request.partnerId = [dic objectForKey:@"mch_id"];
            request.prepayId = [dic objectForKey:@"prepay_id"];
            request.package = @"Sign=WXPay";
            request.nonceStr = [dic objectForKey:@"nonce_str"];
            // 将当前事件转化成时间戳
            NSDate *datenow = [NSDate date];
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
            UInt32 timeStamp = [timeSp intValue];
            request.timeStamp = timeStamp;
            NSLog(@"%u",(unsigned int)timeStamp);
            DataMD5 *md5 = [[DataMD5 alloc] init];
            request.sign = [md5 createMD5SingForPay:@"wxe6dd197ef305900d" partnerid:request.partnerId prepayid:request.prepayId package:request.package noncestr:request.nonceStr timestamp:request.timeStamp];
            NSLog(@"%@",request.sign);
            // 调用微信 (函数调用后，会切换到微信的界面。第三方应用程序等待微信返回onResp。微信在异步处理完成后一定会调用onResp。)
            [WXApi sendReq:request];
        } else {
            NSLog(@"参数不正确，请检查参数!");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error is %@", error);
    }];
}

//************************微信支付*****************************//
#pragma mark - 支付宝支付
- (void) AliPay
{
    NSLog(@"支付宝支付");
    NSString *partner = @"2088121612028197";
    NSString *seller = @"pay@renrenpiao.com";
    NSString *privateKey =@"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAOW5Kpwezod63hL4i09iRjolXIVCVuBGvsrKrUzKvkLq/oCWnsEeLnMrpBZjwSXdKnfsbcvDnTKIczhwY0JUAYmRf/O7qKnj5ySFltPzZPkCJKe977X8wKornU/oOrfCU1FIq5oW93XhiLZ/V+LfEfSdLYJsOzVOoWcxANjT/yBNAgMBAAECgYAq3oErHTyhX7Zth+BHcil01GANpjGcLNeR9Hyepf8Xcc8IpBMAKue0KmK2our6a+lu87oRmnGNapVF5QNA73hRn0iZtNfzQLq0MiDc2atowzo8cr3FlvU5knSxx2zaeFFnlQhaS1xl3N8WCdGdK5U7GTS31x8FKjW3ruKQuQHjwQJBAPNCv/6Pe7A5+bncOE0k+LYG9TzOS9YhFPpyEK7fveZ8obF/YrEhyqa9iPx/cFISTwDV00L2bNwxeP3KpUIgGCkCQQDxwO2grgGEugAI9EbHhtOSraIoKhLZPbwh7L0bfi+hOzQ/zai6+Nnhun8rW0CqVkqsIRJB3eqf12vSdUySXFuFAkEAoUoHvMPr0buO7YGrPtMdqKtSXN+3fqFupGOO1jP5WGIYX3TDvghWslmHA0uH8JK9GSOtMH/tS83tl/CNxBs9iQJBAM5wzXrUnH9WxgjfcEGaJLmwhDSAGTBhw3HE04fSraGlCO0jFd7z+jsEIuxHNGVA4usyIoEUm/J65pwFhqnFLHECQC5s/iB42K3Wx6xLhdv5u8OAFSj6Jv9XLX3WhEAjRRPN6l7UZvn4O2xALhS2MXUhLe4+wd5bSPr9OgzugnVYQsA=";
    
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.sellerID = seller;
    
    order.outTradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.subject = @"测试"; //商品标题
    order.body = @"啦啦啦"; //商品描述
    order.totalFee = [NSString stringWithFormat:@"%.2f",0.01]; //商品价格
    
    order.notifyURL =  @"http://www.xxx.com"; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showURL = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkdemo";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }

}
//随机产生订单号
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

/*************************支付宝支付****************************/



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
