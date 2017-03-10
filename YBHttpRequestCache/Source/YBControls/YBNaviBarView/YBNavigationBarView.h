//
//  YBNaviBarView.h
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/13.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBNavigationBarView : UIView

@property (nonatomic, strong) UIViewController *sourceController;

/** 背景图片  */
- (void)setYBBackgroundImage:(UIImage *)bgImage;
/** 标题  */
- (void)setYBTitle:(NSString *)strTitle;
/** 标题颜色  */
- (void)setYBTitleColor:(UIColor *)color;
/** 左边按钮  */
- (void)setYBLeftItem:(UIButton *)item;
/** 左边按钮数组  */
- (void)setYBLeftItems:(NSArray *)items;
/** 右边按钮  */
- (void)setYBRightItem:(UIButton *)item;
/** 右边按钮数组  */
- (void)setYBRightItems:(NSArray *)items;
/** 自定义标题样式 标题的最大宽度 =  屏幕宽度- 44 * 4  */
- (void)setYBTitleView:(UIView *)view;
/** 底部分割线  */
- (void)setYBBottomLine:(BOOL)nIsHide;
/** 设置底部分割线颜色  */
- (void)setBottomLineColor:(UIColor *)color;

#pragma mark -
- (void)hideOriginalBarItem:(BOOL)bIsHide;
// 在导航条上覆盖一层自定义视图。比如：输入搜索关键字时，覆盖一个输入框在上面。
- (void)showCoverView:(UIView *)view;
/** 展示自定义视图  */
- (void)showCoverView:(UIView *)view animation:(BOOL)bIsAnimation;
/** 删除自定义视图  */
- (void)hideCoverView:(UIView *)view;

@end
