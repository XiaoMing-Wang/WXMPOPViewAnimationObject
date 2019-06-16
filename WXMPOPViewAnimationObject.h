//
//  WXMPopupHelp.h
//  ModuleDebugging
//
//  Created by edz on 2019/5/6.
//  Copyright © 2019年 wq. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, WXMPopupHelpType) {
    WXMPopupHelpTypeDefault = 0,
};

@interface WXMPOPViewAnimationObject : UIView

/** 显示的图层 nil为window */
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, assign) WXMPopupHelpType popupHelpType;

/** 默认YES 点击黑色底层隐藏 */
@property (nonatomic, assign) BOOL touchBlackHiden;

/** 核心位置 */
+ (instancetype)wxmpopupHelpWithContentView:(UIView *)contentView;

/** 显示弹窗 */
- (void)showPopupView;

/** 隐藏弹窗 */
- (void)hidePopupView;

@end
