//
//  WXMPopupHelp.h
//  ModuleDebugging
//
//  Created by edz on 2019/5/6.
//  Copyright © 2019年 wq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXMPOPBaseConfiguration.h"

@interface WXMPOPViewAnimationObject : UIView

/** 核心位置 */
+ (WXMPOPViewAnimationObject *)popupHelpWithContentView:(UIView *)contentView;

/** 显示弹窗 */
- (void)animationShowpopupView;

/** 隐藏弹窗 */
- (void)animationHidepopupView;

@end
