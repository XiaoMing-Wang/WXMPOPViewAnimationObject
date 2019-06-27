//
//  WXMPOPBaseView.m
//  Multi-project-coordination
//
//  Created by wq on 2019/6/22.
//  Copyright © 2019年 wxm. All rights reserved.
//

#import "WXMPOPBaseInterfaceView.h"
@interface WXMPOPBaseInterfaceView ()
@property (nonatomic, strong) UIView *popButtonView;
@end
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

- (instancetype)init {
    if (self = [super init]) [self defaultInterfaceView];
    return self;
}

- (void)setChooseType:(WXMPOPChooseType)chooseType {
    _chooseType = chooseType;
    if (chooseType == WXMPOPChooseTypeNone) {
        if (_popButtonView) [_popButtonView removeFromSuperview];
        
    } else if (chooseType == WXMPOPChooseTypeSingle) {
        
        [self addSubview:self.popButtonView];
        [self.popButtonView addSubview:self.cancleButton];
        if (_sureButton) [_sureButton removeFromSuperview];
        if (_buttonVerticalLine) [_buttonVerticalLine removeFromSuperlayer];
        
    } else if (chooseType == WXMPOPChooseTypeDouble) {
        
        [self addSubview:self.popButtonView];
        [self.popButtonView addSubview:self.sureButton];
        [self.popButtonView addSubview:self.cancleButton];
    }
}

/** 默认样式 */
- (void)defaultInterfaceView {
    
}

/** 布局 */
- (void)setupAutomaticLayout {
    [_titleLabel sizeToFit];
    
    CGFloat contentEdge = (_contentEdge == 0 ?  WXMPOPContentEdge : _contentEdge);
    CGFloat centerX = self.frame.size.width / 2;
    CGFloat buttonHeight = self.cancleButton.frame.size.height;
    CGFloat buttonTop = self.totalOneselfHeight - buttonHeight;
    
    _titleLabel.frame = (CGRect){CGPointMake(0, contentEdge), _titleLabel.frame.size};
    _titleLabel.center = CGPointMake(centerX, _titleLabel.center.y);
    
    if (_chooseType == WXMPOPChooseTypeSingle) {
        _cancleButton.frame = CGRectMake(0, 0, centerX * 2, buttonHeight);
    } else if (_chooseType == WXMPOPChooseTypeDouble) {
        _cancleButton.frame = CGRectMake(0, 0, centerX, buttonHeight);
        _sureButton.frame = CGRectMake(centerX, 0, centerX, buttonHeight);
    }
    
    self.popButtonView.frame = CGRectMake(0, buttonTop, self.frame.size.width, buttonHeight);
    self.buttonHorizontalLine.frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
    self.buttonVerticalLine.frame = CGRectMake(centerX, 0, 0.5, buttonHeight);
}

/** 固定高度 除去messageTextView */
- (CGFloat)minImmobilizationHeight {
    CGFloat titleHeight = 0;
    CGFloat allEdge = 0;
    
    if (_titleLabel.text.length > 0) {
        titleHeight = _titleLabel.frame.size.height;
        allEdge = (_contentEdge == 0 ?  WXMPOPContentEdge : _contentEdge) * 2;
    } else {
        allEdge = (_messageEdge == 0 ?  WXMPOPContentEdge : _messageEdge) * 2;
    }
    return titleHeight + allEdge + WXMPOPButtonHeight;
}

/** 总高度 */
- (CGFloat)totalOneselfHeight {
    return self.frame.size.height;
}

- (void)didMoveToSuperview {
    if (self.superview) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setupAutomaticLayout];
        });
    }
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

- (void)setYWithView:(UIView *)targetView absoluteY:(CGFloat)absoluteY {
    CGRect frame = targetView.frame;
    frame.origin.y = absoluteY;
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
        _messageTextView.textColor = WXMPOPMessageColor;
    }
    return _messageTextView;
}

- (UITextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.textColor = WXMPOPTitleColor;
        _inputTextField.font = [UIFont systemFontOfSize:WXMPOPMessageFont];
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
        _buttonHorizontalLine.backgroundColor = WXMPOPLineColor.CGColor;
    }
    return _buttonHorizontalLine;
}

- (CALayer *)buttonVerticalLine {
    if (!_buttonVerticalLine) {
        _buttonVerticalLine = [[CALayer alloc] init];
        _buttonVerticalLine.backgroundColor = WXMPOPLineColor.CGColor;
    }
    return _buttonVerticalLine;
}

- (CALayer *)reservedLine {
    if (!_reservedLine) {
        _reservedLine = [[CALayer alloc] init];
        _reservedLine.backgroundColor = WXMPOPLineColor.CGColor;
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
        _cancleButton.titleLabel.font = [UIFont systemFontOfSize:WXMPOPButtonFont];
        [_cancleButton setTitleColor:WXMPOPButtonColor forState:UIControlStateNormal];
        [_cancleButton addTarget:self action:@selector(touchEvent:) forControlEvents:event];
    }
    return _cancleButton;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        UIControlEvents event = UIControlEventTouchUpInside;
        _sureButton = [[UIButton alloc] init];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:WXMPOPButtonFont];
        [_sureButton setTitleColor:WXMPOPButtonColor forState:UIControlStateNormal];
        [_cancleButton addTarget:self action:@selector(touchEvent:) forControlEvents:event];
    }
    return _sureButton;
}

- (UIView *)popButtonView {
    if (!_popButtonView) {
        _popButtonView = [[UIView alloc] init];
        _popButtonView.frame = CGRectMake(0, 0, self.frame.size.width, WXMPOPButtonHeight);
        _popButtonView.backgroundColor = [UIColor clearColor];
        [_popButtonView.layer addSublayer:self.buttonVerticalLine];
        [_popButtonView.layer addSublayer:self.buttonHorizontalLine];
    }
    return _popButtonView;
}
@end

