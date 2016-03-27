//
//  NSString+GetModelProperyAttribute.m
//  HZModel
//
//  Created by huazi on 16/3/27.
//  Copyright © 2016年 huazi. All rights reserved.
//

#import "NSString+GetModelProperyAttribute.h"

@implementation NSString (GetModelProperyAttribute)
- (NSString *)stringChangeFirstchar{
    NSString *strReturn =[NSString stringWithFormat:@"%@%@",[[self substringToIndex:1] uppercaseString],[self substringFromIndex:1]];
    return strReturn;
}
@end
