//
//  WXMPOPBaseView.m
//  Multi-project-coordination
//
//  Created by wq on 2019/6/22.
//  Copyright © 2019年 wxm. All rights reserved.
//

#import "WXMPOPBaseInterfaceView.h"

@implementation WXMPOPBaseInterfaceView

#pragma mark WXMPOPViewAnimationProtocol

- (void)showpopupView {
    self.animationObject = [WXMPOPViewAnimationObject popupHelpWithContentView:self];
    self.animationObject.touchBlackHiden = self.touchBlackHiden;
    self.animationObject.popupAnimationType = self.popupAnimationType;
    self.animationObject.viewController = self.displayViewController;
    self.animationObject.priorityType = self.priorityType;
    [self.animationObject animationShowpopupView];
}

- (void)hidepopupView {
    [self.animationObject animationHidepopupView];
}

- (UIViewController *)displayViewController {
    return self.viewController;
}

- (void)setChooseType:(WXMPOPChooseType)chooseType {
    _chooseType = chooseType;
    if (chooseType == WXMPOPChooseTypeNone) {
        
        if (_sureButton) [_sureButton removeFromSuperview];
        if (_cancleButton) [_cancleButton removeFromSuperview];
        if (_buttonHorizontalLine) [_buttonHorizontalLine removeFromSuperlayer];
        if (_buttonVerticalLine) [_buttonVerticalLine removeFromSuperlayer];
        
    } else if (chooseType == WXMPOPChooseTypeSingle) {
        
        [self addSubview:self.cancleButton];
        [self.layer addSublayer:self.buttonHorizontalLine];
        if (_sureButton) [_sureButton removeFromSuperview];
        if (_buttonVerticalLine) [_buttonVerticalLine removeFromSuperlayer];
        
    } else if (chooseType == WXMPOPChooseTypeDouble) {
        
        [self addSubview:self.sureButton];
        [self addSubview:self.cancleButton];
        [self.layer addSublayer:self.buttonVerticalLine];
        [self.layer addSublayer:self.buttonHorizontalLine];
    }
}

/** 默认样式 */
- (void)defaultInterfaceView {
    
}

/** 布局 */
- (void)setupAutomaticLayout {
    
}

/** 固定高度 */
- (CGFloat)minImmobilizationHeight {
    CGFloat titleHeight = 0;
    CGFloat allEdge = 0;
    /** CGFloat messageHeight = 0; */
    /** CGFloat buttonHeight = 0; */
   
    if (_titleLabel.text.length > 0) {
        titleHeight = _titleLabel.frame.size.height;
        allEdge = WXMPOPContentEdge * 2;
    }
  
    
    return titleHeight + allEdge + WXMPOPButtonHeight;
}

/** 总高度 */
- (CGFloat)totalOneselfHeight {
    return 0;
}

- (void)didMoveToSuperview {
    if (self.superview) [self setupAutomaticLayout];
}

#pragma mark Action

- (void)touchEvent:(UIButton *)sender {
    if (self.touchButtonHiden) [self.animationObject animationHidepopupView];
    BOOL cancleIndex = (sender == _cancleButton);
    if (self.callback) self.callback(cancleIndex);
    if (self.callbackTitle) self.callbackTitle(sender.titleLabel.text);
    if (self.delegate == nil) return;
    if ([self.delegate respondsToSelector:@selector(popCallbackProtocolWithIndex:)]) {
        [self.delegate popCallbackProtocolWithIndex:cancleIndex];
    }
    if ([self.delegate respondsToSelector:@selector(popCallbackProtocolWithIdentString:)]) {
        [self.delegate popCallbackProtocolWithIdentString:sender.titleLabel.text];
    }
}

/**  */
- (void)setYWithView:(UIView *)targetView y:(CGFloat)y {
    CGRect frame = targetView.frame;
    frame.origin.y = y;
    targetView.frame = frame;
}

#pragma mark GET

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = WXMPOPTitleColor;
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:WXMPOPTitleFont];
    }
    return _titleLabel;
}

- (UILabel *)reservedLabel {
    if (!_reservedLabel) {
        _reservedLabel = [[UILabel alloc] init];
    }
    return _reservedLabel;
}

- (UITextView *)messageTextView {
    if (!_messageTextView) {
        _messageTextView = [[UITextView alloc] init];
        _messageTextView.textAlignment = NSTextAlignmentLeft;
        _messageTextView.font = [UIFont systemFontOfSize:WXMPOPMessageFont];
    }
    return _messageTextView;
}

- (UITextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc] init];
    }
    return _inputTextField;
}

- (CALayer *)titleLine {
    if (!_titleLine) {
        _titleLine = [[CALayer alloc] init];
        _titleLine.backgroundColor = WXMPOPLineColor.CGColor;
    }
    return _titleLine;
}

- (CALayer *)buttonHorizontalLine {
    if (!_buttonHorizontalLine) {
        _buttonHorizontalLine = [[CALayer alloc] init];
    }
    return _buttonHorizontalLine;
}

- (CALayer *)buttonVerticalLine {
    if (!_buttonVerticalLine) {
        _buttonVerticalLine = [[CALayer alloc] init];
    }
    return _buttonVerticalLine;
}

- (CALayer *)reservedLine {
    if (!_reservedLine) {
        _reservedLine = [[CALayer alloc] init];
    }
    return _reservedLine;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
    }
    return _tableView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

- (UIButton *)cancleButton {
    if (!_cancleButton) {
        UIControlEvents event = UIControlEventTouchUpInside;
        _cancleButton = [[UIButton alloc] init];
        [_cancleButton setTitleColor:WXMPOPButtonColor forState:UIControlStateNormal];
        [_cancleButton addTarget:self action:@selector(touchEvent:) forControlEvents:event];
    }
    return _cancleButton;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        UIControlEvents event = UIControlEventTouchUpInside;
        _sureButton = [[UIButton alloc] init];
        [_sureButton setTitleColor:WXMPOPButtonColor forState:UIControlStateNormal];
        [_cancleButton addTarget:self action:@selector(touchEvent:) forControlEvents:event];
    }
    return _sureButton;
}


@end

