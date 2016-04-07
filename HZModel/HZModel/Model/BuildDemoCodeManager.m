//
//  BuildDemoCodeManager.m
//  HZModel
//
//  Created by huazi on 16/4/5.
//  Copyright © 2016年 huazi. All rights reserved.
//

#import "BuildDemoCodeManager.h"

@implementation BuildDemoCodeManager
- (void)build:(NSMutableArray *)classNameAndPropertys {
    for (NSInteger i=0; i<classNameAndPropertys.count; i++) {
        [self createHFile:classNameAndPropertys[i]];
        [self createMFile:classNameAndPropertys[i]];
    }
    
}
- (void)createHFile:(NSMutableArray *)classNameAndPropertys {
    NSString *strFile =[NSBundle pathForResource:@"createHTemplate" ofType:@"" inDirectory:[[NSBundle mainBundle] bundlePath]];
    NSMutableString *strCreateHTemplate =[[NSMutableString alloc] initWithContentsOfFile:strFile encoding:NSUTF8StringEncoding error:nil];
    NSArray *arrayItems =[strCreateHTemplate componentsSeparatedByString:@"/*=====*/"];
    NSMutableString *hfileStr =[[NSMutableString alloc] init];
    
    [hfileStr appendString:arrayItems[0]];
    [self appendClass:classNameAndPropertys andHfileStr:hfileStr];
    
    [hfileStr appendString:arrayItems[1]];
    [self replaceClassNameAndAddExplain:classNameAndPropertys andHfileStr:hfileStr];
    
    [self appendPropertys:classNameAndPropertys andHfileStr:hfileStr];
    
    [hfileStr appendString:arrayItems[2]];
    
    
    NSString *className =[[[classNameAndPropertys objectAtIndex:0] componentsSeparatedByString:@","] objectAtIndex:0];
    
    NSLog(@"%@/%@.h",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],className);
    [hfileStr writeToFile:[NSString stringWithFormat:@"%@/%@.h",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],className]
                atomically:NO
                  encoding:NSUTF8StringEncoding
                     error:nil];
    
}
- (void)createMFile:(NSMutableArray *)classNameAndPropertys {
    NSString *strFile =[NSBundle pathForResource:@"createMTemplate" ofType:@"" inDirectory:[[NSBundle mainBundle] bundlePath]];
    NSMutableString *strCreateMTemplate =[[NSMutableString alloc] initWithContentsOfFile:strFile encoding:NSUTF8StringEncoding error:nil];
    NSString *className =[[[classNameAndPropertys objectAtIndex:0] componentsSeparatedByString:@","] objectAtIndex:0];
    [strCreateMTemplate replaceOccurrencesOfString:@"#classname#" withString:className options:1 range:NSMakeRange(0, strCreateMTemplate.length)];
    NSLog(@"%@/%@.m",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],className);
    [strCreateMTemplate writeToFile:[NSString stringWithFormat:@"%@/%@.m",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],className]
               atomically:NO
                 encoding:NSUTF8StringEncoding
                    error:nil];
}
/**
 *  添加引用类
 *
 *  @param classNameAndPropertys
 */
- (void)appendClass:(NSMutableArray *)classNameAndPropertys andHfileStr:(NSMutableString *)hfileStr {
    NSString *strFile =[NSBundle pathForResource:@"PropertyTypeMapping" ofType:@"plist" inDirectory:[[NSBundle mainBundle] bundlePath]];
    NSDictionary *dicProperyType =[[NSDictionary alloc] initWithContentsOfFile:strFile];
    for (NSInteger i=1; i<classNameAndPropertys.count; i++) {
        NSArray *arrayItems =[[classNameAndPropertys objectAtIndex:i] componentsSeparatedByString:@","];
        if (![[dicProperyType allKeys] containsObject:arrayItems[2]]) {
            [hfileStr appendFormat:@"@class %@;\n",arrayItems[2]];
        }
    }
}
/**
 *  替换类名和添加类名注释
 *
 *  @param classNameAndPropertys
 *  @param hfileStr
 */
- (void)replaceClassNameAndAddExplain:(NSMutableArray *)classNameAndPropertys andHfileStr:(NSMutableString *)hfileStr {
    NSArray *arrayItems =[[classNameAndPropertys objectAtIndex:0] componentsSeparatedByString:@","];
    [hfileStr replaceOccurrencesOfString:@"#classname#" withString:[arrayItems objectAtIndex:0] options:1 range:NSMakeRange(0, hfileStr.length)];
    if (((NSString *)[arrayItems objectAtIndex:3]).length >0) {
        [hfileStr replaceOccurrencesOfString:@"//classname" withString:[NSString stringWithFormat:@"// %@",[arrayItems objectAtIndex:3]] options:1 range:NSMakeRange(0, hfileStr.length)];
        return ;
    }
    [hfileStr replaceOccurrencesOfString:@"//classname" withString:@"" options:1 range:NSMakeRange(0, hfileStr.length)];
    
}
- (void)appendPropertys:(NSMutableArray *)classNameAndPropertys andHfileStr:(NSMutableString *)hfileStr {
    NSString *strFile =[NSBundle pathForResource:@"PropertyTypeMapping" ofType:@"plist" inDirectory:[[NSBundle mainBundle] bundlePath]];
    NSDictionary *dicProperyType =[[NSDictionary alloc] initWithContentsOfFile:strFile];
    
    NSDictionary *dicMapping =[[NSDictionary alloc] initWithObjectsAndKeys:@"strong",@"NSArray",@"strong",@"NSDictionary",@"strong",@"NSMutableArray",@"strong",@"NSMutableDictionary",@"copy",@"NSString",@"assign",@"NSInteger",@"assign",@"float",@"assign",@"BOOL", nil];
    
    for (NSInteger i=1; i<classNameAndPropertys.count; i++) {
        NSArray *arrayItems =[[classNameAndPropertys objectAtIndex:i] componentsSeparatedByString:@","];
        NSString *strType =[dicProperyType objectForKey:arrayItems[2]];
        if (strType.length ==0||strType==nil) {
            strType =arrayItems[2];
        }
        NSString *strModifyPropery =[dicMapping objectForKey:strType];
        if (strModifyPropery ==0||strModifyPropery==nil) {
            strModifyPropery =@"strong";
        }
        NSString *strModifyProperyMean =@"";
        if (((NSString *)arrayItems[3]).length>0) {
            strModifyProperyMean =[NSString stringWithFormat:@"  //%@",arrayItems[3]];
        }
        if ([strModifyPropery isEqualToString:@"assign"]) {
            [hfileStr appendFormat:@"@property (nonatomic ,%@) %@ %@;%@\n",strModifyPropery,strType,arrayItems[1],strModifyProperyMean];
            return;
        }
        
        [hfileStr appendFormat:@"@property (nonatomic ,%@) %@ *%@;%@\n",strModifyPropery,strType,arrayItems[1],strModifyProperyMean];
    }
}
@end
