//
//  BustersCatcher.h
//  DeallocCatcher
//
//  Created by JianghuiLiu on 15/6/3.
//  Copyright (c) 2015年 JianghuiLiu. All rights reserved.
//

#import <Foundation/Foundation.h>

/************
 一些加了野指针保护的常用方法宏定义
 **************/
//等同于RrespondsToSelector，但加上了对target是否野指针的判断，可以保护后面的方法调用.
#define Safe_RrespondsToSelector(target, sel)   \
(![[BustersCatcher sharedInstance] isDealloc:target] && [target respondsToSelector:sel])

#define Safe_Release(obj) \
if(![[BustersCatcher sharedInstance] isDealloc:obj]) { [obj release]; obj = nil;} \
else {obj = nil;}

//用于MRC 模式下的block传参。类似于 ARC下的 weak 定义，但在block外要用Weak_Obj 包一次对象，然后在 block里用Weak_GetObj取一次。
//例子：
/***********
 Weak_Obj(self);
 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
 id weakSelf = Weak_GetObj(self);
 NSLog(@"obj===%@",weakSelf);
 }];
 ********/
#define Weak_Obj(obj)  __block __typeof__(obj) __weak_##obj##__ = obj;
#define Weak_GetObj(obj) [[BustersCatcher sharedInstance] weakGetObj:__weak_##obj##__]



@interface BustersCatcher : NSObject {
    int     numOfClasses;
    Class*  classList;
}

+ (instancetype)sharedInstance;

//刷新存储的类列表，主要用于 runtime动态添加了类之后调用。
- (void)refreshClassList;

- (BOOL)isDealloc:(NSObject*)ob;

- (id)weakGetObj:(NSObject*)weakObj;

@end
