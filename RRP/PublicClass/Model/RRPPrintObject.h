//
//  RRPPrintObject.h
//  RRP
//
//  Created by WangZhaZha on 16/3/4.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRPPrintObject : NSObject
//单例
+ (RRPPrintObject *)sharePrintObjiect;
//通过对象返回一个NSDictionary，键是属性名称，值是属性值。
+ (NSDictionary*)getObjectData:(id)obj;
//将getObjectData方法返回的NSDictionary转化成JSON
+ (NSData*)getJSON:(id)obj options:(NSJSONWritingOptions)options error:(NSError**)error;
//直接通过NSLog输出getObjectData方法返回的NSDictionary
+ (void)print:(id)obj;

//将NSDictionary中的Null类型的项目转化成@""
+(NSDictionary *)nullDic:(NSDictionary *)myDic;
//将NSArray中的Null类型的项目转化成@""
+(NSArray *)nullArr:(NSArray *)myArr;
//将NSString类型的原路返回
+(NSString *)stringToString:(NSString *)string;
//将Null类型的项目转化成@""
+(NSString *)nullToString;
//类型识别:将所有的NSNull类型转化成@""
+(id)changeType:(id)myObj;



@end
