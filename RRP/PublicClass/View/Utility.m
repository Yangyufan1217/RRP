//
//  Utility.m
//  KMovie
//
//  Created by PP－mac001 on 15/7/14.
//  Copyright (c) 2015年 PP－mac001. All rights reserved.
//

#import "Utility.h"
//引入IOS自带密码库
#import <CommonCrypto/CommonCrypto.h>
#import <MJExtension.h>
#import <FMDatabase.h>
#import "UIImage+ResizeMagick.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>
//#import "HXFindComModel.h"
#include <sys/types.h>
#include <sys/sysctl.h>
//空字符串
#define   LocalStr_None   @""

static NSDateFormatter* formatter = nil;
static CGRect oldframe;
static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@interface Utility()
@property(nonatomic, strong)NSMutableArray * dataArray;
@property(nonatomic, strong)NSMutableArray * addNumberArray;
@end
@implementation Utility
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)addNumberArray{
    if (!_addNumberArray) {
        _addNumberArray = [NSMutableArray array];
    }
    return _addNumberArray;
}

+ (Utility*)sharedInstance
{
    static Utility *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


#pragma 正则匹配手机号
+ (BOOL)checkUserTelNumber:(NSString *)telNumber;
{
    //    NSString *pattern = @"^1+[3578]+\d{9}";
    NSString * pattern = @"^(0|86|17951)?(916|13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}


#pragma mark 存储用户的uid
+ (void)setUid:(NSString *)uid
{
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getUid
{
    NSString * uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    return uid;
}

+(UIView*)createViewWithFrame:(CGRect)frame color:(UIColor*)color
{
    UIView*view=[[UIView alloc]initWithFrame:frame];
    if (color!=nil) {
        view.backgroundColor=color;
    }
    return view;
}
+(UILabel*)createLabelWithFrame:(CGRect)frame font:(float)font text:(NSString *)text
{
    UILabel*label=[[UILabel alloc]initWithFrame:frame];
    label.font=[UIFont systemFontOfSize:font];
    //设置折行方式
    label.lineBreakMode=NSLineBreakByCharWrapping;
    //设置折行行数
    label.numberOfLines=0;
    //设置文字
    label.text=text;
    //设置对齐方式
    label.textAlignment=NSTextAlignmentLeft;
    return label;
}
+(UIButton*)createButtonWithFrame:(CGRect)frame title:(NSString*)title imageName:(NSString*)imageName bgImageName:(NSString*)bgImageName target:(id)target method:(SEL)select
{
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=frame;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (imageName) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if (bgImageName) {
        [button setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    }
    [button addTarget:target action:select forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+(UIImageView*)createImageViewFrame:(CGRect)frame imageName:(NSString*)imageName
{
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:frame];
    if (imageName) {
        imageView.image=[UIImage imageNamed:imageName];
    }
    imageView.userInteractionEnabled=YES;
    return imageView;
}
+(UITextField*)createTextFieldFrame:(CGRect)frame placeholder:(NSString*)placeholder bgImageName:(NSString*)imageName leftView:(UIView*)leftView rightView:(UIView*)rightView isPassWord:(BOOL)isPassWord
{
    UITextField*textField=[[UITextField alloc]initWithFrame:frame];
    if (placeholder) {
        textField.placeholder=placeholder;
    }
    if (imageName) {
        textField.background=[UIImage imageNamed:imageName];
    }
    if (leftView) {
        textField.leftView=leftView;
        textField.leftViewMode=UITextFieldViewModeAlways;
    }
    if (rightView) {
        textField.rightView=rightView;
        textField.rightViewMode=UITextFieldViewModeAlways;
    }
    if (isPassWord) {
        textField.secureTextEntry=YES;
    }
    return textField;
}

- (NSURL *)getVideoContentURL:(NSString *)urlStr
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * fileName = [urlStr lastPathComponent];
    NSString * filePath = [self.videoPath stringByAppendingPathComponent:fileName];
//    NSLog(@"%@",filePath);
    if ([fileManager fileExistsAtPath:filePath]) {
        return [NSURL fileURLWithPath:filePath];
    } else {
        return [NSURL URLWithString:urlStr];
    }
}

#pragma mark 回复字段拼接

//+ (NSString *)commentString:(HXFindListMode *)commentsModel
//{
//    NSMutableString * mutableString = [NSMutableString string];
//    if (commentsModel.userb_nickname.length>0) {
////        NSString * nickName = commentsModel.nickname;
//        NSString * userb_nickname = commentsModel.userb_nickname;
////        [mutableString appendString:nickName];
//        [mutableString appendString:@"回复"];
//        [mutableString appendString:userb_nickname];
//        [mutableString appendString:@":  "];
//        [mutableString appendString:commentsModel.publish_comment_content];
//    }else{
//        [mutableString appendString:commentsModel.publish_comment_content];
//    }
//    return mutableString;
//}



- (void)addNumber:(NSNumber *)numbe{
    [self.addNumberArray addObject:numbe];
}

- (NSMutableArray *)getNumberArray{
    return self.addNumberArray;
}

/**
 *  获取uid tok 时间戳
 */
- (NSMutableDictionary *)getUserUidAndTokAndTimeStamp
{
    NSMutableDictionary * mutabelDict = [NSMutableDictionary dictionary];
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    NSString * uid = [NSString stringWithFormat:@"%@",[def objectForKey:@"uid"]];
    NSString * tok = [def objectForKey:@"token"];
    NSString * ts = [[Utility sharedInstance]getTimeStamp];
    
    [mutabelDict setValue:uid forKey:@"uid"];
    [mutabelDict setValue:tok forKey:@"tok"];
    [mutabelDict setValue:ts forKey:@"ts"];
    return mutabelDict;
}


/**
 *  图片合成
 *  @param resizedImage 大图
 *  @param shareImage   要分享出去的图片
 *  @param userIcon     用户的头像icon
 *  @param name         用户昵称
 */
- (UIImage *)synImage:(UIImage *)resizedImage andShareImage:(UIImage *)shareImage andUserIcon:(UIImage *)userIcon andUserName:(NSString *)name
{
    UIGraphicsBeginImageContextWithOptions(resizedImage.size, NO, 0);
    [resizedImage drawInRect:CGRectMake(0, 0, resizedImage.size.width, resizedImage.size.height)];
    //要分享出去的图片
    [shareImage drawInRect:CGRectMake(10*2, 10*2, 354*2, 354*2)];
    //用户头像
    [userIcon drawInRect:CGRectMake(24*2, 378*2, 45*2, 45*2)];
    //用户昵称
    [name drawAtPoint:CGPointMake(90*2, 378*2) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13*2],NSForegroundColorAttributeName:[UIColor blackColor]}];
    [@"向你分享了这张图片" drawAtPoint:CGPointMake(90*2,407*2) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11*2],NSForegroundColorAttributeName:[UIColor blackColor]}];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}


+ (NSMutableArray *)dictToModelClass:(Class)modelClass andArray:(NSArray *)array
{
    NSMutableArray * mutableArray = [NSMutableArray array];
    for (NSDictionary * dict in array)
    {
        [mutableArray addObject:[modelClass mj_objectWithKeyValues:dict]];
    }
    return mutableArray;
}

- (NSString *)returnContent:(NSInteger)code
{
    
    if (code == 4000)
    {
        return @"用户不存在,请注册或重新登录";
    }
    if (code == 4002)
    {
        return @"验证码发送失败,请重新点击发送";
    }
    if (code == 4003) {
        return @"手机号已被注册,请登录";
    }
    
    if (code == 4004) {
        return @"手机号尚未注册,请先注册";
    }
    if (code == 4005) {
        return @"注册失败,请重新注册";
    }
    if (code == 4006)
    {
        return @"此手机号不存在,请注册";
    }
    
    if (code == 4007)
    {
        return @"用户不存在，请注册";
    }
    
    if (code == 4008)
    {
        return @"手机号或密码有误,重新登录";
    }
    
    if (code == 4009)
    {
        return @"信息过期,请重新登录";
    }
    
    if (code == 4010)
    {
        return @"该用户已在其他设备登录";
    }
    
    if (code == 4011)
    {
        return @"验证码有误,请重新获取验证码";
    }
    
    if (code == 4012)
    {
        return @"更改密码失败";
    }
    
    if (code == 4013)
    {
        return @"更改手机号失败";
    }
    
    if (code == 4014) {
        return @"有敏感词,请检查内容";
    }
    
    if (code==4015) {
        return @"更新失败";
    }
    
    if (code == 4016) {
        return @"发送失败";
    }
    
    if (code == 4017)
    {
        return @"删除失败";
    }
    
    if (code == 4018) {
        return @"验证码发送超时";
    }
    
    if (code == 4020||code == 4109||code == 4110)
    {
        return @"用户无效,请重新登录";
    }
    
    if (code == 4111||code==4112||code == 4113) {
        return @"本地时间有误,请核实手机本地时间";
    }
    
    if (code == 4101||code ==4102||code==4103||code==4104||code ==4105||code==4106||code ==4107||code ==4108||code ==4114||code ==4115||code ==4116) {
        return @"出错了,请刷新或重新登录";
    }
    if (code == 5000)
    {
        return @"出错了,请联系客服MM";
    }
    
    if (code == -1009) {
        return @"似乎已断开与互联网的连接";
    }
    return nil;
    
}
/**
 *  @param code 后台返回的code
 *  返回登录页面
 */
- (BOOL)codeWithLogin:(NSInteger)code
{
    if (code==4000||code==4007||code==4009||code==4010||code==4020
        ||code==4109||code==4110||code==4111||code==4112||code==4113
        ||code==4114||code==4115||code==4116||code==4101||code==4102
        ||code==4103||code==4104||code==4105||code==4106||code==4107
        ||code==4108||code==5000)
    {
        return YES;
    }else
    {
        return NO;
    }
}

- (void)showAfnError:(NSError *)error
{
    NSString * info = error.userInfo[@"NSLocalizedDescription"];
//    UIWindow* w = [AppDelegate getDelegate].window;
    CGFloat x = (RRPWidth - 200)*0.5;
    CGFloat y = RRPHeight - 120;
    
    [[MyAlertView sharedInstance]showFrom:info andTextColor:[UIColor whiteColor] andFrame:CGRectMake(x, y, 200, 50)];

}

- (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}


- (void)endWeiboEditing:(UIView *)view
{
    [view removeFromSuperview];
    UIWindow * w = [AppDelegate getDelegate].window;
    [w endEditing:YES];
}



/**
 *  向后台传数据
 *
 *  @param nkn3   第三方用户昵称
 *  @param ID     第三方用户ID
 *  @param number  第三方类型 0 微信，1qq，2微博
 */
//- (void)postDataToServerNkns:(NSString *)nkn3 andIdent:(NSString *)ID andThirdPlat:(NSInteger)number
//{
//    
//    NSDictionary * dict = [[NSDictionary alloc]initWithObjectsAndKeys:nkn3,@"nkn3",ID,@"ideni3",number,@"ident3", nil];
//    [[NetWorkManager sharedHTTPManager]POST:hxUrl_SignInWithThirdParty parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
////        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        
//    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//        debugLog(@"%@",error);
//    }];
//}

- (void)postModileData:(NSDictionary *)userDict
{
    
}
/**
 *  视频在文件夹中是否下载完
 *
 */
-(BOOL)isCategoryActionsDownLoadFinished:(NSArray *)actions{
    
    if (!actions.count) {
        return NO;
    }
    
    //到缓存中查询这个课程的每一个视频是否都存在，如果都存在就是下载完了
    for (int i = 0; i<actions.count; i++) {
        NSString *urlString = actions[i];
        if([urlString isEqual:[NSNull null]])
        {
            continue;
        }
        if (0==urlString.length) {
            continue;
        }
        if (![[Utility sharedInstance] isVideoCached:urlString]) {
            return NO;
        }
       
    }
    return YES;
}


- (NSString *)getCdnUrl:(NSString *)url{
    
    if (NSNotFound == [url rangeOfString:@".aliyuncs.com"].location) {
        return url;
    }
    
    NSString *fileName = [url lastPathComponent];
    return [NSString stringWithFormat:@"http://resource.hotbody.cn/%@",fileName];
}


/**
 *  视频是否在缓存中
 */
- (BOOL)isVideoCached:(NSString *)url;
{
//    NSLog(@"=================%@",url);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [url lastPathComponent];
    return [fileManager fileExistsAtPath:[self.videoPath stringByAppendingPathComponent:fileName]];
}

- (NSString *)videoPath;
{
    if (!_videoPath)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        _videoPath = [self videoPathString];
        
        if (![fileManager fileExistsAtPath:_videoPath])
        {
            [fileManager createDirectoryAtPath:_videoPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
    return _videoPath;
}


/**
 *  获取当天凌晨的时间戳
 */
+ (NSInteger)getLingChenTimeStamp
{
    　　NSInteger year,month,day,hour,min,sec,week;
    　　NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    　　NSDate *now = [NSDate date];
    　　NSDateComponents *comps = [[NSDateComponents alloc] init];
    　　NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |     NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    　　comps = [calendar components:unitFlags fromDate:now];
    　 year = [comps year];
    　　week = [comps weekday];
    　　month = [comps month];
    　　day = [comps day];
    　　hour = [comps hour];
    　　min = [comps minute];
    　　sec = [comps second];
    　　NSString * dateString = @"";
    　　dateString = [NSString stringWithFormat:@"%ld-%ld-%ld 00:00:00",(long)year,(long)month,(long)day];
    //修改此处的 00:00:00 可以得到想要的时间 例如 12:00:00
    　　NSDateFormatter * dateFormat = [[NSDateFormatter alloc]init]; 　　[dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    　NSDate * date = [dateFormat dateFromString:dateString];

     　　NSLog(@"今天凌晨时间戳：%ld",[date timeIntervalSince1970]);
    　　return [date timeIntervalSince1970];
    
   
}


- (NSString *)tempPath
{
    if (!_tempPath)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *cacheDirectory = [[paths lastObject] stringByAppendingPathComponent:@"Caches"];
        
        _tempPath = [cacheDirectory stringByAppendingPathComponent:@"temp"];
        if (![fileManager fileExistsAtPath:_tempPath])
        {
            [fileManager createDirectoryAtPath:_tempPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
    return _tempPath;
}

/**
 *  把当前时间转化成时间戳
 */
- (NSString *)getTimeStamp
{
    NSDate * date = [NSDate date]; //现在时间
    //时间戳
    NSString * nowtimeStr = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
    return nowtimeStr;
}
/**
 *  视频的路径
 */
- (NSString *)videoPathString {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [[paths lastObject] stringByAppendingPathComponent:@"Caches"];
    NSLog(@"%@",[cacheDirectory stringByAppendingPathComponent:@"video2"]);
    return [cacheDirectory stringByAppendingPathComponent:@"video2"];
}

+ (NSString *)base64StringFromText:(NSString *)text
{
    if (text && ![text isEqualToString:LocalStr_None]) {
        //取项目的bundleIdentifier作为KEY  改动了此处
        //NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
        //IOS 自带DES加密 Begin  改动了此处
        //data = [self DESEncrypt:data WithKey:key];
        //IOS 自带DES加密 End
        return [self base64EncodedStringFrom:data];
    }
    else {
        return LocalStr_None;
    }
}

+ (NSString *)textFromBase64String:(NSString *)base64
{
    if (base64 && ![base64 isEqualToString:LocalStr_None]) {
        //取项目的bundleIdentifier作为KEY   改动了此处
        //NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        NSData *data = [self dataWithBase64EncodedString:base64];
        //IOS 自带DES解密 Begin    改动了此处
        //data = [self DESDecrypt:data WithKey:key];
        //IOS 自带DES加密 End
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else {
        return LocalStr_None;
    }
}

+ (NSString *)timeWithString:(CGFloat)interval
{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd"];
    return [objDateformat stringFromDate:confromTimesp];
}


+ (NSString *)timeWithStringToday:(NSTimeInterval)time
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * components0 = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:date];
    NSDateComponents * components1 = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:[NSDate date]];
    
    NSString* timeStr = @"";
    if (components0.year == components1.year
        && components0.month == components1.month
        && components0.day == components1.day){
        // 今天
        if (formatter == nil) {
            formatter = [[NSDateFormatter alloc] init] ;
        }
        [formatter setDateFormat:@"hh:mm"];
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
        timeStr = [formatter stringFromDate:date];
    }
    else {
        timeStr = [NSString stringWithFormat:@"%02ld-%02ld-%02ld", (long)components0.year, (long)components0.month, (long)components0.day];
    }
    return timeStr;
}

/*判断是否为新课程*/
+ (BOOL) isNewLession:(NSString *)timeStr
{
    //Tue May 21 10:56:45 +0800 2013
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:timeStr];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    
    NSTimeInterval cha=now-late;
    if ((float)cha/86400>7) {
        return NO;
    }
    return YES;
}


/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES加密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}



/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES解密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}

/******************************************************************************
 函数名称 : + (NSData *)dataWithBase64EncodedString:(NSString *)string
 函数描述 : base64格式字符串转换为文本数据
 输入参数 : (NSString *)string
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 :
 ******************************************************************************/
+ (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    if (string == nil)
        [NSException raise:NSInvalidArgumentException format:nil];
    if ([string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

/******************************************************************************
 函数名称 : + (NSString *)base64EncodedStringFrom:(NSData *)data
 函数描述 : 文本数据转换为base64格式字符串
 输入参数 : (NSData *)data
 输出参数 : N/A
 返回参数 : (NSString *)
 备注信息 :
 ******************************************************************************/
+ (NSString *)base64EncodedStringFrom:(NSData *)data
{
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

/**
 *  删除文件夹
 *
 */

+(void)removeAllFilesOfDirectory:(NSString *)directory{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:directory]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:directory];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[directory stringByAppendingPathComponent:fileName];
            BOOL isDir;
            if ([fileManager fileExistsAtPath:absolutePath isDirectory:&isDir]) {
                if (!isDir) {
                    [fileManager removeItemAtPath:absolutePath error:nil];
                }
            };
        }
    }
}







//+ (void)checkNewMsg
//{
//    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
//    NSString * uid = [NSString stringWithFormat:@"%@",[def objectForKey:@"uid"]];
//    if([uid integerValue] == 0){
//        return;
//    }
//    NSMutableDictionary * mutable = [[Utility sharedInstance]getUserUidAndTokAndTimeStamp];
//    [[NetWorkManager sharedManager] POST:hxUrl_MessageHasNew
//                              parameters:mutable
//                                 success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//                                     NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//                                     NSInteger code = [dict[@"code"] integerValue];
//                                     
//                                     if (code == 200) {
//                                         NSDictionary* dic = [dict objectForKey:@"message"];
//                                         NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
//                                         
//                                         NSString * uid = [NSString stringWithFormat:@"%@",[def objectForKey:@"uid"]];
//                                         
//                                         
//                                         NSNumber* favour = [dic objectForKey:@"favour"];
//                                         NSString* favourKey = [NSString stringWithFormat:@"favour_%@", uid];
//                                         NSNumber* comment = [dic objectForKey:@"comment"];
//                                         NSString* commentKey = [NSString stringWithFormat:@"comment_%@", uid];
//                                         NSNumber* attention = [dic objectForKey:@"attention"];
//                                         NSString* attentionKey = [NSString stringWithFormat:@"attention_%@", uid];
//                                         
//                                         
//                                         if (favour != nil) {
//                                             [def setObject:favour forKey:favourKey];
//                                         }
//                                         if (comment != nil) {
//                                             [def setObject:comment forKey:commentKey];
//                                         }
//                                         if (attention != nil) {
//                                             [def setObject:attention forKey:attentionKey];
//                                         }
//                                         [def synchronize];
//                                         if (favour.integerValue+comment.integerValue+attention.integerValue == 0) {
//                                             [self cleanAppBadge];
//                                         }
//                                         else {
//                                             //通知显示红点
//                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"kShowNewMessageHotDotNotification"
//                                                                                    object:nil];
//                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"kShowNewMessageBeadbadgeNotification"
//                                                                                                 object:nil];
//                                         }
//                                     }else
//                                     {
//                                         [[MyAlertView sharedInstance]showFrom:[[Utility sharedInstance]returnContent:code]];
//                                         if ([[Utility sharedInstance]codeWithLogin:code]
//                                             )
//                                         {
//                                             NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
//                                             [def setBool:NO forKey:@"isLogin"];
//                                             [[AppDelegate getDelegate]showLoginController];
//                                         }
//                                     }
//                                     
//                                     debugLog(@"%@",dict);
//                                 } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//                                     debugLog(@"%@",error);
//                                     
//                                 }];
//    
//}


+ (BOOL)hasNewMsg
{
    if ([self favourMsgCount] > 0
        || [self commentMsgCount] > 0
        || [self attentionMsgCount] > 0) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (NSInteger)favourMsgCount
{
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    NSString * uid = [NSString stringWithFormat:@"%@",[def objectForKey:@"uid"]];
    NSString* favourKey = [NSString stringWithFormat:@"favour_%@", uid];
    NSNumber* num = [def objectForKey:favourKey];
    return num.integerValue;
}

+ (NSInteger)commentMsgCount
{
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    NSString * uid = [NSString stringWithFormat:@"%@",[def objectForKey:@"uid"]];
    NSString* commentKey = [NSString stringWithFormat:@"comment_%@", uid];
    NSNumber* num = [def objectForKey:commentKey];
    return num.integerValue;
}

+ (NSInteger)attentionMsgCount
{
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    NSString * uid = [NSString stringWithFormat:@"%@",[def objectForKey:@"uid"]];
    NSString* attentionKey = [NSString stringWithFormat:@"attention_%@", uid];
    NSNumber* num = [def objectForKey:attentionKey];
    return num.integerValue;
}

+ (void)zeroFavourMsgCount
{
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    NSString * uid = [NSString stringWithFormat:@"%@",[def objectForKey:@"uid"]];
    NSString* favourKey = [NSString stringWithFormat:@"favour_%@", uid];
    [def removeObjectForKey:favourKey];
    if ([self commentMsgCount]==0 &&[self attentionMsgCount] ==0)
    {
        [self cleanAppBadge];
    }
}
+ (void)zeroCommentMsgCount
{
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    NSString * uid = [NSString stringWithFormat:@"%@",[def objectForKey:@"uid"]];
    NSString* commentKey = [NSString stringWithFormat:@"comment_%@", uid];
    [def removeObjectForKey:commentKey];
    if ([self attentionMsgCount] == 0 && [self favourMsgCount] == 0) {
        [self cleanAppBadge];
    }
}
+ (void)zeroAttentionMsgCount
{
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    NSString * uid = [NSString stringWithFormat:@"%@",[def objectForKey:@"uid"]];
    NSString* attentionKey = [NSString stringWithFormat:@"attention_%@", uid];
    [def removeObjectForKey:attentionKey];
    if ([self commentMsgCount] == 0 && [self favourMsgCount] == 0) {
        [self cleanAppBadge];
    }
}

+(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

+ (void)cleanAppBadge
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

+ (void)updateAppBadge
{
    NSInteger count = [self favourMsgCount] + [self commentMsgCount] + [self attentionMsgCount];
    [UIApplication sharedApplication].applicationIconBadgeNumber = count;
}

+ (NSString *)getCurrentIphoneModels{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString * platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    if ([platform isEqualToString:@"iPhone3,1"]) {
        return @"iPhone 4";
    }
    if ([platform isEqualToString:@"iPhone4,1"]){
        return @"iPhone 4S";
    }
    if ([platform isEqualToString:@"iPhone5,1"]){
        return @"iPhone 5(GSM)";
    }
    if ([platform isEqualToString:@"iPhone5,2"]){
        return @"iPhone 5(GSM+CDMA)";
    }
    if ([platform isEqualToString:@"iPhone5,3"]){
        return @"iPhone  5c(GSM)";
    }
    if ([platform isEqualToString:@"iPhone5,4"]){
        return @"iPhone 5c(GSM+CDMA)";
    }
    if ([platform isEqualToString:@"iPhone6,1"]){
        return @"iPhone 5s(GSM)";
    }
    if ([platform isEqualToString:@"iPhone6,2"]){
        return @"iPhone 5s(GSM+CDMA)";
    }
    if ([platform isEqualToString:@"iPhone7,1"])
        return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])
        return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"])
        return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])
        return @"iPhone 6s Plus";
    return nil;
}
@end

