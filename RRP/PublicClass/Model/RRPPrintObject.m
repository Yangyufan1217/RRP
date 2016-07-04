//
//  RRPPrintObject.m
//  RRP
//
//  Created by WangZhaZha on 16/3/4.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPPrintObject.h"
#import <objc/runtime.h>
@implementation RRPPrintObject
//单例
+ (RRPPrintObject *)sharePrintObjiect
{
    static RRPPrintObject *printOnject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        printOnject = [[RRPPrintObject alloc] init];
    });
    
    return printOnject;
}
+(NSDictionary*)getObjectData:(id)obj

{
    
    NSMutableDictionary
    *dic = [NSMutableDictionary dictionary];
    
    unsigned
    int propsCount;
    
    objc_property_t
    *props = class_copyPropertyList([obj class], &propsCount);
    
    for(int
        i = 0;i < propsCount; i++)
        
    {
        
        objc_property_t
        prop = props[i];
        
        
        
        NSString
        *propName = [NSString stringWithUTF8String:property_getName(prop)];
        
        id
        value = [obj valueForKey:propName];
        
        if(value
           == nil)
            
        {
            
            value
            = [NSNull null];
            
        }
        
        else
            
        {
            
            value
            = [self getObjectInternal:value];
            
        }
        
        [dic
         setObject:value forKey:propName];
        
    }
    return
    
    dic;
    
}



+
(void)print:(id)obj

{
    
//    NSLog(@"%@",
//          [self getObjectData:obj]);
    
}
+
(NSData*)getJSON:(id)obj options:(NSJSONWritingOptions)options error:(NSError**)error

{
    
    return
    
    [NSJSONSerialization dataWithJSONObject:[self getObjectData:obj] options:options error:error];
    
}



+
(id)getObjectInternal:(id)obj

{
    
    if([obj
        isKindOfClass:[NSString class]]
       
       ||
       [obj isKindOfClass:[NSNumber class]]
       
       ||
       [obj isKindOfClass:[NSNull class]])
        
    {
        
        return
        
        obj;
        
    }
    if([obj
        isKindOfClass:[NSArray class]])
        
    {
        
        NSArray
        *objarr = obj;
        
        NSMutableArray
        *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        
        for(int
            i = 0;i < objarr.count; i++)
            
        {
            
            [arr
             setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
            
        }      
        
        return
        
        arr;
        
    }
    if([obj
        isKindOfClass:[NSDictionary class]])
        
    {
        
        NSDictionary
        *objdic = obj;
        
        NSMutableDictionary
        *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        
        for(NSString
            *key in
            
            objdic.allKeys)
            
        {
            
            [dic
             setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
            
        }     
        
        return
        
        dic;
        
    } 
    
    return
    
    [self getObjectData:obj];
    
}


//将NSDictionary中的Null类型的项目转化成@""
+(NSDictionary *)nullDic:(NSDictionary *)myDic
{
    NSArray *keyArr = [myDic allKeys];
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < keyArr.count; i ++)
    {
        id obj = [myDic objectForKey:keyArr[i]];
        obj = [self changeType:obj];
        [resDic setObject:obj forKey:keyArr[i]];
    }
    return resDic;
}

//将NSDictionary中的Null类型的项目转化成@""
+(NSArray *)nullArr:(NSArray *)myArr
{
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < myArr.count; i ++)
    {
        id obj = myArr[i];
        obj = [self changeType:obj];
        [resArr addObject:obj];
    }
    return resArr;
}

//将NSString类型的原路返回
+(NSString *)stringToString:(NSString *)string
{
    return string;
}

//将Null类型的项目转化成@""
+(NSString *)nullToString
{
    return @"";
}

//类型识别:将所有的NSNull类型转化成@""
+(id)changeType:(id)myObj
{
    if ([myObj isKindOfClass:[NSDictionary class]])
    {
        return [self nullDic:myObj];
    }
    else if([myObj isKindOfClass:[NSArray class]])
    {
        return [self nullArr:myObj];
    }
    else if([myObj isKindOfClass:[NSString class]])
    {
        return [self stringToString:myObj];
    }
    else if([myObj isKindOfClass:[NSNull class]])
    {
        return [self nullToString];
    }
    else
    {
        return myObj;
    }
}






@end
