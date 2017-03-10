//
//  NSMutableAttributedString+YBTools.m
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/8.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import "NSMutableAttributedString+YBTools.h"

@implementation NSMutableAttributedString (YBTools)

/** 添加行间距  */
-(NSMutableAttributedString *)yb_addParagraphStyle:(CGFloat)lineSpacing
{
    // 行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    return self;
    
    //    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    //    paragraph.alignment = NSTextAlignmentJustified;//设置对齐方式
    //    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
}

- (CGSize)yb_getAttrsStringSize:(CGSize)size
{
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [self boundingRectWithSize:size options:options context:nil];
    return rect.size;
}

- (CGFloat)yb_getWidthAttributesSize:(CGSize)size
{
    return [self yb_getAttrsStringSize:size].width;
}

- (CGFloat)yb_getHeightAttributesSize:(CGSize)size
{
    return [self yb_getAttrsStringSize:size].height;
}

@end
