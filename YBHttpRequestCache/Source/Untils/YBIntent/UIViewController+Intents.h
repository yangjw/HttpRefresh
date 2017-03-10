//
//  UIViewController+Intents.h
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/9.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBIntent;
@interface UIViewController (Intents)

/**
 *  父控制导航栏  Push 跳转，反之presentation
 *
 *  @param intent intent ： 自己设置跳转方式
 */
- (void)startController:(YBIntent *)intent;

/** push跳转  */
- (void)pushController:(YBIntent *)intent;

/**
 *  默认跳转方式 presentation
 *
 *  @param intent      跳转的对象
 *  @param requestCode 回调code
 */
- (void)startControllerForResult:(YBIntent *)intent requestCode:(NSNumber *)requestCode;

/**
 *  push
 *
 *  @param intent      跳转的对象
 *  @param requestCode 回调code
 */
- (void)pushControllerForResult:(YBIntent *)intent requestCode:(NSNumber *)requestCode;

@end
