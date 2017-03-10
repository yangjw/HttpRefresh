//
//  UINavigationController+StatusBarStyle.m
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/13.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import "UINavigationController+StatusBarStyle.h"

@implementation UINavigationController (StatusBarStyle)
- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.visibleViewController;
}
- (UIViewController *)childViewControllerForStatusBarHidden
{
    return self.visibleViewController;
}

@end

