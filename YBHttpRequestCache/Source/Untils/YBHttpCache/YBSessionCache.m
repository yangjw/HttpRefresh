//
//  YBSessionCache.m
//  YBJK
//
//  Created by yangjw on 16/10/31.
//  Copyright © 2016年 mahong. All rights reserved.
//

#import "YBSessionCache.h"
#import "YBCache.h"
#import "YBFileTool.h"
#import "NSString+Custom.h"
#import "YBDateTool.h"
#import "AFNetworking.h"
#import "NSDictionary+Custom.h"

#define YBSessionRequestCache @"YBSessionCache"

/** 超时时间  */
#define YBSessionTimeoutInterval 5
/** 过期时间  */
#define YBSessionExpTime  5*60

/** 获取缓存文件默认存储位置 */
NSString *YBSessionCachePath() {
    return  [[NSDocumentsFolder() stringByAppendingPathComponent:YBSessionRequestCache] copy];
}
/** 文件名称  */
NSString *YBSessionCacheFile(NSString* key)
{
    return [[YBSessionCachePath() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",key]] copy];
}

@interface YBSessionCache ()<NSURLSessionDelegate>
{
    
}
@property (readonly) NSURLSession *defaultSession;
@property NSMutableDictionary *headers;
@end

@implementation YBSessionCache

+ (instancetype)sharedCache {
    static YBSessionCache *_sharedCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCache = [[YBSessionCache alloc] init];
    });
    
    return _sharedCache;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        /** 创建 网络请求 缓存 */
        [[YBFileTool sharedManager] createDir:YBSessionCachePath()];
        self.timeoutInterval = YBSessionTimeoutInterval;
        self.headers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)sessionCacheKey:(NSString *)key url:(NSString *)url expTime:(NSTimeInterval)expTime complete:(YBSessionCacheCompleteBlock)completeBlock
{
    __block NSString *cnt = @"";
    /** 时间戳起始日期2000.1.1.00.00.00  */
    __block NSTimeInterval modTime = 946656000;
    /** 保存key  */
    if (!key)
    {
        key = url.md5String;
    }
    /** 本地路径  */
    NSString *file = YBSessionCacheFile(key);
    
    YBFileTool *ft = [YBFileTool sharedManager];
    YBDateTool *dt = [YBDateTool shareManager];
    if ([ft fileExistsAtPath:file])
    {
        cnt = [ft readFile:file];
        modTime =  [dt getTimeIntervalWithDate:[ft fileModDate:file]];
    }
    /** 当前时间戳  */
    NSTimeInterval nowTime = [dt getTimeIntervalWithDate:[NSDate date]];
    
    if (expTime <= 0)
    {
        expTime = YBSessionExpTime;
    }
    /** 请求失败把之前的内容 延迟过期时间  */
    NSTimeInterval changeTime = nowTime - modTime + expTime;
    
    /** 检测缓存是否过期  */
    if ((nowTime - modTime) > expTime)
    {
        //创建Request请求
        NSMutableURLRequest *request = [self request:url method:@"GET" parms:nil];
        self.timeoutInterval = YBSessionTimeoutInterval;
        
        NSURLSessionTask *task = [self.defaultSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            // 请求失败，打印错误信息
            if (error) {
                NSLog(@"%@",error.localizedDescription);
                dispatch_async(dispatch_get_main_queue(), ^{
                    /** 请求失败  超时等等*/
                    [ft writeFile:file data:cnt];
                    [ft changeFileTime:file date:[NSDate dateWithTimeIntervalSinceNow:changeTime]];
                    [self callBack:cnt complete:completeBlock];
                    NSLog(@"请求失败:----->:%@---->:%@",response,error);
                });
            }
            // 8、请求成功，解析数据
            else {
                NSHTTPURLResponse *responseObject = (NSHTTPURLResponse *)response;
                if (responseObject.statusCode == 200)
                {
                    // 直接将data数据转成OC字符串(NSUTF8StringEncoding)；
                    cnt = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    // 解析成功，处理数据，通过GCD获取主队列，在主线程中刷新界面。
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ft writeFile:file data:cnt];
                        NSLog(@"%@",cnt);
                        [self callBack:cnt complete:completeBlock];
                    });
                }else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        /** 请求失败  超时等等*/
                        [ft writeFile:file data:cnt];
                        [ft changeFileTime:file date:[NSDate dateWithTimeIntervalSinceNow:changeTime]];
                        [self callBack:cnt complete:completeBlock];
                        NSLog(@"请求失败:----->:%@---->:%@",response,error);
                    });
                }
            }
        }];
        //执行任务
        [task resume];
    }else
    {
        [self callBack:cnt complete:completeBlock];
    }
}

-(void)callBack:(NSString *)cnt complete:(YBSessionCacheCompleteBlock)completeBlock
{
    if (_headers) {
        [self.headers removeAllObjects];
    }
    
    self.timeoutInterval = YBSessionTimeoutInterval;
    if (completeBlock) {
        completeBlock(cnt);
    }
}

/**
 *  创建请求
 *
 *  @param url    url
 *  @param method 请求方式GET POST
 *  @param parms  请求参数
 *
 *  @return 请求对象
 */
- (NSMutableURLRequest *)request:(NSString *)url method:(NSString *)method parms:(NSMutableDictionary *)parms
{
    // 1、构造URL资源地址
    NSURL *httpUrl = [NSURL URLWithString:url];
    // 2、创建Request请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:httpUrl];
    // 3、配置Request请求
    // 设置请求方法
    request.HTTPMethod = method;
    // 设置请求超时
    request.timeoutInterval = _timeoutInterval;
    if ([method isEqualToString:@"POST"])
    {
        NSMutableArray *parameters = [[NSMutableArray alloc] init];
        for (NSString *key in parms.allKeys) {
            // 拼接字符串
            [parameters addObject:[NSString stringWithFormat:@"%@=%@",key,parms[key]]];
        }
        //截取参数字符串，去掉最后一个“&”，并且将其转成NSData数据类型。
        NSData *parametersData = [[parameters componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding];
        request.HTTPBody = parametersData;
    }
    // 设置头部参数
    [self setWithAppInfo:request];
    return  request;
}


/**
 *  请求头文件中添加appInfo
 */
- (void)setWithAppInfo:(NSMutableURLRequest *)request
{
//    NSSet *set = [NSSet setWithObjects:@"", @"text/json", @"text/javascript",@"text/plain", @"text/html", nil];
//    NSString *contentType = [NSString stringWithFormat:@"application/json,",];
//    [request setValue:@"" forHTTPHeaderField: @"Content-Type"];
    
    [request setValue:[NSString stringWithFormat:@"http://%@/",APP_BUNDLEID] forHTTPHeaderField:@"Referer"];
    /** 获取系统UA  自定义UA*/
    NSDictionary *headFields = request.allHTTPHeaderFields;
    NSString *sysUA = [headFields objectForKey:@"User-Agent"];
    NSString *bundleIdentifier = APP_BUNDLEID;
    NSString *version = APP_VERSION;
    NSString *buildVersion = APP_BUILD;
    
    NSString *customAgent = [NSString stringWithFormat:@"MozillaMobile/10.17 %@ com.runbey.app/1.0 (Runbey) RBBrowser/1.0.1 %@/%@/%@",sysUA,bundleIdentifier,version,buildVersion];
    [request setValue:customAgent forHTTPHeaderField:@"User-Agent"];
    
    NSString *appInfo = [YBAppInfoHandler fetchAppInfoWithBase64:YES];
    NSString *SQH = [LoginManager instanceManager].loginUserInfo.SQH ?: BLANK;
    NSString *SQHKEY = [LoginManager instanceManager].loginUserInfo.SQHKEY ?: BLANK;
    
    [request setValue:appInfo forHTTPHeaderField:@"Runbey-Appinfo"];
    [request setValue:SQH forHTTPHeaderField:@"Runbey-Appinfo-SQH"];
    [request setValue:SQHKEY forHTTPHeaderField:@"Runbey-Appinfo-SQHKEY"];
}

/** session  */
-(NSURLSession*) defaultSession {
    
    static dispatch_once_t onceToken;
    static NSURLSessionConfiguration *defaultSessionConfiguration;
    static NSURLSession *defaultSession;
    dispatch_once(&onceToken, ^{
        defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultSession = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration
                                                       delegate:self
                                                  delegateQueue:[NSOperationQueue mainQueue]];
    });
    
    return defaultSession;
}

#pragma mark -
#pragma mark NSURLSession Authentication delegates

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
    }
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPBasic] ||
       [challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPDigest]){
        
        if([challenge previousFailureCount] == 3) {
            completionHandler(NSURLSessionAuthChallengeRejectProtectionSpace, nil);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    }
}

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval {
    [self willChangeValueForKey:NSStringFromSelector(@selector(timeoutInterval))];
    _timeoutInterval = timeoutInterval;
    [self didChangeValueForKey:NSStringFromSelector(@selector(timeoutInterval))];
}

-(void)addHeaders:(NSDictionary*) headersDictionary {
    
    [self.headers addEntriesFromDictionary:headersDictionary];
}

-(void)setAuthorizationHeaderValue:(NSString*)value forAuthType:(NSString*)authType {
    
    self.headers[@"Authorization"] = [NSString stringWithFormat:@"%@ %@", authType, value];
}

- (void)dealloc
{

}
@end
