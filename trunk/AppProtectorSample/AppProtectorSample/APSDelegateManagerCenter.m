//
//  DelegateManagerCenter.m
//  AppProtectorSample
//
//  Created by Jianghui Liu on 14-5-23.
//  Copyright (c) 2014年 cn. All rights reserved.
//

#import "APSDelegateManagerCenter.h"

#import "NSObject+appSuperProtecter.h"


static APSDelegateManagerCenter *s_delegateCenter = nil;


@implementation NSObject (delegateSetter)
- (void)setMyDelegate:(NSString*)delegateName delegate:(id)delegate {
    if ([delegateName length] <= 1)
        return;
    //取得setter方法
    NSString *firstLetter = [[delegateName substringToIndex:1] uppercaseString];
    NSString *leftLetters = [delegateName substringFromIndex:1];
    NSString *methodName = [NSString stringWithFormat:@"set%@%@:", firstLetter, leftLetters];
    SEL selector = NSSelectorFromString(methodName);
    if ([self respondsToSelector:selector] && selector) {
        [self performSelector:selector withObject:delegate];
    }
    
    [[APSDelegateManagerCenter sharedInstance] insertRelation:self delegate:delegate delegateName:delegateName];
}

@end

@implementation APSDelegateRelation

- (void)dealloc {
    self.delegateName   = nil;
    [super dealloc];
}

@end


@implementation APSDelegateManagerCenter

+ (APSDelegateManagerCenter*)sharedInstance {
    static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        s_delegateCenter = [APSDelegateManagerCenter new];
        [NSObject swizzleMethod:@selector(dealloc) origClass:@"NSObject" withMethod:@selector(mirrorDealloc) targetClass:@"NSObject"];
	});
    return s_delegateCenter;
}

- (id)init {
    if (self = [super init]) {
        relationArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)somebodyDealloc:(id)object {
    [self destroyRelation:object];
    
}

#pragma mark RELATION-Manager
- (void)insertRelation:(id)sourceObject delegate:(id)delegate delegateName:(NSString*)delegateName {
    if (!sourceObject || !delegate) {
        return;
    }
    APSDelegateRelation *relation = [self getRelaton:sourceObject delegateName:delegateName];
    BOOL ifExisted = relation?YES:NO;
    if (!relation) {
        relation = [[APSDelegateRelation new] autorelease];
    }
    relation.sourceObject   = sourceObject;
    relation.delegate       = delegate;
    relation.delegateName   = delegateName;
    if (!ifExisted) {
        [relationArr addObject:relation];
    }
}

- (APSDelegateRelation*)getRelaton:(id)sourceObject delegateName:(NSString*)delegateName {
    for (APSDelegateRelation *relation in relationArr) {
        id _source = relation.sourceObject;
        NSString *_delegateName = relation.delegateName;
        if (_source == sourceObject && [_delegateName isEqualToString:delegateName]) {
            return relation;
        }
    }
    return nil;
}

- (void)destroyRelation:(id)object {
    @synchronized(relationArr) {
        for (int i = [relationArr count] - 1; i >= 0; i --) {
            APSDelegateRelation *relation = [relationArr objectAtIndex:i];
            //如果是source对象，则整个关系移除
            if (object == relation.sourceObject) {
                [relationArr removeObject:relation];
            }
            else if (object == relation.delegate) {  //delegate浮空
                id source = relation.sourceObject;
                [source setMyDelegate:relation.delegateName delegate:nil];
            }
        }
    }
}


@end
