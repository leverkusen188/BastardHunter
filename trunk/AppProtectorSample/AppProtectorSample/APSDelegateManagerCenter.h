//
//  DelegateManagerCenter.h
//  AppProtectorSample
//
//  Created by Jianghui Liu on 14-5-23.
//  Copyright (c) 2014年 cn. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (delegateSetter)
- (void)setMyDelegate:(NSString*)delegateName delegate:(id)delegate;
@end

@interface APSDelegateRelation : NSObject

@property   (nonatomic, assign)     id  sourceObject;
@property   (nonatomic, assign)     id  delegate;
@property   (nonatomic, copy)       NSString    *delegateName;


@end

@protocol APSDelegateManagerCenterDelegate <NSObject>

@optional
//通知对应的delegate对象被销毁了，在当前runloop中，delegate还是可用的
- (void)delegateDealloced:(NSString*)delegateName delegate:(id)delegate;

@end

@interface APSDelegateManagerCenter : NSObject {
    NSMutableArray      *relationArr;
}
+ (APSDelegateManagerCenter*)sharedInstance;

- (void)insertRelation:(id)sourceObject delegate:(id)delegate delegateName:(NSString*)delegateName;

@end
