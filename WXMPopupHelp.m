//
//  WXMPopupHelp.m
//  ModuleDebugging
//
//  Created by edz on 2019/5/6.
//  Copyright © 2019年 wq. All rights reserved.
//
#define WXMPopupHelpSign 100021
#define KHeight [UIScreen mainScreen].bounds.size.height
#define KNotificationCenter [NSNotificationCenter defaultCenter]

#import "WXMPopupHelp.h"
@interface WXMPopupHelp ()
@property (nonatomic, strong) UIControl *blackView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) BOOL interactivePop;
@property (nonatomic, assign) CGFloat locationBottom;
@property (nonatomic, assign) CGFloat keyboardTop;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, assign) CGRect oldRect;
@end

@implementation WXMPopupHelp

/** 核心位置 */
+ (instancetype)wxmpopupHelpWithContentView:(UIView *)contentView {
    if (!contentView) return nil;
    WXMPopupHelp *help = [WXMPopupHelp new];
    help.contentView = contentView;
    [help setupInterface];
    return help;
}
- (void)setupInterface {
    _blackView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    _blackView.userInteractionEnabled = YES;
    _blackView.alpha = 0;
    
    self.tag = WXMPopupHelpSign;
    self.frame = CGRectMake(0, 0, _blackView.frame.size.width, _blackView.frame.size.height);
    self.userInteractionEnabled = YES;
    self.touchBlackHiden = YES;
    self.contentView.alpha = 0;
    self.contentView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    [self addSubview:_blackView];
    [self addSubview:self.contentView];
    
    if ([self getParentViewOfTextField:self.contentView]) {
        _oldRect = _contentView.frame;
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        CGRect rect = [_contentView convertRect:_contentView.bounds toView:window];
        self.locationBottom = rect.origin.y + _contentView.frame.size.height;
        
        [KNotificationCenter addObserver:self selector:@selector(keyBoardWillShow:)
                                    name:UIKeyboardWillShowNotification object:nil];
        [KNotificationCenter addObserver:self selector:@selector(keyBoardWillHide:)
                                    name:UIKeyboardWillHideNotification object:nil];
    }
}

/** 显示弹窗 */
- (void)showPopupView {
    UIView * superView = [[[UIApplication sharedApplication] delegate] window];
    if (self.superview) superView = self.superview;
    if (self.viewController) superView = self.viewController.view;
    if (self.viewController && [self.viewController isKindOfClass:[UINavigationController class]])  {
        UINavigationController * navigation = (UINavigationController *)self.viewController;
        _interactivePop = navigation.interactivePopGestureRecognizer.enabled;
        navigation.interactivePopGestureRecognizer.enabled = NO;
        superView = navigation.view;
    }
    
   
    CGFloat delay = 0;
    self.bounds = _blackView.bounds = superView.bounds;
    
    _blackView.alpha = 0;
    _contentView.alpha = 0;
    _contentView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    _oldRect = _contentView.frame;
    _contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    WXMPopupHelp *sameView = [superView viewWithTag:WXMPopupHelpSign];
    if (sameView) [sameView removeFromSuperview];
    if (sameView) delay = 0.1;
    if (sameView) self.blackView.alpha = 1;
    [superView addSubview:self];
   
    [UIView animateWithDuration:0.32 delay:delay usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.blackView.alpha = 1;
        self.contentView.alpha = 1.0;
        self.contentView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

/** 隐藏弹窗 */
- (void)hidePopupView {
    [_contentView endEditing:YES];
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.blackView.alpha = 0.0;
        self.contentView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.viewController && [self.viewController isKindOfClass:[UINavigationController class]])  {
            UINavigationController * navigation = (UINavigationController *)self.viewController;
            navigation.interactivePopGestureRecognizer.enabled = self.interactivePop;
        }
    }];
}

- (void)setTouchBlackHiden:(BOOL)touchBlackHiden {
    _touchBlackHiden = touchBlackHiden;
    SEL sel = @selector(hidePopupView);
    if (_touchBlackHiden) [_blackView addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    else [_blackView removeTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
}
/** 键盘弹出 */
- (void)keyBoardWillShow:(NSNotification *)sender {
    CGFloat keyboardH = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    if (keyboardH == 0) return;
    
    /** 键盘位置*/
    _keyboardHeight = MAX(keyboardH, _keyboardHeight);
    _keyboardTop = KHeight - _keyboardHeight;
    CGFloat distance = _locationBottom - _keyboardTop;
    if (distance <= 0) return;
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = self.oldRect;
        rect.origin.y = rect.origin.y - (distance + 15);
        self.contentView.frame = rect;
    } completion:nil];
}

/** 键盘收起 */
- (void)keyBoardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.frame = self.oldRect;
    } completion:nil];
}

/* 递归获取textField */
- (UITextField *)getParentViewOfTextField:(UIView *)supView {
    for (UIView *subView in supView.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) return (UITextField *)subView;
        else if(subView.subviews.count > 0) [self getParentViewOfTextField:subView];
    }
    return nil;
}
@end
