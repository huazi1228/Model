//
//  NSJSONSerialization+Transform.m
//  HZModel
//
//  Created by huazi on 16/3/27.
//  Copyright © 2016年 huazi. All rights reserved.
//

#import "NSJSONSerialization+Transform.h"

@implementation NSJSONSerialization (Transform)
+(id)returnObjectWithJsonStr:(NSString *)str
{
    if (str ==nil||str.length==0) return nil;
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    id object =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return object;
}
+(NSString *)returnJsonStrWithObject:(id)object
{
    if (object ==nil) return @"";
    NSData *jsonObject  =[NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
    NSString *str =[[NSString alloc] initWithData:jsonObject encoding:NSUTF8StringEncoding];
    return str;
}
@end
