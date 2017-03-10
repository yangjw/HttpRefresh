//
//  FirstViewController.m
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/9.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThridViewController.h"
#import "YBControllerManager.h"
#import "YBIntent.h"
#import "UIViewController+Intents.h"
#import "SBorXibVC.h"

@interface FirstViewController ()<YBIntentForResultSendable>

@end

@implementation FirstViewController
#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *intentbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    intentbutton.frame = CGRectMake(0, 200, 200, 44);
    [intentbutton setBackgroundColor:[UIColor orangeColor]];
    [intentbutton setTitle:@"intentbutton" forState:UIControlStateNormal];
    [intentbutton addTarget:self action:@selector(actionIntent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:intentbutton];
    
    UIButton *callBacktbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    callBacktbutton.frame = CGRectMake(0, 260, 200, 44);
    [callBacktbutton setBackgroundColor:[UIColor redColor]];
    [callBacktbutton setTitle:@"callBacktbutton" forState:UIControlStateNormal];
    [callBacktbutton addTarget:self action:@selector(callBackAactionIntent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:callBacktbutton];
    
    
    UIButton *sbBacktbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    sbBacktbutton.frame = CGRectMake(0, 320, 200, 44);
    [sbBacktbutton setBackgroundColor:[UIColor blueColor]];
    [sbBacktbutton setTitle:@"sbBacktbutton" forState:UIControlStateNormal];
    [sbBacktbutton addTarget:self action:@selector(sbBacktbutton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sbBacktbutton];
}

-(void)sbBacktbutton
{
    YBIntent *intent = [[YBIntent alloc] initWithClazz:[SBorXibVC class]];
    [intent putExtraWithName:@"SBorXibVC" data:@"SBorXibVC"];
    [self startController:intent];
}

- (void)actionIntent
{
    YBIntent *intent = [[YBIntent alloc] initWithClazz:[SecondViewController class]];
    [intent putExtraWithName:@"SecondViewController" data:@"SecondViewController"];
    [self startController:intent];
//    NSLog(@"==============>%@",@(1));
//    [self performSelector:@selector(method:) withObject:@(1)];
}

- (void)callBackAactionIntent
{
    YBIntent *intent = [[YBIntent alloc] initWithClazz:[ThridViewController class]];    
    [intent putExtraWithName:@"ThridViewController" data:@"ThridViewController"];
    [self startControllerForResult:intent requestCode:@(1)];
}

- (void)onControllerResult:(NSNumber *)requestCode resultCode:(YBIntentResultCode)resultCode data:(YBIntent *)data
{
    if (resultCode == YBIntentResultCodeOK)
    {
        if ([requestCode integerValue] == 1) {
            NSLog(@"ThridViewController=====%@",data.extras);
            NSLog(@"ThridViewController");
        }
    }
    
}

-(void)method:(NSNumber*)code
{
    NSLog(@"***************%ld",[code integerValue]);
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
