//
//  PickerLabelView.h
//  TaskLabel
//
//  Created by new on 30.06.17.
//  Copyright © 2017 Home. All rights reserved//
//

#import <UIKit/UIKit.h>

@interface PickerLabelView : UIView <CAAnimationDelegate>

@property (nonatomic, strong) NSMutableArray <UILabel *> *characterViews;
@property (nonatomic, strong) UIView *characterView;

@property (nonatomic) CGFloat characterWidth;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) IBInspectable UIColor *textColor;

/*
 Default 1.0
 */
@property (nonatomic, assign) IBInspectable CGFloat animationDuration;

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *maxValue;

- (id)initWithParentView:(UIView *)view;
- (void)startCountingToValue:(NSString *)maxValue;

@end
