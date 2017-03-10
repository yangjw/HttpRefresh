//
//  YBPlaceHoderCell.m
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/12.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import "YBPlaceHolderCell.h"
#import "YBLayoutConst.h"

@interface YBPlaceHolderCell()
{

}
/** 图片 */
@property (strong, nonatomic) UIImageView *errorImageView;
/** 错误提示 */
@property (strong, nonatomic) UILabel *errorMsg;

/** 错误提示 */
@property (strong, nonatomic) UILabel *reloadMsg;

@property (nonatomic, strong) UIView *holderView;

@end

@implementation YBPlaceHolderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
    }
    return self;
}

- (void)setUp
{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.holderView];
    [self.holderView addSubview:self.errorImageView];
    [self.holderView addSubview:self.errorMsg];
    [self.holderView addSubview:self.reloadMsg];
}

- (CGFloat)calculatePlaceHolderHeight:(YBPlaceHolderModel *)model
{
    return 10;
}


- (void)congfigPlaceHolderView:(YBPlaceHolderModel *)model
{
    /** 显示区域的宽度  */
    CGFloat holderW = self.frame.size.width - kYBPlaceHolderMagrin * 2;
    if (model.holderImage)
    {
        /** 图片处理  */
        CGSize imageSize = model.holderImage.size;
        CGFloat width = self.frame.size.width - kYBPlaceHolderMagrin * 2;
        CGFloat height = self.frame.size.height -  kYBPlaceHolderMagrin * 2;
        
        CGFloat imageHeight = 0;
        CGFloat imageWidth = 0;
        if (imageSize.width > width)
        {
            imageWidth = width;
            imageHeight = width/imageSize.width * imageSize.height;
        }
        else if(imageSize.height > width)
        {
            imageHeight = height;
            imageWidth  = height/imageSize.height * imageSize.width;
        }else
        {
            imageWidth = imageSize.width;
            imageHeight = imageSize.height;
        }
        _errorImageView.frame = CGRectMake((width - imageWidth)/2, 0, imageWidth, imageHeight);
        _errorImageView.image = model.holderImage;
    }else
    {
      _errorImageView.frame = CGRectMake(0, 0, 0, 0);
      _errorImageView.image = nil;
    }
    
    
    /** 错误信息  */
    CGRect msgRect = CGRectZero;
    if (model.holderMsg.length > 0 )
    {
        CGFloat msgH = [self textHeight:model.holderMsg font:[UIFont systemFontOfSize:16]];
        msgRect = CGRectMake(0, CGRectGetMaxY(_errorImageView.frame) + kYBPlaceHolderTop, holderW, msgH);
        _errorMsg.text = model.holderMsg;
    }else
    {
        msgRect =  CGRectMake(0, CGRectGetMaxY(_errorImageView.frame), holderW, 0);
    }
    _errorMsg.frame = msgRect;
    
    /** 刷新提示信息  */
    CGRect tipRect = CGRectZero;
    if (model.holdertip.length > 0) {
        CGFloat tipH = [self textHeight:model.holdertip font:[UIFont systemFontOfSize:14]];
        tipRect = CGRectMake(0, CGRectGetMaxY(_errorMsg.frame) + kYBPlaceHolderTop, holderW, tipH);
        _reloadMsg.text = model.holdertip;
    }else
    {
        tipRect = CGRectMake(0, CGRectGetMaxY(_errorMsg.frame), holderW, 0);
    }
    _reloadMsg.frame = tipRect;
    
    /** 重新计算 holderView 大小*/
    CGFloat holderH = CGRectGetMaxY(_reloadMsg.frame) + kYBPlaceHolderTop;
    _holderView.frame = CGRectMake(kYBPlaceHolderMagrin, (CGRectGetHeight(self.frame) - holderH)/2, holderW, holderH);
    
    /** 界面点击  */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadDataView:)];
    self.userInteractionEnabled =YES;
    [self addGestureRecognizer:tap];
}

- (CGFloat)textHeight:(NSString *)text font:(UIFont *)font
{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    /** menu 大小  */
    CGSize displayTitleSize = [text boundingRectWithSize:CGSizeMake(self.frame.size.width - kYBPlaceHolderMagrin * 2, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return displayTitleSize.height;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)errorMsg
{
    if (!_errorMsg) {
        _errorMsg = [[UILabel alloc] init];
        _errorMsg.textAlignment = NSTextAlignmentCenter;
        _errorMsg.font =  [UIFont systemFontOfSize:16];
        _errorMsg.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
        _errorMsg.lineBreakMode = NSLineBreakByCharWrapping;
        _errorMsg.numberOfLines = 0;
    }
    return _errorMsg;
}

- (UILabel *)reloadMsg
{
    if (!_reloadMsg) {
        _reloadMsg = [[UILabel alloc] init];
        _reloadMsg.textAlignment = NSTextAlignmentCenter;
        _reloadMsg.font = [UIFont systemFontOfSize:14];
        _reloadMsg.textColor =  [UIColor colorWithWhite:0.600 alpha:1.000];
    }
    return _reloadMsg;
}

- (UIImageView *)errorImageView
{
    if (!_errorImageView) {
        _errorImageView = [[UIImageView alloc] init];
    }
    return _errorImageView;
}

- (UIView *)holderView
{
    if (!_holderView) {
        _holderView = [[UIView alloc] initWithFrame:CGRectMake(kYBPlaceHolderMagrin, 0, self.frame.size.width - kYBPlaceHolderMagrin * 2, 200)];
    }
    return _holderView;
}


/** 刷新界面  */
- (void)reloadDataView:(id)sender
{
    if (_reloadBlock)
    {
        self.reloadBlock();
    }
}

- (void)dealloc
{
    if (_reloadBlock) {
        _reloadBlock = nil;
    }
}

- (void)placeHolderCellReloadBlock:(YBPlaceHolderCellReloadBlock)block
{
    self.reloadBlock = block;
}

@end

@interface YBPlaceHolderModel()
{
    
}
@end

@implementation YBPlaceHolderModel


@end