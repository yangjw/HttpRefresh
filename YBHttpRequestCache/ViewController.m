//
//  ViewController.m
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/6.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import "ViewController.h"
#import "YBHttpCache.h"
#import "YBFileTool.h"
#import "NSDate+YBTools.h"
#import "YBDBManager.h"
#import <HelloTest/HelloTest.h>
#import "YBMacros.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [HelloTest outString];
    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:nil];
    
//    self.navigationItem.leftBarButtonItems = @[item,item,item,item,item,item,item,item,item,item];
    
    // Do any additional setup after loading the view, typically from a nib.
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setValue:@"yangjw" forKey:@"User"];
//    [[YBHttpCache sharedCache] setHttpHeaderField:dic];
//    [[YBHttpCache sharedCache] requestCacheKey:nil url:@"http://mis.mnks.cn/app/app_banner.php?tag=test_json_iOS_AD_Test" method:YBHttpCacheMethodGet parms:nil expTime:2*60 complete:^(id responseObject) {
//         NSLog(@"xxxxxxx%@",responseObject);
//    }];
//    [dic setValue:@"20161206" forKey:@"time"];
//    [[YBHttpCache sharedCache] setHttpHeaderField:dic];
//    [[YBHttpCache sharedCache] requestCacheKey:nil url:@"https://www.baidu.com/" method:YBHttpCacheMethodGet parms:nil expTime:1 complete:^(id responseObject) {
//        NSLog(@"xxxxxxx%@",responseObject);
//    }];
    
//    [[YBHttpCache sharedCache] requestImageCacheKey:nil url:@"http://dl.bizhi.sogou.com/images/2013/11/25/420492.jpg?f=download" expTime:0 imageSuffix:@".png" complete:^(UIImage *image, NSString *file) {
//        
//    }];
//    
//    [[YBHttpCache sharedCache] requestAFImageCacheKey:nil url:@"http://img3.duitang.com/uploads/item/201504/26/201504261714_hsjyx.jpeg" expTime:0 imageSuffix:@".png" complete:^(UIImage *image, NSString *file) {
//        
//    }];
    
//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://img3.duitang.com/uploads/item/201504/26/201504261714_hsjyx.jpeg"]]];
//    NSString *path =  [YBDocumentsFolder() stringByAppendingPathComponent:@"image"];
//    if ([YBFileTool createDirectoryAtPath:path]) {
//        NSLog(@"写入成功");
//    }
    
    
//    NSString *file = [YBDocumentsFolder() stringByAppendingPathComponent:@"image/13.png"];
//    [UIImagePNGRepresentation(image) writeToFile:file atomically:YES];
    
//    [YBFileTool createFileAtPath:file content:image];
    
//    UIImage *image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://dl.bizhi.sogou.com/images/2013/11/25/420492.jpg?f=download"]]];
//    NSError *error;
//    [YBFileTool  writeFileAtPath:file content:image1 error:&error];
//    NSLog(@"===================%@",error);
    
    NSLog(@"===============>%@",[NSDate currentCalendar]);
    
    NSLog(@"=====>时间戳:%f",[[NSDate date] timeInterval]);
    NSLog(@"===============>autoupdatingCurrentLocale:%@",[NSLocale autoupdatingCurrentLocale]);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d h:mm a"];
    NSLog(@"======>%@",[formatter stringFromDate:[NSDate date]]);
    [formatter setDateFormat:@"MMM d"];
     NSLog(@"======>%@",[formatter stringFromDate:[NSDate date]]);
    [formatter setDateFormat:@"yyyy年MM月dd日 HH时mm分ss秒"];
    NSLog(@"======>%@",[formatter stringFromDate:[NSDate date]]);
  
    NSLog(@"======>%ld",[[NSDate date] hour]);
    NSLog(@"======>%ld",[[NSDate date] minute]);
     NSLog(@"======>%ld",[[NSDate date] seconds]);
     NSLog(@"======>%ld",[[NSDate date] day]);
     NSLog(@"======>%ld",[[NSDate date] month]);
    
    
    NSString *time = @"2016-12-5 23:59:59";
    
    NSDate *date = [NSDate dateFromString:time format:kYBFormatSQLDateWithTime];
    
    NSLog(@"===========%@",[NSDate weekTimeAgoSinceDate:date]);

    [[YBDBManager  sharedInstance] createTable];
    [[YBDBManager sharedInstance] insert];
    
    
    [[YBDBManager sharedInstance] insertData:0 useTransaction:NO];
    
    NSDate *date1 = [NSDate date];
    
    [[YBDBManager sharedInstance] insertData:500 useTransaction:NO];
    NSDate *date2 = [NSDate date];
    
    NSTimeInterval a = [date2 timeIntervalSince1970] - [date1 timeIntervalSince1970];
    NSLog(@"不使用事务插入500条数据用时%.3f秒",a);
    [[YBDBManager sharedInstance] insertData:1000 useTransaction:YES];
    NSDate *date3 = [NSDate date];
    NSTimeInterval b = [date3 timeIntervalSince1970] - [date2 timeIntervalSince1970];
    NSLog(@"使用事务插入500条数据用时%.3f秒",b);
    NSTimeInterval start = CFAbsoluteTimeGetCurrent();
    [[YBDBManager sharedInstance] select];
    NSTimeInterval end = CFAbsoluteTimeGetCurrent();
    NSLog(@"**************%f",end - start);
//    NSLocalizedStringFromTableInBundle(key, @"DateTools", [NSBundle bundleWithPath:[[[NSBundle bundleForClass:[DTError class]] resourcePath] stringByAppendingPathComponent:@"DateTools.bundle"]], nil)
    
}
// nil, @"", @"  ", @"\n" will Returns NO; otherwise Returns YES.
//- (BOOL)isNotBlank {
//    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//    for (NSInteger i = 0; i < self.length; ++i) {
//        unichar c = [self characterAtIndex:i];
//        if (![blank characterIsMember:c]) {
//            return YES;
//        }
//    }
//    return NO;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
