//
//  HUDVC.m
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/12.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import "HUDVC.h"
#import "YBHudManager.h"

@implementation HUDVC
- (IBAction)close:(id)sender
{
    [YBHUDManager hide];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [YBHUDManager showWithView:self.view  Status:YBHUDStatusWaitting text:@""];
    }
    else
    {
       [YBHUDManager showWithView:self.view text:@"成成" block:^{
           NSLog(@".....................................................");
       }];
    }
}


@end
