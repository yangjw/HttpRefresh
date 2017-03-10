//
//  NSNull+YBTools.h
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/8.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNull (YBTools)
/*
 *  @brief YES if obj is NSNull; otherwise NO.
 */
+ (BOOL)yb_objectIsNull:(id)obj;

/*
 *  @brief YES if obj is nil or NSNull; otherwise NO.
 */
+ (BOOL)yb_objectIsNilOrNull:(id)obj;

/*
 *  @brief Returns NSNull if obj is nil; otherwise obj.
 */
+ (id)yb_nullIfObjectIsNil:(id)obj;

/*
 *  @brief Returns nil if obj is NSNull; otherwise obj.
 */
+ (id)yb_nilIfObjectIsNull:(id)obj;
@end
