//
//  WXMPOPBaseView.h
//  Multi-project-coordination
//
//  Created by wq on 2019/6/22.
//  Copyright © 2019年 wxm. All rights reserved.
//
#define WXMPOPWidth 270
#define WXMPOPMinHeight 200
#define WXMPOPContentEdge 25
#define WXMPOPMessageEdge 15
#define WXMPOPButtonHeight 45

#define WXMPOPTitleFont 16
#define WXMPOPMessageFont 16
#define WXMPOPButtonFont 16

#define WXMPOPTitleColor [UIColor blackColor]
#define WXMPOPMessageColor [UIColor blackColor]
#define WXMPOPButtonColor [UIColor blackColor]
#define WXMPOPLineColor [UIColor lightGrayColor]

#import <UIKit/UIKit.h>
#import "WXMPOPViewAnimationObject.h"

@protocol WXMPOPBaseCallbackProtocol <NSObject>
@optional
- (void)popCallbackProtocolWithIndex:(NSInteger)index;
- (void)popCallbackProtocolWithIdentString:(NSString *)aString;
@end

@interface WXMPOPBaseInterfaceView : UIView <WXMPOPViewAnimationProtocol>
typedef NS_ENUM(NSUInteger, WXMPOPChooseType) {
    WXMPOPChooseTypeNone = 0,
    WXMPOPChooseTypeSingle,
    WXMPOPChooseTypeDouble,
};

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *reservedLabel;
@property (nonatomic, strong) UITextView *messageTextView;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic, strong) CALayer *titleLine;
@property (nonatomic, strong) CALayer *buttonHorizontalLine;
@property (nonatomic, strong) CALayer *buttonVerticalLine;
@property (nonatomic, strong) CALayer *reservedLine;

@property (nonatomic, assign) WXMPOPChooseType chooseType;
@property (nonatomic, assign) WXMPOPViewAnimationType popupAnimationType;
@property (nonatomic, assign) WXMPOPViewPriorityType priorityType;
@property (nonatomic, assign) BOOL touchBlackHiden;
@property (nonatomic, assign) BOOL touchButtonHiden;
@property (nonatomic, weak) WXMPOPViewAnimationObject *animationObject;
@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic, copy) void (^callback)(NSInteger index);
@property (nonatomic, copy) void (^callbackTitle)(NSString *ident);
@property (nonatomic, assign) id<WXMPOPBaseCallbackProtocol> delegate;

/** 默认样式 */
- (void)defaultInterfaceView;

/** 布局 */
- (void)setupAutomaticLayout;

/** 显示弹窗 */
- (void)showpopupView;

/** 隐藏弹窗 */
- (void)hidepopupView;

/** 固定高度 */
- (CGFloat)minImmobilizationHeight;

/** 总高度 */
- (CGFloat)totalOneselfHeight;

@end
