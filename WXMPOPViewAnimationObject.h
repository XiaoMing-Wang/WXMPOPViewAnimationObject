//
//  WXMPopupHelp.h
//  ModuleDebugging
//
//  Created by edz on 2019/5/6.
//  Copyright © 2019年 wq. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, WXMPOPViewAnimationType) {
    WXMPOPViewAnimationDefault = 0, /** 中间弹出 */
    WXMPOPViewAnimationBottomSlide, /** 底部弹出 */
};

/** 弹窗优先级 */
typedef NS_ENUM(NSUInteger, WXMPOPViewPriorityType) {
    WXMPOPViewPriorityTypeDefault = 0,
    WXMPOPViewPriorityTypeLow,
    WXMPOPViewPriorityTypeHigh,
};

@protocol WXMPOPViewAnimationProtocol <NSObject>
@optional
- (void)showpopupView;
- (void)hidepopupView;
- (UIViewController *)displayViewController;
@end

@interface WXMPOPViewAnimationObject : UIView

/** 显示的图层 nil为window */
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, assign) WXMPOPViewAnimationType popupAnimationType;
@property (nonatomic, assign) WXMPOPViewPriorityType priorityType;

/** 默认YES 点击黑色底层隐藏 */
@property (nonatomic, assign) BOOL touchBlackHiden;

/** 核心位置 */
+ (instancetype)popupHelpWithContentView:(UIView *)contentView;

/** 显示弹窗 */
- (void)animationShowpopupView;

/** 隐藏弹窗 */
- (void)animationHidepopupView;

@end
