//
//  UITableView+Holder.m
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/12.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import "UITableView+Holder.h"
#import "NSObject+Swizzling.h"

@implementation UITableView (Holder)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self methodSwizzlingWithOriginalSelector:@selector(reloadData)
                               bySwizzledSelector:@selector(sure_reloadData)];
    });
}

- (void)sure_reloadData
{
    [self checkEmpty];
    [self sure_reloadData];
}

- (void)checkEmpty {
    BOOL isEmpty = YES;//flag标示
    
//    UICollectionView
//    id <UICollectionViewDataSource> dataSource = self.dataSource;
//    NSInteger sections = 1;
//    if ([dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
//        sections = [dataSource numberOfSectionsInCollectionView:self] - 1;
//    }
//    
//    for (NSInteger i = 0; i <= sections; i++) {
//        NSInteger rows = [dataSource collectionView:self numberOfItemsInSection:sections];
//        if (rows) {
//            isEmpty = NO;
//        }
//    }

    
//    UITableView
    id <UITableViewDataSource> dataSource = self.dataSource;
    NSInteger sections = 1;//默认一组
    if ([dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        sections = [dataSource numberOfSectionsInTableView:self] - 1;//获取当前TableView组数
    }
    
    for (NSInteger i = 0; i <= sections; i++) {
        NSInteger rows = [dataSource tableView:self numberOfRowsInSection:sections];//获取当前TableView各组行数
        if (rows) {
            isEmpty = NO;//若行数存在，不为空
        }
    }
    if (isEmpty) {//若为空，加载占位图
        //默认占位图
        if (!self.placeholderView)
        {
            [self makeDefaultPlaceholderView];
        }
        self.placeholderView.hidden = NO;
        [self addSubview:self.placeholderView];
    }
    else {//不为空，移除占位图
        self.placeholderView.hidden = YES;
    }
}

- (void)makeDefaultPlaceholderView
{
    
    self.placeholderView = nil;
}

- (UIView *)placeholderView {
    return objc_getAssociatedObject(self, @selector(placeholderView));
}

- (void)setPlaceholderView:(UIView *)placeholderView {
    objc_setAssociatedObject(self, @selector(placeholderView), placeholderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(void))reloadBlock {
    return objc_getAssociatedObject(self, @selector(reloadBlock));
}

- (void)setReloadBlock:(void (^)(void))reloadBlock {
    objc_setAssociatedObject(self, @selector(reloadBlock), reloadBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
