//
//  HZModelManager.h
//  HZModel
//
//  Created by huazi on 16/3/27.
//  Copyright © 2016年 huazi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+GetModelProperyAttribute.h"
#import <objc/runtime.h>
#ifdef DEBUG
#    define DLog(...) NSLog(__VA_ARGS__)
#else
#    define DLog(...) {}
#endif
@interface HZModelManager : NSObject

+(HZModelManager *)shareModelManager;
/**
 *  返回一个Model数据
 *
 *  @param dic          model 对应的Dic
 *  @param strClassName model 的类名
 *
 *  @return 赋好值的model数据
 */
-(id)returnModelWithDic:(NSDictionary *)dic AndClassName:(NSString *)strClassName;    //返回一个Model数据
/**
 *  返回一个数组Model数据，数组对象类型必须相同
 *
 *  @param models      model上 对应的数组
 *  @param strClassName model 的类名
 *
 *  @return 赋好值的model数据
 */
-(id)returnArrayModelWithArray:(NSArray *)models AndClassName:(NSString *)strClassName;  //返回一个数组Model数据
/**
 *  返回一个类的属性数组
 *
 *  @param strClassName 类名
 *
 *  @return 类里面的数组
 */
-(NSMutableArray *)returnPropertysWithClassName:(NSString *)strClassName;
/**
 *  返回属性的类型
 *
 *  @param strClassName strClassName 类名
 *
 *  @return 类里面的属性类型数组
 */
-(NSMutableArray *)returnPropertysTypeWithClassName:(NSString *)strClassName;
@end
