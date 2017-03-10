//
//  UIPlaceHolderTextView.h
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/12.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBPlaceHolderTextView : UITextView
{
    NSString *placeholder;
    UIColor *placeholderColor;
    UILabel *placeHolderLabel;
}
@property(nonatomic, strong) UILabel *placeHolderLabel;
@property(nonatomic, strong) NSString *placeholder;
@property(nonatomic, strong) UIColor *placeholderColor;

- (void)textChanged:(NSNotification*)notification;
@end

