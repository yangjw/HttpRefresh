//
//  NSNull+YBTools.m
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/8.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import "NSNull+YBTools.h"

@implementation NSNull (YBTools)
+ (BOOL)yb_objectIsNull:(id)obj {
    return obj == [NSNull null];
}

+ (BOOL)yb_objectIsNilOrNull:(id)obj {
    return obj == nil || obj == [NSNull null];
}

+ (id)yb_nullIfObjectIsNil:(id)obj {
    if (obj == nil) {
        return [NSNull null];
    }
    return obj;
}

+ (id)yb_nilIfObjectIsNull:(id)obj {
    if (obj == [NSNull null]) {
        return nil;
    }
    return obj;
}

@end
