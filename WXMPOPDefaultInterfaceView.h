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
- (void)setupCustomSettings;

/** 布局 */
- (void)setupAutomaticLayout;
- (void)setupAutomaticLayoutMessage;

/** 固定高度(标题+标题上边距+按钮高度) */
- (CGFloat)minImmobilizationHeight;

/** 总高度 */
- (CGFloat)totalOneselfHeight;

@end

NS_ASSUME_NONNULL_END
