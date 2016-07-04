//
//  Utility.h
//  KMovie
//
//  Created by TuHaiSheng on 15/7/14.
//  Copyright (c) 2015年 PP－mac001. All rights reserved.
//

#import <Foundation/Foundation.h>
#define __BASE64( text )        [CommonFunc base64StringFromText:text]
#define __TEXT( base64 )        [CommonFunc textFromBase64String:base64]

@class Utility,HXFindListMode;
@interface Utility : NSObject
/**
 *  正则表达式检查电话号码是否合法
 */
+ (BOOL)checkUserTelNumber:(NSString *)telNumber;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+ (Utility*)sharedInstance;
/**
 *  存用户的userid
 *
 *  @param uid
 */
+ (void)setUid:(NSString *)uid;
/**
 *  获取用户的uid
 */
+ (NSString *)getUid;
+(UIView*)createViewWithFrame:(CGRect)frame color:(UIColor*)color;
+(UILabel*)createLabelWithFrame:(CGRect)frame font:(float)font text:(NSString*)text;
+(UIButton*)createButtonWithFrame:(CGRect)frame title:(NSString*)title imageName:(NSString*)imageName bgImageName:(NSString*)bgImageName target:(id)target method:(SEL)select;
+(UIImageView*)createImageViewFrame:(CGRect)frame imageName:(NSString*)imageName;
+(UITextField*)createTextFieldFrame:(CGRect)frame placeholder:(NSString*)placeholder bgImageName:(NSString*)imageName leftView:(UIView*)leftView rightView:(UIView*)rightView isPassWord:(BOOL)isPassWord;
- (NSURL *)getVideoContentURL:(NSString *)urlStr;
- (NSMutableDictionary *)getUserUidAndTokAndTimeStamp;
/**
 *   分享功能
 *
 *  @param sender  按钮
 *  @param url     url
 *  @param content 内容
 */
//- (void)btnShare:(UIButton *)sender andUrl:(NSString *)url andContent:(NSString *)content andTitle:(NSString *)title andImageUrl:(NSString *)imgUrl;

- (UIImage *)synImage:(UIImage *)resizedImage andShareImage:(UIImage *)shareImage andUserIcon:(UIImage *)userIcon andUserName:(NSString *)name;
/**
 *  将文本转换为base64格式字符串
 *
 *  @param text 输入参数  文本
 *
 *  @return base64格式字符串
 */

+ (NSString *)base64StringFromText:(NSString *)text;
//向后台发送用户修改个人
- (void)postModileData:(NSDictionary *)userDict;
/**
 *   将base64格式字符串转换为文本
 *
 *  @param base64 base64格式字符串
 *
 *  @return  文本
 */
+ (NSString *)textFromBase64String:(NSString *)base64;

- (BOOL)checkUserTelNumber:(NSString *)telNumber;//电话号码
/**
 *  评论回复字段拼接
 */
+ (NSString *)commentString:(HXFindListMode *)commentsModel;
//获取时间戳
- (NSString *)getTimeStamp;

/**
 *  向后台传数据
 *
 *  @param nkn3   第三方用户昵称
 *  @param ID     第三方用户ID
 *  @param number  第三方类型 0 微信，1qq，2微博
 */
- (void)postDataToServerNkns:(NSString *)nkn3 andIdent:(NSString *)ID andThirdPlat:(NSInteger)number;

-(BOOL)isCategoryActionsDownLoadFinished:(NSArray *)actions;

//发现分享
- (void)findBtnShare:(UIButton *)sender andUrl:(NSString *)url andContent:(NSString *)content andTitle:(NSString *)title andImageUrl:(NSString *)imgUrl;

#pragma mark 下载数据
- (NSString *)getCdnUrl:(NSString *)url;

- (BOOL)isVideoCached:(NSString *)url;

/**
 * 中文unicode编码
 */
- (NSString *)replaceUnicode:(NSString *)unicodeStr;
/**
 *  从数据库中获取数据
 */
//- (void)getDataFromDataBase;


/**
 * afnetworking 网络出错处理
 */
- (void)showAfnError:(NSError *)error;

+ (NSMutableArray *)dictToModelClass:(Class)modelClass andArray:(NSArray *)array;


/**
 *  获取当天凌晨的时间戳
 */
+ (NSInteger)getLingChenTimeStamp;

/**
 * 根据提示码返回响应的内容
 */
- (NSString *)returnContent:(NSInteger)code;

/**
 * 根据提示码返回登录界面
 */
- (BOOL)codeWithLogin:(NSInteger)code;

+ (NSString *)timeWithString:(CGFloat)string;
+ (NSString *)timeWithStringToday:(NSTimeInterval)date;
+ (BOOL) isNewLession:(NSString *)timeStr;

@property(nonatomic, copy) NSString *videoPath; //3.4版本前的视频文件存在Video中,3.4开始存在vedio2中

@property(nonatomic, copy) NSString *tempPath;

@property(nonatomic, assign)NSInteger badge;

@property(nonatomic, assign)NSInteger type;


+ (void)checkNewMsg;
+ (BOOL)hasNewMsg;
+ (NSInteger)favourMsgCount;
+ (NSInteger)commentMsgCount;
+ (NSInteger)attentionMsgCount;
+ (void)zeroFavourMsgCount;
+ (void)zeroCommentMsgCount;
+ (void)zeroAttentionMsgCount;
+ (void)updateAppBadge;
+ (NSString *)getCurrentIphoneModels;
- (void)addNumber:(NSNumber *)numbe;
- (NSMutableArray *)getNumberArray;
@end
