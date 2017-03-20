//
//  YBSessionCache.h
//  YBJK
//
//  Created by yangjw on 16/10/31.
//  Copyright © 2016年 mahong. All rights reserved.
//

#import <Foundation/Foundation.h>



/*
 example:
 
 //    [[YBSessionCache sharedCache] sessionCacheKey:nil url:@"http://www.weather.com.cn/data/sk/101190408.html" expTime:1*60 complete:^(id responseObject) {
 //        NSLog(@"--->%@",responseObject);
 //    }];
 //
 [[YBSessionCache sharedCache] setTimeoutInterval:10];
 [[YBSessionCache sharedCache] sessionCacheKey:nil url:@"http://www.ybjk.com/" expTime:1*60 complete:^(id responseObject) {
 NSLog(@"--->%@",responseObject);
 }];
 
 [[YBSessionCache sharedCache] sessionCacheKey:nil url:@"https://rapi.mnks.cn/v1/banner/app_banner_com.runbey.ybjk_shequ.json" expTime:10 complete:^(id responseObject) {
 NSLog(@"--->%@",responseObject);
 }];
 */
/** 天->秒  */
#define YBDayS(D) D * 24 * 60 * 60
/** 时->秒  */
#define YBHourS(H) H * 60 * 60
/** 分->秒  */
#define YBMinS(M) M * 60

/** 请求返回数据  */
typedef void(^YBSessionCacheCompleteBlock)(id responseObject);

/**   */
@interface YBSessionCache : NSObject
{

}
+ (instancetype)sharedCache;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;


/**
 *  请求缓存数据
 *
 *  @param key           保存本地key
 *  @param url           get: httpUrl
 *  @param time          缓存时间
 *  @param completeBlock data
 */
- (void)sessionCacheKey:(NSString *)key url:(NSString *)url expTime:(NSTimeInterval)expTime complete:(YBSessionCacheCompleteBlock)completeBlock;
@end
