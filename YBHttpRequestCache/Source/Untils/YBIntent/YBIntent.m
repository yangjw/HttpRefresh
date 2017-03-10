//
//  YBIntent.m
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/9.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import "YBIntent.h"

@interface YBIntent ()
{
    
}
@end

@implementation YBIntent

- (instancetype)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}

- (instancetype)initWithClazz:(id)receiveClass
{
    self = [super init];
    if (self) {
        self.receiveClass = receiveClass;
    }
    return self;
}

-(void)putExtraWithName:(NSString *)name data:(id)data
{
    [self.extras setValue:data forKey:name];
}

- (NSMutableDictionary<NSString *,id> *)extras
{
    if (!_extras) {
        _extras  = [NSMutableDictionary dictionary];
    }
    return _extras;
}

@end

@implementation YBIntentPresentationDisplay

- (void)displayViewControllerSource:(UIViewController *)source destination:(UIViewController *)destination
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:destination];
    [source presentViewController:nav animated:YES completion:nil];
}

@end

@implementation YBIntentPushDisplay

- (void)displayViewControllerSource:(UIViewController *)source destination:(UIViewController *)destination
{
    /** 判断父 控制器 是否是 导航栏  */
    if (source.navigationController)
    {
        [source.navigationController pushViewController:destination animated:YES];
    }else
    {
        [source presentViewController:destination animated:YES completion:nil];
    }
}

@end