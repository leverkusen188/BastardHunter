//
//  NSObject+appSuperProtecter.h
//  TestMap
//
//  Created by Jianghui Liu on 14-3-25.
//  Copyright (c) 2014年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *_OBJECTIVE_OBJECT_DEALLOCED;

@interface NSObject (appSuperProtecter)
+ (BOOL)swizzleClassMethod:(SEL)origSel withClassMethod:(SEL)altSel;
+ (BOOL)swizzleMethod:(SEL)origSel withMethod:(SEL)altSel;
+ (BOOL)swizzleMethod:(SEL)origSel origClass:(NSString*)origClassName withMethod:(SEL)altSel targetClass:(NSString*)newClassName;
@end

@interface NSArray (deadlyApiReplacement)
- (id)objectAtIndexMirror:(NSUInteger)index;
+ (instancetype)arrayWithObjectMirror:(id)anObject;

@end

@interface NSMutableArray (deadlyApiReplacement)
- (void)addObjectMirror:(id)anObject;
- (void)insertObjectMirror:(id)anObject atIndex:(NSUInteger)index;
- (void)removeObjectAtIndexMirror:(NSUInteger)index;
- (void)replaceObjectAtIndexMirror:(NSUInteger)index withObject:(id)anObject;
@end


@interface NSDictionary (deadlyApiReplacement)
+ (instancetype)dictionaryWithObjectMirror:(id)object forKey:(id <NSCopying>)key;

@end

@interface NSMutableDictionary (deadlyApiReplacement)
- (void)setObjectMirror:(id)anObject forKey:(id <NSCopying>)aKey;
- (void)removeObjectForKeyMirror:(id)aKey;
@end



