//
//  YBSessionUpdateCache.h
//  YBJKWYC
//
//  Created by yangjw on 17/3/20.
//  Copyright © 2017年 高昇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// MARK: 常量属性定义
/** 立即请求 忽略缓存时间 */
UIKIT_EXTERN NSTimeInterval const YBSessionCacheImmediately; /** 1  */
/** 读取文件的时间常量  */
UIKIT_EXTERN NSTimeInterval const YBSessionCacheReadTimeInterVal; /** 9999  */
/** 修改时间缓存文件超时  */
UIKIT_EXTERN NSTimeInterval const YBSessionCacheModTimeInterVal; /** 8888  */
/** 判断文件是否存在的时间常量  */
UIKIT_EXTERN NSTimeInterval const YBSessionCacheFileTimeInterVal; /** 7777  */
/** 检测文件是否过期  */
UIKIT_EXTERN NSTimeInterval const YBSessionCacheExpTimeOutInterVal;  /** 6666  */ /** 读取文件是否过期key定义(YBExpTimeOutInterVal##key)  */

// MARK: 数据请求时间默认配置项
/** 文件存在 or 文件过期  or 删除状态*/
UIKIT_EXTERN NSString *const YBSessionCacheFileExistYes; /** Y  */
/** 文件不存在 or 文件未过期 or 删除状态 */
UIKIT_EXTERN NSString *const YBSessionCacheFileExistNo; /** N  */
/** 超时时间  */
UIKIT_EXTERN NSTimeInterval const YBSessionCacheTimeoutInterval; /** 默认 20 秒  */
/** 默认过期时间  */
UIKIT_EXTERN NSTimeInterval const YBSessionCacheExpTime; /** 默认:5*60  秒 */

// MARK: 文件夹完整路径
/** 获取缓存文件默认存储位置 */
UIKIT_STATIC_INLINE NSString *YBSessionCachePath();
/** 话题详情缓存目录  */
//UIKIT_STATIC_INLINE NSString *YBSessionCacheCommuntiyPath();
/** 缓存文件全路径  */
UIKIT_STATIC_INLINE NSString *YBSessionCacheKeyFile(NSString* key);

// MARK: 文件夹名称
/** 自更新文件夹名称  */
UIKIT_EXTERN NSString *const YBSessionCacheFile;
/** 话题详情缓存文件夹名称  */
UIKIT_EXTERN NSString *const YBSessionCacheCommuityFile;
/** 置顶帖缓存目录  */
UIKIT_EXTERN NSString *const YBSessionCacheTopCommunityCache;
/** 缓存tabbar图片文件夹名称  */
UIKIT_EXTERN NSString *const YBSessionCacheImageCache;

// MARK: 回调函数
/** 请求数据  */
typedef void(^YBSessionCacheCompleteBlock)(id responseObject);
/** 请求返回  NSDictionary 集合 */
typedef void(^YBSessionCacheResponseBlock)(NSDictionary *response,NSError *error);

// MARK: example
/*
 example:
    [[YBSessionCache sharedCache] requestCacheKey:nil url:@"http://www.ybjk.com/" expTime:1*60 complete:^(id responseObject) {
        NSLog(@"--->%@",responseObject);
         if (responseObject)
         {
             NSDictionary *response = [responseObject jsonStringConvertToDictionary];
             if (response && [response isKindOfClass:[NSDictionary class]])
             {
                 if ([response[networkResult] isEqualToString:networkSuccess])
                 {
                     if (response[networkData])
                     {
                     
                     }
                 }
             }
         }
    }];
*/

@interface YBSessionUpdateCache : NSObject<NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>
/**
 *  单例
 *
 *  @return 对象
 */
+ (instancetype)sharedCache;
// MARK: 设置请求属性
/**
 *  只读属性 session对象
 */
@property (readonly) NSURLSession *session;
/** 任务  */
@property (nonatomic, strong) NSURLSessionDataTask *sessionDataTask;
/** 请求超时时间  */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
/** 添加请求头  */
- (void)addHeaders:(NSDictionary*)headersDictionary;
/** 添加认证头  */
- (void)setAuthorizationHeaderValue:(NSString*)value forAuthType:(NSString*)authType;
#pragma mark - 自更新请求
// MARK: 返回值为NSDictionary
/**
 *  Get 返回值为NSDictionary: 网络请求
 *  key可以为空，缓存本地的数据对url进行md5
 *  @param key            key : 1.读取文件是否过期key定义(expTime##key) 2.创建缓存目录指定key   缓存根目录:YBReqeustCache  PATH/key   exp: YBCacheData/Community/sp-communityId
 *  @param url           url
 *  @param expTime       有效期
 *  @param responseBlock NSDictionary
 */
- (void)sessionCacheKey:(NSString *)key url:(NSString *)url expTime:(NSTimeInterval)expTime response:(YBSessionCacheResponseBlock)responseBlock;
/**
 *  NSDictionary:网络请求
 *  key可以为空，缓存本地的数据对url进行md5
 *  @param key           key : 1.读取文件是否过期key定义(expTime##key) 2.创建缓存目录指定key   缓存根目录:YBReqeustCache  PATH/key    exp: YBReqeustCache/Community/key
 *  @param url           url
 *  @param parms         请求参数
 *  @param expTime       有效期
 *  @param responseBlock NSDictionary
 */
- (void)sessionCacheKey:(NSString *)key url:(NSString *)url parms:(NSMutableDictionary *)parms expTime:(NSTimeInterval)expTime response:(YBSessionCacheResponseBlock)responseBlock;

// MARK: 字符串
/**
 *  网络请求 APPinfo:添加
 *  key可以为空，缓存本地的数据对url进行md5
 *  @param key           key : 1.读取文件是否过期key定义(expTime##key) 2.创建缓存目录指定key   缓存根目录:YBReqeustCache  PATH/key   exp: YBReqeustCache/Community/key
 *  @param url           url
 *  @param parms         请求参数:有请求参数:POST 无:GET
 *  @param expTime       有效期
 *  @param completeBlock 回调
 */
- (void)sessionCacheAuthCacheKey:(NSString *)key url:(NSString *)url parms:(NSMutableDictionary *)parms expTime:(NSTimeInterval)expTime complete:(YBSessionCacheCompleteBlock)completeBlock;
// MARK: 默认请求头
- (void)sessionCacheKey:(NSString *)key url:(NSString *)url expTime:(NSTimeInterval)expTime complete:(YBSessionCacheCompleteBlock)completeBlock;
/**
 *  自更新主函数:网络请求
 *  key可以为空，缓存本地的数据对url进行md5
 *  @param key           key : 1.读取文件是否过期key定义(expTime##key) 2.创建缓存目录指定key   缓存根目录:YBReqeustCache  PATH/key    exp: YBReqeustCache/Community/key
 *  @param url           url
 *  @param parms         请求参数:有请求参数:POST 无:GET
 *  @param expTime       有效期
 *  @param completeBlock 回调
 */
- (void)sessionCacheKey:(NSString *)key url:(NSString *)url parms:(NSMutableDictionary *)parms expTime:(NSTimeInterval)expTime complete:(YBSessionCacheCompleteBlock)completeBlock;

#pragma mark - 删除自更新数据

/**
 *  删除  缓存根目录:YBSessionCachePath()
 *  key可以为空，缓存本地的数据对url进行md5
 *  @param key           默认删除YBSessionCachePath()目录下文件  exp:删除指定缓存目录指定keyPATH/key    exp: YBReqeustCache/Community/key
 *  @param url           url
 *  @param completeBlock 回调 成功:Y 失败：N
 */
- (void)clearCacheKey:(NSString *)key url:(NSString *)url complete:(YBSessionCacheCompleteBlock)completeBlock;
/**
 *  删除文件夹 指定超时时间: 根目录-->YBSessionCachePath()
 *
 *  @param dir     文件夹名称
 *  @param expTime 过期时间
 */
- (void)deleteDir:(NSString *)dir with:(NSTimeInterval)expTime;
/**
 *  删除自更新指定文件夹内容:根目录-->YBSessionCachePath()
 *
 *  @param dir 文件夹名称
 */
- (void)deletesSessionCachePathCacheDir:(NSString *)dir;
@end
/** 自更新  */
#define YBUpdateCache [YBSessionUpdateCache sharedCache]