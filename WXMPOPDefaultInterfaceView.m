//
//  WXMPOPDefault InterfaceView.m
//  ModuleDebugging
//
//  Created by edz on 2019/10/17.
//  Copyright © 2019 wq. All rights reserved.
//

#import "WXMPOPDefaultInterfaceView.h"

@implementation WXMPOPDefaultInterfaceView
@synthesize chooseType = _chooseType;

/** 设置标题 */
- (void)setPopsTitle:(NSString *)popsTitle {
    _popsTitle = popsTitle;
    self.titleLabel.text = popsTitle;
    [self addSubview:self.titleLabel];
    [self setupAutomaticLayout];
}

- (void)setPopsMessage:(NSString *)popsMessage {
    _popsMessage = popsMessage;
    self.messageTextView.text = popsMessage;
    [self addSubview:self.messageTextView];
    [self setupAutomaticLayout];
}

- (void)setupAutomaticLayoutMessage {
    [self.messageTextView sizeToFit];
    CGFloat bottom = self.messageTextView.frame.origin.y + self.messageTextView.frame.size.height;
    CGFloat messageEdge = (self.messageEdge == 0) ? WXMPOPMessageEdge : (self.messageEdge - 10);
    CGFloat allHeight = bottom + WXMPOPButtonHeight + messageEdge + 2.5;
    self.frame = CGRectMake(0, 0, WXMPOPWidth, allHeight);
    [self setupAutomaticLayout];
}

/** 固定高度 除去messageTextView */
- (CGFloat)minImmobilizationHeight {
    CGFloat titleHeight = 0;
    CGFloat buttonHeight = (self.chooseType == WXMPOPChooseTypeNone) ? 0 : WXMPOPButtonHeight;
    CGFloat allEdge = 0;
    
    if (self.titleLabel.text.length > 0) {
        [self.titleLabel sizeToFit];
        titleHeight = self.titleLabel.frame.size.height;
        allEdge = (self.contentEdge == 0 ? WXMPOPContentEdge : self.contentEdge) * 1;
    } else {
        allEdge = (self.messageEdge == 0 ? WXMPOPContentEdge : self.messageEdge) * 1;
    }
    return titleHeight + allEdge + buttonHeight;
}

/** 总高度 */
- (CGFloat)totalOneselfHeight {
    return self.frame.size.height;
}

/** 布局 */
- (void)setupAutomaticLayout {
    [self.titleLabel sizeToFit];
    [self.messageTextView sizeToFit];
    
    CGFloat contentEdge = (self.contentEdge == 0 ? WXMPOPContentEdge : self.contentEdge);
    self.titleLabel.frame = (CGRect){CGPointMake(0, contentEdge), self.titleLabel.frame.size};
    self.titleLabel.center = CGPointMake(self.frame.size.width / 2, self.titleLabel.center.y);
    
    CGFloat titleBottom = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height;
    if (self.popsTitle.length == 0) titleBottom = 0;
    CGFloat messageTop = titleBottom + (self.messageEdge == 0 ? WXMPOPMessageEdge : self.messageEdge);
    CGFloat messageWidth = (self.frame.size.width ?: WXMPOPWidth) - 2 * WXMPOPMessageLREdge;
    
    CGFloat messageHeight = self.messageTextView.frame.size.height;
    self.messageTextView.frame = (CGRect){0, messageTop, messageWidth, messageHeight};
    self.messageTextView.center = CGPointMake(self.frame.size.width / 2, self.messageTextView.center.y);
    
    if (!self.backgroundColor) self.backgroundColor = [UIColor whiteColor];
    [self setDefaultOptions];
}

- (void)setChooseType:(WXMPOPChooseType)chooseType {
    _chooseType = chooseType;
    if (chooseType == WXMPOPChooseTypeNone) {
        
        [self.popButtonView removeFromSuperview];
        [self.buttonVerticalLine removeFromSuperlayer];
        [self.buttonHorizontalLine removeFromSuperlayer];
        
    } else if (chooseType == WXMPOPChooseTypeSingle || chooseType == WXMPOPChooseTypeSingleSure) {
        
        [self addSubview:self.popButtonView];
        if (chooseType == WXMPOPChooseTypeSingle) {
            [self.popButtonView addSubview:self.cancleButton];
            [self.sureButton removeFromSuperview];
        } else {
            [self.popButtonView addSubview:self.sureButton];
            [self.cancleButton removeFromSuperview];
        }
                
        [self.popButtonView.layer addSublayer:self.buttonHorizontalLine];
        [self.buttonVerticalLine removeFromSuperlayer];
        
    } else if (chooseType == WXMPOPChooseTypeDouble) {
        
        [self addSubview:self.popButtonView];
        [self.popButtonView addSubview:self.sureButton];
        [self.popButtonView addSubview:self.cancleButton];
        
        [self.popButtonView.layer addSublayer:self.buttonHorizontalLine];
        [self.popButtonView.layer addSublayer:self.buttonVerticalLine];
    }
    
    [self setDefaultOptions];
}

/** 设置点击按钮frame */
- (void)setDefaultOptions {
    CGFloat centerX = self.frame.size.width / 2;
    CGFloat buttonHeight = self.cancleButton.frame.size.height ?: WXMPOPButtonHeight;
    CGFloat buttonTop = self.totalOneselfHeight - buttonHeight;

    if (self.chooseType == WXMPOPChooseTypeSingle || self.chooseType == WXMPOPChooseTypeSingleSure) {
        self.sureButton.frame = CGRectMake(0, 0, self.frame.size.width, buttonHeight);
        self.cancleButton.frame = CGRectMake(0, 0, self.frame.size.width, buttonHeight);

    } else if (self.chooseType == WXMPOPChooseTypeDouble) {
        self.cancleButton.frame = CGRectMake(0, 0, centerX, buttonHeight);
        self.sureButton.frame = CGRectMake(centerX, 0, centerX, buttonHeight);
    }

    self.popButtonView.frame = CGRectMake(0, buttonTop, self.frame.size.width, buttonHeight);
    self.buttonHorizontalLine.frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
    self.buttonVerticalLine.frame = CGRectMake(centerX, 0, 0.5, buttonHeight);
}

/** 设置按钮选项 */
- (instancetype)init {
    if (self = [super init]) [self setupCustomSettings];
    return self;
}

- (void)setupCustomSettings {
    
}

@end
