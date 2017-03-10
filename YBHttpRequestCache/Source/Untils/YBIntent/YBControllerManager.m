//
//  YBControllerManager.m
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/9.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import "YBControllerManager.h"
#import "YBIntent.h"
#import "UIApplication+YBTools.h"


@implementation YBControllerManager

+ (instancetype)sharedInstance {
    static YBControllerManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[YBControllerManager alloc] init];
    });
    
    return _sharedInstance;
}


- (void)startIntent:(YBIntent *)intent
{
    UIViewController *souce = [UIApplication visibleViewController];
    [self startController:souce intent:intent];
}

- (void)startIntent:(YBIntent *)intent requestCode:(NSNumber *)requestCode
{
    UIViewController *souce = [UIApplication visibleViewController];
    [self startController:souce intent:intent requestCode:requestCode];
}

- (void)startController:(UIViewController *)source intent:(YBIntent *)intent
{
    UIViewController *viewController = [self controllerForIntentParams:intent];
    if (intent.controllerDisplay)
    {
        [intent.controllerDisplay displayViewControllerSource:source destination:viewController];
    }
    else
    {
        YBIntentPushDisplay *display = [[YBIntentPushDisplay alloc] init];
        [display displayViewControllerSource:source destination:viewController];
    }
}

- (void)startController:(UIViewController *)source intent:(YBIntent *)intent  requestCode:(NSNumber *)requestCode
{
    UIViewController *viewController = [self controllerForIntentParams:intent];
    
    if ([viewController conformsToProtocol:@protocol(YBIntentForResultReceivable)])
    {
        NSLog(@"----->%@",requestCode);
        [viewController performSelector:@selector(setRequestCode:) withObject:requestCode];
        [viewController performSelector:@selector(setDelegate:) withObject:source];
    }
    if (intent.controllerDisplay)
    {
        [intent.controllerDisplay displayViewControllerSource:source destination:viewController];
    }
    else
    {
        YBIntentPresentationDisplay *display = [[YBIntentPresentationDisplay alloc] init];
        [display displayViewControllerSource:source destination:viewController];
    }
}

- (UIViewController *)controllerForIntentParams:(YBIntent *)intent
{
    /**  类方法 */
    SEL controller_class_selector = sel_registerName("allocWithParams:");
    /** 实例方法  */
    SEL controller_selector = sel_registerName("initWithExtras:");
    UIViewController *controller = nil;
    Class controllerClass = intent.receiveClass;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([controllerClass respondsToSelector:controller_class_selector]) {
        controller = [controllerClass performSelector:controller_class_selector withObject:intent.extras];
    }
    else if ([intent.receiveClass instancesRespondToSelector:controller_selector]) {
        controller = [[intent.receiveClass alloc] performSelector:controller_selector withObject:intent.extras];
    }
//    else
//    {
//        controller = [[intent.receiveClass alloc] init];
//    }
#pragma clang diagnostic pop
    if (!controller)
    {
        if (_ignoresExceptions)
        {
            return controller;
        }
        @throw [NSException exceptionWithName:@"IntentInitializerNotFound"
                                       reason:[NSString stringWithFormat:@"你的控制器类%@需要实现%@静态方法或实例方法%@", NSStringFromClass(controllerClass), NSStringFromSelector(controller_class_selector),  NSStringFromSelector(controller_selector)]
                                     userInfo:nil];
    }
    return controller;
}


@end
