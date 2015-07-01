//
//  BustersCatcher.m
//  DeallocCatcher
//
//  Created by JianghuiLiu on 15/6/3.
//  Copyright (c) 2015年 JianghuiLiu. All rights reserved.
//

#import "BustersCatcher.h"
#import <objc/runtime.h>

@implementation BustersCatcher

+ (instancetype)sharedInstance {
    static  BustersCatcher  *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [BustersCatcher new];
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        classList = NULL;
        [self refreshClassList];
    }
    return self;
}

- (void)refreshClassList {
    if (classList) {
        free(classList);
        classList = NULL;
    }
    if (!classList) {
        numOfClasses = objc_getClassList(NULL, 0);
        classList = malloc(sizeof(Class) * numOfClasses);
        numOfClasses = objc_getClassList(classList, numOfClasses);
    }
    
}

- (BOOL)isDealloc:(NSObject*)ob {
    Class cls = object_getClass(ob);
    for (int i = 0; i < numOfClasses; i ++) {
        if (classList[i] == cls) {
            return NO;
        }
    }
    return YES;
}

- (id)weakGetObj:(NSObject*)weakObj {
    if ([self isDealloc:weakObj]) {
        return nil;
    }
    return weakObj;
}

@end
