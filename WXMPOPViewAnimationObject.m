//
//  WXMPopupHelp.m
//  ModuleDebugging
//
//  Created by edz on 2019/5/6.
//  Copyright © 2019年 wq. All rights reserved.
//
#define WXMPopupHelpSign 4004
#define KHeight [UIScreen mainScreen].bounds.size.height
#define KNotificationCenter [NSNotificationCenter defaultCenter]

#import "WXMPOPViewAnimationObject.h"
#import "WXMPOPBaseInterfaceView.h"
@interface WXMPOPViewAnimationObject ()
@property (nonatomic, strong) UIControl *blackView;
@property (nonatomic, strong) WXMPOPBaseInterfaceView *contentView;

@property (nonatomic, assign) BOOL isAnimation;
@property (nonatomic, assign) BOOL interactivePop;
@property (nonatomic, assign) CGFloat locationBottom;
@property (nonatomic, assign) CGFloat keyboardTop;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, assign) CGRect oldRect;
@end

static NSMutableArray *aniObjectArray;
@implementation WXMPOPViewAnimationObject

- (instancetype)init {
    if (self = [super init]) {
        if (!aniObjectArray) aniObjectArray = @[].mutableCopy;
    }
    return self;
}

/** 核心位置 */
+ (WXMPOPViewAnimationObject *)popupHelpWithContentView:(WXMPOPBaseInterfaceView *)content {
    if (content == nil) return nil;
    WXMPOPViewAnimationObject *animationObject = [[WXMPOPViewAnimationObject alloc] init];
    animationObject.contentView = content;
    [animationObject setupInterface];
    [aniObjectArray addObject:animationObject];
    return animationObject;
}

- (void)setupInterface {
    
    /** 黑色背景 */
    _blackView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    _blackView.userInteractionEnabled = YES;
    _blackView.alpha = 0;
    
    self.tag = WXMPopupHelpSign;
    self.frame = CGRectMake(0, 0, _blackView.frame.size.width, _blackView.frame.size.height);
    self.userInteractionEnabled = YES;
    
    /** 点击黑色背景消失 */
    [self setTouchBlackHiden:self.contentView.touchBlackHiden];
    
    self.contentView.alpha = 0;
    self.contentView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    [self addSubview:self.blackView];
    [self addSubview:self.contentView];
    
    /** 递归获取TextField */
    if ([self getParentViewOfTextField:self.contentView]) {
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        CGRect rect = [self.contentView convertRect:self.contentView.bounds toView:window];
        
        self.oldRect = self.contentView.frame;
        self.locationBottom = rect.origin.y + self.contentView.frame.size.height;
        [KNotificationCenter addObserver:self selector:@selector(keyBoardWillShow:)
                                    name:UIKeyboardWillShowNotification object:nil];
        [KNotificationCenter addObserver:self selector:@selector(keyBoardWillHide:)
                                    name:UIKeyboardWillHideNotification object:nil];
    }
}

/** 显示弹窗 */
- (void)animationShowpopupView {
    UIView *superView = [[[UIApplication sharedApplication] delegate] window];
    if (self.superview) superView = self.superview;
    UIViewController *contentVC = self.contentView.viewController;
    if (contentVC) superView = contentVC.view;
    if ([contentVC isKindOfClass:[UINavigationController class]])  {
        UINavigationController * navigation = (UINavigationController *) contentVC;
        self.interactivePop = navigation.interactivePopGestureRecognizer.enabled;
        navigation.interactivePopGestureRecognizer.enabled = NO;
        superView = navigation.view;
    }
    
    self.bounds = self.blackView.bounds = superView.bounds;
    WXMPOPViewAnimationObject *previous = [superView viewWithTag:WXMPopupHelpSign];
    if (previous && self.contentView.priorityType == WXMPOPViewPriorityTypeWait) return;
    
    int64_t delta = (int64_t)(0.0 * NSEC_PER_SEC);
    dispatch_queue_t queue = dispatch_get_main_queue();
    if (previous && self.contentView.priorityType >= previous.contentView.priorityType) {
        [previous animationHidepopupView];
        delta = (int64_t)(0.35 * NSEC_PER_SEC);
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), queue, ^{
        [superView addSubview:self];
        [self setDifferentAnimations];
    });
}

/** 设置动画 */
- (void)setDifferentAnimations {
    if (self.isAnimation) return;
    self.isAnimation = YES;
    self.contentView.alpha = 0;
    
    if (self.contentView.popupAnimationType == WXMPOPViewAnimationDefault) {
        self.contentView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        self.contentView.transform = CGAffineTransformMakeScale(0.75, 0.75);
        [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            self.blackView.alpha = 1.0;
            self.contentView.alpha = 1.0;
            self.contentView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) { self.isAnimation = NO; }];
        
    } else if (self.contentView.popupAnimationType == WXMPOPViewAnimationBottomSlide) {
        
        [self setContentY:[UIScreen mainScreen].bounds.size.height];
        self.oldRect = self.contentView.frame;
        [UIView animateWithDuration:0.32 delay:0 options:0 animations:^{
            CGFloat height = self.frame.size.height;
            CGFloat y = [UIScreen mainScreen].bounds.size.height - height;
            [self setContentY:y];
        } completion:^(BOOL finished) { self.isAnimation = NO; }];
    }
}

/** 隐藏弹窗 */
- (void)animationHidepopupView {
    
    [self.contentView endEditing:YES];
    UIViewController *contentVC = self.contentView.viewController;
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.blackView.alpha = 0.0;
        self.contentView.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        [aniObjectArray removeObject:self];
        if (finished) [self judgeNextPopover];
        if (contentVC && [contentVC isKindOfClass:[UINavigationController class]])  {
            UINavigationController * navigation = (UINavigationController *)contentVC;
            navigation.interactivePopGestureRecognizer.enabled = self.interactivePop;
        }
    }];
}

- (void)judgeNextPopover {
    WXMPOPViewAnimationObject *animationObject = aniObjectArray.firstObject;
    if (animationObject&&animationObject.contentView.priorityType==WXMPOPViewPriorityTypeWait) {
        int64_t delta = (int64_t)(0.35 * NSEC_PER_SEC);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), dispatch_get_main_queue(), ^{
            [animationObject animationShowpopupView];
        });
    }
}

- (void)setTouchBlackHiden:(BOOL)touchBlackHiden {
    UIControlEvents event = UIControlEventTouchUpInside;
    SEL sel = @selector(animationHidepopupView);
    if (touchBlackHiden) [_blackView addTarget:self action:sel forControlEvents:event];
    if (!touchBlackHiden) [_blackView removeTarget:self action:sel forControlEvents:event];
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

- (void)setContentY:(CGFloat)y {
    CGRect frame = self.contentView.frame;
    frame.origin.y = y;
    self.contentView.frame = frame;
}

@end
