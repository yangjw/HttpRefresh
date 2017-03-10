//
//  NSObject+Swizzling.h
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/12.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@interface NSObject (Swizzling)
+ (void)methodSwizzlingWithOriginalSelector:(SEL)originalSelector
                         bySwizzledSelector:(SEL)swizzledSelector;
@end
