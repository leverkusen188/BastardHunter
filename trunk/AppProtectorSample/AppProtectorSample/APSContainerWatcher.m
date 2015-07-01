//
//  APSContainerWatcher.m
//  AppProtectorSample
//
//  Created by Jianghui Liu on 14-11-7.
//  Copyright (c) 2014年 cn. All rights reserved.
//

#import "APSContainerWatcher.h"

#pragma mark --
#pragma mark 数组的替换 API
@interface NSMutableArray (containerWatcher)

@end

@implementation NSMutableArray (containerWatcher)

- (void)addObjectWatcher:(id)anObject {
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self];
    NSRange range = NSMakeRange(self.count, 1);
    [self addObjectWatcher:anObject];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:tempArr forKey:APSContainer_Param_OriginalArray];
    [param setObject:self forKey:APSContainer_Param_CurrentArray];
    [param setObject:[NSArray arrayWithObject:anObject] forKey:APSContainer_Param_AddedItems];
    [param setObject:[NSValue valueWithRange:range] forKey:APSContainer_Param_AddedRange];
    [[APSContainerWatcher sharedInstance] dealEvent:APSContainerEvent_Array_objectAdded param:param];
}

- (void)insertObjectWatcher:(id)anObject atIndex:(NSUInteger)index {
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self];
    NSRange range = NSMakeRange(index, 1);
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:NO];
    [self insertObjectWatcher:anObject atIndex:index];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:tempArr forKey:APSContainer_Param_OriginalArray];
    [param setObject:self forKey:APSContainer_Param_CurrentArray];
    [param setObject:[NSArray arrayWithObject:anObject] forKey:APSContainer_Param_AddedItems];
    [param setObject:[NSValue valueWithRange:range] forKey:APSContainer_Param_AddedRange];
    [[APSContainerWatcher sharedInstance] dealEvent:APSContainerEvent_Array_objectAdded param:param];
}

- (void)addObjectsFromArrayWatcher:(NSArray *)otherArray {
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self];
    NSRange range = NSMakeRange(self.count, otherArray.count);
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:NO];
    [self addObjectsFromArrayWatcher:otherArray];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:tempArr forKey:APSContainer_Param_OriginalArray];
    [param setObject:self forKey:APSContainer_Param_CurrentArray];
    if (otherArray)
        [param setObject:otherArray forKey:APSContainer_Param_AddedItems];
    [param setObject:[NSValue valueWithRange:range] forKey:APSContainer_Param_AddedRange];
    [[APSContainerWatcher sharedInstance] dealEvent:APSContainerEvent_Array_objectAdded param:param];
}

- (void)insertObjectsWatcher:(NSArray *)objects atIndexes:(NSIndexSet *)indexes {
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self];
    NSRange range = NSMakeRange(indexes.firstIndex, indexes.lastIndex-indexes.firstIndex+1);
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:NO];
    [self insertObjectsWatcher:objects atIndexes:indexes];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:tempArr forKey:APSContainer_Param_OriginalArray];
    [param setObject:self forKey:APSContainer_Param_CurrentArray];
    if (objects)
        [param setObject:objects forKey:APSContainer_Param_AddedItems];
    [param setObject:[NSValue valueWithRange:range] forKey:APSContainer_Param_AddedRange];
    [[APSContainerWatcher sharedInstance] dealEvent:APSContainerEvent_Array_objectAdded param:param];
}

- (void)replaceObjectAtIndexWatcher:(NSUInteger)index withObject:(id)anObject {
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self];
    NSRange range = NSMakeRange(index, 1);
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:NO];
    [self replaceObjectAtIndexWatcher:index withObject:anObject];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:tempArr forKey:APSContainer_Param_OriginalArray];
    [param setObject:self forKey:APSContainer_Param_CurrentArray];
    [param setObject:[NSValue valueWithRange:range] forKey:APSContainer_Param_ReplacedRange];
    [[APSContainerWatcher sharedInstance] dealEvent:APSContainerEvent_Array_objectReplaced param:param];
}

- (void)exchangeObjectAtIndexWatcher:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2 {
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self];
    NSRange range = NSMakeRange(idx1, 1);
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:NO];
    [self exchangeObjectAtIndexWatcher:idx1 withObjectAtIndex:idx2];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:tempArr forKey:APSContainer_Param_OriginalArray];
    [param setObject:self forKey:APSContainer_Param_CurrentArray];
    [param setObject:[NSValue valueWithRange:range] forKey:APSContainer_Param_ReplacedRange];
    [[APSContainerWatcher sharedInstance] dealEvent:APSContainerEvent_Array_objectReplaced param:param];
}

- (void)replaceObjectsInRangeWatcher:(NSRange)range withObjectsFromArray:(NSArray *)otherArray {
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:NO];
    [self replaceObjectsInRangeWatcher:range withObjectsFromArray:otherArray];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:tempArr forKey:APSContainer_Param_OriginalArray];
    [param setObject:self forKey:APSContainer_Param_CurrentArray];
    [[APSContainerWatcher sharedInstance] dealEvent:APSContainerEvent_Array_objectReplaced param:param];
}

- (void)replaceObjectsInRangeWatcher:(NSRange)range withObjectsFromArray:(NSArray *)otherArray range:(NSRange)otherRange {
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:NO];
    [self replaceObjectsInRangeWatcher:range withObjectsFromArray:otherArray range:otherRange];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:tempArr forKey:APSContainer_Param_OriginalArray];
    [param setObject:self forKey:APSContainer_Param_CurrentArray];
    [[APSContainerWatcher sharedInstance] dealEvent:APSContainerEvent_Array_objectReplaced param:param];
}

- (void)replaceObjectsAtIndexesWatcher:(NSIndexSet *)indexes withObjects:(NSArray *)objects {
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self];
    NSRange range = NSMakeRange(indexes.firstIndex, indexes.lastIndex-indexes.firstIndex+1);
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:NO];
    [self replaceObjectsAtIndexesWatcher:indexes withObjects:objects];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:tempArr forKey:APSContainer_Param_OriginalArray];
    [param setObject:self forKey:APSContainer_Param_CurrentArray];
    [param setObject:[NSValue valueWithRange:range] forKey:APSContainer_Param_ReplacedRange];
    [[APSContainerWatcher sharedInstance] dealEvent:APSContainerEvent_Array_objectReplaced param:param];
}

- (void)setObjectWatcher:(id)obj atIndexedSubscript:(NSUInteger)idx {
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self];
    NSRange range = NSMakeRange(idx, 1);
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:NO];
    [self setObjectWatcher:obj atIndexedSubscript:idx];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:tempArr forKey:APSContainer_Param_OriginalArray];
    [param setObject:self forKey:APSContainer_Param_CurrentArray];
    [param setObject:[NSValue valueWithRange:range] forKey:APSContainer_Param_ReplacedRange];
    [[APSContainerWatcher sharedInstance] dealEvent:APSContainerEvent_Array_objectReplaced param:param];
}

- (void)removeLastObjectWatcher {
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self];
    NSRange range = NSMakeRange(self.count-1, 1);
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:NO];
    [self removeLastObjectWatcher];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:tempArr forKey:APSContainer_Param_OriginalArray];
    [param setObject:self forKey:APSContainer_Param_CurrentArray];
    [param setObject:[NSValue valueWithRange:range] forKey:APSContainer_Param_DeletedRange];
    [[APSContainerWatcher sharedInstance] dealEvent:APSContainerEvent_Array_objectRemoved param:param];
}

- (void)removeObjectAtIndexWatcher:(NSUInteger)index {
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self];
    NSRange range = NSMakeRange(index, 1);
    [self removeObjectAtIndexWatcher:index];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:tempArr forKey:APSContainer_Param_OriginalArray];
    [param setObject:self forKey:APSContainer_Param_CurrentArray];
    [param setObject:[NSValue valueWithRange:range] forKey:APSContainer_Param_DeletedRange];
    [[APSContainerWatcher sharedInstance] dealEvent:APSContainerEvent_Array_objectRemoved param:param];
}

- (void)removeObjectWatcher:(id)anObject {
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self];
    NSRange range = NSMakeRange([self indexOfObject:anObject], 1);
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:NO];
    [self removeObjectWatcher:anObject];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:tempArr forKey:APSContainer_Param_OriginalArray];
    [param setObject:self forKey:APSContainer_Param_CurrentArray];
    [param setObject:[NSValue valueWithRange:range] forKey:APSContainer_Param_DeletedRange];
    [[APSContainerWatcher sharedInstance] dealEvent:APSContainerEvent_Array_objectRemoved param:param];
}

- (void)removeObjectWatcher:(id)anObject inRange:(NSRange)range {
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self];
    NSRange range1 = NSMakeRange([self indexOfObject:anObject inRange:range], 1);
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:NO];
    [self removeObjectWatcher:anObject inRange:range];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:tempArr forKey:APSContainer_Param_OriginalArray];
    [param setObject:self forKey:APSContainer_Param_CurrentArray];
    [param setObject:[NSValue valueWithRange:range1] forKey:APSContainer_Param_DeletedRange];
    [[APSContainerWatcher sharedInstance] dealEvent:APSContainerEvent_Array_objectRemoved param:param];
}

- (void)removeAllObjectsWatcher {
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self];
    NSRange range1 = NSMakeRange(0, self.count);
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:NO];
    [self removeAllObjectsWatcher];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:tempArr forKey:APSContainer_Param_OriginalArray];
    [param setObject:self forKey:APSContainer_Param_CurrentArray];
    [param setObject:[NSValue valueWithRange:range1] forKey:APSContainer_Param_DeletedRange];
    [[APSContainerWatcher sharedInstance] dealEvent:APSContainerEvent_Array_objectRemoved param:param];
}

- (void)removeObjectIdenticalToWatcher:(id)anObject {
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self];
    NSRange range = NSMakeRange([self indexOfObjectIdenticalTo:anObject], 1);
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:NO];
    [self removeObjectIdenticalToWatcher:anObject];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:tempArr forKey:APSContainer_Param_OriginalArray];
    [param setObject:self forKey:APSContainer_Param_CurrentArray];
    [param setObject:[NSValue valueWithRange:range] forKey:APSContainer_Param_DeletedRange];
    [[APSContainerWatcher sharedInstance] dealEvent:APSContainerEvent_Array_objectRemoved param:param];
}

- (void)removeObjectIdenticalToWatcher:(id)anObject inRange:(NSRange)range {
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self];
    NSRange range1 = NSMakeRange([self indexOfObjectIdenticalTo:anObject inRange:range], 1);
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:NO];
    [self removeObjectIdenticalToWatcher:anObject inRange:range];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:tempArr forKey:APSContainer_Param_OriginalArray];
    [param setObject:self forKey:APSContainer_Param_CurrentArray];
    [param setObject:[NSValue valueWithRange:range1] forKey:APSContainer_Param_DeletedRange];
    [[APSContainerWatcher sharedInstance] dealEvent:APSContainerEvent_Array_objectRemoved param:param];
}

- (void)removeObjectsInArrayWatcher:(NSArray *)otherArray {
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:NO];
    [self removeObjectsInArrayWatcher:otherArray];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:tempArr forKey:APSContainer_Param_OriginalArray];
    [param setObject:self forKey:APSContainer_Param_CurrentArray];
    [[APSContainerWatcher sharedInstance] dealEvent:APSContainerEvent_Array_objectRemoved param:param];
}

- (void)removeObjectsInRangeWatcher:(NSRange)range {
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:NO];
    [self removeObjectsInRangeWatcher:range];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:tempArr forKey:APSContainer_Param_OriginalArray];
    [param setObject:self forKey:APSContainer_Param_CurrentArray];
    [param setObject:[NSValue valueWithRange:range] forKey:APSContainer_Param_DeletedRange];
    [[APSContainerWatcher sharedInstance] dealEvent:APSContainerEvent_Array_objectRemoved param:param];
}

- (void)removeObjectsAtIndexesWatcher:(NSIndexSet *)indexes {
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self];
    NSRange range = NSMakeRange(indexes.firstIndex, indexes.firstIndex-indexes.lastIndex+1);
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:NO];
    [self removeObjectsAtIndexesWatcher:indexes];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:tempArr forKey:APSContainer_Param_OriginalArray];
    [param setObject:self forKey:APSContainer_Param_CurrentArray];
    [param setObject:[NSValue valueWithRange:range] forKey:APSContainer_Param_DeletedRange];
    [[APSContainerWatcher sharedInstance] dealEvent:APSContainerEvent_Array_objectRemoved param:param];
}


@end



#pragma mark 字典的替换 API
@interface NSMutableDictionary (containerWatcher)

@end

@implementation NSMutableDictionary (containerWatcher)

- (void)setObjectWatcher:(id)anObject forKey:(id<NSCopying>)aKey {
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:self];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:NO];
    [self setObjectWatcher:anObject forKey:aKey];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectWatcher:tempDic forKey:APSContainer_Param_OriginalDictionary];
    [param setObjectWatcher:self forKey:APSContainer_Param_CurrentDictionary];
    [[APSContainerWatcher sharedInstance] dealEvent:APSContainerEvent_Dictionary_replace param:param];
    
}

- (void)addEntriesFromDictionaryWatcher:(NSDictionary *)otherDictionary {
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:self];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:NO];
    [self addEntriesFromDictionaryWatcher:otherDictionary];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:tempDic forKey:APSContainer_Param_OriginalDictionary];
    [param setObject:self forKey:APSContainer_Param_CurrentDictionary];
    [[APSContainerWatcher sharedInstance] dealEvent:APSContainerEvent_Dictionary_newSet param:param];
    
}

- (void)removeObjectForKeyWatcher:(id)aKey {
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:self];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:NO];
    [self removeObjectForKeyWatcher:aKey];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:tempDic forKey:APSContainer_Param_OriginalDictionary];
    [param setObject:self forKey:APSContainer_Param_CurrentDictionary];
    [[APSContainerWatcher sharedInstance] dealEvent:APSContainerEvent_Dictionary_removed param:param];
    
}

- (void)removeObjectsForKeysWatcher:(NSArray *)keyArray {
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:self];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:NO];
    [self removeObjectsForKeysWatcher:keyArray];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:tempDic forKey:APSContainer_Param_OriginalDictionary];
    [param setObject:self forKey:APSContainer_Param_CurrentDictionary];
    [[APSContainerWatcher sharedInstance] dealEvent:APSContainerEvent_Dictionary_removed param:param];
}

- (void)removeAllObjectsWatcher {
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:self];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:NO];
    [self removeAllObjectsWatcher];
    [[APSContainerWatcher sharedInstance] setWatcherEnabled:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:tempDic forKey:APSContainer_Param_OriginalDictionary];
    [param setObject:self forKey:APSContainer_Param_CurrentDictionary];
    [[APSContainerWatcher sharedInstance] dealEvent:APSContainerEvent_Dictionary_removed param:param];
}


@end

@interface APSContainerWatcherObject : NSObject {
    
}

//@property   (nonatomic, assign)     id<APSContainerWatcherDelegate>  observer;  //监听者
@property   (nonatomic, assign)     NSMutableArray      *observerArr;
@property   (nonatomic, assign)     NSMutableArray      *watchedArrayObject;
@property   (nonatomic, assign)     NSMutableDictionary *watchedDicObject;

@end

@implementation APSContainerWatcherObject

- (id)init {
    if (self = [super init]) {
        self.observerArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_observerArr release];
    
    [super dealloc];
}


@end

@implementation APSContainerWatcher


+ (id)sharedInstance {
    static  APSContainerWatcher     *s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [[APSContainerWatcher alloc] init];
        
    });
    return s_instance;
}

- (void)dealloc {
    [_containerArr release];
    
    [super dealloc];
}

- (id)init {
    if (self = [super init]) {
        _containerArr = [[NSMutableArray alloc] init];
        _bEnabled = YES;
        [self initSwizzleMethods];
    }
    
    return self;
}

- (void)initSwizzleMethods {
    
    [NSMutableArray swizzleMethod:@selector(addObject:) origClass:@"__NSArrayM" withMethod:@selector(addObjectWatcher:) targetClass:@"NSMutableArray"];
    [NSMutableArray swizzleMethod:@selector(insertObject:atIndex:) origClass:@"__NSArrayM" withMethod:@selector(insertObjectWatcher:atIndex:) targetClass:@"NSMutableArray"];
    [NSMutableArray swizzleMethod:@selector(addObjectsFromArray:) origClass:@"__NSArrayM" withMethod:@selector(addObjectsFromArrayWatcher:) targetClass:@"NSMutableArray"];
    [NSMutableArray swizzleMethod:@selector(insertObjects:atIndexes:) origClass:@"__NSArrayM" withMethod:@selector(insertObjectsWatcher:atIndexes:) targetClass:@"NSMutableArray"];
    [NSMutableArray swizzleMethod:@selector(replaceObjectAtIndex:withObject:) origClass:@"__NSArrayM" withMethod:@selector(replaceObjectAtIndexWatcher:withObject:) targetClass:@"NSMutableArray"];
    [NSMutableArray swizzleMethod:@selector(exchangeObjectAtIndex:withObjectAtIndex:) origClass:@"__NSArrayM" withMethod:@selector(exchangeObjectAtIndexWatcher:withObjectAtIndex:) targetClass:@"NSMutableArray"];
    [NSMutableArray swizzleMethod:@selector(replaceObjectsInRange:withObjectsFromArray:) origClass:@"__NSArrayM" withMethod:@selector(replaceObjectsInRangeWatcher:withObjectsFromArray:) targetClass:@"NSMutableArray"];
    [NSMutableArray swizzleMethod:@selector(replaceObjectsInRange:withObjectsFromArray:range:) origClass:@"__NSArrayM" withMethod:@selector(replaceObjectsInRangeWatcher:withObjectsFromArray:range:) targetClass:@"NSMutableArray"];
    [NSMutableArray swizzleMethod:@selector(replaceObjectsAtIndexes:withObjects:) origClass:@"__NSArrayM" withMethod:@selector(replaceObjectsAtIndexesWatcher:withObjects:) targetClass:@"NSMutableArray"];
    [NSMutableArray swizzleMethod:@selector(setObject:atIndexedSubscript:) origClass:@"__NSArrayM" withMethod:@selector(setObjectWatcher:atIndexedSubscript:) targetClass:@"NSMutableArray"];
    
    [NSMutableArray swizzleMethod:@selector(removeLastObject) origClass:@"__NSArrayM" withMethod:@selector(removeLastObjectWatcher) targetClass:@"NSMutableArray"];
    [NSMutableArray swizzleMethod:@selector(removeObjectAtIndex:) origClass:@"__NSArrayM" withMethod:@selector(removeObjectAtIndexWatcher:) targetClass:@"NSMutableArray"];
    [NSMutableArray swizzleMethod:@selector(removeObject:) origClass:@"__NSArrayM" withMethod:@selector(removeObjectWatcher:) targetClass:@"NSMutableArray"];
    [NSMutableArray swizzleMethod:@selector(removeObject:inRange:) origClass:@"__NSArrayM" withMethod:@selector(removeObjectWatcher:inRange:) targetClass:@"NSMutableArray"];
    [NSMutableArray swizzleMethod:@selector(removeAllObjects) origClass:@"__NSArrayM" withMethod:@selector(removeAllObjectsWatcher) targetClass:@"NSMutableArray"];
    [NSMutableArray swizzleMethod:@selector(removeObjectsInArray:) origClass:@"__NSArrayM" withMethod:@selector(removeObjectsInArrayWatcher:) targetClass:@"NSMutableArray"];
    [NSMutableArray swizzleMethod:@selector(removeObjectsInRange:) origClass:@"__NSArrayM" withMethod:@selector(removeObjectsInRangeWatcher:) targetClass:@"NSMutableArray"];
    [NSMutableArray swizzleMethod:@selector(removeObjectsAtIndexes:) origClass:@"__NSArrayM" withMethod:@selector(removeObjectsAtIndexesWatcher:) targetClass:@"NSMutableArray"];
    [NSMutableArray swizzleMethod:@selector(removeObjectIdenticalTo:) origClass:@"__NSArrayM" withMethod:@selector(removeObjectIdenticalToWatcher:) targetClass:@"NSMutableArray"];
    [NSMutableArray swizzleMethod:@selector(removeObjectIdenticalTo:inRange:) origClass:@"__NSArrayM" withMethod:@selector(removeObjectIdenticalToWatcher:inRange:) targetClass:@"NSMutableArray"];
    
    //字典类型
    [NSMutableDictionary swizzleMethod:@selector(removeObjectForKey:) origClass:@"__NSDictionaryM" withMethod:@selector(removeObjectForKeyWatcher:) targetClass:@"NSMutableDictionary"];
    [NSMutableDictionary swizzleMethod:@selector(setObject:forKey:) origClass:@"__NSDictionaryM" withMethod:@selector(setObjectWatcher:forKey:) targetClass:@"NSMutableDictionary"];
    [NSMutableDictionary swizzleMethod:@selector(addEntriesFromDictionary:) origClass:@"__NSDictionaryM" withMethod:@selector(addEntriesFromDictionaryWatcher:) targetClass:@"NSMutableDictionary"];
    [NSMutableDictionary swizzleMethod:@selector(removeObjectsForKeys:) origClass:@"__NSDictionaryM" withMethod:@selector(removeObjectsForKeysWatcher:) targetClass:@"NSMutableDictionary"];
    [NSMutableDictionary swizzleMethod:@selector(removeAllObjects) origClass:@"__NSDictionaryM" withMethod:@selector(removeAllObjectsWatcher) targetClass:@"NSMutableDictionary"];
}


#pragma mark 监听管理相关 API

- (void)addContainerObserver:(id)container observer:(id<APSContainerWatcherDelegate>)observer {
    if (!container || !observer) {
        return;
    }
    //只支持数组和字典
    if (![container isKindOfClass:[NSMutableArray class]]
        && ![container isKindOfClass:[NSMutableDictionary class]]) {
        return;
    }
    
    @synchronized(_containerArr) {
        BOOL bAlreadyWatched = NO;
        for (APSContainerWatcherObject *object in _containerArr) {
            //已经监听该容器了，监听者加入队列
            if (object.watchedArrayObject == container ||
                object.watchedDicObject == container) {
                if (![object.observerArr containsObject:observer]) {
                    [object.observerArr addObject:observer];
                }
                bAlreadyWatched = YES;
                break;
            }
        }
        
        //新的容器需要监听
        if (!bAlreadyWatched) {
            APSContainerWatcherObject *object = [[APSContainerWatcherObject alloc] init];
            if ([container isKindOfClass:[NSMutableArray class]]) {
                object.watchedArrayObject = container;
            }
            else if ([container isKindOfClass:[NSMutableDictionary class]]) {
                object.watchedDicObject = container;
            }
            [object.observerArr addObject:observer];
            [_containerArr addObject:object];
            [object release];
        }
    }
}


- (void)removeContainerObserver:(id)container observer:(id<APSContainerWatcherDelegate>)observer {
    if (!container || !observer) {
        return;
    }
    //只支持数组和字典
    if (![container isKindOfClass:[NSMutableArray class]]
        && ![container isKindOfClass:[NSMutableDictionary class]]) {
        return;
    }
    
    @synchronized(_containerArr) {
        for (APSContainerWatcherObject *object in _containerArr) {
            //已经监听该容器了，移除这个监听者
            if (object.watchedArrayObject == container ||
                object.watchedDicObject == container) {
                if ([object.observerArr containsObject:observer]) {
                    [object.observerArr removeObject:observer];
                }
                break;
            }
        }
    }
}


- (void)removeContainerObservers:(id)container {
    if (!container) {
        return;
    }
    //只支持数组和字典
    if (![container isKindOfClass:[NSMutableArray class]]
        && ![container isKindOfClass:[NSMutableDictionary class]]) {
        return;
    }
    
    @synchronized(_containerArr) {
        for (APSContainerWatcherObject *object in _containerArr) {
            //已经监听该容器了，移除这个容器所有监听者
            if (object.watchedArrayObject == container ||
                object.watchedDicObject == container) {
                [_containerArr removeObject:object];
                break;
            }
        }
    }
}

#pragma mark 已监控的对像信息管理
- (void)setWatcherEnabled:(BOOL)enabled {
    _bEnabled = enabled;
}

- (void)dealEvent:(APSContainerEvent)event param:(NSDictionary*)param {
    if (!_bEnabled) {
        return;
    }
    
    switch (event) {
        case APSContainerEvent_Array_objectAdded:
        case APSContainerEvent_Array_objectReplaced:
        case APSContainerEvent_Array_objectRemoved: {
            @synchronized(_containerArr) {
                NSArray *container = param[APSContainer_Param_CurrentArray];
                for (APSContainerWatcherObject *object in _containerArr) {
                    //找到监听者，通知他们
                    if (object.watchedArrayObject == container) {
                        for (id<APSContainerWatcherDelegate> observer in object.observerArr) {
                            if (observer && [observer respondsToSelector:@selector(watchedForContainer:event:context:)]) {
                                [observer watchedForContainer:container event:event context:param];
                            }
                        }
                        break;
                    }
                }
            }
            break;
        }
        case APSContainerEvent_Dictionary_newSet:
        case APSContainerEvent_Dictionary_replace:
        case APSContainerEvent_Dictionary_removed: {
            @synchronized(_containerArr) {
                NSDictionary *container = param[APSContainer_Param_CurrentDictionary];
                for (APSContainerWatcherObject *object in _containerArr) {
                    //找到监听者，通知他们
                    if (object.watchedDicObject == container) {
                        for (id<APSContainerWatcherDelegate> observer in object.observerArr) {
                            if (observer && [observer respondsToSelector:@selector(watchedForContainer:event:context:)]) {
                                [observer watchedForContainer:container event:event context:param];
                            }
                        }
                        break;
                    }
                }
            }
            break;
        }
        default:
            break;
    }
}


@end
