//
//  NSObject+appSuperProtecter.m
//  TestMap
//
//  Created by Jianghui Liu on 14-3-25.
//  Copyright (c) 2014年 com. All rights reserved.
//

#import "NSObject+appSuperProtecter.h"
#import <objc/runtime.h>
#import "APSDelegateManagerCenter.h"

NSString *_OBJECTIVE_OBJECT_DEALLOCED = @"objectiveObjectDealloced";

@implementation NSObject (appSuperProtecter)
#pragma mark METHOD-SWIZZLE
+ (BOOL)swizzleMethod:(SEL)origSel origClass:(NSString*)origClassName withMethod:(SEL)altSel targetClass:(NSString*)newClassName
{

    Class newMethodCls = NSClassFromString(newClassName);
    Class originalCls = NSClassFromString(origClassName);
    if (!newMethodCls || !originalCls)
        return NO;
    Method originMethod = class_getInstanceMethod(originalCls, origSel);
    Method newMethod = class_getInstanceMethod(newMethodCls, altSel);
    
    if (originMethod && newMethod) {
        //2012年5月更新
        if (class_addMethod(originalCls, origSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
            class_replaceMethod(originalCls, altSel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
        } else {
            method_exchangeImplementations(originMethod, newMethod);
        }
        return YES;
    }
    return NO;
}

+ (BOOL)swizzleMethod:(SEL)origSel withMethod:(SEL)altSel
{
    Method originMethod = class_getInstanceMethod(self, origSel);
    Method newMethod = class_getInstanceMethod(self, altSel);
    
    if (originMethod && newMethod) {
        if (class_addMethod(self, origSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
            class_replaceMethod(self, altSel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
        } else {
            method_exchangeImplementations(originMethod, newMethod);
        }
        return YES;
    }
    return NO;
}

+ (BOOL)swizzleClassMethod:(SEL)origSel withClassMethod:(SEL)altSel
{
    Class c = object_getClass((id)self);
    return [c swizzleMethod:origSel withMethod:altSel];
}

+ (void)load {
    [self swizzleMethod:@selector(methodSignatureForSelector:) withMethod:@selector(methodSignatureForSelectorMirror:)];
    [self swizzleMethod:@selector(forwardInvocation:) withMethod:@selector(forwardInvocationMirror:)];
    [self swizzleMethod:@selector(doesNotRecognizeSelector:) withMethod:@selector(doesNotRecognizeSelectorMirror:)];
    
    
//    [self swizzleMethod:@selector(mirrorDealloc) withMethod:@selector(dealloc)];
    //testcode
    [NSObject swizzleClassMethod:@selector(resolveInstanceMethod:) withClassMethod:@selector(resolveInstanceMethodMirror:)];
    //bad param api replacement
    [NSArray swizzleMethod:@selector(objectAtIndex:) origClass:@"__NSArrayI" withMethod:@selector(objectAtIndexMirror:) targetClass:@"NSArray"];
    [NSArray swizzleClassMethod:@selector(arrayWithObject:) withClassMethod:@selector(arrayWithObjectMirror:)];
    
    
    [NSMutableArray swizzleMethod:@selector(addObject:) origClass:@"__NSArrayM" withMethod:@selector(addObjectMirror:) targetClass:@"NSMutableArray"];
    [NSMutableArray swizzleMethod:@selector(objectAtIndex:) origClass:@"__NSArrayM" withMethod:@selector(objectAtIndexMirror:) targetClass:@"NSMutableArray"];
    [NSMutableArray swizzleMethod:@selector(insertObject:atIndex:) origClass:@"__NSArrayM" withMethod:@selector(insertObjectMirror:atIndex:) targetClass:@"NSMutableArray"];
    [NSMutableArray swizzleMethod:@selector(removeObjectAtIndex:) origClass:@"__NSArrayM" withMethod:@selector(removeObjectAtIndexMirror:) targetClass:@"NSMutableArray"];
    [NSMutableArray swizzleMethod:@selector(replaceObjectAtIndex:withObject:) origClass:@"__NSArrayM" withMethod:@selector(replaceObjectAtIndexMirror:withObject:) targetClass:@"NSMutableArray"];
    
    
    [NSDictionary swizzleClassMethod:@selector(dictionaryWithObject:forKey:) withClassMethod:@selector(dictionaryWithObjectMirror:forKey:)];
    
    [NSMutableDictionary swizzleMethod:@selector(setObject:forKey:) origClass:@"__NSDictionaryM" withMethod:@selector(setObjectMirror:forKey:) targetClass:@"NSMutableDictionary"];
    [NSMutableDictionary swizzleMethod:@selector(removeObjectForKey:) origClass:@"__NSDictionaryM" withMethod:@selector(removeObjectForKeyMirror:) targetClass:@"NSMutableDictionary"];
}

#pragma mark UNRECOGNIZED-SELECTOR-INSIDE-JOB
- (void)errorHandlingWithUnrecognizedSelector:(SEL)aSelector {
    //print call stack log
    [self printUnrecognizedSelectorLog:aSelector];
    //do your UI alert in main thread
    [self UIAlert:@""];
}

- (void)UIAlert:(NSString*)msg {
    //do your UI alert in main thread
    dispatch_async(dispatch_get_main_queue(), ^{
//#ifdef DEBUG_MODE
//        [GlobalTools showMessageBox:@"致命错误" content:msg cancelBtn:@"确定"];
//#endif
    });
}

- (void)printUnrecognizedSelectorLog:(SEL)aSelector
{
    NSLog(@"*****************printCallStack begin**************");
    NSLog(@"unrecognized selector [%@] sent to the object of class [%@]", NSStringFromSelector(aSelector), [self class]);
    NSArray* callStack = [NSThread callStackSymbols];
    for (NSString* symbol in callStack)
    {
        NSLog(@"%s", [symbol UTF8String]);
    }
    NSLog(@"*****************printCallStack end**************");
}

- (void)forwardInvocationMirror:(NSInvocation *)anInvocation {
    SEL selector = [anInvocation selector];
    //just leave it to the error handler.
    [self errorHandlingWithUnrecognizedSelector:selector];
    
}

- (void)doesNotRecognizeSelectorMirror:(SEL)aSelector {
    [self doesNotRecognizeSelectorMirror:aSelector];
}

void dynamicMethodIMP(id self, SEL _cmd, ...)
{
    
}

- (NSMethodSignature*)addMethodForParamCount:(NSString*)lostMethod {
    class_addMethod([self class], NSSelectorFromString(lostMethod), (IMP) dynamicMethodIMP, "v@:");
    NSMethodSignature *sig = [self methodSignatureForSelector:NSSelectorFromString(lostMethod)];
    return sig;
}

- (NSMethodSignature *)methodSignatureForSelectorMirror:(SEL)aSelector
{
    //just return an available selector.
    if ([self respondsToSelector:aSelector]) {
        return [self methodSignatureForSelectorMirror:aSelector];
    }
    NSMethodSignature *returnMethod = [self methodSignatureForSelectorMirror:aSelector];
    if (returnMethod)
        return returnMethod;
    //return the method signature with the same count of param.
    NSString *selectorStr = NSStringFromSelector(aSelector);
    return [self addMethodForParamCount:selectorStr];
}


- (void)mirrorDealloc {
    [[APSDelegateManagerCenter sharedInstance] performSelector:@selector(somebodyDealloc:) withObject:self];
//    [[NSNotificationCenter defaultCenter] postNotificationName:_OBJECTIVE_OBJECT_DEALLOCED object:self userInfo:nil];
    [self mirrorDealloc];
}

+ (BOOL)resolveInstanceMethodMirror:(SEL)aSelector {
//    NSLog(@"selector=======%@", NSStringFromSelector(aSelector));
    return YES;
}

#pragma mark BAD-PARAM-INSIDE-JOB
- (void)errorHandlingWithBadParam:(SEL)aSelector params:(NSArray*)params {
    //print call stack log
    [self printBadParamLog:aSelector params:params];
    //do your UI alert in main thread
    [self UIAlert:@""];
}



- (void)printBadParamLog:(SEL)aSelector params:(NSArray*)params
{
    NSLog(@"*****************printCallStack begin**************");
    NSLog(@"bad param [%@] in selector [%@] to the object of class [%@]", params, NSStringFromSelector(aSelector), [self class]);
    NSArray* callStack = [NSThread callStackSymbols];
    for (NSString* symbol in callStack)
    {
        NSLog(@"%s", [symbol UTF8String]);
    }
    NSLog(@"*****************printCallStack end**************");
}

@end

@implementation NSArray (deadlyApiReplacement)
- (id)objectAtIndexMirror:(NSUInteger)index {
    //input checking
    if (index >= [self count]) {
        //also sent the param to the handler
        NSArray *params = [NSArray arrayWithObject:[NSNumber numberWithUnsignedInteger:index]];
        [self errorHandlingWithBadParam:@selector(objectAtIndex:) params:params];
        return nil;
    }
    return [self objectAtIndexMirror:index];
}


+ (instancetype)arrayWithObjectMirror:(id)anObject {
    if (!anObject) {
        NSArray *params = [NSArray arrayWithObjectMirror:[NSNull null]];
        [self errorHandlingWithBadParam:@selector(arrayWithObjectMirror:) params:params];
        return nil;
    }
    return [self arrayWithObjectMirror:anObject];
}

@end

@implementation NSMutableArray (deadlyApiReplacement)
- (void)addObjectMirror:(id)anObject {
    if (!anObject) {
        NSArray *params = [NSArray arrayWithObject:[NSNull null]];
        [self errorHandlingWithBadParam:@selector(addObject:) params:params];
        return;
    }
    [self addObjectMirror:anObject];
}

- (id)objectAtIndexMirror:(NSUInteger)index {
    //input checking
    if (index >= [self count]) {
        //also sent the param to the handler
        NSArray *params = [NSArray arrayWithObject:[NSNumber numberWithUnsignedInteger:index]];
        [self errorHandlingWithBadParam:@selector(objectAtIndex:) params:params];
        return nil;
    }
    return [self objectAtIndexMirror:index];
}

- (void)insertObjectMirror:(id)anObject atIndex:(NSUInteger)index {
    if (!anObject || index > [self count]) {
        NSArray *params = [NSArray arrayWithObjects:[NSNull null], [NSNumber numberWithUnsignedInteger:index], nil];
        [self errorHandlingWithBadParam:@selector(insertObject:atIndex:) params:params];
        return;
    }
    [self insertObjectMirror:anObject atIndex:index];
}


- (void)removeObjectAtIndexMirror:(NSUInteger)index {
    if (index >= [self count]) {
        NSArray *params = [NSArray arrayWithObjects:[NSNumber numberWithUnsignedInteger:index], nil];
        [self errorHandlingWithBadParam:@selector(removeObjectAtIndexMirror:) params:params];
        return;
    }
    [self removeObjectAtIndexMirror:index];
}


- (void)replaceObjectAtIndexMirror:(NSUInteger)index withObject:(id)anObject {
    if (index >= [self count] || anObject == nil) {
        NSMutableArray *params = [NSMutableArray arrayWithObjects:[NSNumber numberWithUnsignedInteger:index], nil];
        [params addObject:anObject?anObject:[NSNull null]];
        [self errorHandlingWithBadParam:@selector(replaceObjectAtIndexMirror:withObject:) params:params];
        return;
    }
    [self replaceObjectAtIndexMirror:index withObject:anObject];
}


@end

@implementation NSDictionary (deadlyApiReplacement)

+ (instancetype)dictionaryWithObjectMirror:(id)object forKey:(id <NSCopying>)key {
    if (!object || !key) {
        NSMutableArray *params = [NSMutableArray array];
        [params addObject:object?object:[NSNull null]];
        [params addObject:key?key:[NSNull null]];
        [self errorHandlingWithBadParam:@selector(dictionaryWithObject:forKey:) params:params];
        return nil;
    }
    return [self dictionaryWithObjectMirror:object forKey:key];
}

@end

@implementation NSMutableDictionary (deadlyApiReplacement)

- (void)setObjectMirror:(id)anObject forKey:(id <NSCopying>)aKey {
    if (anObject == nil || aKey == nil) {
        NSMutableArray *params = [NSMutableArray array];
        [params addObject:anObject?anObject:[NSNull null]];
        [params addObject:aKey?aKey:[NSNull null]];
        [self errorHandlingWithBadParam:@selector(setObject:forKey:) params:params];
        return;
    }
    [self setObjectMirror:anObject forKey:aKey];
}


- (void)removeObjectForKeyMirror:(id)aKey {
    if (aKey == nil) {
        NSMutableArray *params = [NSMutableArray array];
        [params addObject:aKey?aKey:[NSNull null]];
        [self errorHandlingWithBadParam:@selector(removeObjectForKey:) params:params];
        return;
    }
    [self removeObjectForKeyMirror:aKey];
}




@end
