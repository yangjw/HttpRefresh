//
//  YBNaviBarView.m
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/13.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import "YBNavigationBarView.h"
#import "YBMacros.h"
#import "UIView+YBTools.h"

@interface YBNavigationBarView ()
{
    
}
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) UIButton *yb_backBtn;
@property (nonatomic, strong) UIButton *yb_leftBtn;
@property (nonatomic, strong) UIButton *yb_rightBtn;
@property (nonatomic, strong) UILabel  *yb_titlelabel;
@property (nonatomic, strong) UIImageView *yb_bgImageV;
@property (nonatomic, strong) NSString *yb_title;

@property (nonatomic, strong) NSArray *leftItems;

@property (nonatomic, strong) NSArray *rightItems;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation YBNavigationBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initUI];
}

- (CGRect)rightBtnFrame
{
    return ccr(kYBScreenW - self.btnSize.width, kYBStatusBarHeight, self.btnSize.width, self.btnSize.height);
}


- (CGSize)barSize
{
    return CGSizeMake(kYBScreenW, kYBTopBarHeight);
}

- (CGSize)btnSize
{
    return  CGSizeMake(kYBNavigationBarHeight, kYBNavigationBarHeight);
}

- (UIButton *)createImgNaviBarBtnByImgNormal:(NSString *)strImg imgHighlight:(NSString *)strImgHighlight imgSelected:(NSString *)strImgSelected target:(id)target action:(SEL)action
{
    UIImage *imgNormal = [UIImage imageNamed:strImg];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:imgNormal forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:(strImgHighlight ? strImgHighlight : strImg)] forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageNamed:(strImgSelected ? strImgSelected : strImg)] forState:UIControlStateSelected];    
    return btn;
}

#pragma mark - 创建View

- (UIView *)leftView
{
    if (!_leftView) {
        _leftView = [[UIView alloc] initWithFrame:ccr(0, kYBStatusBarHeight, kYBNavigationBarHeight, kYBNavigationBarHeight)];
    }
    return _leftView;
}

- (UIView *)rightView
{
    if (!_rightView) {
        _rightView = [[UIView alloc] initWithFrame:ccr(kYBScreenW - kYBNavigationBarHeight, kYBStatusBarHeight, kYBNavigationBarHeight, kYBNavigationBarHeight)];
    }
    return _rightView;
}


- (UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:ccr(kYBNavigationBarHeight * 2, kYBStatusBarHeight, kYBScreenW - kYBNavigationBarHeight * 4, kYBNavigationBarHeight)];
    }
    return _titleView;
}


- (void)initUI
{
    self.backgroundColor = [UIColor colorWithRed:0.125 green:0.788 blue:0.655 alpha:1.000];
    _yb_bgImageV = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:_yb_bgImageV];
    
    
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, kYBTopBarHeight - YBINGLE_LINE_WIDTH, kYBScreenW, YBINGLE_LINE_WIDTH)];
    _bottomLine.backgroundColor = [UIColor grayColor];
    [self addSubview:_bottomLine];
    [self bringSubviewToFront:_bottomLine];
    
    [self addSubview:self.titleView];
    
    _yb_titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _yb_titlelabel.backgroundColor = [UIColor clearColor];
    _yb_titlelabel.textColor = [UIColor blackColor];
    _yb_titlelabel.font = [UIFont systemFontOfSize:19.0f];
    _yb_titlelabel.textAlignment = NSTextAlignmentCenter;
    _yb_titlelabel.frame = ccr(0, 0, kYBScreenW - kYBNavigationBarHeight * 4, kYBNavigationBarHeight);
    [self.titleView addSubview:_yb_titlelabel];

    
    _yb_backBtn = [self createImgNaviBarBtnByImgNormal:@"main_left_back_white" imgHighlight:nil imgSelected:nil target:self action:@selector(backAction:)];
    
    [self setYBLeftItem:_yb_backBtn];
}


- (void)backAction:(id)sender
{
    if (self.sourceController)
    {
        [self.sourceController.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setYBBackgroundImage:(UIImage *)bgImage
{
    if (_yb_bgImageV)
    {
        _yb_bgImageV.image = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

- (void)setYBBottomLine:(BOOL)bIsHide
{
    if (_bottomLine) {
        _bottomLine.hidden = bIsHide;
    }
}
- (void)setBottomLineColor:(UIColor *)color
{
    if (_bottomLine) {
        _bottomLine.backgroundColor = color;
    }
}


- (void)setYBTitle:(NSString *)strTitle
{
    _yb_title = strTitle;
    [_yb_titlelabel setText:strTitle];
}

- (void)setYBTitleColor:(UIColor *)color
{
    if (_yb_title)
    {
        _yb_titlelabel.textColor = color;
    }
}

- (void)setYBLeftItem:(UIButton *)item
{
    if (item)
    {
        [self setYBLeftItems:@[item]];
    }
    else
    {
        if (_leftView)
        {
            [_leftView removeFromSuperview];
            _leftView = nil;
        }
    }    
}

- (void)setYBLeftItems:(NSArray *)items
{
    if (_leftView)
    {
        [_leftView removeFromSuperview];
        _leftView = nil;
    }
    [self addSubview:self.leftView];
    CGFloat beginX = 0;
    CGFloat endX = 0;

    for (UIButton * button in items)
    {
        if (CGRectIsEmpty(button.frame))
        {
            button.frame = ccr(0, 0, kYBNavigationBarHeight, kYBNavigationBarHeight);
        }
        if (button.height > kYBNavigationBarHeight) {
            CGFloat scale = button.height/kYBNavigationBarHeight;
            button.height = kYBNavigationBarHeight;
            button.width = button.width * scale;
        }
        button.left = beginX;
        button.top = (kYBNavigationBarHeight - button.height)/2;
    
        [self.leftView addSubview:button];
        beginX += button.frame.size.width;
        endX = CGRectGetMaxX(button.frame);
    }
    self.leftView.width = endX;
}

- (void)setYBRightItem:(UIButton *)item
{
    if (item)
    {
        [self setYBRightItems:@[item]];
    }
    else
    {
        if (_rightView)
        {
            [_rightView removeFromSuperview];
            _rightView = nil;
        }
    }
    
}

- (void)setYBRightItems:(NSArray <UIButton *> *)items
{
    if (_rightView)
    {
        [_rightView removeFromSuperview];
        _rightView = nil;
    }
    [self addSubview:self.rightView];
    CGFloat beginX = 0;
    CGFloat endX = 0;
    for (UIButton * button in items)
    {
        if (CGRectIsEmpty(button.frame))
        {
            button.frame = ccr(0, 0, kYBNavigationBarHeight, kYBNavigationBarHeight);
        }
        if (button.height > kYBNavigationBarHeight) {
            CGFloat scale = button.height/kYBNavigationBarHeight;
            button.height = kYBNavigationBarHeight;
            button.width = button.width * scale;
        }
        button.left = beginX;
        button.top = (kYBNavigationBarHeight - button.height)/2;
        [self.rightView addSubview:button];
        beginX += button.frame.size.width;
        endX = CGRectGetMaxX(button.frame);
    }
    self.rightView.width = endX;
    self.rightView.left = kYBScreenW - endX;
}

- (void)setYBTitleView:(UIView *)view
{
    if (view)
    {
        if (_titleView)
        {
            _titleView.hidden = YES;
        }
        [view removeFromSuperview];
        if (CGRectIsEmpty(view.frame))
        {
          view.frame = ccr(kYBNavigationBarHeight * 2, kYBStatusBarHeight, kYBScreenW - kYBNavigationBarHeight*4 , kYBNavigationBarHeight);
        }
        view.left  = (kYBScreenW - view.width)/2;
        [self addSubview:view];
    }
}

- (void)showCoverView:(UIView *)view
{
    [self showCoverView:view animation:NO];
}

- (void)showCoverView:(UIView *)view animation:(BOOL)bIsAnimation
{
    if (view)
    {
        [self hideOriginalBarItem:YES];
        
        [view removeFromSuperview];
        view.alpha = 0.4f;
        [self addSubview:view];
        if (bIsAnimation)
        {
            [UIView animateWithDuration:0.2f animations:^()
             {
                 view.alpha = 1.0f;
             }completion:^(BOOL f){}];
        }
        else
        {
            view.alpha = 1.0f;
        }
    }
}

- (void)hideCoverView:(UIView *)view
{
    [self hideOriginalBarItem:NO];
    if (view && (view.superview == self))
    {
        [view removeFromSuperview];
    }
}

#pragma mark -
- (void)hideOriginalBarItem:(BOOL)bIsHide
{
    if (_leftView)
    {
        _leftView.hidden = bIsHide;
    }
    if (_titleView)
    {
        _titleView.hidden = bIsHide;
    }
    if (_rightView)
    {
        _rightView.hidden = bIsHide;
    }
}


@end
