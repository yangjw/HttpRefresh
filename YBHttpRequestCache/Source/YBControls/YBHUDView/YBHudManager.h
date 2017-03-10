//
//  YBHudManager.h
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/12.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** 请求状态  */
typedef NS_ENUM(NSInteger, YBHUDStatus) {
    
    /** 成功 */
    YBHUDStatusSuccess,
    
    /** 失败 */
    YBHUDStatusError,
    
    /** 信息 */
    YBHUDStatusInfo,
    
    /** 加载中 */
    YBHUDStatusWaitting
};

#define YBHUDManager [YBHudManager sharedInstance]

@interface YBHudManager : NSObject

+ (instancetype)sharedInstance;
/**
 *  提示
 *
 *  @param status 状态
 *  @param text   内容
 */
- (void)showWithView:(UIView *)view Status:(YBHUDStatus)status text:(NSString *)text;
#pragma mark - 建议使用的方法

/** 添加一个只显示文字的HUD */
- (void)showWithView:(UIView *)view ext:(NSString *)text;
/**
 *  提示
 *
 *  @param text  内容
 *  @param block 关闭回调
 */
- (void)showWithView:(UIView *)view text:(NSString *)text block:(dispatch_block_t)block;
/**
 *  显示提示
 *
 *  @param text  内容
 *  @param delay 展示时间
 *  @param block 关闭提示回调
 */
- (void)showWithView:(UIView *)view text:(NSString *)text delay:(NSTimeInterval)delay block:(dispatch_block_t)block;

#pragma mark - 状态
/** 添加一个提示`信息`的HUD */
- (void)showWithView:(UIView *)view infoText:(NSString *)text;
/** 添加一个提示`失败`的HUD */
- (void)showWithView:(UIView *)view failureText:(NSString *)text;
/** 添加一个提示`成功`的HUD */
- (void)showWithView:(UIView *)view successText:(NSString *)text;
/** 添加一个提示`加载中`的HUD,  需要手动关闭  超过10秒自动关闭，防止异常 */
- (void)showWithView:(UIView *)view loadingText:(NSString *)text;
/** 手动隐藏HUD */
- (void)hide;
@end
