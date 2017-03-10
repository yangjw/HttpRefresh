//
//  YBHttpCache.h
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/6.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AFNetworking.h>

typedef NS_ENUM(NSInteger,YBHttpCacheMethod) {
    YBHttpCacheMethodGet,
    YBHttpCacheMethodPost
};

/** 话题详情缓存文件夹  */
#define YBCacheCommuityPath @"YBCommuityPath"

/** 请求缓存目录  */
UIKIT_EXTERN NSString *const YBHttpCachePath;

/** 缓存tabbar图片目录  */
UIKIT_EXTERN NSString *const YBCacheRequestImageCache;
/** 立即请求 忽略缓存时间 */
UIKIT_EXTERN NSTimeInterval const YBRequestImmediately;
/** 读取文件的时间常量  */
UIKIT_EXTERN NSTimeInterval const YBCacheReadTimeInterVal;
/** 判断文件是否存在的时间常量  */
UIKIT_EXTERN NSTimeInterval const YBCacheFileTimeInterVal;
/** 文件存在  */
UIKIT_EXTERN NSString *const YBCacheFileExistYes;
/** 文件不存在  */
UIKIT_EXTERN NSString *const YBCacheFileExistNo;

/** 话题详情缓存目录  */
NSString *YBCacheReqeustCommuntiyPath();

/** 请求缓存图片  */
typedef void(^YBRequestCacheImageCompleteBlock)(UIImage *image,NSString *file);

/** 请求数据  */
typedef void(^YBRequestCacheCompleteBlock)(id responseObject);

/** 请求数据返回格式json  */
typedef void(^YBRequestJSONCompleteBlock)(NSDictionary *response,NSError *error);


@interface YBHttpCache : NSObject

+ (instancetype)sharedCache;

/**
 *  AFHTTPSessionManager 对象
 */
@property (strong, nonatomic) AFHTTPSessionManager *httpManager;

/** 超时时间  */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/** 添加其他 请求头  ps:使用此类进行扩展 */
@property (readwrite,nonatomic, strong) NSMutableDictionary *httpHeaderField;

/**
 *  初始化请求头
 */
-(void)httpHeadersField;
/** 移除自定义的请求头,并初始化  */
- (void)removeAllHeadersField;

/**
 *  get 获取json 数据
 *
 *  @param key           缓存key
 *  @param url           url
 *  @param parms         参数
 *  @param expTime       过期
 *  @param completeBlock
 */
- (void)requestGetJSONCacheKey:(NSString *)key url:(NSString *)url parms:(NSMutableDictionary *)parms expTime:(NSTimeInterval)expTime complete:(YBRequestJSONCompleteBlock)completeBlock;


/**
 *  post 获取json 数据
 *
 *  @param key           缓存key
 *  @param url           url
 *  @param parms         参数
 *  @param expTime       过期
 *  @param completeBlock
 */
- (void)requestPostJSONCacheKey:(NSString *)key url:(NSString *)url parms:(NSMutableDictionary *)parms expTime:(NSTimeInterval)expTime complete:(YBRequestJSONCompleteBlock)completeBlock;

/**
 *  post 获取 数据
 *
 *  @param key           缓存key
 *  @param url           url
 *  @param parms         参数
 *  @param expTime       过期
 *  @param completeBlock
 */
- (void)requestPostCacheKey:(NSString *)key url:(NSString *)url parms:(NSMutableDictionary *)parms expTime:(NSTimeInterval)expTime complete:(YBRequestCacheCompleteBlock)completeBlock;

/**
 *  get 获取数据
 *
 *  @param key           缓存key
 *  @param url           url
 *  @param parms         参数
 *  @param expTime       过期
 *  @param completeBlock
 */
- (void)requestGetCacheKey:(NSString *)key url:(NSString *)url parms:(NSMutableDictionary *)parms expTime:(NSTimeInterval)expTime complete:(YBRequestCacheCompleteBlock)completeBlock;

/**
 *  获取数据 添加认证请求头
 *
 *  @param key           缓存key
 *  @param url           url
 *  @param parms         参数
 *  @param expTime       过期
 *  @param completeBlock
 */
- (void)requestAuthenticationCacheKey:(NSString *)key url:(NSString *)url method:(YBHttpCacheMethod)method parms:(NSMutableDictionary *)parms expTime:(NSTimeInterval)time complete:(YBRequestCacheCompleteBlock)completeBlock;

/**
 *  获取数据 添加请求头
 *
 *  @param key           缓存key
 *  @param url           url
 *  @param parms         参数
 *  @param expTime       过期
 *  @param completeBlock
 */
- (void)requestHttpHeadCacheKey:(NSString *)key url:(NSString *)url method:(YBHttpCacheMethod)method parms:(NSMutableDictionary *)parms expTime:(NSTimeInterval)time complete:(YBRequestCacheCompleteBlock)completeBlock;

/**
 *  请求缓存数据
 *
 *  @param key           保存本地key
 *  @param url           url
 *  @param method        请求方式
 *  @param parms         请求参数
 *  @param time          缓存时间
 *  @param completeBlock 回调
 */
- (void)requestCacheKey:(NSString *)key url:(NSString *)url method:(YBHttpCacheMethod)method parms:(NSDictionary *)parms expTime:(NSTimeInterval)time complete:(YBRequestCacheCompleteBlock)completeBlock;
/**
 *  清除缓存文件,文件时间
 *
 *  @param dir  目录
 *  @param time 缓存时间
 */
- (void)deletesFiles:(NSString *)dir time:(NSTimeInterval )time;
/**
 *  AF缓存图
 *
 *  @param key           文件名字
 *  @param url           地址
 *  @param expTime       过期时间
 *  @param imageSuffix   后缀  @2x.png、@3x.png、.png、.jpeg、.jpg
 *  @param completeBlock 回调
 */
- (void)requestAFImageCacheKey:(NSString *)key url:(NSString *)url expTime:(NSTimeInterval)expTime imageSuffix:(NSString *)imageSuffix complete:(YBRequestCacheImageCompleteBlock)completeBlock;
/**
 *  图片缓存
 *
 *  @param key           文件名字
 *  @param url           地址
 *  @param expTime       过期时间
 *  @param imageSuffix   默认后缀@2x.png
 *  @param completeBlock 回调
 */
- (void)requestImageCacheKey:(NSString *)key url:(NSString *)url expTime:(NSTimeInterval)expTime complete:(YBRequestCacheImageCompleteBlock)completeBlock;
/**
 *  图片缓存
 *
 *  @param key           文件名字
 *  @param url           地址
 *  @param expTime       过期时间
 *  @param imageSuffix   后缀  @2x.png、@3x.png、.png、.jpeg、.jpg
 *  @param completeBlock 回调
 */
-(void)requestImageCacheKey:(NSString *)key url:(NSString *)url expTime:(NSTimeInterval)expTime imageSuffix:(NSString *)imageSuffix complete:(YBRequestCacheImageCompleteBlock)completeBlock;
/** 删除超过30天的活动图片  */
-(void)deletesImageFiles;
@end
