//
//  UIImage+scale.h
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/14.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (scale)

/**
*  图片内容更改
*
*  @param size        CGSize
*  @param contentMode 填充样式
*
*  @return 返回一张给定大小的图片
*/

- (UIImage *)imageYBByResizeToSize:(CGSize)size contentMode:(UIViewContentMode)contentMode;

/**
 *  图片圆角处理
 *
 *  @param radius 角度
 *
 *  @return
 */
- (UIImage *)imageYBByRoundCornerRadius:(CGFloat)radius;

/**
 *  图片添加边框、边框颜色、角度
 *
 *  @param radius      角度
 *  @param borderWidth 宽度
 *  @param borderColor 颜色
 *
 *  @return
 */
- (UIImage *)imageYBByRoundCornerRadius:(CGFloat)radius
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor;

/**
 *  获取正方形图片
 *
 *  @param newSize 新的尺寸
 *
 *  @return 新图
 */
- (UIImage *)squareYBScaledToSize:(CGSize)newSize;

/**
 *  裁剪image适应自己的尺寸
 *
 */
+ (UIImage *)scaleYBToSize:(UIImage *)img size:(CGSize)size;
@end

