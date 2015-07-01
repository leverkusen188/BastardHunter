//
//  MainVCAppDelegate.m
//  AppProtectorSample
//
//  Created by Jianghui Liu on 14-3-25.
//  Copyright (c) 2014年 cn. All rights reserved.
//

#import "MainVCAppDelegate.h"
#import "APSDelegateManagerCenter.h"
#import <objc/runtime.h>
#import "BustersCatcher.h"

@implementation MainVCAppDelegate

/****
 metaclass的varlist检查，methodlist检查
 Class arr = [UIView class];
 //    arr = arr->isa;
 for (int i = 0; i < 100; i ++) {
 NSLog(@"arr====%p", arr);
 arr = arr->isa;
 }
 
 int numOfMethod = 0;
 class_copyMethodList(arr, &numOfMethod);
 
 unsigned int numberOfIvars = 0;
 Ivar* ivars = class_copyIvarList(arr, &numberOfIvars);
 
 for(const Ivar* p = ivars; p < ivars+numberOfIvars; p++)
 {
 
 }
 *****/

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSString *selName = NSStringFromSelector(@selector(test));
//    NSLog(@"invoke ====%@", NSStringFromSelector(sel));
    if ([selName isEqualToString:NSStringFromSelector(sel)])
    {
        return NO;
    }
    return [super resolveInstanceMethod:sel];
}

- (void)checkArr:(NSArray*)arr {
    [arr objectAtIndex:100];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //unrecognized selector sent to XXX   test
//    UIView *testView = [UIView new];
//    [testView performSelector:@selector(undefinedSelector)];
//    
//    //NSArray test
//    NSArray *array = [NSArray array];
//    NSLog(@"arr=%@", array[100]);
//    
//    //NSMutableDictionary test
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:nil forKey:nil];
//    
//    //NSMutableArray test
//    NSMutableArray *mutableArr = [NSMutableArray array];
//    [mutableArr addObject:nil];
//    [mutableArr removeObjectAtIndex:100];
//    [mutableArr replaceObjectAtIndex:100 withObject:nil];
//    [self test];
    NSMutableArray *arrr = [NSMutableArray array];
    [self checkArr:arrr];
    
    //未定义接口保护的测试代码
    [self hal:@"1" param1:333 param2:@"33"];
    
    
    //delegateManagerCenter  工具测试代码
    UITableView *tablev = [[UITableView alloc] initWithFrame:CGRectZero];
//    [tablev setMyDelegate:@"delegate" delegate:self];
    UIView *vv = [UIView new];
    [tablev setMyDelegate:@"delegate" delegate:vv];
    [tablev setMyDelegate:@"dataSource" delegate:vv];
    [vv release];
    NSLog(@"dell=====%@", tablev.delegate);
    NSLog(@"dell=====%@", tablev.dataSource);
    [tablev release];
    
    
    //ContainerWatcher  工具测试代码
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"1", @"2", nil];
    for (int i = 0; i < 3; i ++) {
        [arr addObject:[NSString stringWithFormat:@"%d", i]];
        
    }
    [arr addObjectsFromArray:[NSArray arrayWithObjects:@"22", @"33", @"44", nil]];
    [[APSContainerWatcher sharedInstance] addContainerObserver:arr observer:self];
    //测试移除  监控 功能。
    [[APSContainerWatcher sharedInstance] removeContainerObserver:arr observer:self];
    [arr removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 3)]];
    
    //
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (int i = 0; i < 5; i ++) {
        [dic setObject:[NSString stringWithFormat:@"value %i", i] forKey:[NSString stringWithFormat:@"key %i", i]];
    }
    //dictionary的监控测试
    [[APSContainerWatcher sharedInstance] addContainerObserver:dic observer:self];
    [dic setObject:@"44" forKey:@"24114"];
    
    
    //野指针抓取 工具宏测试
    NSObject    *p = [[[NSObject alloc] init] autorelease];
    Weak_Obj(p);
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        id weakP = Weak_GetObj(p);
        NSLog(@"Obj===%@",weakP);
    }];
    
    return YES;
}

- (void)watchedForContainer:(id)instance event:(APSContainerEvent)event context:(NSDictionary*)context {
    NSLog(@"");
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
