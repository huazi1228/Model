//
//  ViewController.m
//  HZModel
//
//  Created by huazi on 16/3/27.
//  Copyright © 2016年 huazi. All rights reserved.
//

#import "ViewController.h"
#import "HZModelManager.h"
#import "NSJSONSerialization+Transform.h"
#define Local_File_path [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
@interface Student : NSObject
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *address;
@property (nonatomic, assign)NSInteger age;
@end
@implementation Student

@end

@interface Hostel :NSObject
@property (nonatomic, strong)NSArray *studentPbListTotal;  //寝室每个学生对象
@property (nonatomic, strong)Student *studentPbModelLead; //寝室长
@property (nonatomic, copy)NSString *gradeName;  //班级名称
@end

@implementation Hostel

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnTest:(id)sender {
    
//    NSDictionary *dicHostel =[NSDictionary dictionaryWithObjectsAndKeys:@"090711班级16-311室",@"gradeName",@{@"name":@"老姜",@"address":@"东北",@"age":[NSNumber numberWithInteger:19]},@"studentPbModelMonitor",@[@{@"name":@"老姜",@"address":@"东北",@"age":[NSNumber numberWithInteger:19]},@{@"name":@"华子",@"address":@"江西",@"age":[NSNumber numberWithInteger:18]},@{@"name":@"小禄",@"address":@"江西",@"age":[NSNumber numberWithInteger:18]},@{@"name":@"小黑",@"address":@"安徽",@"age":[NSNumber numberWithInteger:17]}],@"studentPbListTotal", nil];
//    NSString *json =[NSJSONSerialization returnJsonStrWithObject:dicHostel];
//    [json writeToFile:[Local_File_path stringByAppendingString:@"11a"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSString *strFile =[NSBundle pathForResource:@"jsonfile" ofType:@"txt" inDirectory:[[NSBundle mainBundle] bundlePath]];
    NSString *strJson =[[NSString alloc] initWithContentsOfFile:strFile encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *dicHostel =[NSJSONSerialization returnObjectWithJsonStr:strJson];
    Hostel *hostel =[[HZModelManager shareModelManager] returnModelWithDic:dicHostel AndClassName:@"Hostel"];
    NSLog(@"%@", hostel);
    
}

@end
