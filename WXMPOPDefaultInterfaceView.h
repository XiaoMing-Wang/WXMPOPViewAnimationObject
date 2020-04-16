//
//  WXMPOPDefault InterfaceView.h
//  ModuleDebugging
//
//  Created by edz on 2019/10/17.
//  Copyright © 2019 wq. All rights reserved.
//

#import "WXMPOPBaseInterfaceView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WXMPOPDefaultInterfaceView : WXMPOPBaseInterfaceView

/** 标题 */
@property (nonatomic, copy) NSString *popsTitle;
@property (nonatomic, copy) NSString *popsMessage;

/** 初始化 */
- (void)initializationInterface;

/** 自适应高度布局 根据title和message适配 需要子类调用 */
- (void)setupAutomaticLayout;

/** 按钮点击事件 */
- (void)touchEvent:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
