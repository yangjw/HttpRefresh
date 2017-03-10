//
//  YBMacros.h
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/8.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#ifndef YBMacros_h
#define YBMacros_h

#pragma mark - Device
// 系统
#define YBOS_6 ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)&&([[UIDevice currentDevice].systemVersion floatValue] < 7.0)

#define YBOS_7 ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)&&([[UIDevice currentDevice].systemVersion floatValue] < 8.0)

#define YBOS_8 ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)&&([[UIDevice currentDevice].systemVersion floatValue] < 9.0)

#define YBOS_9 ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)&&([[UIDevice currentDevice].systemVersion floatValue] < 10.0)

#pragma mark - Screen
//屏幕宽高
#define kYBScreenW [[UIScreen mainScreen] bounds].size.width
#define kYBScreenH [[UIScreen mainScreen] bounds].size.height
// 设备屏幕
#define YBWindowSize  [UIScreen mainScreen].applicationFrame.size

#define YBWindowWidth  [UIScreen mainScreen].applicationFrame.size.width

#define YBWindowHeight ([UIScreen mainScreen].applicationFrame.size.height+20)

#define YBiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define YBiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define YBiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define YBiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

// 一像素线
#define YBINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define YBINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)

#define kYBTabBarHeight 49.0f
#define kYBTopBarHeight 64.0f
#define kYBNavigationBarHeight 44.0f
#define kYBStatusBarHeight 20.0f

#define YBSharedApplication                   [UIApplication sharedApplication]
#define YBBundle                              [NSBundle mainBundle]
#define YBMainScreen                          [UIScreen mainScreen]

#define YBSelfNavBar                          self.navigationController.navigationBar
#define YBSelfTabBar                          self.tabBarController.tabBar
#define YBSelfNavBarHeight                    self.navigationController.navigationBar.bounds.size.height
#define YBSelfTabBarHeight                    self.tabBarController.tabBar.bounds.size.height

/* 常用 */
#define ccr(t, l, w, h)                     CGRectMake(t, l, w, h)
#define ccp(x, y)                           CGPointMake(x, y)
#define ccs(w, h)                           CGSizeMake(w, h)
#define ccei(t, l, b, r)                    UIEdgeInsetsMake(t, l, b, r)


#pragma mark UIColor

#define UIColorFromHexWithAlpha(hexValue,a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:a]
#define UIColorFromHex(hexValue)            UIColorFromHexWithAlpha(hexValue,1.0)
#define UIColorFromRGBA(r,g,b,a)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorFromRGB(r,g,b)               UIColorFromRGBA(r,g,b,1.0)

//int to NSString
#define NSStringFromInt(intValue) [NSString stringWithFormat:@"%ld",intValue]

#pragma mark - method

#define YBWeakSelf(type)  __weak typeof(type) weak##type = type;
#define YBStrongSelf(type)  __strong typeof(type) type = weak##type;

// 过期提醒
#define YBDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

//  调试打印当前行、方法

#ifdef DEBUG
#   define YBLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define YBLog(...)
#endif

// 重新NSLog, 调试打印日志、当前行 方法

#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif


//调试 弹出当方法、前行、日志、

#ifdef DEBUG
#   define UILog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define UILog(...)
#endif


#endif /* YBMacros_h */
