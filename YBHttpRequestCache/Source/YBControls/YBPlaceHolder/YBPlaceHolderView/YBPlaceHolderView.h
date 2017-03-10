//
//  YBPlaceHolderView.h
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/12.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 for example:
 YBPlaceHolderView *plcaeView = [[YBPlaceHolderView alloc] initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, kScreenH - kTopBarHeight) errorImage:[UIImage imageNamed:@"icon_ww"] errorMsg:@"网络连接已经断开,请检查网络" reloadTip:@"刷新"];
 [plcaeView placeHolderViewReloadBlock:^{
 
 }];
 [self.view addSubview:plcaeView];
 */

typedef void(^YBPlaceHolderViewReloadBlock)();

@interface YBPlaceHolderView : UIView
/** block  */
@property (nonatomic, copy) YBPlaceHolderViewReloadBlock holderViewReloadBlock;

/**
 *  占位图
 *
 *  @param frame      frame
 *  @param errorImage 错误图片
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame errorImage:(UIImage *)errorImage;

/**
 *  占位图
 *
 *  @param frame      frame
 *  @param errorImage 错误图片
 *  @param tip        点击界面刷新提示词
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame errorImage:(UIImage *)errorImage reloadTip:(NSString *)tip;

/**
 *  占位图
 *
 *  @param frame      frame
 *  @param errorImage 错误图片
 *  @param errorMsg   错误信息
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame errorImage:(UIImage *)errorImage errorMsg:(NSString *)errorMsg;

/**
 *  占位图
 *
 *  @param frame      frame
 *  @param errorImage 错误图片
 *  @param errorMsg   错误信息
 *  @param tip        点击界面刷新提示词
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame errorImage:(UIImage *)errorImage errorMsg:(NSString *)errorMsg  reloadTip:(NSString *)tip;


/**
 *  占位图
 *
 *  @param frame      frame
 *  @param errorImage 错误图片
 *  @param errorMsg   错误信息
 *  @param tip        点击界面刷新提示词
 *  @param block      点击回调
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame errorImage:(UIImage *)errorImage errorMsg:(NSString *)errorMsg  reloadTip:(NSString *)tip block:(YBPlaceHolderViewReloadBlock)reloadBlock;
/**
 *  Block
 *
 *  @param reloadBlock   手动 添加点击block
 */
- (void)placeHolderViewReloadBlock:(YBPlaceHolderViewReloadBlock)reloadBlock;

@end

