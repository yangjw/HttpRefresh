//
//  YBSessionUpdateCache.m
//  YBJKWYC
//
//  Created by yangjw on 17/3/20.
//  Copyright © 2017年 高昇. All rights reserved.
//

#import "YBSessionUpdateCache.h"

#import "YBFileTool.h"
#import "NSString+Custom.h"
#import "YBDateTool.h"
#import "NSDictionary+Custom.h"
/** 立即请求 */
NSTimeInterval const YBSessionCacheImmediately = 1;
/** 读取文件  */
NSTimeInterval const YBSessionCacheReadTimeInterVal = 9999;
/** 修改时间  */
NSTimeInterval const YBSessionCacheModTimeInterVal = 8888;
/** 文件是否存在  */
NSTimeInterval const YBSessionCacheFileTimeInterVal = 7777;
/** 是否过期  */
NSTimeInterval const YBSessionCacheExpTimeOutInterVal = 6666;

/** 文件存在 or 文件过期 */
NSString *const YBSessionCacheFileExistYes = @"Y";
/** 文件不存在 or 文件未过期 */
NSString *const YBSessionCacheFileExistNo = @"N";
/** 缓存图片路径  */
NSString *const YBSessionCacheImageCache = @"YBRequestImageCache";
/** 置顶帖目录  */
NSString *const YBSessionCacheTopCommunityCache  = @"YBRequestTopCommunityCache";
/** 话题缓存文件夹  */
NSString *const YBSessionCacheCommuityFile = @"YBCommuityPath";
/** 自更新根文件夹名称  */
NSString *const YBSessionCacheFile = @"YBReqeustCache";

/** 超时时间  */
NSTimeInterval const YBSessionCacheTimeoutInterval = 20;
/** 默认过期时间  */
NSTimeInterval const YBSessionCacheExpTime = 5*60;

/** 获取缓存文件默认存储位置 */
NSString *YBSessionCachePath() {
    return  [[NSDocumentsFolder() stringByAppendingPathComponent:YBSessionCacheFile] copy];
}
/** 话题详情缓存  */
//NSString *YBSessionCacheCommuntiyPath(){
//    return  [[YBSessionCachePath() stringByAppendingPathComponent:YBSessionCacheCommuityFile] copy];
//}
/** 文件名称  */
NSString *YBSessionCacheKeyFile(NSString* key)
{
    return [[YBSessionCachePath() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",key]] copy];
}

// MARK: 编码
NSString * YBPercentEscapedStringFromString(NSString *string) {
    static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
    static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
    
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
    static NSUInteger const batchSize = 50;
    
    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;
    
    while (index < string.length) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wgnu"
        NSUInteger length = MIN(string.length - index, batchSize);
#pragma GCC diagnostic pop
        NSRange range = NSMakeRange(index, length);
        
        // To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [string rangeOfComposedCharacterSequencesForRange:range];
        
        NSString *substring = [string substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        
        index += range.length;
    }
    
    return escaped;
}

@interface YBSessionUpdateCache ()
{
    
}
/**
 *  文件工具
 */
@property (nonatomic, strong) YBFileTool *ft;
/** 日期工具  */
@property (nonatomic, strong) YBDateTool *dt;
/** 请求头  */
@property (nonatomic, strong) NSMutableDictionary *httPRequestHeaders;

@end
@implementation YBSessionUpdateCache
#pragma mark - lazyInit

+ (instancetype)sharedCache {
    static YBSessionUpdateCache *_sharedCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCache = [[YBSessionUpdateCache alloc] init];
    });
    
    return _sharedCache;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        /** 创建 网络请求 缓存 */
        [[YBFileTool sharedManager] createDir:YBSessionCachePath()];
        self.timeoutInterval = YBSessionCacheExpTime;
    }
    return self;
}
- (YBFileTool *)ft
{
    if (!_ft) {
        _ft = [YBFileTool sharedManager];
    }
    return _ft;
}

- (YBDateTool *)dt
{
    if (!_dt) {
        _dt = [YBDateTool shareManager];
    }
    return _dt;
}
/** 请求头  */
- (NSMutableDictionary *)httPRequestHeaders
{
    if (!_httPRequestHeaders) {
        _httPRequestHeaders = [[NSMutableDictionary alloc] init];
    }
    return _httPRequestHeaders;
}

#pragma mark - 自更新请求
- (void)sessionCacheAuthCacheKey:(NSString *)key url:(NSString *)url parms:(NSMutableDictionary *)parms expTime:(NSTimeInterval)expTime complete:(YBRequestCacheCompleteBlock)completeBlock
{
    [self setLoginHttpReqHeader:parms];
    [self sessionCacheKey:key url:url parms:parms expTime:expTime complete:completeBlock];
}

/**
 *  设置登陆模块http请求头文件信息
 */
- (void)setLoginHttpReqHeader:(NSMutableDictionary *)dictionary
{
    if (!dictionary) return;
    
    /** 获取当前时间戳 */
    NSString *timeStamp = [YBAppInfoHandler getCurrentTimeStamp];
    /** 获取token */
    NSString *token = [YBAppInfoHandler getHexRandomToken];
    /** loginApp */
    NSString *loginApp = [NSString stringWithFormat:@"ios_%@_%@",APP_BUNDLEID,APP_VERSION];
    /** 临时key */
    NSString *tmpKey = [NSString stringWithFormat:@"%@%@%@",token,loginApp,timeStamp];
    /** secKey */
    NSString *secKey = [YBAppInfoHandler encryptionReq:dictionary withtmpKey:tmpKey];
    
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    [resultDict setObject:token forKey:@"_token"];
    [resultDict setObject:loginApp forKey:@"_app"];
    [resultDict setObject:timeStamp forKey:@"_timestamp"];
    [resultDict setObject:secKey forKey:@"_secKey"];
    
    NSString *result = [resultDict convertToJson] ?: BLANK;
    result = [result encodeToBase64];
    [self.httPRequestHeaders setValue:result forKey:@"RUNBEY_SECINFO"];
}

- (void)sessionCacheKey:(NSString *)key url:(NSString *)url expTime:(NSTimeInterval)expTime complete:(YBRequestCacheCompleteBlock)completeBlock
{
    [self sessionCacheKey:key url:url parms:nil expTime:expTime complete:completeBlock];
}
/**
 *  Get 网络请求
 *
 *  @param key           key : 1.读取文件是否过期key定义(expTime##key) 2.创建缓存目录指定key   缓存根目录:YBReqeustCache  PATH/key   exp: YBCacheData/Community/sp-communityId
 *  @param url           url
 *  @param expTime       有效期
 *  @param responseBlock NSDictionary
 */
- (void)sessionCacheKey:(NSString *)key url:(NSString *)url expTime:(NSTimeInterval)expTime response:(YBSessionCacheResponseBlock)responseBlock
{
    [self sessionCacheKey:key url:url expTime:expTime response:responseBlock];
}
/**
 *  网络请求  鉴权
 *
 *  @param key           key : 1.读取文件是否过期key定义(expTime##key) 2.创建缓存目录指定key   缓存根目录:YBReqeustCache  PATH/key   exp: YBCacheData/Community/sp-communityId
 *  @param url           url
 *  @param parms         请求参数
 *  @param expTime       有效期
 *  @param responseBlock NSDictionary
 */
- (void)sessionCacheKey:(NSString *)key url:(NSString *)url parms:(NSMutableDictionary *)parms expTime:(NSTimeInterval)expTime response:(YBSessionCacheResponseBlock)responseBlock
{
    [self sessionCacheKey:key url:url parms:parms expTime:expTime complete:^(id responseObject) {
        if (responseObject)
        {
            NSError *error = nil;
            NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&error];
            if (responseBlock)
            {
                if (error) {
                    responseBlock(nil,error);
                }
                else
                {
                    responseBlock(dic,nil);
                }
            }
        }
    }];
}


- (void)sessionCacheKey:(NSString *)key url:(NSString *)url parms:(NSMutableDictionary *)parms expTime:(NSTimeInterval)expTime complete:(YBSessionCacheCompleteBlock)completeBlock
{
    __block NSString *cnt = @"";
    /** 时间戳起始日期2000.1.1.00.00.00  */
    __block NSTimeInterval modTime = 946656000;
    
    NSArray *keys = [key componentsSeparatedByString:@"##"];
    NSTimeInterval expTimeOut = 0;
    if (keys.count == 2)
    {
        key = [keys lastObject];
        expTimeOut = [[keys firstObject] integerValue];
    }else if (keys.count == 1)
    {
        key = [keys lastObject];
    }
    if (key.length > 0)
    {
        NSArray *components = [key pathComponents];
        if (components.count == 2) {
            NSString *path = key.stringByDeletingLastPathComponent;
            if (path != nil || path.length > 0)
            {
                NSString *dir = [NSString stringWithFormat:@"%@/%@",YBSessionCachePath(),path];
                if (![[YBFileTool sharedManager] fileExistsAtPath:dir])
                {
                    [[YBFileTool sharedManager] createDir:dir];
                }
            }
        }
    }
    /** 保存key  */
    if (!key)
    {
        key = url.md5String;
    }
    /** 本地路径  */
    NSString *file = YBSessionCacheKeyFile(key);
    
    __weak typeof(self)weakSelf = self;
    /** 判断文件是否存在  */
    if (expTime == YBFileTimeInterVal) {
        
        if ([weakSelf.ft fileExistsAtPath:file]) {
            /** 文件存在  */
            [weakSelf callBack:YBFileExistYes complete:completeBlock];
        }else
        {
            /** 文件不存在存在  */
            [weakSelf callBack:YBFileExistNo complete:completeBlock];
        }
        return;
    }
    /** 判断文件是否存在读取文件  */
    if ([weakSelf.ft fileExistsAtPath:file])
    {
        cnt = [weakSelf.ft readFile:file];
        if (cnt.length !=0)
        {
            modTime =  [weakSelf.dt getTimeIntervalWithDate:[weakSelf.ft fileModDate:file]];
        }
    }
    //    NSLog(@"本地key:%@自更新本地文件读取数据:%@",key,cnt);
    /** 判断是否读取文件  */
    if (expTime == YBReadTimeInterVal)
    {
        [weakSelf callBack:cnt complete:completeBlock];
        return;
    }
    /** 当前时间戳  */
    NSTimeInterval nowTime = [weakSelf.dt getTimeIntervalWithDate:[NSDate date]];
    
    /** 判断文件是否过期  */
    if (expTime == YBExpTimeOutInterVal)
    {
        NSString *fileExp = nil;
        if ((nowTime - modTime) > expTimeOut) {
            fileExp = YBFileExistYes;
        }
        else
        {
            fileExp = YBFileExistNo;
        }
        [weakSelf callBack:fileExp complete:completeBlock];
        return;
    }
    
    /** 文件修改时间  */
    if (expTime == YBModTimeInterVal)
    {
        /** 文件最后一次修改时间  */
        [self callBack:[NSString stringWithFormat:@"%f",modTime] complete:completeBlock];
        return;
    }
    if (expTime <= 0)
    {
        expTime = YBSessionCacheExpTime;
    }
    /** 请求失败把之前的内容 延迟过期时间  */
    NSTimeInterval changeTime = fabs(nowTime - modTime + expTime);
    /** 检测缓存是否过期  */
    if (fabs(nowTime - modTime) > expTime)
    {
        //创建Request请求
        NSMutableURLRequest *request = nil;
        if (!parms)
        {
            /** Get  */
          request = [self request:url method:@"GET" parms:nil];
        }else
        {
            /** post请求  */
           request = [self request:url method:@"POST" parms:parms];
        }
        self.timeoutInterval = YBSessionCacheTimeoutInterval;
        NSURLSessionTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            // 请求失败，打印错误信息
            if (error) {
                NSLog(@"自更新请求错误%@",error.localizedDescription);
                 NSHTTPURLResponse *responseObject = (NSHTTPURLResponse *)response;
                if(responseObject.statusCode == 404)
                {
                    cnt = @"";
                }
                [self file:file callBack:cnt changeTime:changeTime complete:completeBlock];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    /** 请求失败  超时等等*/
//                    [weakSelf.ft writeFile:file data:cnt];
//                    [weakSelf.ft changeFileTime:file date:[NSDate dateWithTimeIntervalSinceNow:changeTime]];
//                    [weakSelf callBack:cnt complete:completeBlock];
//                });
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
                        [weakSelf.ft writeFile:file data:cnt];
                        NSLog(@"自更新key:%@自更新网络数据:%@",key,cnt);
                        [weakSelf callBack:cnt complete:completeBlock];
                    });
                }
                else if(responseObject.statusCode == 404)
                {
                    cnt = @"";
                    [self file:file callBack:cnt changeTime:changeTime complete:completeBlock];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        /** 请求失败  超时等等*/
//                        [weakSelf.ft writeFile:file data:cnt];
//                        [weakSelf.ft changeFileTime:file date:[NSDate dateWithTimeIntervalSinceNow:changeTime]];
//                        [weakSelf callBack:cnt complete:completeBlock];
//                    });
                     NSLog(@"请求失败:----->:%@---->:%@",response,error);
                }
                else
                {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        /** 请求失败  超时等等*/
//                        [weakSelf.ft writeFile:file data:cnt];
//                        [weakSelf.ft changeFileTime:file date:[NSDate dateWithTimeIntervalSinceNow:changeTime]];
//                        [weakSelf callBack:cnt complete:completeBlock];
//                    });
                    [self file:file callBack:cnt changeTime:changeTime complete:completeBlock];
                    NSLog(@"请求失败:----->:%@---->:%@",response,error);
                }
            }
        }];
        //执行任务
        [task resume];
    }
    else
    {
         NSLog(@"自更新key:%@自更新本地读取数据:%@",key,cnt);
        /** 缓存没有过期 直接返回*/
        [weakSelf callBack:cnt complete:completeBlock];
        cnt = nil;
    }
}

- (void)file:(NSString*)file callBack:(NSString *)cnt changeTime:(NSTimeInterval)changeTime complete:(YBSessionCacheCompleteBlock)completeBlock
{
    WS(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        /** 请求失败  超时等等*/
        [weakSelf.ft writeFile:file data:cnt];
        [weakSelf.ft changeFileTime:file date:[NSDate dateWithTimeIntervalSinceNow:changeTime]];
        [weakSelf callBack:cnt complete:completeBlock];
    });
}
- (void)callBack:(NSString *)cnt complete:(YBSessionCacheCompleteBlock)completeBlock
{
    if (_httPRequestHeaders)
    {
        [_httPRequestHeaders removeAllObjects];
    }
    self.timeoutInterval = YBSessionCacheTimeoutInterval;
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
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    for (NSString *key in parms.allKeys) {
        // 拼接字符串
        [parameters addObject:[NSString stringWithFormat:@"%@=%@",YBPercentEscapedStringFromString(key),YBPercentEscapedStringFromString(parms[key])]];
    }
    if ([method isEqualToString:@"POST"])
    {
        //截取参数字符串，去掉最后一个“&”，并且将其转成NSData数据类型。
        NSData *parametersData = [[parameters componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding];
        request.HTTPBody = parametersData;
    }
    // 设置头部参数
    [self setWithAppInfo:request];
    
    [self.httPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![request valueForHTTPHeaderField:field]) {
            [request setValue:value forHTTPHeaderField:field];
        }
    }];
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
- (NSURLSession*)session
{
    static dispatch_once_t onceToken;
    static NSURLSessionConfiguration *defaultSessionConfiguration;
    static NSURLSession *defaultSession;
    dispatch_once(&onceToken, ^{
        defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSOperationQueue *operation = [[NSOperationQueue alloc] init];
        operation.maxConcurrentOperationCount = 1;
        // 是否允许使用蜂窝网络(后台传输不适用)
//        defaultSessionConfiguration.allowsCellularAccess = YES;
        defaultSession = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration
                                                       delegate:self
                                                  delegateQueue:operation];
    });
    return defaultSession;
}

#pragma mark -

//对应的代理方法如下:

// 1.接收到服务器的响应
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    // 允许处理服务器的响应，才会继续接收服务器返回的数据
    //默认是取消的
     /*
            NSURLSessionResponseCancel = 0,        默认的处理方式，取消
            NSURLSessionResponseAllow = 1,         接收服务器返回的数据
            NSURLSessionResponseBecomeDownload = 2,变成一个下载请求
            NSURLSessionResponseBecomeStream        变成一个流
      */
    completionHandler(NSURLSessionResponseAllow);
}

// 2.接收到服务器的数据（可能调用多次）
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    // 处理每次接收的数据
}

// 3.请求成功或者失败（如果失败，error有值）
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    // 请求完成,成功或者失败的处理
}
#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
   
}
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

- (void)addHeaders:(NSDictionary*)headersDictionary
{
    [self.httPRequestHeaders addEntriesFromDictionary:headersDictionary];
}

- (void)setAuthorizationHeaderValue:(NSString*)value forAuthType:(NSString*)authType {
    self.httPRequestHeaders[@"Authorization"] = [NSString stringWithFormat:@"%@ %@", authType, value];
}

#pragma mark - 删除自更新数据

/**
 *  删除  缓存根目录:YBSessionCachePath()
 *
 *  @param key           默认删除YBSessionCachePath()目录下文件  exp:删除指定缓存目录指定keyPATH/key   exp: YBCacheData/Community/sp-communityId
 *  @param url           url
 *  @param completeBlock 回调 成功:Y 失败：N
 */
- (void)clearCacheKey:(NSString *)key url:(NSString *)url complete:(YBSessionCacheCompleteBlock)completeBlock
{
    if (!key)
    {
        key = url.md5String;
    }else
    {
        NSString *cacheDir = YBSessionCachePath();
        NSString *dir = [NSString stringWithFormat:@"%@/%@",cacheDir,key.stringByDeletingLastPathComponent];
        if (![[YBFileTool sharedManager] fileExistsAtPath:dir])
        {
            [[YBFileTool sharedManager] createDir:dir];
        }
    }
    /** 本地路径  */
    NSString *file = YBSessionCacheKeyFile(key);
    /** 默认N  */
    NSString *deleteState = YBFileExistNo;
    
    /** 判断文件是否存在  */
    if([self.ft fileExistsAtPath:file])
    {
//        删除文件
        if ([self.ft deletesFile:file])
        {
            deleteState = YBFileExistYes; /** 成功  */
        }
    }else
    {
        /** 本地没有此文件直接是Y  */
        deleteState = YBFileExistYes;
    }
    if (completeBlock)
    {
        completeBlock(deleteState);
    }
}

/**
 *  删除文件夹中超过一定时间
 *
 *  @param dir     文件夹
 *  @param expTime 过期时间
 */
- (void)deleteDir:(NSString *)dir with:(NSTimeInterval)expTime
{
    NSString *path = [NSString stringWithFormat:@"%@/%@",YBSessionCachePath(),dir];
    /** 清除话题详情  */
    [[YBFileTool sharedManager] deletesFile:path time:expTime];
}
/**
 *  删除自更新指定文件夹
 *
 *  @param dir 文件夹
 */
- (void)deletesSessionCachePathCacheDir:(NSString *)dir
{
    NSString *path = [NSString stringWithFormat:@"%@/%@",YBSessionCachePath(),dir];
    [[YBFileTool sharedManager] deleteDir:path];
}


- (void)dealloc
{
    
}
@end