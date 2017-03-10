//
//  KeyBoardViewController.m
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/9.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import "KeyBoardViewController.h"
#import "UIView+YBTools.h"

#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")
@interface KeyBoardViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{

}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) CGRect keyboardRect;

- (IBAction)close:(id)sender;
@end

@implementation KeyBoardViewController

#pragma mark - UIViewController

- (void)setUp
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TPKeyboardAvoiding_keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TPKeyboardAvoiding_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)TPKeyboardAvoiding_keyboardWillShow:(NSNotification*)notification
{
    
    CGRect keyboardRect = [self.scrollView convertRect:[[[notification userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue] toView:nil];
    NSLog(@"---------->%@",[NSValue valueWithCGRect:keyboardRect]);
    if (CGRectIsEmpty(keyboardRect)) {
        return;
    }
    
    self.keyboardRect = keyboardRect;
//    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC));
//    dispatch_after(delay, dispatch_get_main_queue(), ^{
//        
//        // Shrink view's inset by the keyboard's height, and scroll to show the text field/view being edited
//        [UIView beginAnimations:nil context:NULL];
//        
//        [UIView setAnimationDelegate:self];
//        [UIView setAnimationWillStartSelector:@selector(keyboardViewAppear:context:)];
//        [UIView setAnimationDidStopSelector:@selector(keyboardViewDisappear:finished:context:)];
//        
//        [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
//        [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    
        UIView *firstResponder = [self TPKeyboardAvoiding_findFirstResponderBeneathView:self.scrollView];
        if ( firstResponder ) {
            
            self.scrollView.contentInset = [self TPKeyboardAvoiding_contentInsetForKeyboard];
            
            CGFloat viewableHeight = self.scrollView.bounds.size.height - self.scrollView.contentInset.top - self.scrollView.contentInset.bottom;
            CGPoint size = CGPointMake(self.scrollView.contentOffset.x,
                                       [self TPKeyboardAvoiding_idealOffsetForView:firstResponder
                                                             withViewingAreaHeight:viewableHeight]);
            [self.scrollView setContentOffset:size animated:NO];
        }
        
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
//        [UIView commitAnimations];
//    });
}

-(CGFloat)TPKeyboardAvoiding_idealOffsetForView:(UIView *)view withViewingAreaHeight:(CGFloat)viewAreaHeight {
    CGSize contentSize = self.scrollView.contentSize;
    __block CGFloat offset = 0.0;
    
    CGRect subviewRect = [view convertRect:view.bounds toView:self.scrollView];
    
    __block CGFloat padding = 0.0;
    
    void(^centerViewInViewableArea)()  = ^ {
        // Attempt to center the subview in the visible space
        padding = (viewAreaHeight - subviewRect.size.height) / 2;
        
        // But if that means there will be less than kMinimumScrollOffsetPadding
        // pixels above the view, then substitute kMinimumScrollOffsetPadding
        if (padding < 20)
        {
            padding = 20;
        }
        
        // Ideal offset places the subview rectangle origin "padding" points from the top of the scrollview.
        // If there is a top contentInset, also compensate for this so that subviewRect will not be placed under
        // things like navigation bars.
        offset = subviewRect.origin.y - padding - self.scrollView.contentInset.top;
    };
    
    // If possible, center the caret in the visible space. Otherwise, center the entire view in the visible space.
    if ([view conformsToProtocol:@protocol(UITextInput)]) {
        UIView <UITextInput> *textInput = (UIView <UITextInput>*)view;
        UITextPosition *caretPosition = [textInput selectedTextRange].start;
        if (caretPosition) {
            CGRect caretRect = [self.scrollView convertRect:[textInput caretRectForPosition:caretPosition] fromView:textInput];
            
            // Attempt to center the cursor in the visible space
            // pixels above the view, then substitute kMinimumScrollOffsetPadding
            padding = (viewAreaHeight - caretRect.size.height) / 2;
            
            // But if that means there will be less than kMinimumScrollOffsetPadding
            // pixels above the view, then substitute kMinimumScrollOffsetPadding
            if (padding < 20 ) {
                padding = 20;
            }
            
            // Ideal offset places the subview rectangle origin "padding" points from the top of the scrollview.
            // If there is a top contentInset, also compensate for this so that subviewRect will not be placed under
            // things like navigation bars.
            offset = caretRect.origin.y - padding - self.scrollView.contentInset.top;
        } else {
            centerViewInViewableArea();
        }
    } else {
        centerViewInViewableArea();
    }
    
    // Constrain the new contentOffset so we can't scroll past the bottom. Note that we don't take the bottom
    // inset into account, as this is manipulated to make space for the keyboard.
    CGFloat maxOffset = contentSize.height - viewAreaHeight - self.scrollView.contentInset.top;
    if (offset > maxOffset) {
        offset = maxOffset;
    }
    
    // Constrain the new contentOffset so we can't scroll past the top, taking contentInsets into account
    if ( offset < -self.scrollView.contentInset.top ) {
        offset = -self.scrollView.contentInset.top;
    }
    
    return offset;
}


- (UIEdgeInsets)TPKeyboardAvoiding_contentInsetForKeyboard {
    UIEdgeInsets newInset = self.scrollView.contentInset;
    CGRect keyboardRect = self.keyboardRect;
    newInset.bottom = keyboardRect.size.height - MAX((CGRectGetMaxY(keyboardRect) - CGRectGetMaxY(self.scrollView.bounds)), 0);
    return newInset;
}


- (UIView*)TPKeyboardAvoiding_findFirstResponderBeneathView:(UIView*)view {
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] ) return childView;
        UIView *result = [self TPKeyboardAvoiding_findFirstResponderBeneathView:childView];
        if ( result ) return result;
    }
    return nil;
}

- (void)keyboardViewAppear:(NSString *)animationID context:(void *)context {
    
}

- (void)keyboardViewDisappear:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
    if (finished) {
        
    }
}

- (void)TPKeyboardAvoiding_keyboardWillHide:(NSNotification *)notification
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self setUp];
    [self.view addSubview:self.scrollView];
    
    
    [self.scrollView setContentSize:CGSizeMake(self.view.width, self.view.height)];
 
    self.textField.frame = CGRectMake(0, self.view.height - 44 - 64, self.view.width, 44);
    
    [self.scrollView addSubview:self.textField];
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


- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor redColor];
    }
    return _scrollView;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.backgroundColor = [UIColor orangeColor];
    }
    return _textField;
}

- (IBAction)close:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
