//
//  APSContainerWatcher.h
//  AppProtectorSample
//
//  Created by Jianghui Liu on 14-11-7.
//  Copyright (c) 2014年 cn. All rights reserved.
//

/*********************
 监控指定对象的生命周期。
 监控array和dictionary 的内容变更。
*********************/

#import <Foundation/Foundation.h>

#import "NSObject+appSuperProtecter.h"

///////////////////////
//////// 一些参数宏定义////
///////////////////////

typedef NS_ENUM(NSInteger, APSContainerEvent) {
    APSContainerEvent_Array_objectAdded         = 1 << 0,
    APSContainerEvent_Array_objectRemoved       = 1 << 1,
    APSContainerEvent_Array_objectReplaced      = 1 << 2,
    
    
    APSContainerEvent_Dictionary_newSet         = 1 << 3,   //之前没有的key，set了value
    APSContainerEvent_Dictionary_replace        = 1 << 4,   //之前已有的key，value被更新
    APSContainerEvent_Dictionary_removed        = 1 << 5,   //已有的key，value被remove
};
//Array的事件相关参数定义
#define APSContainer_Param_OriginalArray    @"__APSContainer_Param_OriginalArray__"
#define APSContainer_Param_CurrentArray     @"__APSContainer_Param_CurrentArray__"
#define APSContainer_Param_AddedItems       @"__APSContainer_Param_AddedItems__"    //
#define APSContainer_Param_AddedRange       @"__APSContainer_Param_AddedRange__"    //新添的元素在新数组里的位置
#define APSContainer_Param_ReplacedRange    @"__APSContainer_Param_ReplacedRange__" //原数组被替换掉的元素的位置
#define APSContainer_Param_DeletedRange     @"__APSContainer_Param_DeletedRange__"  //原数组被删除的元素所在的位置
//Dictionary的事件相关参数定义
#define APSContainer_Param_OriginalDictionary    @"__APSContainer_Param_OriginalDictionary__"
#define APSContainer_Param_CurrentDictionary     @"__APSContainer_Param_CurrentDictionary__"


@protocol APSContainerWatcherDelegate <NSObject>

@optional
/*******************
 监控的实例对象发生了变化
 参数：
 instance：监控的 数组or 字典对象
 event：发生了什么事
 context：保存了一些其他参数，比如老的值，新的值
 ********************/
- (void)watchedForContainer:(id)instance event:(APSContainerEvent)event context:(NSDictionary*)context;

@end

@interface APSContainerWatcher : NSObject {
//    NSMutableArray      *_lifeTimeArr;  //保存  被监控生命周期的对象的相关信息
    NSMutableArray      *_containerArr; //
    BOOL                _bEnabled;
}

+ (id)sharedInstance;

/*******************
 设置 关闭 or  打开  监控功能
 ********************/
- (void)setWatcherEnabled:(BOOL)enabled;

/*******************
 添加一个监控
 参数：
 container：需要监控的 数组or 字典对象
 observer：监听者，  事件发生后的接收者, 可以对同一个监控容器添加多个监听者
 ********************/
- (void)addContainerObserver:(id)container observer:(id<APSContainerWatcherDelegate>)observer;

/*******************
 移除指定容器的某个监听者
 参数：
 container：需要监控的 数组or 字典对象
 observer：监听者，  事件发生后的接收者, 可以对同一个监控容器添加多个监听者
 ********************/
- (void)removeContainerObserver:(id)container observer:(id<APSContainerWatcherDelegate>)observer;

/*******************
 移除指定容器的所有个监听者
 参数：
 container：需要监控的 数组or 字典对象
 ********************/
- (void)removeContainerObservers:(id)container;

//处理一个事件，并转发给所有的监听者
- (void)dealEvent:(APSContainerEvent)event param:(NSDictionary*)param;

@end
