//
//  ColorPickerView.h
//  CollorPicker
//
//  Created by new on 02.07.17.
//  Copyright © 2017 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ColorPickerViewDelegate;



@interface ColorPickerView : UIView
{
    UIImageView *colorPickerImgView;
}

@property (weak, nonatomic) id <ColorPickerViewDelegate> delegate;


@end

@protocol ColorPickerViewDelegate <NSObject>

- (void)pickerView:(ColorPickerView *)picker colorDidChange:(UIColor *)color;
- (void)pickerViewChangeEnded:(ColorPickerView *)picker;

@end
