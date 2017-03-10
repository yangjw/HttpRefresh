//
//  YBHudManager.m
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/12.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import "YBHudManager.h"
#import <MBProgressHUD.h>

@interface YBHudManager ()<MBProgressHUDDelegate>
{

}
@property (nonatomic, copy) dispatch_block_t block;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation YBHudManager
+ (instancetype)sharedInstance {
    static YBHudManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[YBHudManager alloc] init];
    });
    
    return _sharedInstance;
}
/**
 *  提示
 *
 *  @param status 状态
 *  @param text   内容
 */
- (void)showWithView:(UIView *)view Status:(YBHUDStatus)status text:(NSString *)text
{
    [self showWithView:view Status:status text:text block:nil];
}

- (void)showWithView:(UIView *)view Status:(YBHUDStatus)status text:(NSString *)text block:(dispatch_block_t)block
{
    if (block) {
        self.block = block;
    }
//    NSTimeInterval s = CFAbsoluteTimeGetCurrent();
    _hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    _hud.contentColor = [UIColor whiteColor];
//   边框
    _hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    _hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    背景
//    _hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
//    _hud.backgroundView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    /** 内容  */
    _hud.detailsLabel.text = text;
    _hud.detailsLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    
    [_hud setRemoveFromSuperViewOnHide:YES];
    [_hud setMinSize:CGSizeMake(100.0f, 100.0f)];
    _hud.delegate = self;
    switch (status) {
            
        case YBHUDStatusSuccess: {
            
            _hud.mode = MBProgressHUDModeCustomView;
            UIImageView *sucView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yb_hud_success"]];
            _hud.customView = sucView;
            [_hud hideAnimated:YES afterDelay:1.0f];
        }
            break;
        case YBHUDStatusError: {
            
            _hud.mode = MBProgressHUDModeCustomView;
            UIImageView *errView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yb_hud_error"]];
            _hud.customView = errView;
            [_hud hideAnimated:YES afterDelay:1.0f];
        }
            break;
            
        case YBHUDStatusWaitting:
        {
//             NSLog(@"*********************************耗时");
            _hud.mode = MBProgressHUDModeIndeterminate;
            
            [_hud hideAnimated:YES afterDelay:10.0f];
//            NSTimeInterval e = CFAbsoluteTimeGetCurrent();
//            NSLog(@"*********************************耗时:%f",e - s);
        }
            break;
        case YBHUDStatusInfo:
        {
            _hud.mode = MBProgressHUDModeCustomView;
            UIImageView *errView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yb_hud_info"]];
            _hud.customView = errView;
            [_hud hideAnimated:YES afterDelay:1.0f];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 建议使用的方法

/** 在window上添加一个只显示文字的HUD */
- (void)showWithView:(UIView *)view ext:(NSString *)text
{
    [self showWithView:view text:text block:nil];
}
/**
 *  提示
 *
 *  @param text  内容
 *  @param block 关闭回调
 */
- (void)showWithView:(UIView *)view text:(NSString *)text block:(dispatch_block_t)block
{
    [self showWithView:view text:text delay:1.0f block:block];
}
/**
 *  显示提示
 *
 *  @param text  内容
 *  @param delay 展示时间
 *  @param block 关闭提示回调
 */
- (void)showWithView:(UIView *)view text:(NSString *)text delay:(NSTimeInterval)delay block:(dispatch_block_t)block
{
    if (block) {
        self.block = block;
    }
    _hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    _hud.contentColor = [UIColor whiteColor];
    _hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    _hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _hud.detailsLabel.text = text;
    _hud.detailsLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    [_hud setMode:MBProgressHUDModeText];
    [_hud setRemoveFromSuperViewOnHide:YES];
    [_hud setMinSize:CGSizeMake(100.0f, 100.0f)];

    _hud.delegate = self;
    [_hud hideAnimated:YES afterDelay:delay];
}
/**
 * Called after the HUD was fully hidden from the screen.
 */
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    NSLog(@"提示消失");
    if (self.block)
    {
        self.block();
    }
}


#pragma mark - 状态
/**添加一个提示`信息`的HUD */
- (void)showWithView:(UIView *)view infoText:(NSString *)text
{
    [self showWithView:view Status:YBHUDStatusInfo text:text];
}
/**添加一个提示`失败`的HUD */
- (void)showWithView:(UIView *)view failureText:(NSString *)text
{
    [self showWithView:view Status:YBHUDStatusError text:text];
}
/** 添加一个提示`成功`的HUD */
- (void)showWithView:(UIView *)view successText:(NSString *)text
{
    [self showWithView:view Status:YBHUDStatusSuccess text:text];
}
/** 添加一个提示`加载中`的HUD, 需要手动关闭 */
- (void)showWithView:(UIView *)view loadingText:(NSString *)text
{
    [self showWithView:view Status:YBHUDStatusWaitting text:text];
}
/** 手动隐藏HUD */
- (void)hide
{
    if (_hud)
    {
        [_hud hideAnimated:YES];
    }
}

//界面增加关闭事件
- (void)addGestureRecognizer:(UIView *)view
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [view setUserInteractionEnabled:YES];
    [view addGestureRecognizer:tap];
}

- (void)dealloc
{
    if (_hud) {
        _hud = nil;
    }
    if (_block) {
        _block = nil;
    }
}

@end
