//
//  UIApplication+YBTools.h
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/9.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (YBTools)
+ (UIViewController *)visibleViewController;
+ (UIViewController *)topViewController:(UIViewController *)parent;
@end
