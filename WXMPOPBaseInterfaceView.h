//
//  WXMPOPBaseView.h
//  Multi-project-coordination
//
//  Created by wq on 2019/6/22.
//  Copyright © 2019年 wxm. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "WXMPOPBaseConfiguration.h"
#import "WXMPOPViewAnimationObject.h"
@interface WXMPOPBaseInterfaceView : UIView

/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;

/** 描述 */
@property (nonatomic, strong) UITextView *messageTextView;

/** 按钮 */
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIView *popButtonView;

/** 线条 */
@property (nonatomic, strong) CALayer *titleLine;
@property (nonatomic, strong) CALayer *buttonHorizontalLine;
@property (nonatomic, strong) CALayer *buttonVerticalLine;

/** 边距 */
@property (nonatomic, assign) CGFloat contentEdge;
@property (nonatomic, assign) CGFloat messageEdge;
@property (nonatomic, assign) CGFloat roundedCorners;

/** 垂直偏移 原始位置是正居中 */
@property (nonatomic, assign) CGFloat verticalOffset;

/** 触摸消失 */
@property (nonatomic, assign) BOOL touchBlackHiden;
@property (nonatomic, assign) BOOL touchButtonHiden;

/** WXMPOPViewAnimationBottomSlide模式是否有收回动画 YES代表有 默认NO */
@property (nonatomic, assign) BOOL decline;

/** 按钮类型 */
@property (nonatomic, assign) WXMPOPChooseType chooseType;

/** 弹窗类型 */
@property (nonatomic, assign) WXMPOPViewAnimationType popupAnimationType;

/** 优先级 */
@property (nonatomic, assign) WXMPOPViewPriorityType priorityType;

/** 弹窗对象 */
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, weak) WXMPOPViewAnimationObject *animationObject;

@property (nonatomic, copy) void (^callback)(NSInteger index);
@property (nonatomic, copy) void (^callbackTitle)(NSString *ident);
@property (nonatomic, weak) id<WXMPOPBaseCallbackProtocol> delegate;

/** 弹窗控制器 */
- (UIViewController *)wp_displayViewController;
- (void)wp_showpopupView;
- (void)wp_hidepopupView;

@end
