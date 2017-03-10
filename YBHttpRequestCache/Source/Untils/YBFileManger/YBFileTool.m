
//
//  YBFileTool.m
//  YBJK
//
//  Created by yangjw on 16/10/26.
//  Copyright © 2016年 mahong. All rights reserved.
//

#import "YBFileTool.h"

NSString *YBHomeFolder(){
    static NSString *path = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        path = NSHomeDirectory();
    });
    return path;
}

NSString *YBDocumentsFolder() {
    static NSString *path = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        path = [paths objectAtIndex:0];
    });
    return path;
}

NSString *YBLibraryFolder() {
    static NSString *path = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        path = [paths objectAtIndex:0];
    });
    return path;
}

NSString *YBForCachesDirectory()
{
    static NSString *path = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        path = [paths lastObject];
    });
    return path;
}

NSString *YBTemDirectory()
{
    static NSString *path = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        path = NSTemporaryDirectory();
    });
    return path;
}

NSString *YBBundleFolder() {
    return [[NSBundle mainBundle] bundlePath];
}


@interface YBFileTool ()

@end

@implementation YBFileTool

+ (instancetype)sharedManager {
    static YBFileTool *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[YBFileTool alloc] init];
    });
    
    return _sharedManager;
}

#pragma mark - 遍历文件夹
+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path deep:(BOOL)deep {
    NSArray *listArr;
    NSError *error;
    NSFileManager *manager = [NSFileManager defaultManager];
    if (deep) {
        // 深遍历
        NSArray *deepArr = [manager subpathsOfDirectoryAtPath:path error:&error];
        if (!error) {
            listArr = deepArr;
        }else {
            listArr = nil;
        }
    }else {
        // 浅遍历
        NSArray *shallowArr = [manager contentsOfDirectoryAtPath:path error:&error];
        if (!error) {
            listArr = shallowArr;
        }else {
            listArr = nil;
        }
    }
    return listArr;
}

+ (NSArray *)listFilesInHomeDirectoryByDeep:(BOOL)deep {
    return [self listFilesInDirectoryAtPath:YBHomeFolder() deep:deep];
}

+ (NSArray *)listFilesInLibraryDirectoryByDeep:(BOOL)deep {
    return [self listFilesInDirectoryAtPath:YBLibraryFolder() deep:deep];
}

+ (NSArray *)listFilesInDocumentDirectoryByDeep:(BOOL)deep {
    return [self listFilesInDirectoryAtPath:YBDocumentsFolder() deep:deep];
}

+ (NSArray *)listFilesInTmpDirectoryByDeep:(BOOL)deep {
    return [self listFilesInDirectoryAtPath:YBTemDirectory() deep:deep];
}

+ (NSArray *)listFilesInCachesDirectoryByDeep:(BOOL)deep {
    return [self listFilesInDirectoryAtPath:YBForCachesDirectory() deep:deep];
}

#pragma mark - 获取文件属性
+ (id)attributeOfItemAtPath:(NSString *)path forKey:(NSString *)key {
    return [[self attributesOfItemAtPath:path] objectForKey:key];
}

+ (id)attributeOfItemAtPath:(NSString *)path forKey:(NSString *)key error:(NSError *__autoreleasing *)error {
    return [[self attributesOfItemAtPath:path error:error] objectForKey:key];
}

+ (NSDictionary *)attributesOfItemAtPath:(NSString *)path {
    return [self attributesOfItemAtPath:path error:nil];
}

+ (NSDictionary *)attributesOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return [[NSFileManager defaultManager] attributesOfItemAtPath:path error:error];
}
#pragma mark - 创建文件(夹)
+ (BOOL)createDirectoryAtPath:(NSString *)path {
    return [self createDirectoryAtPath:path error:nil];
}

+ (BOOL)createDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isSuccess = [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:error];
    return isSuccess;
}

+ (BOOL)createFileAtPath:(NSString *)path {
    return [self createFileAtPath:path content:nil overwrite:YES error:nil];
}

+ (BOOL)createFileAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return [self createFileAtPath:path content:nil overwrite:YES error:error];
}

+ (BOOL)createFileAtPath:(NSString *)path overwrite:(BOOL)overwrite {
    return [self createFileAtPath:path content:nil overwrite:overwrite error:nil];
}

+ (BOOL)createFileAtPath:(NSString *)path overwrite:(BOOL)overwrite error:(NSError *__autoreleasing *)error {
    return [self createFileAtPath:path content:nil overwrite:overwrite error:error];
}

+ (BOOL)createFileAtPath:(NSString *)path content:(NSObject *)content {
    return [self createFileAtPath:path content:content overwrite:YES error:nil];
}

+ (BOOL)createFileAtPath:(NSString *)path content:(NSObject *)content error:(NSError *__autoreleasing *)error {
    return [self createFileAtPath:path content:content overwrite:YES error:error];
}

+ (BOOL)createFileAtPath:(NSString *)path content:(NSObject *)content overwrite:(BOOL)overwrite {
    return [self createFileAtPath:path content:content overwrite:overwrite error:nil];
}

+ (BOOL)createFileAtPath:(NSString *)path content:(NSObject *)content overwrite:(BOOL)overwrite error:(NSError *__autoreleasing *)error {
    // 如果文件夹路径不存在，那么先创建文件夹
    NSString *directoryPath = [self directoryAtPath:path];
    if (![self isExistsAtPath:directoryPath]) {
        // 创建文件夹
        if (![self createDirectoryAtPath:directoryPath error:error]) {
            return NO;
        }
    }
    // 如果文件存在，并不想覆盖，那么直接返回YES。
    if (!overwrite) {
        if ([self isExistsAtPath:path]) {
            return YES;
        }
    }
    // 创建文件
    BOOL isSuccess = [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    if (content) {
        [self writeFileAtPath:path content:content error:error];
    }
    return isSuccess;
}

+ (NSDate *)creationDateOfItemAtPath:(NSString *)path {
    return [self creationDateOfItemAtPath:path error:nil];
}

+ (NSDate *)creationDateOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return (NSDate *)[self attributeOfItemAtPath:path forKey:NSFileCreationDate error:error];
}

+ (NSDate *)modificationDateOfItemAtPath:(NSString *)path {
    return [self modificationDateOfItemAtPath:path error:nil];
}

+ (NSDate *)modificationDateOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return (NSDate *)[self attributeOfItemAtPath:path forKey:NSFileModificationDate error:error];
}


/** 写入文件  */
+ (BOOL)writeFile:(NSString *)file data:(id)data
{
    /** 判断是否存在目录  */
    NSString *dir = file.stringByDeletingLastPathComponent;

    if (![self isExistsAtPath:dir])
    {
        NSLog(@"删除路径的最后一个组成部分======>%@",file.stringByDeletingLastPathComponent);
//        创建目录
        [self createDirectoryAtPath:dir];
    }
   return [[NSKeyedArchiver archivedDataWithRootObject:data] writeToFile:file atomically:YES];;
}

/** 修改 文件修改时间  */
+ (BOOL)changeFileTime:(NSString *)path date:(NSDate *)date
{
    if ([self isExistsAtPath:path]) {
        NSDictionary *attrib = [NSDictionary dictionaryWithObjectsAndKeys:
                                date, NSFileModificationDate,nil];
        NSError *error = nil;
        NSFileManager *fm = [NSFileManager defaultManager];
        return [fm setAttributes:attrib ofItemAtPath:path error:&error];
    }
    return NO;
}

#pragma mark - 删除文件(夹)
+ (BOOL)deletesFile:(NSString *)dir time:(NSInteger)times
{
    BOOL isSucess = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator *myDirectoryEnumerator = [fm enumeratorAtPath:dir];
    NSString *file;
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    while((file = [myDirectoryEnumerator nextObject]))     //遍历当前目录
    {
        NSString *fileName = [dir stringByAppendingPathComponent:file];
        if (interval - [[self modificationDateOfItemAtPath:fileName] timeIntervalSince1970] > times)
        {
            [fm removeItemAtPath:fileName error:nil];
        }
        isSucess = YES;
    }
    return isSucess;
}

+ (BOOL)removeItemAtPath:(NSString *)path {
    return [self removeItemAtPath:path error:nil];
}

+ (BOOL)removeItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return [[NSFileManager defaultManager] removeItemAtPath:path error:error];
}

+ (BOOL)clearCachesDirectory {
    NSArray *subFiles = [self listFilesInCachesDirectoryByDeep:NO];
    BOOL isSuccess = YES;
    
    for (NSString *file in subFiles) {
        NSString *absolutePath = [YBForCachesDirectory() stringByAppendingPathComponent:file];
        isSuccess &= [self removeItemAtPath:absolutePath];
    }
    return isSuccess;
}

+ (BOOL)clearTmpDirectory {
    NSArray *subFiles = [self listFilesInTmpDirectoryByDeep:NO];
    BOOL isSuccess = YES;
    
    for (NSString *file in subFiles) {
        NSString *absolutePath = [YBTemDirectory() stringByAppendingPathComponent:file];
        isSuccess &= [self removeItemAtPath:absolutePath];
    }
    return isSuccess;
}

#pragma mark - 复制文件(夹)
+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath {
    return [self copyItemAtPath:path toPath:toPath overwrite:NO error:nil];
}

+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError *__autoreleasing *)error {
    return [self copyItemAtPath:path toPath:toPath overwrite:NO error:error];
}

+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite {
    return [self copyItemAtPath:path toPath:toPath overwrite:overwrite error:nil];
}

+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite error:(NSError *__autoreleasing *)error {
    // 先要保证源文件路径存在，不然抛出异常
    if (![self isExistsAtPath:path]) {
        [NSException raise:@"非法的源文件路径" format:@"源文件路径%@不存在，请检查源文件路径", path];
        return NO;
    }
    NSString *toDirPath = [self directoryAtPath:toPath];
    if (![self isExistsAtPath:toDirPath]) {
        // 创建复制路径
        if (![self createDirectoryAtPath:toDirPath error:error]) {
            return NO;
        }
    }
    // 如果覆盖，那么先删掉原文件
    if (overwrite) {
        if ([self isExistsAtPath:toPath]) {
            [self removeItemAtPath:toPath error:error];
        }
    }
    // 复制文件
    BOOL isSuccess = [[NSFileManager defaultManager] copyItemAtPath:path toPath:toPath error:error];
    
    return isSuccess;
}

#pragma mark - 移动文件(夹)
+ (BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath {
    return [self moveItemAtPath:path toPath:toPath overwrite:NO error:nil];
}

+ (BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError *__autoreleasing *)error {
    return [self moveItemAtPath:path toPath:toPath overwrite:NO error:error];
}

+ (BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite {
    return [self moveItemAtPath:path toPath:toPath overwrite:overwrite error:nil];
}

+ (BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite error:(NSError *__autoreleasing *)error {
    // 先要保证源文件路径存在，不然抛出异常
    if (![self isExistsAtPath:path]) {
        [NSException raise:@"非法的源文件路径" format:@"源文件路径%@不存在，请检查源文件路径", path];
        return NO;
    }
    NSString *toDirPath = [self directoryAtPath:toPath];
    if (![self isExistsAtPath:toDirPath]) {
        // 创建移动路径
        if (![self createDirectoryAtPath:toDirPath error:error]) {
            return NO;
        }
    }
    // 如果覆盖，那么先删掉原文件
    if ([self isExistsAtPath:toPath]) {
        if (overwrite) {
            [self removeItemAtPath:toPath error:error];
        }else {
            [self removeItemAtPath:path error:error];
            return YES;
        }
    }
    // 移动文件
    BOOL isSuccess = [[NSFileManager defaultManager] moveItemAtPath:path toPath:toPath error:error];
    
    return isSuccess;
}



#pragma mark - 根据URL获取文件名
+ (NSString *)fileNameAtPath:(NSString *)path suffix:(BOOL)suffix {
    NSString *fileName = [path lastPathComponent];
    if (!suffix) {
        fileName = [fileName stringByDeletingPathExtension];
    }
    return fileName;
}

+ (NSString *)directoryAtPath:(NSString *)path {
    return [path stringByDeletingLastPathComponent];
}

+ (NSString *)suffixAtPath:(NSString *)path {
    return [path pathExtension];
}

#pragma mark - 判断文件(夹)是否存在
+ (BOOL)isExistsAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (BOOL)isEmptyItemAtPath:(NSString *)path {
    return [self isEmptyItemAtPath:path error:nil];
}

+ (BOOL)isEmptyItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return ([self isFileAtPath:path error:error] &&
            [[self sizeOfItemAtPath:path error:error] intValue] == 0) ||
    ([self isDirectoryAtPath:path error:error] &&
     [[self listFilesInDirectoryAtPath:path deep:NO] count] == 0);
}

+ (BOOL)isDirectoryAtPath:(NSString *)path {
    return [self isDirectoryAtPath:path error:nil];
}

+ (BOOL)isDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return ([self attributeOfItemAtPath:path forKey:NSFileType error:error] == NSFileTypeDirectory);
}

+ (BOOL)isFileAtPath:(NSString *)path {
    return [self isFileAtPath:path error:nil];
}

+ (BOOL)isFileAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return ([self attributeOfItemAtPath:path forKey:NSFileType error:error] == NSFileTypeRegular);
}

+ (BOOL)isExecutableItemAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] isExecutableFileAtPath:path];
}

+ (BOOL)isReadableItemAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] isReadableFileAtPath:path];
}
+ (BOOL)isWritableItemAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] isWritableFileAtPath:path];
}

#pragma mark - 获取文件(夹)大小
+ (NSNumber *)sizeOfItemAtPath:(NSString *)path {
    return [self sizeOfItemAtPath:path error:nil];
}

+ (NSNumber *)sizeOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return (NSNumber *)[self attributeOfItemAtPath:path forKey:NSFileSize error:error];
}

+ (NSNumber *)sizeOfFileAtPath:(NSString *)path {
    return [self sizeOfFileAtPath:path error:nil];
}

+ (NSNumber *)sizeOfFileAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    if ([self isFileAtPath:path error:error]) {
        return [self sizeOfItemAtPath:path error:error];
    }
    return nil;
}

+ (NSNumber *)sizeOfDirectoryAtPath:(NSString *)path {
    return [self sizeOfDirectoryAtPath:path error:nil];
}

+ (NSNumber *)sizeOfDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    if ([self isDirectoryAtPath:path error:error]) {
        NSArray *subPaths = [self listFilesInDirectoryAtPath:path deep:YES];
        NSEnumerator *contentsEnumurator = [subPaths objectEnumerator];
        
        NSString *file;
        unsigned long long int folderSize = 0;
        
        while (file = [contentsEnumurator nextObject]) {
            NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[path stringByAppendingPathComponent:file] error:nil];
            folderSize += [[fileAttributes objectForKey:NSFileSize] intValue];
        }
        return [NSNumber numberWithUnsignedLongLong:folderSize];
    }
    return nil;
}

+ (NSString *)sizeFormattedOfItemAtPath:(NSString *)path {
    return [self sizeFormattedOfItemAtPath:path error:nil];
}

+ (NSString *)sizeFormattedOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    NSNumber *size = [self sizeOfItemAtPath:path error:error];
    if (size) {
        return [self sizeFormatted:size];
    }
    return nil;
}

+ (NSString *)sizeFormattedOfFileAtPath:(NSString *)path {
    return [self sizeFormattedOfFileAtPath:path error:nil];
}

+ (NSString *)sizeFormattedOfFileAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    NSNumber *size = [self sizeOfFileAtPath:path error:error];
    if (size) {
        return [self sizeFormatted:size];
    }
    return nil;
}

+ (NSString *)sizeFormattedOfDirectoryAtPath:(NSString *)path {
    return [self sizeFormattedOfDirectoryAtPath:path error:nil];
}

+ (NSString *)sizeFormattedOfDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    NSNumber *size = [self sizeOfDirectoryAtPath:path error:error];
    if (size) {
        return [self sizeFormatted:size];
    }
    return nil;
}

#pragma mark - 写入文件内容
+ (BOOL)writeFileAtPath:(NSString *)path content:(NSObject *)content {
    return [self writeFileAtPath:path content:content error:nil];
}

+ (BOOL)writeFileAtPath:(NSString *)path content:(NSObject *)content error:(NSError *__autoreleasing *)error {
    if (!content) {
        [NSException raise:@"非法的文件内容" format:@"文件内容不能为nil"];
        return NO;
    }
//    // 如果文件夹路径不存在，那么先创建文件夹
//    NSString *directoryPath = [self directoryAtPath:path];
//    if (![self isExistsAtPath:directoryPath]) {
//        // 创建文件夹
//        if (![self createDirectoryAtPath:directoryPath error:error]) {
//            return NO;
//        }
//    }
    if ([self isExistsAtPath:path])
    {
        if ([content isKindOfClass:[NSMutableArray class]]) {
            [(NSMutableArray *)content writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[NSArray class]]) {
            [(NSArray *)content writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[NSMutableData class]]) {
            [(NSMutableData *)content writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[NSData class]]) {
            [(NSData *)content writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[NSMutableDictionary class]]) {
            [(NSMutableDictionary *)content writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[NSDictionary class]]) {
            [(NSDictionary *)content writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[NSJSONSerialization class]]) {
            [(NSDictionary *)content writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[NSMutableString class]]) {
            [[((NSString *)content) dataUsingEncoding:NSUTF8StringEncoding] writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[NSString class]]) {
            [[((NSString *)content) dataUsingEncoding:NSUTF8StringEncoding] writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[UIImage class]]) {
            [UIImagePNGRepresentation((UIImage *)content) writeToFile:path atomically:YES];
        }else if ([content conformsToProtocol:@protocol(NSCoding)]) {
            [NSKeyedArchiver archiveRootObject:content toFile:path];
        }else {
            [NSException raise:@"非法的文件内容" format:@"文件类型%@异常，无法被处理。", NSStringFromClass([content class])];
            
            return NO;
        }
    }else {
        return NO;
    }
    return YES;

}

#pragma mark - private methods
+ (BOOL)isNotError:(NSError **)error {
    return ((error == nil) || ((*error) == nil));
}

+ (NSString *)sizeFormatted:(NSNumber *)size {
    return [NSByteCountFormatter stringFromByteCount:[size unsignedLongLongValue] countStyle:NSByteCountFormatterCountStyleFile];
}
#pragma mark - 读取文件内容
/**
 *  读取文件
 *
 *  @param file 路径
 *
 *  @return 数据对象
 */
+ (id)readFile:(NSString *)file
{
//    NSData* fileData = [NSData dataWithContentsOfFile:file];
//    return [NSKeyedUnarchiver unarchiveObjectWithData:fileData];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:file];
}

+ (NSString *)readFileAtPath:(NSString *)file
{
    return [self readFileAtPathAsString:file error:nil];
}

+ (NSString *)readFileAtPath:(NSString *)file error:(NSError **)error
{
    return [self readFileAtPathAsString:file error:error];
}

+ (NSArray *)readFileAtPathAsArray:(NSString *)file
{
    return [NSArray arrayWithContentsOfFile:file];
}

+ (NSObject *)readFileAtPathAsCustomModel:(NSString *)file
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:file];
}

+ (NSData *)readFileAtPathAsData:(NSString *)path
{
    return [self readFileAtPathAsData:path error:nil];
}

+ (NSData *)readFileAtPathAsData:(NSString *)file error:(NSError **)error
{
    return [NSData dataWithContentsOfFile:file options:NSDataReadingMapped error:error];
}

+ (NSDictionary *)readFileAtPathAsDictionary:(NSString *)file
{
    return [NSDictionary dictionaryWithContentsOfFile:file];
}

+ (UIImage *)readFileAtPathAsImage:(NSString *)file
{
    return [self readFileAtPathAsImage:file error:nil];
}

+ (UIImage *)readFileAtPathAsImage:(NSString *)file error:(NSError **)error
{
    NSData *data = [self readFileAtPathAsData:file error:error];
    
    if([self isNotError:error])
    {
        return [UIImage imageWithData:data];
    }
    return nil;
}

+ (UIImageView *)readFileAtPathAsImageView:(NSString *)file
{
    return [self readFileAtPathAsImageView:file error:nil];
}

+ (UIImageView *)readFileAtPathAsImageView:(NSString *)file error:(NSError **)error
{
    UIImage *image = [self readFileAtPathAsImage:file error:error];
    
    if([self isNotError:error])
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView sizeToFit];
        return imageView;
    }
    
    return nil;
}


+ (NSJSONSerialization *)readFileAtPathAsJSON:(NSString *)file
{
    return [self readFileAtPathAsJSON:file error:nil];
}


+ (NSJSONSerialization *)readFileAtPathAsJSON:(NSString *)file error:(NSError **)error
{
    NSData *data = [self readFileAtPathAsData:file error:error];
    
    if([self isNotError:error])
    {
        NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
        
        if([NSJSONSerialization isValidJSONObject:json])
        {
            return json;
        }
    }
    
    return nil;
}


+ (NSMutableArray *)readFileAtPathAsMutableArray:(NSString *)file
{
    return [NSMutableArray arrayWithContentsOfFile:file];
}

+(NSMutableData *)readFileAtPathAsMutableData:(NSString *)file
{
    return [self readFileAtPathAsMutableData:file error:nil];
}


+ (NSMutableData *)readFileAtPathAsMutableData:(NSString *)file error:(NSError **)error
{
    return [NSMutableData dataWithContentsOfFile:file options:NSDataReadingMapped error:error];
}


+(NSMutableDictionary *)readFileAtPathAsMutableDictionary:(NSString *)file
{
    return [NSMutableDictionary dictionaryWithContentsOfFile:file];
}


+(NSString *)readFileAtPathAsString:(NSString *)file
{
    return [self readFileAtPath:file error:nil];
}


+(NSString *)readFileAtPathAsString:(NSString *)file error:(NSError **)error
{
    return [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:error];
}


@end
