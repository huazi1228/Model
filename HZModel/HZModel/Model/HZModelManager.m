//
//  HZModelManager.m
//  HZModel
//
//  Created by huazi on 16/3/27.
//  Copyright © 2016年 huazi. All rights reserved.
//

#import "HZModelManager.h"

@implementation HZModelManager
+(HZModelManager *)shareModelManager {
    static HZModelManager *_modelManager =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _modelManager =[[HZModelManager alloc] init];
    });
    return _modelManager;
}
- (id)init {
    if (self = [super init]) {
    }
    return self;
}
-(id)returnModelWithDic:(NSDictionary *)dic AndClassName:(NSString *)strClassName {
    id model =[[NSClassFromString(strClassName) alloc] init];
    NSMutableArray* allProperys =[self returnPropertysWithClassName:strClassName];
    NSMutableArray* allProperyAttributes =[self returnPropertysTypeWithClassName:strClassName];
    if (![dic isKindOfClass:[NSDictionary class]]&&![dic isKindOfClass:[NSMutableDictionary class]]) {
        return nil;
    }
    if (allProperys.count>0 &&[dic allKeys].count>0) {
        for (NSInteger i=0; i<[dic allKeys].count; i++) {
            NSString *key =[[dic allKeys] objectAtIndex:i];
            id value =[[dic allValues] objectAtIndex:i];
            DLog(@"%@",NSStringFromClass([value superclass]));
            
            if (![allProperys containsObject:key]) {  //model中不存在Dic中的这个属性
                continue ;
            }
            if ([NSStringFromClass([value superclass]) isEqualToString:@"NSMutableArray"]||[NSStringFromClass([value superclass]) isEqualToString:@"NSArray"]) {
                [self handelModelArrayValue:value key:key model:model];
                continue;
            }
            if ([NSStringFromClass([value superclass]) isEqualToString:@"NSMutableDictionary"]||[NSStringFromClass([value superclass]) isEqualToString:@"NSDictionary"]) {
                NSString *strClassName =[[key substringToIndex:[key rangeOfString:@"PbModel"].location] stringChangeFirstchar];
                id newvalues =[self returnModelWithDic:value AndClassName:strClassName];
                [model setValue:newvalues forKey:key];
                continue ;
            }
            
            NSInteger indexValue =[allProperys indexOfObject:key];
            DLog(@"%@",[allProperyAttributes objectAtIndex:indexValue]);
            if ([[NSString stringWithFormat:@"%@",value] isEqualToString:@"<null>"]||[[NSString stringWithFormat:@"%@",value] isEqualToString:@"null"]) {
                continue;
            }
            if ([[allProperyAttributes objectAtIndex:indexValue] hasPrefix:@"Ti"]) {
                DLog(@"%@",[NSString stringWithFormat:@"%@",value]);
                if ([[NSString stringWithFormat:@"%@",value] isEqualToString:@"<null>"]||[[NSString stringWithFormat:@"%@",value] isEqualToString:@"null"]) {
                    continue;
                }
                NSNumber *number =[NSNumber numberWithInt:[value intValue]];
                [model setValue:number forKey:key];
                continue;
            }
            
            [model setValue:value forKey:key];
        }
    }
    return model;
}
-(id)returnArrayModelWithArray:(NSArray *)array AndClassName:(NSString *)strClassName {
    NSMutableArray *arrayModels =[[NSMutableArray alloc] init];
    if ([NSStringFromClass([array superclass]) isEqualToString:@"NSMutableArray"]||[NSStringFromClass([array superclass]) isEqualToString:@"NSArray"]) {
        if (array&&array.count >0) {
            for (NSInteger i=0; i<array.count; i++) {
                id object =[array objectAtIndex:i];
                DLog(@"%@",NSStringFromClass([object superclass]));
                if ([NSStringFromClass([object superclass]) isEqualToString:@"NSDictionary"]||[NSStringFromClass([object superclass]) isEqualToString:@"NSMutableDictionary"]) {
                    id model =[self returnModelWithDic:object AndClassName:strClassName];
                    [arrayModels addObject:model];
                }
            }
        }
        return arrayModels;
    }
    //    DLog(@"数据格式错误，该返回array");
    return arrayModels;
}
/**
 *  处理model中的属性为数组的类型：区分PBList和array里面装NSString  如:imgList
 *
 *  @param value 属性值
 *  @param key   属性名称
 *  @param model model实例
 */
-(void)handelModelArrayValue:(id)value key:(id)key model:(id)model {
    if ([key rangeOfString:@"PbList"].location ==NSNotFound) {
        
        NSArray *arrayValue =value;
        if (arrayValue.count ==0||arrayValue ==nil) {
            return ;
        }
//        key =[key stringByAppendingString:@"Array"];
        [model setValue:value forKey:key];
        return ;
    }
    NSString *strClassName =[[key substringToIndex:[key rangeOfString:@"PbList"].location] stringChangeFirstchar];
    id newvalues =[self returnArrayModelWithArray:value AndClassName:strClassName];
//    key =[key stringByAppendingString:@"Array"];
    [model setValue:[newvalues mutableCopy] forKey:key];
    return ;
}
-(NSMutableArray *)returnPropertysWithClassName:(NSString *)strClassName {
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([NSClassFromString(strClassName) class], &outCount);
    NSMutableArray *arrayPropertys =[[NSMutableArray alloc] init];
    for (i=0; i<outCount; i++) {
        objc_property_t property = properties[i];
        NSString * key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
        [arrayPropertys addObject:key];
    }
    free(properties);
    return arrayPropertys;
}
-(NSMutableArray *)returnPropertysTypeWithClassName:(NSString *)strClassName {
    unsigned int outCount, i;
    objc_property_t *properties =class_copyPropertyList([NSClassFromString(strClassName) class], &outCount);
    NSMutableArray *arrayPropertyAttributes =[[NSMutableArray alloc] init];
    for (i=0; i<outCount; i++) {
        objc_property_t property = properties[i];
        NSString * key = [[NSString alloc]initWithCString:property_getAttributes(property)  encoding:NSUTF8StringEncoding];
        [arrayPropertyAttributes addObject:key];
        
    }
    free(properties);
    return arrayPropertyAttributes;
}

@end
