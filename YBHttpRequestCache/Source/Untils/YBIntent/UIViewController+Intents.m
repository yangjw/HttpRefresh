//
//  UIViewController+Intents.m
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/9.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import "UIViewController+Intents.h"
#import "YBIntent.h"
#import "YBControllerManager.h"

@implementation UIViewController (Intents)

- (void)startController:(YBIntent *)intent
{
    [[YBControllerManager sharedInstance] startController:self intent:intent];
}

- (void)pushController:(YBIntent *)intent
{
    YBIntentPushDisplay *push = [[YBIntentPushDisplay alloc] init];
    intent.controllerDisplay = push;
    [[YBControllerManager sharedInstance] startController:self intent:intent];
}

-(void)startControllerForResult:(YBIntent *)intent requestCode:(NSNumber *)requestCode
{
    [[YBControllerManager sharedInstance] startController:self intent:intent requestCode:requestCode];
}

- (void)pushControllerForResult:(YBIntent *)intent requestCode:(NSNumber *)requestCode
{
    YBIntentPushDisplay *push = [[YBIntentPushDisplay alloc] init];
    intent.controllerDisplay = push;
    [[YBControllerManager sharedInstance] startController:self intent:intent requestCode:requestCode];
}

@end
