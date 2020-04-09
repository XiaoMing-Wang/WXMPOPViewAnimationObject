//
//  WXMPOPBaseConfiguration.h
//  ModuleDebugging
//
//  Created by edz on 2019/10/15.
//  Copyright © 2019 wq. All rights reserved.
//

#ifndef WXMPOPBaseConfiguration_h
#define WXMPOPBaseConfiguration_h
#define WXMRGBAColor(r, g, b) \
[UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:1]

/** iphoneX */
#define WXMPOPIPhoneX ({  \
BOOL isPhoneX = NO;  \
if (@available(iOS 11.0, *)) {  \
    isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0; \
} (isPhoneX); })

/** 弹窗宽度系统弹窗宽度270 */
#define WXMPOPWidth        270

/** 最小高度 */
#define WXMPOPMinHeight    200

/** 圆角 WXMPOPViewAnimationDefaultcal才有 */
#define WXMPOPRoundedCorners  12

/** 标题上下间隔 */
#define WXMPOPContentEdge  25

/** 标题左右边距 */
#define WXMPOPContentLREdge  14

/** 描述上下间隔 */
#define WXMPOPMessageEdge  6.5

/** 描述左右边距 */
#define WXMPOPMessageLREdge  14

/** 按钮高度 */
#define WXMPOPButtonHeight 50

/** 标题字号 */
#define WXMPOPTitleFont    [UIFont boldSystemFontOfSize:17];

/** 描述字号 */
#define WXMPOPMessageFont  16

/** 按钮字号 */
#define WXMPOPButtonFont   16

/** 标题颜色 */
#define WXMPOPTitleColor   WXMRGBAColor(45, 45, 45)

/** 描述颜色 */
#define WXMPOPMessageColor WXMRGBAColor(120, 120, 120)

/** 按钮标题颜色 */
#define WXMPOPButtonColor WXMRGBAColor(35, 35, 35)

/** 线条颜色 */
#define WXMPOPLineColor [UIColor lightGrayColor]

/** 按钮样式 */
typedef NS_ENUM(NSUInteger, WXMPOPChooseType) {

    /** 无按钮 */
    WXMPOPChooseTypeNone = 0,

    /** 单个按钮取消 */
    WXMPOPChooseTypeSingle,

    /** 单个按钮确定 */
    WXMPOPChooseTypeSingleSure,

    /** 两个按钮 */
    WXMPOPChooseTypeDouble,
};

typedef NS_ENUM(NSUInteger, WXMPOPViewAnimationType) {

    /** 中间弹出 */
    WXMPOPViewAnimationDefault = 0,

    /** 底部弹出 */
    WXMPOPViewAnimationBottomSlide,
};

/** 弹窗优先级 */
typedef NS_ENUM(NSUInteger, WXMPOPViewPriorityType) {

    /** 默认 */
    WXMPOPViewPriorityTypeDefault = 0,
    
    /** 等待其他弹窗 */
    WXMPOPViewPriorityTypeWait,
    
    /** 低 */
    WXMPOPViewPriorityTypeLow,
    
    /** 高 */
    WXMPOPViewPriorityTypeHigh,
};

/** 回调协议 */
@protocol WXMPOPBaseCallbackProtocol <NSObject>
@optional
- (void)popCallbackProtocolWithIndex:(NSInteger)index;
- (void)popCallbackProtocolWithIdentString:(NSString *)aString;
@end

#endif /* WXMPOPBaseConfiguration_h */
