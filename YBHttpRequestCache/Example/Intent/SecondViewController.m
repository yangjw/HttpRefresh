//
//  SecondViewController.m
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/9.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import "SecondViewController.h"
#import "YBIntent.h"

@interface SecondViewController ()<YBIntentReceivable,YBIntentReceivable>
@property (nonatomic, strong) NSDictionary *data;
@end

@implementation SecondViewController

- (id)initWithExtras:(NSDictionary<NSString *,id> *)extras
{
    if ((self = [self initWithNibName:nil bundle:nil]))
    {
        NSLog(@"=======>%@",extras);
        self.data = extras;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"====传入参数===>%@",self.data);
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
