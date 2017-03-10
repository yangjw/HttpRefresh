//
//  YBHttpCache.m
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/6.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import "YBHttpCache.h"

#import "YBFileTool.h"
#import <SDWebImageDownloader.h>
#import <CommonCrypto/CommonDigest.h>
#import <AFImageDownloader.h>

/** 立即请求 */
NSTimeInterval const YBRequestImmediately = 1;
/** 读取文件  */
NSTimeInterval const YBCacheReadTimeInterVal = 9999;
/** 判断文件是否存在  */
NSTimeInterval const YBCacheFileTimeInterVal = 7777;
/** 文件存在  */
NSString *const YBCacheFileExistYes = @"Y";
/** 文件不存在  */
NSString *const YBCacheFileExistNo = @"N";

/** 缓存图片路径  */
NSString *const YBCacheRequestImageCache = @"YBRequestImageCache";

/** 请求缓存目录  */
NSString *const YBHttpCachePath = @"YBHttpReqeustCache";
/** 超时时间  */
NSTimeInterval const YBHttpTimeoutInterval = 5;
/** 文件过期时间  */
NSTimeInterval const YBFileExpTime = 300;


/** 获取缓存文件默认存储位置 */
NSString *YBHttpReqeustCachePath() {
    return  [[YBDocumentsFolder() stringByAppendingPathComponent:YBHttpCachePath] copy];
}
/** 话题详情缓存  */
NSString *YBHttpReqeustCommuntiyPath(){
    return  [[YBHttpReqeustCachePath() stringByAppendingPathComponent:YBCacheCommuityPath] copy];
}
/** 文件名称  */
NSString *YBHttpReqeustCacheFile(NSString* key)
{
    return [[YBHttpReqeustCachePath() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",key]] copy];
}

/** 本地图片后缀  */
NSString *YBImageSuffix(NSString *key)
{
    return [key stringByAppendingString:@"@2x.png"];
}

@interface YBHttpCache ()

@property (nonatomic, strong) YBFileTool *ft;

@end

@implementation YBHttpCache

+ (instancetype)sharedCache {
    static YBHttpCache *_sharedCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCache = [[YBHttpCache alloc] init];
    });
    
    return _sharedCache;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        /** 创建 网络请求 缓存 */
        [YBFileTool createDirectoryAtPath:YBHttpReqeustCachePath()];
        self.timeoutInterval = YBHttpTimeoutInterval;
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
#pragma mark - 初始化请求对象
- (AFURLSessionManager *)httpManager
{
    if (!_httpManager) {
        _httpManager = [AFHTTPSessionManager manager];
//        _httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        /** 开启https  */
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
//        //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO//如果是需要验证自建证书，需要设置为YES
//        securityPolicy.allowInvalidCertificates = YES;
//        //validatesDomainName 是否需要验证域名，默认为YES；
//        securityPolicy.validatesDomainName = YES;
//        _httpManager.securityPolicy  = securityPolicy;
//        //关闭缓存
//        _httpManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        _httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        _httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", @"text/html", nil];
        /** 请求头  */
//        NSString *appbundleid = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
//        [_httpManager.requestSerializer setValue:[NSString stringWithFormat:@"http://%@/",appbundleid] forHTTPHeaderField:@"Referer"];
//        /** 获取系统UA  自定义UA*/
//        NSDictionary *headFields = [_httpManager.requestSerializer HTTPRequestHeaders];
//        NSString *sysUA = [headFields objectForKey:@"User-Agent"];
//        
//        NSString *appVersion =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//        NSString *appBuild =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//        NSString *bundleIdentifier = appbundleid;
//        NSString *version = appVersion;
//        NSString *buildVersion = appBuild;
//        
//        NSString *customAgent = [NSString stringWithFormat:@"MozillaMobile/10.17 %@ com.runbey.app/1.0 (Runbey) RBBrowser/1.0.1 %@/%@/%@",sysUA,bundleIdentifier,version,buildVersion];
//        [_httpManager.requestSerializer setValue:customAgent forHTTPHeaderField:@"User-Agent"];
    }
    return _httpManager;
}

//- (NSMutableDictionary *)httpHeaderField
//{
//    if (!_httpHeaderField) {
//        _httpHeaderField = [NSMutableDictionary dictionary];
//    }
//    return _httpHeaderField;
//}

- (void)setHttpHeaderField:(NSMutableDictionary *)httpHeaderField
{
    _httpHeaderField = httpHeaderField;
}
#pragma mark - 删除缓存
- (void)deletesFiles:(NSString *)dir time:(NSTimeInterval)time
{
    [YBFileTool deletesFile:dir time:time];
}

#pragma mark - 请求数据
/** get json  */
- (void)requestGetJSONCacheKey:(NSString *)key url:(NSString *)url parms:(NSMutableDictionary *)parms expTime:(NSTimeInterval)expTime complete:(YBRequestJSONCompleteBlock)completeBlock
{
    [self requestGetCacheKey:key url:url parms:parms expTime:expTime complete:^(id responseObject) {
        if (completeBlock) {
            if (responseObject)
            {
                NSError *error;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
                completeBlock(dic,error);
            }
        }
    }];
}
/** post json */
- (void)requestPostJSONCacheKey:(NSString *)key url:(NSString *)url parms:(NSMutableDictionary *)parms expTime:(NSTimeInterval)expTime complete:(YBRequestJSONCompleteBlock)completeBlock
{
    [self requestPostCacheKey:key url:url parms:parms expTime:expTime complete:^(id responseObject) {
        if (completeBlock) {
            if (responseObject)
            {
                NSError *error;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
                completeBlock(dic,error);
            }
        }
    }];
}
/** post  */
- (void)requestPostCacheKey:(NSString *)key url:(NSString *)url parms:(NSDictionary *)parms expTime:(NSTimeInterval)expTime complete:(YBRequestCacheCompleteBlock)completeBlock
{
    [self requestCacheKey:key url:url method:YBHttpCacheMethodGet parms:parms expTime:expTime complete:completeBlock];
}
/** get  */
- (void)requestGetCacheKey:(NSString *)key url:(NSString *)url parms:(NSDictionary *)parms expTime:(NSTimeInterval)expTime complete:(YBRequestCacheCompleteBlock)completeBlock
{
    [self requestCacheKey:key url:url method:YBHttpCacheMethodPost parms:parms expTime:expTime complete:completeBlock];
}

/** 请求数据 缓存主体方法  */
- (void)requestCacheKey:(NSString *)key url:(NSString *)url method:(YBHttpCacheMethod)method parms:(NSMutableDictionary *)parms expTime:(NSTimeInterval)expTime complete:(YBRequestCacheCompleteBlock)completeBlock;
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
                NSString *dir = [NSString stringWithFormat:@"%@/%@",YBHttpReqeustCachePath(),path];
                if (![YBFileTool isExistsAtPath:dir])
                {
                    [YBFileTool createDirectoryAtPath:dir];
                }
            }
        }
    }
    /** 保存key  */
    if (!key)
    {
        key = [self md5String:url];
    }
    /** 本地路径  */
    NSString *file = YBHttpReqeustCacheFile(key);
    
    __weak typeof(self)weakSelf = self;
    /** 判断文件是否存在  */
    if (expTime == YBCacheFileTimeInterVal) {
        
        if ([YBFileTool isExistsAtPath:file]) {
            /** 文件存在  */
            [weakSelf callBack:YBCacheFileExistYes complete:completeBlock];
        }else
        {
            /** 文件不存在存在  */
            [weakSelf callBack:YBCacheFileExistNo complete:completeBlock];
        }
        return;
    }
    /** 判断文件是否存在读取文件  */
    if ([YBFileTool isExistsAtPath:file])
    {
        cnt = [YBFileTool readFile:file];
        if (cnt.length !=0)
        {
            modTime = [[YBFileTool modificationDateOfItemAtPath:file] timeIntervalSince1970];
        }
    }
    /** 判断是否读取文件  */
    if (expTime == YBCacheReadTimeInterVal)
    {
        [weakSelf callBack:cnt complete:completeBlock];
        return;
    }
    /** 当前时间戳  */
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    
    if (expTime <= 0)
    {
        expTime = YBFileExpTime;
    }
    /** 请求失败把之前的内容 延迟过期时间  */
    NSTimeInterval changeTime = nowTime - modTime + expTime;
    /** 检测缓存是否过期  */
    if ((nowTime - modTime) > expTime)
    {
        [self.httpManager.requestSerializer setTimeoutInterval:_timeoutInterval];
        if (_httpHeaderField)
        {
            [_httpHeaderField enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [weakSelf.httpManager.requestSerializer setValue:obj forHTTPHeaderField:key];
            }];
        }
        NSLog(@"=================>请求头:%@",_httpManager.requestSerializer.HTTPRequestHeaders);
        if (method == YBHttpCacheMethodGet)
        {
            [self.httpManager GET:url parameters:parms progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [weakSelf file:file cnt:cnt time:changeTime success:task data:responseObject complete:completeBlock];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [weakSelf file:file cnt:cnt time:changeTime failure:task error:error complete:completeBlock];
            }];
        }
        else if(method == YBHttpCacheMethodPost)
        {
            [self.httpManager POST:url parameters:parms progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [weakSelf file:file cnt:cnt time:changeTime success:task data:responseObject complete:completeBlock];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [weakSelf file:file cnt:cnt time:changeTime failure:task error:error complete:completeBlock];
            }];
        }
    }else
    {
        /** 缓存没有过期 直接返回*/
        [weakSelf callBack:cnt complete:completeBlock];
        cnt = nil;
    }
}
/** 请求成功回调  */
- (void)file:(NSString *)file cnt:(NSString *)cnt time:(NSTimeInterval)changeTime success:(NSURLSessionDataTask *)task data:(id)responseObject complete:(YBRequestCacheCompleteBlock)completeBlock;
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)task.response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    if (responseStatusCode == 200) {
        cnt = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        [YBFileTool writeFile:file data:cnt];
    }else
    {
        [YBFileTool writeFile:file data:cnt];
        [YBFileTool changeFileTime:file date:[NSDate dateWithTimeIntervalSinceNow:changeTime]];
        NSLog(@"请求失败:----->:%@---->:%@",task,responseObject);
    }
    [self callBack:cnt complete:completeBlock];
    cnt = nil;
//    NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//    NSLog(@"===================>%@",response);
}
/** 请求失败回调  */
-(void)file:(NSString *)file cnt:(NSString *)cnt time:(NSTimeInterval)changeTime failure:(NSURLSessionDataTask *)task error:(NSError *)error complete:(YBRequestCacheCompleteBlock)completeBlock;
{
    /** 请求失败  超时等等*/
    [YBFileTool writeFile:file data:cnt];
    [YBFileTool changeFileTime:file date:[NSDate dateWithTimeIntervalSinceNow:changeTime]];
    [self callBack:cnt complete:completeBlock];
    cnt = nil;
    NSLog(@"请求失败:----->:%@---->:%@",task,error);
}

/** 请求数据回调  */
- (void)callBack:(NSString *)cnt complete:(YBRequestCacheCompleteBlock)completeBlock
{
    /** 重置网络请求超时时间 为默认超时时间 */
    self.timeoutInterval = YBHttpTimeoutInterval;
    /** 移除所有请求头  */
    [_httpHeaderField removeAllObjects];
    if (completeBlock) {
        completeBlock(cnt);
    }
}

- (void)removeAllHeadersField:(NSMutableDictionary *)headers
{

}

/**
 *  初始化请求头
 */
-(void)httpHeadersField
{
    self.httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
}
/** 移除自定义的请求头  */
- (void)removeAllHeadersField
{
    if (_httpHeaderField)
    {
        [_httpHeaderField removeAllObjects];
    }
    [self httpHeaderField];
}

/** 设置认证请求头  */
- (void)requestAuthenticationCacheKey:(NSString *)key url:(NSString *)url method:(YBHttpCacheMethod)method parms:(NSMutableDictionary *)parms expTime:(NSTimeInterval)time complete:(YBRequestCacheCompleteBlock)completeBlock
{
    [self setLoginHttpReqHeader:parms];
    [self setHttpReqHeaderWithAppInfo];
    [self requestCacheKey:key url:url method:method parms:parms expTime:time complete:completeBlock];
}
/** 设置请求头请求数据  */
- (void)requestHttpHeadCacheKey:(NSString *)key url:(NSString *)url method:(YBHttpCacheMethod)method parms:(NSMutableDictionary *)parms expTime:(NSTimeInterval)time complete:(YBRequestCacheCompleteBlock)completeBlock
{
    [self setHttpReqHeaderWithAppInfo];
    [self requestCacheKey:key url:url method:method parms:parms expTime:time complete:completeBlock];
}
/**
 *  请求头文件中添加appInfo
 */
- (void)setHttpReqHeaderWithAppInfo
{
    NSString *appInfo = @"";
    NSString *SQH = @"";
    NSString *SQHKEY = @"";
    [self.httpManager.requestSerializer setValue:appInfo forHTTPHeaderField:@"Runbey-Appinfo"];
    [self.httpManager.requestSerializer setValue:SQH forHTTPHeaderField:@"Runbey-Appinfo-SQH"];
    [self.httpManager.requestSerializer setValue:SQHKEY forHTTPHeaderField:@"Runbey-Appinfo-SQHKEY"];
}

/**
 *  设置登陆模块http请求头文件信息
 */
- (void)setLoginHttpReqHeader:(NSMutableDictionary *)dictionary
{
    if (!dictionary) return;
    
    /** 获取当前时间戳 */
    NSString *timeStamp = @"";
    /** 获取token */
    NSString *token = @"";
    /** loginApp */
    NSString *loginApp = @"";
    /** 临时key */
    NSString *tmpKey = [NSString stringWithFormat:@"%@%@%@",token,loginApp,timeStamp];
    /** secKey */
    NSString *secKey = @"";
    
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    [resultDict setObject:token forKey:@"_token"];
    [resultDict setObject:loginApp forKey:@"_app"];
    [resultDict setObject:timeStamp forKey:@"_timestamp"];
    [resultDict setObject:secKey forKey:@"_secKey"];
    
    NSString *result =@"";
    [self.httpManager.requestSerializer setValue:result forHTTPHeaderField:@"RUNBEY_SECINFO"];
}
#pragma mark - 缓存图片
/** AF缓存图  */
- (void)requestAFImageCacheKey:(NSString *)key url:(NSString *)url expTime:(NSTimeInterval)expTime imageSuffix:(NSString *)imageSuffix complete:(YBRequestCacheImageCompleteBlock)completeBlock
{
    
    NSString *dir = [NSString stringWithFormat:@"%@/%@",YBHttpReqeustCachePath(),YBCacheRequestImageCache];
    if (![YBFileTool isExistsAtPath:dir])
    {
        [YBFileTool createDirectoryAtPath:dir];
    }
    __block UIImage *cnt = nil;
    /** 保存key  */
    if (!key)
    {
        key = [self md5String:url];
    }
    if (imageSuffix)
    {
        key = [NSString stringWithFormat:@"%@%@",key,imageSuffix];
    }else
    {
        /** 2x  */
        key = YBImageSuffix(key);
    }
    /** 本地路径  */
    NSString *file = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",key]];
    __weak typeof(self)weakSelf = self;
    if ([YBFileTool isExistsAtPath:file])
    {
        cnt = [[UIImage alloc] initWithContentsOfFile:file];
    }
    /** 判断是否读取文件  */
    if (expTime == YBCacheReadTimeInterVal)
    {
        NSLog(@"缓存图片:%@",file);
        [weakSelf callBackImage:cnt file:file complete:completeBlock];
        return;
    }
    if (cnt == nil)
    {
        
        [[AFImageDownloader defaultInstance] downloadImageForURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
            if (responseObject)
            {
                cnt = responseObject;
                [UIImagePNGRepresentation(responseObject) writeToFile:file atomically:YES];
                NSLog(@"图片下载成功:%@",file);
            }
            [weakSelf callBackImage:cnt file:file complete:completeBlock];
            cnt = nil;
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            NSLog(@"图片下载错误:%@",error);
            [weakSelf callBackImage:cnt file:file complete:completeBlock];
            cnt = nil;
        }];
    }
    else
    {
        /** 缓存没有过期 直接返回*/
        [weakSelf callBackImage:cnt file:(NSString *)file complete:completeBlock];
        NSLog(@"缓存图片:%@",file);
        cnt = nil;
    }
}

/** 缓存图片 不带后缀 自动添加后缀  */
-(void)requestImageCacheKey:(NSString *)key url:(NSString *)url expTime:(NSTimeInterval)expTime complete:(YBRequestCacheImageCompleteBlock)completeBlock
{
    [self requestImageCacheKey:key url:url expTime:expTime imageSuffix:nil complete:completeBlock];
}
/** 缓存图片使用sd  */
- (void)requestImageCacheKey:(NSString *)key url:(NSString *)url expTime:(NSTimeInterval)expTime imageSuffix:(NSString *)imageSuffix complete:(YBRequestCacheImageCompleteBlock)completeBlock
{
    
    NSString *dir = [NSString stringWithFormat:@"%@/%@",YBHttpReqeustCachePath(),YBCacheRequestImageCache];
    if (![YBFileTool isExistsAtPath:dir])
    {
        [YBFileTool createDirectoryAtPath:dir];
    }
    __block UIImage *cnt = nil;
    /** 保存key  */
    if (!key)
    {
        key = [self md5String:url];
    }
    if (imageSuffix)
    {
        key = [NSString stringWithFormat:@"%@%@",key,imageSuffix];
    }else
    {
        /** 2x  */
        key = YBImageSuffix(key);
    }
    /** 本地路径  */
    NSString *file = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",key]];
    __weak typeof(self)weakSelf = self;
    if ([YBFileTool isExistsAtPath:file])
    {
        cnt = [[UIImage alloc] initWithContentsOfFile:file];
    }
    /** 判断是否读取文件  */
    if (expTime == YBCacheReadTimeInterVal)
    {
        NSLog(@"缓存图片:%@",file);
        [weakSelf callBackImage:cnt file:file complete:completeBlock];
        return;
    }
    if (cnt == nil)
    {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageDownloaderHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            
            if (error) {
                NSLog(@"error is %@",error);
            }
            if (finished) {
                if (data) {
                    cnt = image;
                    [data writeToFile:file atomically:YES];
                     NSLog(@"图片下载成功:%@",file);
                }
            }
            [weakSelf callBackImage:cnt file:file complete:completeBlock];
            cnt = nil;
        }];
    }
    else
    {
        /** 缓存没有过期 直接返回*/
        [weakSelf callBackImage:cnt file:(NSString *)file complete:completeBlock];
         NSLog(@"缓存图片:%@",file);
        cnt = nil;
    }
}
/** 缓存图片回调  */
-(void)callBackImage:(UIImage *)image file:(NSString *)file complete:(YBRequestCacheImageCompleteBlock)completeBlock
{
    if (completeBlock) {
        completeBlock(image,file);
    }
}
/** 超过30天的清除  */
-(void)deletesImageFiles
{
    NSString *dir = [NSString stringWithFormat:@"%@/%@",YBHttpReqeustCachePath(),YBCacheRequestImageCache];
    /** 超过一天的清除  */
    [YBFileTool deletesFile:dir time:30*24*60*60];
    //    [[YBFileTool sharedManager] deletesFile:dir time:3];
}

/** md5  */
- (NSString *)md5String:(NSString *)str
{
    if(self == nil || [str length] == 0) return nil;
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([str UTF8String], (int)[str lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    for(i=0;i<CC_MD5_DIGEST_LENGTH;i++)
    {
        [ms appendFormat: @"%02x", (int)(digest[i])];
    }
    return [ms copy];
}


@end
