//
//  YBDemoVC.m
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/13.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import "YBDemoVC.h"
#import "YBMacros.h"

@interface YBDemoVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation YBDemoVC
#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviBarTitle:@"Demo"];
    [self navigationCanDragBack:YES];
    [self setnaviBarBottomLine:YES];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
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

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:ccr(0, kYBTopBarHeight, kYBScreenW, kYBScreenH- kYBTopBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = [NSString stringWithFormat:@"%@",indexPath];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= 0) {
        if (scrollView.contentOffset.y > 44)
        {
             NSLog(@"********************%f",scrollView.contentOffset.y);
            self.viewNaviBar.frame = ccr(0, 0, kYBScreenW, 20);
            [self.viewNaviBar hideOriginalBarItem:YES];
            _tableView.frame = ccr(0, 20, kYBScreenW, kYBScreenH - 20);
        }
        else
        {
            NSLog(@"===================%f",scrollView.contentOffset.y);
            self.viewNaviBar.frame = ccr(0, - scrollView.contentOffset.y, kYBScreenW, kYBTopBarHeight);
            _tableView.frame = ccr(0, 64 - scrollView.contentOffset.y, kYBScreenW, kYBScreenH);
        }
    }else
    {
        [self.viewNaviBar hideOriginalBarItem:NO];
//        self.viewNaviBar.frame = ccr(0, 0, kYBScreenW, 64);
//        _tableView.frame = ccr(0, 64 - scrollView.contentOffset.y, kYBScreenW, kYBScreenH - kYBTopBarHeight);
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


@end
