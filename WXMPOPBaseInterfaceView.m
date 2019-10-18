//
//  WXMPOPBaseView.m
//  Multi-project-coordination
//
//  Created by wq on 2019/6/22.
//  Copyright © 2019年 wxm. All rights reserved.
#import "WXMPOPBaseInterfaceView.h"

/**  颜色(0xFFFFFF) 不用带 0x 和 @"" */
#define WXMCOLOR_WITH_HEX(hexValue) \
[UIColor colorWith\
Red:((float)((0x##hexValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((0x##hexValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(0x##hexValue & 0xFF)) / 255.0 alpha:1.0f]

static inline UIImage *COLORTOIMAGE(UIColor *color) {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@implementation WXMPOPBaseInterfaceView

- (UIViewController *)wp_displayViewController {
    return self.viewController;
}

- (void)wp_showpopupView {
    [self.animationObject animationShowpopupView];
}

- (void)wp_hidepopupView {
    [self.animationObject animationHidepopupView];
}

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

- (WXMPOPViewAnimationObject *)animationObject {
    if (!_animationObject) {
        _animationObject = [WXMPOPViewAnimationObject popupHelpWithContentView:self];
    }
    return _animationObject;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = WXMPOPTitleColor;
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = WXMPOPTitleFont;
    }
    return _titleLabel;
}

- (UITextView *)messageTextView {
    if (!_messageTextView) {
        _messageTextView = [[UITextView alloc] init];
        _messageTextView.textAlignment = NSTextAlignmentLeft;
        _messageTextView.font = [UIFont systemFontOfSize:WXMPOPMessageFont];
        _messageTextView.textColor = WXMPOPMessageColor;
        _messageTextView.selectable = NO;
        _messageTextView.scrollEnabled = NO;
    }
    return _messageTextView;
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

- (UIButton *)cancleButton {
    if (!_cancleButton) {
        UIControlEvents event = UIControlEventTouchUpInside;
        UIImage *highlight = COLORTOIMAGE(WXMCOLOR_WITH_HEX(EBEBEB));
        _cancleButton = [[UIButton alloc] init];
        _cancleButton.titleLabel.font = [UIFont systemFontOfSize:WXMPOPButtonFont];
        [_cancleButton setTitleColor:WXMPOPButtonColor forState:UIControlStateNormal];
        [_cancleButton addTarget:self action:@selector(touchEvent:) forControlEvents:event];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleButton setBackgroundImage:highlight forState:UIControlStateHighlighted];
    }
    return _cancleButton;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        UIControlEvents event = UIControlEventTouchUpInside;
        UIImage *highlight = COLORTOIMAGE(WXMCOLOR_WITH_HEX(EBEBEB));
        _sureButton = [[UIButton alloc] init];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:WXMPOPButtonFont];
        [_sureButton setTitleColor:WXMPOPButtonColor forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(touchEvent:) forControlEvents:event];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setBackgroundImage:highlight forState:UIControlStateHighlighted];
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

