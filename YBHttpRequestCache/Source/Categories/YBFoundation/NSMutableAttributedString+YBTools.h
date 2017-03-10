//
//  NSMutableAttributedString+YBTools.h
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/8.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (YBTools)
/**
 *  添加行间距
 *
 *  @param lineSpacing 行间距
 *
 *  @return 样式
 */
- (NSMutableAttributedString *)yb_addParagraphStyle:(CGFloat)lineSpacing;
- (CGSize)yb_getAttrsStringSize:(CGSize)size;
- (CGFloat)yb_getWidthAttributesSize:(CGSize)size;
- (CGFloat)yb_getHeightAttributesSize:(CGSize)size;
@end
/*
 NSFontAttributeName
 字体
 NSParagraphStyleAttributeName
 段落格式
 NSForegroundColorAttributeName
 字体颜色
 NSBackgroundColorAttributeName
 背景颜色
 NSStrikethroughStyleAttributeName
 删除线格式
 NSUnderlineStyleAttributeName
 下划线格式
 NSStrokeColorAttributeName
 删除线颜色
 NSStrokeWidthAttributeName
 删除线宽度
 NSShadowAttributeName
 阴影
 alignment //对齐方式
 firstLineHeadIndent //首行缩进
 headIndent //缩进
 tailIndent  //尾部缩进
 lineBreakMode  //断行方式
 maximumLineHeight  //最大行高
 minimumLineHeight  //最低行高
 lineSpacing  //行距
 paragraphSpacing  //段距
 paragraphSpacingBefore  //段首空间
 baseWritingDirection  //句子方向
 lineHeightMultiple  //可变行高,乘因数。
 hyphenationFactor //连字符属性
 NSString *const NSForegroundColorAttributeName;//值为UIColor，字体颜色，默认为黑色。
 NSString *const NSBackgroundColorAttributeName;//值为UIColor，字体背景色，默认没有。
 NSString *const NSLigatureAttributeName;//值为整型NSNumber，连字属性，一般中文用不到，在英文中可能出现相邻字母连笔的情况。0为不连笔；1为默认连笔，也是默认值；2在ios 上不支持。
 NSString *const NSKernAttributeName;//值为浮点数NSNumber，字距属性，默认值为0。
 NSString *const NSStrikethroughStyleAttributeName;//值为整型NSNumber，可取值为
 enum {
 NSUnderlineStyleNone = 0×00,
 NSUnderlineStyleSingle = 0×01,
 };设置删除线。
 NSString *const NSUnderlineStyleAttributeName;//同上。设置下划线。
 NSString *const NSStrokeColorAttributeName;//值为UIColor，默认值为nil，设置的属性同ForegroundColor。
 NSString *const NSStrokeWidthAttributeName;//值为浮点数NSNumber。设置比画的粗细。
 NSString *const NSShadowAttributeName;//值为NSShadow，设置比画的阴影，默认值为nil。
 NSString *const NSVerticalGlyphFormAttributeName;//值为整型NSNumber，0为水平排版的字，1为垂直排版的字。
 */