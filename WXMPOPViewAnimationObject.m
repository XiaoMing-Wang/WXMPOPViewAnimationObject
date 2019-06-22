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

#import "WXMPOPViewAnimationObject.h"
@interface WXMPOPViewAnimationObject ()
@property (nonatomic, strong) UIControl *blackView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) BOOL interactivePop;
@property (nonatomic, assign) CGFloat locationBottom;
@property (nonatomic, assign) CGFloat keyboardTop;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, assign) CGRect oldRect;
@end

@implementation WXMPOPViewAnimationObject

/** 核心位置 */
+ (instancetype)popupHelpWithContentView:(UIView *)contentView {
    if (!contentView) return nil;
    WXMPOPViewAnimationObject *animationObject = [WXMPOPViewAnimationObject new];
    animationObject.contentView = contentView;
    [animationObject setupInterface];
    return animationObject;
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
    [self addSubview:self.blackView];
    [self addSubview:self.contentView];
    
    /** 递归获取TextField */
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
- (void)animationShowpopupView {
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
    WXMPOPViewAnimationObject *previous = [superView viewWithTag:WXMPopupHelpSign];
    if (self.priorityType < previous.priorityType) return; /** 优先级低于界面上的弹窗 */
    if (previous) {
        delay = 0.2f;
        self.blackView.alpha = 1;
        [previous animationHidepopupView];
    }
    
    [superView addSubview:self];
    [self setDifferentAnimations:delay];
}

/** 设置动画 */
- (void)setDifferentAnimations:(CGFloat)delay {
    if (delay == 0) _blackView.alpha = 0;
    _contentView.alpha = 0;
    
    if (self.popupAnimationType == WXMPOPViewAnimationDefault) {
        _contentView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        _oldRect = _contentView.frame;
        _contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        [UIView animateWithDuration:0.32 delay:delay usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            self.blackView.alpha = 1;
            self.contentView.alpha = 1.0;
            self.contentView.transform = CGAffineTransformIdentity;
        } completion:nil];
    } else if (self.popupAnimationType == WXMPOPViewAnimationBottomSlide) {
        [self setYWithView:_contentView y:[UIScreen mainScreen].bounds.size.height];
        self.oldRect = self.contentView.frame;
        [UIView animateWithDuration:0.32 delay:delay options:0 animations:^{
            CGFloat height = self.frame.size.height;
            CGFloat y = [UIScreen mainScreen].bounds.size.height - height;
            [self setYWithView:self.contentView y:y];
        } completion:nil];
    }
}

/** 隐藏弹窗 */
- (void)animationHidepopupView {
    [_contentView endEditing:YES];
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.blackView.alpha = 0.0;
        self.contentView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.viewController &&
            [self.viewController isKindOfClass:[UINavigationController class]])  {
            UINavigationController * navigation = (UINavigationController *)self.viewController;
            navigation.interactivePopGestureRecognizer.enabled = self.interactivePop;
        }
    }];
}

- (void)setTouchBlackHiden:(BOOL)touchBlackHiden {
    UIControlEvents event = UIControlEventTouchUpInside;
    _touchBlackHiden = touchBlackHiden;
    SEL sel = @selector(hidepopupView);
    if (_touchBlackHiden)[_blackView addTarget:self action:sel forControlEvents:event];
    else [_blackView removeTarget:self action:sel forControlEvents:event];
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

/**  */
- (void)setYWithView:(UIView *)targetView y:(CGFloat)y {
    CGRect frame = targetView.frame;
    frame.origin.y = y;
    targetView.frame = frame;
}
@end
