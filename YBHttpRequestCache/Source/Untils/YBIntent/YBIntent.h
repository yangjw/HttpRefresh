//
//  YBIntent.h
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/9.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YBMacros.h"

@class YBIntent;
/** 回调  */
typedef NS_ENUM(NSInteger,YBIntentResultCode) {
    YBIntentResultCodeOK,  /** 成功  */
    YBIntentResultCodeCanceled, /** 取消 */
    YBIntentResultCodeReload/** 刷新  */
};

@protocol YBIntentForResultSendable <NSObject>
/**
 *  回调
 *
 *  @param requestCode 请求code
 *  @param resultCode  返回code
 *  @param data        集合
 */
- (void)onControllerResult:(NSNumber *)requestCode resultCode:(YBIntentResultCode)resultCode data:(YBIntent *)data;

@end

/** 使用此类 必须实现此协议  */
@protocol YBIntentReceivable <NSObject>

@optional
/** init 对象 使用此协议 */
- (id)initWithExtras:(NSDictionary<NSString *,id> *)extras;
/** 使用故事版、xib 使用此协议  */
+ (id)allocWithParams:(NSDictionary<NSString *,id> *)extras;

@end

/** 扩展回调协议额  */
@protocol YBIntentForResultReceivable <NSObject,YBIntentReceivable>

@required
/** 跳转code  */
- (void)setRequestCode:(NSNumber *)requestCode;
/** 代理  */
- (void)setDelegate:(id<YBIntentForResultSendable>)delegate;

@end
/** 跳转协议  */
@protocol YBIntentControllerDisplay <NSObject>
/**
 *  跳转
 *
 *  @param source      来源
 *  @param destination 目的地
 */
- (void)displayViewControllerSource:(UIViewController*)source destination:(UIViewController *)destination;

@end

/** 弹出效果  */
@interface YBIntentPresentationDisplay : NSObject<YBIntentControllerDisplay>

@end

/** 面包效果  */
@interface YBIntentPushDisplay : NSObject<YBIntentControllerDisplay>

@end

@interface YBIntent : NSObject
/**
 *  路由url
 */
@property (nonatomic, strong) NSString *url YBDeprecated("路由方法没有实现");
/**
 *  对象
 */
@property (nonatomic, strong) Class receiveClass;
/** 跳转方式  */
@property (nonatomic, assign) id <YBIntentControllerDisplay> controllerDisplay;
/** 值  */
@property (nonatomic, strong) NSMutableDictionary<NSString *,id> *extras;

/**
 *  初始化 跳转对象
 *
 *  @param receiveClass 类
 *
 *  @return 对象
 */
- (instancetype)initWithClazz:(id)receiveClass;
/**
 *  初始化 跳转对象
 *
 *  @param url 路由url
 *
 *  @return 对象
 */
- (instancetype)initWithUrl:(NSString *)url YBDeprecated("路由方法没有实现");
/**
 *  传值
 *
 *  @param name key
 *  @param data value
 */
- (void)putExtraWithName:(NSString *)name data:(id)data;

@end
