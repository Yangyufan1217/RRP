//
//  PaymentController.m
//  RRP
//
//  Created by sks on 16/4/24.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "PaymentController.h"
#import "LLPaySdk.h"
#import "LLPayUtil.h"
#import "RRPPaymentController.h"


// TODO: 修改两个参数成商户自己的配置
static NSString *kLLOidPartner = @"201603081000754511";// 商户号
static NSString *kLLPartnerKey = @"201603081000754511_test_20160425";// 密钥
NSString *kAPMerchantID = @"merchant.RRP";

@interface PaymentController ()<LLPaySdkDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *orderParam;
@property (nonatomic, strong) LLAPPaySDK *paySdk;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *Dic_sign;


@end

@implementation PaymentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付详情";
    self.view.backgroundColor = [UIColor whiteColor];
    LLPayUtil *payUtil = [[LLPayUtil alloc] init];
    self.orderParam = [self createOrder];
    // 进行签名
    NSDictionary *signedOrder = [payUtil signedOrderDic:self.orderParam
                                             andSignKey:kLLPartnerKey];
    [LLAPPaySDK sharedSdk].sdkDelegate = self;
    self.paySdk = [[LLAPPaySDK alloc] init]; // 创建
    //Apple pay支付
    [[LLAPPaySDK sharedSdk] payWithTraderInfo:signedOrder
                             inViewController:self];
}


- (NSMutableDictionary*)createOrder{
    NSString *signType = @"MD5";    // MD5 || RSA || HMAC
    NSString *user_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
    // user_id，一个user_id标示一个用户
    // user_id为必传项，需要关联商户里的用户编号，一个user_id下的所有支付银行卡，身份证必须相同
    // demo中需要开发测试自己填入user_id, 可以先用自己的手机号作为标示，正式上线请使用商户内的用户编号
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyyMMddHHmmss"];
    NSString *simOrder = [dateFormater stringFromDate:[NSDate date]];
    // TODO: 请开发人员修改下面订单的所有信息，以匹配实际需求
    [param setDictionary:@{
                           @"sign_type":signType,
                           //签名方式	partner_sign_type	是	String	RSA  或者 MD5
                           @"busi_partner":@"101001",
                           //商户业务类型	busi_partner	是	String(6)	虚拟商品销售：101001
                           @"dt_order":simOrder,
                           //商户订单时间	dt_order	是	String(14)	格式：YYYYMMDDH24MISS  14位数字，精确到秒
                           //交易金额	money_order	是	Number(8,2)	该笔订单的资金总额，单位为RMB-元。大于0的数字，精确到小数点后两位。 如：49.65
#warning 测试请将价格改为0.01,土豪可不用修改
                           @"money_order" : self.money,
                           @"no_order":self.orderno,
                           //商户唯一订单号	no_order	是	String(32)	商户系统唯一订单号
                           @"name_goods":self.name,
                           //商品名称	name_goods	否	String(40)
                           @"info_order":@"来自人人票购票应用",
                           //订单附加信息	info_order	否	String(255)	商户订单的备注信息
                           @"valid_order":@"10080",
                           //分钟为单位，默认为10080分钟（7天），从创建时间开始，过了此订单有效时间此笔订单就会被设置为失败状态不能再重新进行支付。
                           @"notify_url":@"http://payhttp.xiaofubao.com/back.shtml",
                           //服务器异步通知地址	notify_url	是	String(64)	连连钱包支付平台在用户支付成功后通知商户服务端的地址，如：http://payhttp.xiaofubao.com/back.shtml
                           //风险控制参数 否 此字段填写风控参数，采用json串的模式传入，字段名和字段内容彼此对应好
                           @"risk_item" : [LLPayUtil jsonStringOfObj:@{@"user_info_dt_register":@"20131030122130"}],
                           @"user_id": user_id,
                           //商户用户唯一编号 否 该用户在商户系统中的唯一编号，要求是该编号在商户系统中唯一标识该用户
                           }];
    param[@"oid_partner"] = kLLOidPartner;
    param[@"ap_merchant_id"] = kAPMerchantID;
    return param;
}

#pragma -mark 支付结果 LLPaySdkDelegate
// 订单支付结果返回，主要是异常和成功的不同状态
// TODO: 开发人员需要根据实际业务调整逻辑
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic
{
    NSString *msg = @"支付异常";
    switch (resultCode) {
        case kLLPayResultSuccess:
        {
            msg = @"支付成功";
            //统计:支付成功
            [MobClick event:@"30"];
            NSString* result_pay = dic[@"result_pay"];
            if ([result_pay isEqualToString:@"SUCCESS"])
            {
                
                //
                //NSString *payBackAgreeNo = dic[@"agreementno"];
                // TODO: 协议号
            }
            else if ([result_pay isEqualToString:@"PROCESSING"])
            {
                msg = @"支付单处理中";
            }
            else if ([result_pay isEqualToString:@"FAILURE"])
            {
                msg = @"支付单失败";
            }
            else if ([result_pay isEqualToString:@"REFUND"])
            {
                msg = @"支付单已退款";
            }
        }
            break;
        case kLLPayResultFail:
        {
            msg = @"支付失败";
            //统计:支付失败
            [MobClick event:@"31"];
        }
            break;
        case kLLPayResultCancel:
        {
            msg = @"支付取消";
            //统计:支付取消
            [MobClick event:@"32"];
        }
            break;
        case kLLPayResultInitError:
        {
            msg = @"sdk初始化异常";
        }
            break;
        case kLLPayResultInitParamError:
        {
            msg = dic[@"ret_msg"];
        }
            break;
        default:
            break;
    }
    self.Dic_sign = dic[@"sign"];
    self.msg = msg;
    [[[UIAlertView alloc] initWithTitle:@"支付结果"
                                message:self.msg
                               delegate:self
                      cancelButtonTitle:@"确认"
                      otherButtonTitles:nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([self.msg isEqualToString:@"支付成功"]) {
        [self downLoadData];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/**
 *  orderno 订单号 memberid用户ID ticketid票ID busi_partner商户业务类型 sign_type签名方式 sign签名 oid_partner商户编号 dt_refund商户订单时间
 money_order交易金额 no_refund退款流水号 no_order商户订单号 notify_url异步通知地址 risk_item风控指数 user_id用户ID
 *
 */
- (void)downLoadData {
    NSString *user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"pay_success" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.orderParam[@"no_order"] forKey:@"orderno"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:user_id forKey:@"memberid"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:[RRPAllCityHandle shareAllCityHandle].ticketid forKey:@"ticketid"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.orderParam[@"busi_partner"] forKey:@"busi_partner"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.orderParam[@"sign_type"] forKey:@"sign_type"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.Dic_sign forKey:@"sign"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:kLLOidPartner forKey:@"oid_partner"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.orderParam[@"dt_order"] forKey:@"dt_refund"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.orderParam[@"money_order"] forKey:@"money_order"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:[NSString stringWithFormat:@"RRP%@",self.orderParam[@"no_order"]] forKey:@"no_refund"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.orderParam[@"no_order"] forKey:@"no_order"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.orderParam[@"notify_url"] forKey:@"notify_url"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.orderParam[@"risk_item"] forKey:@"risk_item"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.orderParam[@"user_id"] forKey:@"user_id"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.dataDic forKey:@"data"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:OrderFinish parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary * nullDict = [RRPPrintObject nullDic:dict];
        NSInteger code = [nullDict[@"ResponseBody"][@"code"] integerValue];
        if (code == 2000) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[MyAlertView sharedInstance]showFrom:@"订单提交失败"];
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}











@end
