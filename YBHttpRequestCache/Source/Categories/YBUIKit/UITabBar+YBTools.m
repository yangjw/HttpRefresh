//
//  UITabBar+YBTools.m
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/8.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import "UITabBar+YBTools.h"
#import <objc/runtime.h>
#import "AppDelegate.h"

@interface UITabBar ()

@property (nonatomic, strong) NSMutableDictionary *ybbadgeValues;

@end
@implementation UITabBar (YBTools)

static void YBExchangedMethod(SEL originalSelector, SEL swizzledSelector, Class class) {
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        YBExchangedMethod(@selector(layoutSubviews), @selector(yb_layoutSubviews), class);
        YBExchangedMethod(@selector(hitTest:withEvent:), @selector(yb_hitTest:withEvent:), class);
        YBExchangedMethod(@selector(touchesBegan:withEvent:), @selector(yb_touchesBegan:withEvent:), class);
    });
}

- (NSMutableDictionary *)ybbadgeValues {
    return objc_getAssociatedObject(self, @selector(ybbadgeValues));
}

- (void)setYbbadgeValues:(NSMutableDictionary *)ybbadgeValues {
    objc_setAssociatedObject(self, @selector(ybbadgeValues), ybbadgeValues, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
/** 重新布局  */
- (void)yb_layoutSubviews {
    [self yb_layoutSubviews];
    
    NSInteger index = 0;
    /** space:居于底部的高度  tabBarButtonLabelHeight:文本的高度*/
    CGFloat space = 12, tabBarButtonLabelHeight = 16;
    for (UIView *childView in self.subviews) {
        /** UITabbarItem  */
        if (![childView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            continue;
        }
        self.selectionIndicatorImage = [[UIImage alloc] init];
        [self bringSubviewToFront:childView];
        
        UIView *tabBarImageView, *tabBarButtonLabel, *tabBarBadgeView;
        for (UIView *sTabBarItem in childView.subviews) {
            
            if ([sTabBarItem isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) /** 图片  */
            {
                tabBarImageView = sTabBarItem;
            }
            else if ([sTabBarItem isKindOfClass:NSClassFromString(@"UITabBarButtonLabel")]) /** 文字  */
            {
                tabBarButtonLabel = sTabBarItem;
            }
            else if ([sTabBarItem isKindOfClass:NSClassFromString(@"_UIBadgeView")]) /** 角标  */
            {
                tabBarBadgeView = sTabBarItem;
            }
        }
        
        NSString *tabBarButtonLabelText = ((UILabel *)tabBarButtonLabel).text;
        //      根据图片大小重新计算 tabbaritem的 Y坐标
        CGFloat y = CGRectGetHeight(self.bounds) - (CGRectGetHeight(tabBarButtonLabel.bounds) + CGRectGetHeight(tabBarImageView.bounds));
        /**  判断Y坐标是否小于0,来设置新的坐标偏移 */
        if (y < 0)
        {
            if (!tabBarButtonLabelText.length) {
                space -= tabBarButtonLabelHeight;
            }
            else
            {
                space = 12;
            }
            childView.frame = CGRectMake(childView.frame.origin.x,
                                         y - space,
                                         childView.frame.size.width,
                                         childView.frame.size.height - y + space
                                         );
        }
        else
        {
            /** 默认偏移和计算偏移 得到最小偏移  */
            space = MIN(space, y);
        }
        //        角标高度
        CGFloat badgeW_H = 8;
        //        重新计算角标坐标
        CGFloat bandgeX  = CGRectGetMaxX(childView.frame) - (CGRectGetWidth(childView.frame) - CGRectGetWidth(tabBarImageView.frame) - badgeW_H) / 2.0;
        CGFloat bandgeY  = y < 0 ? CGRectGetMinY(childView.frame) + 10 : CGRectGetMinY(childView.frame) + 8;
        //        获取有角标集合
        if (!self.ybbadgeValues)
            self.ybbadgeValues = [NSMutableDictionary dictionary];
        //        索引为key
        NSString *key = @(index).stringValue;
        //        角标对象
        UILabel *currentBadgeValue = self.ybbadgeValues[key];
        /** 重新绘制角标  */
        if (tabBarBadgeView && y < 0 && CGRectGetWidth(self.frame) > 0 && CGRectGetHeight(self.frame) > 0) {
            tabBarBadgeView.hidden = YES;
            
            if (!currentBadgeValue) {
                currentBadgeValue = [self cloneBadgeViewWithOldBadge:tabBarBadgeView];
                self.ybbadgeValues[key] = currentBadgeValue;
            }
            
            CGSize size = [currentBadgeValue.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 18)
                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                                            attributes:@{NSFontAttributeName:currentBadgeValue.font}
                                                               context:nil].size;
            currentBadgeValue.frame = CGRectMake(bandgeX - (ceilf(size.width) + 10) / 2, bandgeY, ceilf(size.width) + 10, CGRectGetHeight(currentBadgeValue.frame));
            [self addSubview:currentBadgeValue];
        }
        else {
            if (currentBadgeValue) {
                [currentBadgeValue removeFromSuperview];
                [self.ybbadgeValues removeObjectForKey:key];
            }
        }
        //       循环对tabbaritem重新布局w
        index++;
    }
}
/** 重新绘制角标  */
- (UILabel *)cloneBadgeViewWithOldBadge:(UIView *)badgeView {
    if (!badgeView) {
        return nil;
    }
    UILabel *oldLabel;
    for (UIView *sView in badgeView.subviews) {
        if ([sView isKindOfClass:[UILabel class]]) {
            oldLabel = (UILabel *)sView;
            break;
        }
    }
    
    UILabel *newLabel = [[UILabel alloc] init];
    newLabel.text = oldLabel.text;
    newLabel.font = oldLabel.font;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    UIFont *font = [UIFont systemFontOfSize:13];
    if (oldLabel.font) {
        font  = oldLabel.font;
    }
    [dic setValue:font forKey:NSFontAttributeName];
    CGSize size = [newLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 18)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:dic
                                              context:nil].size;
    newLabel.frame = CGRectMake(0, 0, ceilf(size.width) + 10, size.height);
    newLabel.textColor = [UIColor whiteColor];
    newLabel.textAlignment = NSTextAlignmentCenter;
    newLabel.backgroundColor = [UIColor redColor];
    newLabel.layer.masksToBounds = YES;
    newLabel.layer.cornerRadius = CGRectGetHeight(newLabel.frame) / 2;
    
    return newLabel;
}
/** 事件响应,超过区域的继续有点击事件  */
- (UIView *)yb_hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.clipsToBounds && !self.hidden && self.alpha > 0) {
        UIView *result = [super hitTest:point withEvent:event];
        if (result) {
            return result;
        }
        else {
            for (UIView *subview in self.subviews.reverseObjectEnumerator) {
                CGPoint subPoint = [subview convertPoint:point fromView:self];
                result = [subview hitTest:subPoint withEvent:event];
                if (result) {
                    return result;
                }
            }
        }
    }
    return nil;
}

/** 点击区域放大,切换tabbar  */
- (void)yb_touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self yb_touchesBegan:touches withEvent:event];
    //    获取点击view
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [allTouches anyObject];
    //    获取点击坐标
    CGPoint point = [touch locationInView:[touch view]];
    
    NSInteger tabCount = 0;
    //    计算tbbar数量
    for (UIView *childView in self.subviews) {
        if (![childView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            continue;
        }
        
        tabCount++;
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width / tabCount;
    // 计算点击了哪个item
    NSUInteger clickIndex = ceilf(point.x) / ceilf(width);
    /** 切换tabbar  */
    UITabBarController *controller = (UITabBarController *)[(AppDelegate *)[[UIApplication sharedApplication] delegate] window].rootViewController;
    [controller setSelectedIndex:clickIndex];
}

@end

