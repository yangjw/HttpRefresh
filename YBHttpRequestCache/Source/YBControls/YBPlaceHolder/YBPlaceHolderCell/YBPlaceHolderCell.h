//
//  YBPlaceHoderCell.h
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/12.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YBPlaceHolderCellReloadBlock)();

@interface YBPlaceHolderModel : NSObject
@property (nonatomic, strong) UIImage *holderImage;
@property (nonatomic, strong) NSString *holderMsg;
@property (nonatomic, strong) NSString *holdertip;
@end

@interface YBPlaceHolderCell : UITableViewCell

@property (nonatomic, copy) YBPlaceHolderCellReloadBlock reloadBlock;

/**
 *  Block
 *
 *  @param reloadBlock   手动 添加点击block
 */
- (void)placeHolderCellReloadBlock:(YBPlaceHolderCellReloadBlock)block;


- (void)congfigPlaceHolderView:(YBPlaceHolderModel *)model;

@end
