//
//  YBDBManager.h
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/8.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@interface YBDBManager : NSObject

@property (nonatomic, strong) FMDatabaseQueue *fmdbQueue;

+ (instancetype)sharedInstance;

- (void)createTable;
- (void)insert;
- (void)insertData:(int)fromIndex useTransaction:(BOOL)useTransaction;
- (void)select;
@end
