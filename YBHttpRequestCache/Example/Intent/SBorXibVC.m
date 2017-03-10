//
//  SBorXibVC.m
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/9.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import "SBorXibVC.h"
#import "YBIntent.h"

@interface SBorXibVC ()<YBIntentReceivable>

@property (nonatomic, strong) NSDictionary *extras;
@end

@implementation SBorXibVC

+ (id)allocWithParams:(NSDictionary<NSString *,id> *)extras
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SBorXibVC" bundle:nil];
    SBorXibVC *sb = [storyboard instantiateInitialViewController];
    sb.extras = extras;
    return sb;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"******sbBacktbutton******%@",self.extras);
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
