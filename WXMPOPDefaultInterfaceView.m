//
//  WXMPOPDefault InterfaceView.m
//  ModuleDebugging
//
//  Created by edz on 2019/10/17.
//  Copyright © 2019 wq. All rights reserved.
//

#import "WXMPOPDefaultInterfaceView.h"

@interface WXMPOPDefaultInterfaceView ()
@property (nonatomic, assign) BOOL automaticHeight;
@end

@implementation WXMPOPDefaultInterfaceView
@synthesize chooseType = _chooseType;

/** 设置按钮选项 */
- (instancetype)init {
    if (self = [super init]) {
        
        [self initializationInterface];
        
        self.frame = CGRectMake(0, 0, WXMPOPWidth, 0);
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        self.touchBlackHiden = YES;
        self.touchButtonHiden = YES;
        self.priorityType = WXMPOPViewPriorityTypeWait;
        self.popupAnimationType = WXMPOPViewAnimationDefault;
    }
    return self;
}

- (void)initializationInterface { }

/** 设置模式 */
- (void)setPopupAnimationType:(WXMPOPViewAnimationType)popupAnimationType {
    [super setPopupAnimationType:popupAnimationType];
    [self setupAutomaticLayout];
    if (popupAnimationType == WXMPOPViewAnimationDefault) {
        
        self.layer.cornerRadius = self.roundedCorners ?: WXMPOPRoundedCorners;
        self.chooseType = WXMPOPChooseTypeDouble;
        
    } else if (popupAnimationType == WXMPOPViewAnimationBottomSlide) {
        
        self.layer.cornerRadius = self.roundedCorners ?: 0;
        self.chooseType = WXMPOPChooseTypeSingle;
    }
}

/** 设置标题 */
- (void)setPopsTitle:(NSString *)popsTitle {
    _popsTitle = popsTitle;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 1.25f;
    NSDictionary *attributes = @{
        NSFontAttributeName:self.titleLabel.font,
        NSForegroundColorAttributeName:self.titleLabel.textColor,
        NSParagraphStyleAttributeName:paragraphStyle
    };
    
    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:popsTitle attributes:attributes];
    [self addSubview:self.titleLabel];
    [self setupAutomaticLayout];
}

/** 设置信息 */
- (void)setPopsMessage:(NSString *)popsMessage {
    _popsMessage = popsMessage;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.lineSpacing = 1.0f;
    NSDictionary *attributes = @{
        NSFontAttributeName:self.messageTextView.font,
        NSForegroundColorAttributeName:self.messageTextView.textColor,
        NSParagraphStyleAttributeName:paragraphStyle
    };
    
    self.messageTextView.attributedText = [[NSAttributedString alloc] initWithString:popsMessage attributes:attributes];
    [self addSubview:self.messageTextView];
    [self setupAutomaticLayout];
}

/** 布局(设置title和message) */
- (void)setupAutomaticLayout {
    if (!self.popsTitle && !self.popsMessage) return;
    
    CGFloat maxWidth = self.automaticHeight ? self.totalWidth : self.frame.size.width;
    CGFloat maxTitleW = maxWidth - 2 * WXMPOPContentLREdge * 1.0;
    CGFloat sizeTitleMaxH = [self.titleLabel sizeThatFits:CGSizeMake(maxTitleW, MAXFLOAT)].height;
    CGFloat sizeTitleLimitH = [self.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
  
    /** 标题上下间隔 */
    /** 标题上下间隔 */
    /** 标题上下间隔 */
    CGFloat contentEdge = (self.contentEdge == 0 ? WXMPOPContentEdge : self.contentEdge);
    self.titleLabel.frame = CGRectMake(0, contentEdge, maxTitleW, sizeTitleMaxH);
    self.titleLabel.center = CGPointMake(maxWidth / 2, self.titleLabel.center.y);
    if (sizeTitleMaxH == sizeTitleLimitH) self.titleLabel.numberOfLines = 1;
    if (sizeTitleMaxH > sizeTitleLimitH) self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    /** 内容上下间隔 */
    /** 内容上下间隔 */
    /** 内容上下间隔 */
    CGFloat titleBottom = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height;
    if (self.popsTitle.length == 0) titleBottom = 0;
    CGFloat messageTop = titleBottom + (self.messageEdge == 0 ? WXMPOPMessageEdge : self.messageEdge);
    CGFloat messageWidth = maxWidth - 2 * WXMPOPMessageLREdge;
    
    CGFloat sizeMaxHeight = [self.messageTextView sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
    CGFloat sizeLimitHeight = [self.messageTextView sizeThatFits:CGSizeMake(messageWidth, MAXFLOAT)].height;
    
    if (self.popsMessage.length == 0) sizeLimitHeight = 0;
    self.messageTextView.frame = (CGRect) {0, messageTop, messageWidth, sizeLimitHeight};
    self.messageTextView.center = CGPointMake(maxWidth / 2, self.messageTextView.center.y);
    if (sizeMaxHeight == sizeLimitHeight) self.messageTextView.textAlignment = NSTextAlignmentCenter;
    if (sizeLimitHeight > sizeMaxHeight) self.messageTextView.textAlignment = NSTextAlignmentLeft;
    
    [self setupCheckHeight];
    [self setDefaultOptions];
}

/** 布局(校验有没有设置高度, 没有的话自适应) */
- (void)setupCheckHeight {
    if (self.automaticHeight == NO) return;
    CGFloat buttonHeight = self.cancleButton.frame.size.height ?: WXMPOPButtonHeight;
    CGFloat safeHeight = ((WXMPOPIPhoneX && self.popupAnimationType == WXMPOPViewAnimationBottomSlide) ? 30 : 0);
       
    if (self.popsMessage.length > 0) {
        
        CGFloat bottom = self.messageTextView.frame.origin.y + self.messageTextView.frame.size.height;
        CGFloat messageEdge = (self.messageEdge == 0) ? WXMPOPMessageEdge : (self.messageEdge);
        CGFloat allHeight = bottom + buttonHeight + messageEdge + 2.5 + safeHeight;
        self.frame = CGRectMake(0, 0, self.totalWidth, allHeight);
        self.automaticHeight = YES;
        
    } else if (self.popsTitle.length > 0) {
        
        CGFloat bottom = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height;
        CGFloat contentEdge = (self.contentEdge == 0) ? WXMPOPMessageEdge : (self.contentEdge);
        CGFloat allHeight = bottom + buttonHeight + contentEdge + contentEdge + 2.5 + safeHeight;
        self.frame = CGRectMake(0, 0, self.totalWidth, allHeight);
        self.automaticHeight = YES;
    }
}

/** 展示(设置按钮显示类) */
- (void)setChooseType:(WXMPOPChooseType)chooseType {
    _chooseType = chooseType;
    if (chooseType == WXMPOPChooseTypeNone) {
        
        [self.popButtonView removeFromSuperview];
        [self.buttonVerticalLine removeFromSuperlayer];
        [self.buttonHorizontalLine removeFromSuperlayer];
        
    } else if (chooseType == WXMPOPChooseTypeSingle || chooseType == WXMPOPChooseTypeSingleSure) {
        
        if (chooseType == WXMPOPChooseTypeSingle) {
            
            [self.popButtonView addSubview:self.cancleButton];
            [self.sureButton removeFromSuperview];
            
        } else {
            
            [self.popButtonView addSubview:self.sureButton];
            [self.cancleButton removeFromSuperview];
        }
              
        [self addSubview:self.popButtonView];
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

/** 布局(设置按钮frame) */
- (void)setDefaultOptions {
    CGFloat maxWidth = self.frame.size.width;
    CGFloat centerX = maxWidth / 2;
    CGFloat buttonHeight = self.cancleButton.frame.size.height ?: WXMPOPButtonHeight;
    CGFloat safeHeight = ((WXMPOPIPhoneX && self.popupAnimationType == WXMPOPViewAnimationBottomSlide) ? 30 : 0);
    CGFloat buttonTop = self.totalHeight - buttonHeight - safeHeight;

    if (self.chooseType == WXMPOPChooseTypeSingle || self.chooseType == WXMPOPChooseTypeSingleSure) {
        
        self.sureButton.frame = CGRectMake(0, 0, maxWidth, buttonHeight);
        self.cancleButton.frame = CGRectMake(0, 0, maxWidth, buttonHeight);

    } else if (self.chooseType == WXMPOPChooseTypeDouble) {
        
        self.cancleButton.frame = CGRectMake(0, 0, centerX, buttonHeight);
        self.sureButton.frame = CGRectMake(centerX, 0, centerX, buttonHeight);
    }

    self.popButtonView.frame = CGRectMake(0, buttonTop, maxWidth, buttonHeight);
    self.buttonHorizontalLine.frame = CGRectMake(0, 0, maxWidth, 0.5);
    self.buttonVerticalLine.frame = CGRectMake(centerX, 0, 0.5, buttonHeight);
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.automaticHeight = (frame.size.height == 0);
}

/** 总高度 */
- (CGFloat)totalHeight {
    return self.frame.size.height;
}

/** 总宽度 */
- (CGFloat)totalWidth {
    return (self.popupAnimationType == WXMPOPViewAnimationBottomSlide) ?
    [UIScreen mainScreen].bounds.size.width :
    WXMPOPWidth;
}

@end
