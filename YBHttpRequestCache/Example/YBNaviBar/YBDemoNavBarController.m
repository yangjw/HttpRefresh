//
//  YBDemoNavBarController.m
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/13.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import "YBDemoNavBarController.h"
#import "YBNavigationBarView.h"
#import "YBMacros.h"
#import "YBDemoVC.h"

@interface YBDemoNavBarController ()
@property (nonatomic, strong) YBNavigationBarView *naviBarView;

@end

@implementation YBDemoNavBarController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _naviBarView = [[YBNavigationBarView alloc] initWithFrame:ccr(0.0f, 0.0f, kYBScreenW, kYBTopBarHeight)];
    _naviBarView.sourceController = self;
    [self.view addSubview:_naviBarView];
    
    
    [_naviBarView setYBTitle:@"导航栏"];
    [_naviBarView setYBTitleColor:[UIColor whiteColor]];
    [_naviBarView setBackgroundColor:[UIColor colorWithRed:0.125 green:0.788 blue:0.655 alpha:1.000]];
    
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton setImage:[UIImage imageNamed:@"main_left_back_white"] forState:UIControlStateNormal];
    [leftbutton setImage:[UIImage imageNamed:@"main_left_back_white"] forState:UIControlStateHighlighted];
    [leftbutton setImage:[UIImage imageNamed:@"main_left_back_white"] forState:UIControlStateSelected];
    [leftbutton addTarget:self action:@selector(leftButton) forControlEvents:UIControlEventTouchUpInside];
    leftbutton.frame = ccr(0, 20, 44, 44);
//    leftbutton.backgroundColor = [UIColor orangeColor];

    
    UIButton *leftbutton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton1 setImage:[UIImage imageNamed:@"nav_close_black"] forState:UIControlStateNormal];
    [leftbutton1 setImage:[UIImage imageNamed:@"nav_close_black"] forState:UIControlStateHighlighted];
    [leftbutton1 setImage:[UIImage imageNamed:@"nav_close_black"] forState:UIControlStateSelected];
    [leftbutton1 addTarget:self action:@selector(leftButton) forControlEvents:UIControlEventTouchUpInside];
//    leftbutton1.frame = ccr(0, 20, 44, 44);
//    leftbutton1.backgroundColor = [UIColor blueColor];

    
    
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbutton setImage:[UIImage imageNamed:@"nav_share_black"] forState:UIControlStateNormal];
    [rightbutton setImage:[UIImage imageNamed:@"nav_share_black"] forState:UIControlStateHighlighted];
    [rightbutton setImage:[UIImage imageNamed:@"nav_share_black"] forState:UIControlStateSelected];
    [rightbutton addTarget:self action:@selector(rightButton) forControlEvents:UIControlEventTouchUpInside];
    rightbutton.frame = ccr(0, 0, 44, 44);
    
    UIButton *rightbutton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbutton1 setImage:[UIImage imageNamed:@"nav_share_black"] forState:UIControlStateNormal];
    [rightbutton1 setImage:[UIImage imageNamed:@"nav_share_black"] forState:UIControlStateHighlighted];
    [rightbutton1 setImage:[UIImage imageNamed:@"nav_share_black"] forState:UIControlStateSelected];
    [rightbutton1 addTarget:self action:@selector(rightButton) forControlEvents:UIControlEventTouchUpInside];
    rightbutton1.frame = ccr(0, 0, 44, 44);

    UIButton *rightbutton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbutton2 setImage:[UIImage imageNamed:@"nav_share_black"] forState:UIControlStateNormal];
    [rightbutton2 setImage:[UIImage imageNamed:@"nav_share_black"] forState:UIControlStateHighlighted];
    [rightbutton2 setImage:[UIImage imageNamed:@"nav_share_black"] forState:UIControlStateSelected];
    [rightbutton2 addTarget:self action:@selector(rightButton) forControlEvents:UIControlEventTouchUpInside];
    rightbutton2.frame = ccr(0, 0, 100, 44);

    
//    rightbutton.backgroundColor = [UIColor redColor];
    
    [_naviBarView setYBLeftItem:nil];
    [_naviBarView setYBLeftItems:@[leftbutton,leftbutton1]];
    
//    [_naviBarView setYBRightItem:rightbutton];
    [_naviBarView setYBRightItems:@[rightbutton,rightbutton1]];
    
//    UIView *view = [[UIView alloc] initWithFrame:ccr(0, 0, kYBScreenW, 64)];
//    view.backgroundColor = [UIColor orangeColor];
//    [_naviBarView showCoverView:view animation:YES];

}

-(void)leftButton
{
    NSLog(@"left");
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)rightButton
{
    NSLog(@"right");
//    YBDemoNavBarController *demo = [[YBDemoNavBarController alloc] init];
//    [self.navigationController pushViewController:demo animated:YES];
    
    YBDemoVC *demo = [[YBDemoVC alloc] init];
    [self.navigationController pushViewController:demo animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
