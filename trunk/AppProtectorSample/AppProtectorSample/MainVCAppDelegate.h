//
//  MainVCAppDelegate.h
//  AppProtectorSample
//
//  Created by Jianghui Liu on 14-3-25.
//  Copyright (c) 2014年 cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APSContainerWatcher.h"

@interface MainVCAppDelegate : UIResponder <UIApplicationDelegate, APSContainerWatcherDelegate>

@property (strong, nonatomic) UIWindow *window;

@property   (nonatomic, retain) NSString    *hello;

@end
