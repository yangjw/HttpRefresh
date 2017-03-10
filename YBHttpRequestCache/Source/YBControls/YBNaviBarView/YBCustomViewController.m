//
//  YBCustomViewController.m
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/13.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import "YBCustomViewController.h"

#import "YBMacros.h"
#import "YBCustomNavigationController.h"


@interface YBCustomViewController ()

@end

@implementation YBCustomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.viewNaviBar];
}

- (YBNavigationBarView *)viewNaviBar
{
    if (!_viewNaviBar)
    {
        _viewNaviBar = [[YBNavigationBarView alloc] initWithFrame:ccr(0.0f, 0.0f,kYBScreenW , kYBTopBarHeight)];
        _viewNaviBar.sourceController = self;
    }
    return _viewNaviBar;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** 移除界面中所有的监听、异步调用  */
- (void)dealloc
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_viewNaviBar && !_viewNaviBar.hidden)
    {
        [self.view bringSubviewToFront:_viewNaviBar];
    }
}

#pragma mark -
/** 导航栏最前面  */
- (void)bringNaviBarToTopmost
{
    if (_viewNaviBar)
    {
        [self.view bringSubviewToFront:_viewNaviBar];
    }
}

- (void)hideNaviBar:(BOOL)bIsHide
{
    _viewNaviBar.hidden = bIsHide;
}

/* 设置导航栏背景 */
- (void)setNaviBarBackgroundImage:(UIImage *)bgImage
{
    if (_viewNaviBar)
    {
        [_viewNaviBar setYBBackgroundImage:bgImage];
    }
}
/** 标题  */
- (void)setNaviBarTitle:(NSString *)strTitle
{
    if (_viewNaviBar)
    {
        [_viewNaviBar setYBTitle:strTitle];
    }
}

/** 标题颜色  */
- (void)setNaviBarTitleColor:(UIColor *)color
{
    if (_viewNaviBar) {
        [_viewNaviBar setYBTitleColor:color];
    }
}
/** 左边按钮  */
- (void)setNaviBarLeftBtn:(UIButton *)btn
{
    if (_viewNaviBar)
    {
        [_viewNaviBar setYBLeftItem:btn];
    }
}
/** 左边按钮数组  */
- (void)setNaviBarLeftItems:(NSArray *)items
{
    if (_viewNaviBar)
    {
        [_viewNaviBar setYBLeftItems:items];
    }
}
/** 右边按钮  */
- (void)setNaviBarRightBtn:(UIButton *)btn
{
    if (_viewNaviBar)
    {
        [_viewNaviBar setYBRightItem:btn];
    }
}
/** 左边按钮数组  */
- (void)setNaviBarRightItems:(NSArray *)items
{
    if (_viewNaviBar)
    {
        [_viewNaviBar setYBRightItems:items];
    }
}
/** 自定义导航栏标题样式  */
- (void)naviBarAddTitleView:(UIView *)view
{
    if (_viewNaviBar && view)
    {
        [_viewNaviBar setYBTitleView:view];
    }
}

/** 底部分割线  */
- (void)setnaviBarBottomLine:(BOOL)nIsHide
{
    if (_viewNaviBar)
    {
        [_viewNaviBar setYBBottomLine:nIsHide];
    }
}
/** 设置底部分割线颜色  */
- (void)setnaviBarBottomLineColor:(UIColor *)color;
{
    if (_viewNaviBar)
    {
        [_viewNaviBar setBottomLineColor:color];
    }
}

/** 自定义导航栏  */
- (void)naviBarAddCoverView:(UIView *)view
{
    if (_viewNaviBar && view)
    {
        [_viewNaviBar showCoverView:view animation:YES];
    }
}
/** 移除自定义导航栏  */
- (void)naviBarRemoveCoverView:(UIView *)view
{
    if (_viewNaviBar)
    {
        [_viewNaviBar hideCoverView:view];
    }
}

/** 是否可右滑返回  */
- (void)navigationCanDragBack:(BOOL)bCanDragBack
{
    if (self.navigationController)
    {
        [((YBCustomNavigationController *)(self.navigationController)) navigationCanDragBack:bCanDragBack];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
