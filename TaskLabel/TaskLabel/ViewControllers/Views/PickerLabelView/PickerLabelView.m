//
//  PickerLabelView.m
//  TaskLabel
//
//  Created by new on 30.06.17.
//  Copyright © 2017 Home. All rights reserved//
//

#import "PickerLabelView.h"

@implementation PickerLabelView

- (id)initWithParentView:(UIView *)view {
    self = [super initWithFrame:view.bounds];
    if (self) {
        [self initialConfigWith:view];
    }
    return self;
}

- (void)initialConfigWith:(UIView *)view {
    self.layer.cornerRadius = 5.0;
    self.characterViews = [NSMutableArray array];
    self.characterView = [[UIView alloc] initWithFrame:view.bounds];
    self.characterView.clipsToBounds = YES;
    self.characterView.backgroundColor = [UIColor clearColor];
    [self addSubview: self.characterView];
    
    self.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:30];
    self.textColor = [UIColor whiteColor];
    self.animationDuration = 1.0;
}

- (void)setTextColor:(UIColor *)textColor
{
    if (![_textColor isEqual: textColor])
    {
        _textColor = textColor;
        [self.characterViews enumerateObjectsUsingBlock:
         ^(UILabel *label, NSUInteger idx, BOOL *stop)
         {
             label.textColor = textColor;
         }];
    }
}

- (void)setFont:(UIFont *)font
{
    if (![_font isEqual: font])
    {
        _font = font;
        self.characterWidth = [@"8" sizeWithAttributes:@{NSFontAttributeName: font}].width;
        
        [self.characterViews enumerateObjectsUsingBlock:
         ^(UILabel *label, NSUInteger idx, BOOL *stop)
         {
             label.font = self.font;
         }];
    }
}

- (void)startCountingToValue:(NSString *)maxValue {
    self.maxValue = maxValue;
    for (UIView *view in self.characterView.subviews) {
        [view removeFromSuperview];
    }
    [self.characterViews removeAllObjects];
    _text = @"";
    
    NSString *string = @"";
    NSInteger oldTextLength = [_text length];
    NSInteger newTextLength = [_maxValue length];
    
    
    if (newTextLength > oldTextLength)
    {
        NSInteger textLengthDelta = newTextLength - oldTextLength;
        for (NSInteger i = 0 ; i < textLengthDelta; ++i)
        {
            [self insertNewCharacterLabel];
            if (i == textLengthDelta - 1) {
                string = [string stringByAppendingString:@"1"];
            } else {
                string = [string stringByAppendingString:@"0"];
            }
        }
        [self layoutCharacterLabels];
        self.characterView.frame = [self characterViewFrameWithContentBounds:self.bounds];
        
        [self changeText:string];
    }
}

- (void)changeText:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.characterViews enumerateObjectsUsingBlock:
         ^(UILabel *label, NSUInteger idx, BOOL *stop)
         {
             NSString *character = [text substringWithRange:NSMakeRange(idx, 1)];
             NSString *oldCharacter = label.text;
             label.text = character;
             
             if (![oldCharacter isEqualToString:character]) {
                 [self addLabelAnimation:label];
             }
             _text = text;
         }];
    });
    
}

#pragma mark - Character Animation

- (CATransition *)addLabelAnimation:(UILabel *)label {
    CATransition *transition = [CATransition animation];
    
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.duration = 0.05;
    transition.type = kCATransitionPush;
    transition.delegate = self;
    
    transition.subtype = kCATransitionFromTop;
    [label.layer addAnimation:transition forKey:nil];
    
    return transition;
}

#pragma mark - Character Labels

- (void)insertNewCharacterLabel
{
    CGRect characterFrame = CGRectZero;
    
    characterFrame.size = CGSizeMake(self.characterWidth, 10);
    characterFrame.origin = CGPointMake(self.characterView.frame.size.width/2, 0);
    UILabel *characterLabel = [[UILabel alloc] initWithFrame: characterFrame];
    characterLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
    characterLabel.textAlignment = NSTextAlignmentCenter;
    characterLabel.textColor = [UIColor whiteColor];
    characterLabel.font = self.font;
    characterLabel.text = @"0";
    characterLabel.textColor = self.textColor;
    
    [self.characterViews addObject:characterLabel];
    [self.characterView addSubview:characterLabel];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        if (self.text.intValue < self.maxValue.intValue) {
            NSString *text = [NSString stringWithFormat:@"%d", _text.intValue+1];
            for (int i = 0; i < _text.length; i++) {
                NSString * str = [_text substringWithRange:NSMakeRange(i, 1)];
                if ([str isEqualToString:@"0"] && text.length < _text.length) {
                    text = [str stringByAppendingString:text];
                }
            }
            
            [self changeText:text];
        }
    }
}

#pragma mark - Layouting

- (CGRect)characterViewFrameWithContentBounds:(CGRect)frame
{
    CGFloat charactersWidth = [self.characterViews count] * self.characterWidth;
    frame.size.width = charactersWidth;
    frame.origin.x = (self.frame.size.width - charactersWidth) / 2;
    
    return frame;
}

- (void)layoutCharacterLabels
{
    CGRect characterFrame = CGRectZero;
    for (UILabel* label in self.characterViews)
    {
        characterFrame.size.height = CGRectGetHeight(self.characterView.bounds);
        characterFrame.size.width = self.characterWidth;
        label.frame = characterFrame;
        
        characterFrame.origin.x += self.characterWidth;
    }
}

@end
