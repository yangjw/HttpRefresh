//
//  UIApplication+YBTools.m
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/9.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import "UIApplication+YBTools.h"

@implementation UIApplication (YBTools)

+ (UIViewController *)visibleViewController
{
    UIViewController *viewController = UIApplication.sharedApplication.delegate.window.rootViewController;
    return [self topViewController:viewController];
}

+ (UIViewController *)topViewController:(UIViewController *)parent {
    if (parent.presentedViewController) {
        return [self topViewController:parent.presentedViewController];
    }
    
    if ([parent isKindOfClass:UINavigationController.class]) {
        return [self topViewController:[(UINavigationController*)parent topViewController]];
    }
    
    if ([parent isKindOfClass:UITabBarController.class]) {
        return [self topViewController:[(UITabBarController*)parent selectedViewController]];
    }
    
    return parent;
}
@end
