//
//  ThridViewController.m
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/9.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import "ThridViewController.h"
#import "YBIntent.h"

@interface ThridViewController ()<YBIntentForResultReceivable>

@property (nonatomic, strong) NSDictionary *data;

@property (nonatomic, assign) NSNumber* requestCode;
@property (nonatomic, weak) id<YBIntentForResultSendable> delegate;

@end

@implementation ThridViewController

- (id)initWithExtras:(NSDictionary<NSString *,id> *)extras
{
    if ((self = [self initWithNibName:nil bundle:nil]))
    {
        self.data = extras;
        NSLog(@"1111111111111111111111111");
        NSLog(@"=======>%@",extras);
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"====传入参数===>%@",self.data);
     NSLog(@"222222222222222222222222");
    UIBarButtonItem *dismiss = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                             target:self
                                                                             action:@selector(dismiss:)];
    self.navigationItem.leftBarButtonItem = dismiss;
}

- (void)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.delegate) {
        YBIntent *intent = [[YBIntent alloc] init];
        [intent putExtraWithName:@"ThridViewController" data:@"回调"];
        [self.delegate onControllerResult:self.requestCode resultCode:YBIntentResultCodeOK data:intent];
    }
}

- (void)setRequestCode:(NSNumber *)requestCode
{
    NSLog(@"----->%ld",[requestCode integerValue]);
    _requestCode = requestCode;
}

- (void)setDelegate:(__strong id<YBIntentForResultSendable> )delegate
{
    _delegate = delegate;
}


@end
