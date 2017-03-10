//
//  UITableView+Holder.h
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/12.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Holder)
@property (nonatomic, strong) UIView *placeholderView;
@property (nonatomic,   copy) void(^reloadBlock)(void);
@end
