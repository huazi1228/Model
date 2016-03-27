//
//  NSJSONSerialization+Transform.h
//  HZModel
//
//  Created by huazi on 16/3/27.
//  Copyright © 2016年 huazi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (Transform)
/**
 *  将json字符转换为对应的NSDic 或NSArray等
 *
 *  @param str json字符
 *
 *  @return  json字符转换为对应的NSDic 或NSArray等
 */
+(id)returnObjectWithJsonStr:(NSString *)str;
/**
 *  将NSDic 或NSArray等转换为对应的json字符
 *
 *  @param object 要转换对应的NSDic 或NSArray等json字符
 *
 *  @return  json字符
 */
+(NSString *)returnJsonStrWithObject:(id)object;
@end
