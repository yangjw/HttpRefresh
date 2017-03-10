//
//  YBCustomViewController.h
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/13.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBNavigationBarView.h"

@interface YBCustomViewController : UIViewController

@property (nonatomic, strong) YBNavigationBarView *viewNaviBar;
/** 导航栏最前面  */
- (void)bringNaviBarToTopmost;

/**
 *  导航栏是否显示
 *
 *  @param bIsHide YES:显示 NO 隐藏
 */
- (void)hideNaviBar:(BOOL)bIsHide;

/**
 *  设置导航栏背景
 *
 *  @param bgImage 背景图片
 */
- (void)setNaviBarBackgroundImage:(UIImage *)bgImage;
/**
 *  设置标题
 *
 *  @param strTitle 标题
 */
- (void)setNaviBarTitle:(NSString *)strTitle;

/** 标题颜色  */
- (void)setNaviBarTitleColor:(UIColor *)color;
/**
 *  左边按钮
 *
 *  @param btn 按钮
 */
- (void)setNaviBarLeftBtn:(UIButton *)btn;
/**
 *  左边按钮数组
 *
 *  @param items @[btn,btn]
 */
- (void)setNaviBarLeftItems:(NSArray *)items;
/**
 *  右边按钮
 *
 *  @param btn 按钮
 */
- (void)setNaviBarRightBtn:(UIButton *)btn;
/**
 *  右边边按钮数组
 *
 *  @param items @[btn,btn]
 */
- (void)setNaviBarRightItems:(NSArray *)items;
/**
 *  自定义导航栏标题样式
 *
 *  @param view 标题View
 */
- (void)naviBarAddTitleView:(UIView *)view;

/** 底部分割线  */
- (void)setnaviBarBottomLine:(BOOL)nIsHide;
/** 设置底部分割线颜色  */
- (void)setnaviBarBottomLineColor:(UIColor *)color;

/**
 *  自定义导航栏
 *
 *  @param view 导航栏View
 */
- (void)naviBarAddCoverView:(UIView *)view;

/**
 *  移除自定义导航栏
 *
 *  @param view 移除自定义 View
 */
- (void)naviBarRemoveCoverView:(UIView *)view;

/**
 *  是否手势返回
 *
 *  @param bCanDragBack
 */
- (void)navigationCanDragBack:(BOOL)bCanDragBack;
@end
