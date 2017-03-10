//
//  YBDBManager.m
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/8.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import "YBDBManager.h"
#import "YBFileTool.h"

static NSString *const kYBDBaseName = @"base.db";

@implementation YBDBManager

+ (instancetype)sharedInstance {
    static YBDBManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[YBDBManager alloc] init];
    });
    
    return _sharedInstance;
}

- (FMDatabaseQueue *)fmdbQueue
{
    if (!_fmdbQueue) {
        
        NSString *dbFile = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",kYBDBaseName]];
//        if (![YBFileTool isExistsAtPath:dbFile])
//        {
//            NSString *appDB = [[NSBundle mainBundle] pathForResource:kYBDBaseName ofType:nil];
//            NSError *error;
//            [YBFileTool copyItemAtPath:appDB toPath:dbFile error:&error];
//            NSLog(@"=====>数据库创建失败%@",error);
//        }
        _fmdbQueue = [FMDatabaseQueue databaseQueueWithPath:dbFile];
    }
    return _fmdbQueue;
}

- (void)createTable
{
    [self.fmdbQueue inDatabase:^(FMDatabase *db) {
        //创建表
        BOOL create =  [db executeUpdate:@"create table if not exists t_health(id integer primary key  autoincrement, name text,phone text)"];
        
        if (create) {
            NSLog(@"创建表成功");
        }else{
            NSLog(@"创建表失败");
        }
    }];
}

- (void)insert {
    
    [self.fmdbQueue inDatabase:^(FMDatabase *db) {
        BOOL insert = [db executeUpdate:@"insert into t_health (name,phone) values(?,?)",@"jacob",@"138000000000"];
        if (insert) {
            NSLog(@"插入数据成功");
        }else{
            NSLog(@"插入数据失败");
        }
    }];
}

//事务操作效率
- (void)insertData:(int)fromIndex useTransaction:(BOOL)useTransaction
{
    if (useTransaction) {
        
        [self.fmdbQueue inDatabase:^(FMDatabase *db) {
            [db beginTransaction];
            BOOL isRollBack = NO;
            @try {
                for (int i = fromIndex; i< 500 + fromIndex; i++) {
                    NSString *nId = [NSString stringWithFormat:@"%d",i];
                    NSString *strName = [[NSString alloc] initWithFormat:@"student_%d",i];
                    NSString *sql = @"INSERT INTO t_health (name,phone) VALUES (?,?)";
                    BOOL a = [db executeUpdate:sql,nId,strName];
                    if (!a) {
                        NSLog(@"插入失败1");
                    }
                }
            }
            @catch (NSException *exception) {
                isRollBack = YES;
                [db rollback];
            }
            @finally {
                if (!isRollBack) {
                    [db commit];
                }
            }
        }];
      
    }else{
        
        [self.fmdbQueue inDatabase:^(FMDatabase *db) {
            for (int i = fromIndex; i < 500+fromIndex; i++) {
                NSString *nId = [NSString stringWithFormat:@"%d",i];
                NSString *strName = [[NSString alloc] initWithFormat:@"student_%d",i];
                NSString *sql = @"INSERT INTO t_health (name,phone)  VALUES (?,?)";
                BOOL a = [db executeUpdate:sql,nId,strName];
                if (!a) {
                    NSLog(@"插入失败2");
                }
            }
        }];
       
    }
}

- (void)select
{
    [self.fmdbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"select * from t_health"];
        
        NSLog(@"%d",[result columnCount]);
        while ([result next]) {
//            NSString *name = [result stringForColumn:@"name"];
//            NSString *phone = [result stringForColumn:@"phone"];
//            NSLog(@"%@=====%@",name,phone);
        }
    }];
}

@end
