//
//  YBPlaceHolderView.m
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/12.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import "YBPlaceHolderView.h"
#import "YBLayoutConst.h"

@interface YBPlaceHolderView ()
/** 图片 */
@property (strong, nonatomic) UIImageView *errorImageView;

/** 错误提示 */
@property (strong, nonatomic) UILabel *errorMsg;

/** 错误提示 */
@property (strong, nonatomic) UILabel *reloadMsg;

@property (nonatomic, strong) UIView *holderView;
/** 点击重新加载 */
@property (strong, nonatomic) UIButton  *reload;
@end

@implementation YBPlaceHolderView

- (id)initWithFrame:(CGRect)frame errorImage:(UIImage *)errorImage
{
    return [self initWithFrame:frame errorImage:errorImage errorMsg:nil reloadTip:nil];
}

- (id)initWithFrame:(CGRect)frame errorImage:(UIImage *)errorImage reloadTip:(NSString *)tip
{
    return [self initWithFrame:frame errorImage:errorImage errorMsg:nil reloadTip:tip];
}

- (id)initWithFrame:(CGRect)frame errorImage:(UIImage *)errorImage errorMsg:(NSString *)errorMsg;
{
    return [self initWithFrame:frame errorImage:errorImage errorMsg:errorMsg reloadTip:nil];
}

- (id)initWithFrame:(CGRect)frame errorImage:(UIImage *)errorImage errorMsg:(NSString *)errorMsg reloadTip:(NSString *)tip
{
    return [self initWithFrame:frame errorImage:errorImage errorMsg:errorMsg reloadTip:tip block:nil];
}

- (id)initWithFrame:(CGRect)frame errorImage:(UIImage *)errorImage errorMsg:(NSString *)errorMsg  reloadTip:(NSString *)tip block:(YBPlaceHolderViewReloadBlock)reloadBlock
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        if (reloadBlock)
        {
            self.holderViewReloadBlock = reloadBlock;
        }
        [self addSubview:self.holderView];
        [self.holderView addSubview:self.errorImageView];
        [self.holderView addSubview:self.errorMsg];
        [self.holderView addSubview:self.reloadMsg];
        //        [self addSubview:self.reload];
        /** 显示区域的宽度  */
        CGFloat holderW = self.frame.size.width - kYBPlaceHolderMagrin * 2;
        
        /** 图片处理  */
        CGSize imageSize = errorImage.size;
        CGFloat width = self.frame.size.width - kYBPlaceHolderMagrin * 2;
        CGFloat height = self.frame.size.height -  kYBPlaceHolderMagrin * 2;
        
        CGFloat imageHeight = 0;
        CGFloat imageWidth = 0;
        if (imageSize.width > width)
        {
            imageWidth = width;
            imageHeight = width/imageSize.width * imageSize.height;
        }
        else if(imageSize.height > width)
        {
            imageHeight = height;
            imageWidth  = height/imageSize.height * imageSize.width;
        }else
        {
            imageWidth = imageSize.width;
            imageHeight = imageSize.height;
        }
        _errorImageView.frame = CGRectMake((width - imageWidth)/2, 0, imageWidth, imageHeight);
        _errorImageView.image = errorImage;
        /** 错误信息  */
        CGRect msgRect = CGRectZero;
        if (errorMsg.length > 0 )
        {
            CGFloat msgH = [self textHeight:errorMsg font:[UIFont systemFontOfSize:16]];
            msgRect = CGRectMake(0, CGRectGetMaxY(_errorImageView.frame) + kYBPlaceHolderTop, holderW, msgH);
            _errorMsg.text = errorMsg;
        }else
        {
            msgRect =  CGRectMake(0, CGRectGetMaxY(_errorImageView.frame), holderW, 0);
        }
        _errorMsg.frame = msgRect;
        
        /** 刷新提示信息  */
        CGRect tipRect = CGRectZero;
        if (tip.length > 0) {
            CGFloat tipH = [self textHeight:tip font:[UIFont systemFontOfSize:14]];
            tipRect = CGRectMake(0, CGRectGetMaxY(_errorMsg.frame) + kYBPlaceHolderTop, holderW, tipH);
            _reloadMsg.text = tip;
        }else
        {
            tipRect = CGRectMake(0, CGRectGetMaxY(_errorMsg.frame), holderW, 0);
        }
        _reloadMsg.frame = tipRect;
        
        /** 重新计算 holderView 大小*/
        CGFloat holderH = CGRectGetMaxY(_reloadMsg.frame) + kYBPlaceHolderTop;
        _holderView.frame = CGRectMake(kYBPlaceHolderMagrin, (CGRectGetHeight(self.frame) - holderH)/2, holderW, holderH);
        //        _holderView.backgroundColor = [UIColor redColor];
        /** 按钮点击区域  */
        _reload.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        /** 界面点击  */
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadDataView:)];
        self.userInteractionEnabled =YES;
        [self addGestureRecognizer:tap];
    }
    
    return self;
    
}

- (void)placeHolderViewReloadBlock:(YBPlaceHolderViewReloadBlock)reloadBlock
{
    self.holderViewReloadBlock = reloadBlock;
}

- (CGFloat)textHeight:(NSString *)text font:(UIFont *)font
{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    /** menu 大小  */
    CGSize displayTitleSize = [text boundingRectWithSize:CGSizeMake(self.frame.size.width - kYBPlaceHolderMagrin * 2, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return displayTitleSize.height;
}

- (UILabel *)errorMsg
{
    if (!_errorMsg) {
        _errorMsg = [[UILabel alloc] init];
        _errorMsg.textAlignment = NSTextAlignmentCenter;
        _errorMsg.font =  [UIFont systemFontOfSize:16];
        _errorMsg.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
        _errorMsg.lineBreakMode = NSLineBreakByCharWrapping;
        _errorMsg.numberOfLines = 0;
    }
    return _errorMsg;
}

- (UILabel *)reloadMsg
{
    if (!_reloadMsg) {
        _reloadMsg = [[UILabel alloc] init];
        _reloadMsg.textAlignment = NSTextAlignmentCenter;
        _reloadMsg.font = [UIFont systemFontOfSize:14];
        _reloadMsg.textColor =  [UIColor colorWithWhite:0.600 alpha:1.000];
    }
    return _reloadMsg;
}

- (UIImageView *)errorImageView
{
    if (!_errorImageView) {
        _errorImageView = [[UIImageView alloc] init];
    }
    return _errorImageView;
}

- (UIView *)holderView
{
    if (!_holderView) {
        _holderView = [[UIView alloc] initWithFrame:CGRectMake(kYBPlaceHolderMagrin, 0, self.frame.size.width - kYBPlaceHolderMagrin * 2, 200)];
    }
    return _holderView;
}

- (UIButton *)reload
{
    if (!_reload) {
        _reload = [UIButton buttonWithType:UIButtonTypeCustom];
        _reload.backgroundColor = [UIColor clearColor];
        [_reload addTarget:self action:@selector(reloadDataView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reload;
}
/** 刷新界面  */
- (void)reloadDataView:(id)sender
{
    if (_holderViewReloadBlock)
    {
        self.holderViewReloadBlock();
    }
}

- (void)dealloc
{
    if (_holderViewReloadBlock) {
        _holderViewReloadBlock = nil;
    }
}

@end

