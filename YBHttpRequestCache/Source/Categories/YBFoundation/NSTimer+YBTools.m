//
//  NSTimer+YBTools.m
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/8.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import "NSTimer+YBTools.h"

@implementation NSTimer (YBTools)
+ (void)_yb_ExecBlock:(NSTimer *)timer {
    if ([timer userInfo]) {
        void (^block)(NSTimer *timer) = (void (^)(NSTimer *timer))[timer userInfo];
        block(timer);
    }
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(_yb_ExecBlock:) userInfo:[block copy] repeats:repeats];
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(_yb_ExecBlock:) userInfo:[block copy] repeats:repeats];
}
@end
