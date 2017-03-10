//
//  DemoViewController.m
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/9.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import "DemoViewController.h"
#import "FirstViewController.h"

@implementation DemoViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        FirstViewController *first = [[FirstViewController alloc] init];
        [self.navigationController pushViewController:first animated:YES];
//        [self presentViewController:first animated:YES completion:nil];
    }else
    {
        
    }
}

@end

