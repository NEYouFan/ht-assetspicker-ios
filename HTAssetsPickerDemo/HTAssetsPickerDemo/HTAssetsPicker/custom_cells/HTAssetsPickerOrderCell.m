//
//  AssetsPickerItemOrderView.m
//  JWAssetsPicker
//
//  Created by jw-mbp on 9/17/15.
//  Copyright (c) 2015 jw. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "HTAssetsPickerOrderCell.h"

@interface HTAssetsPickerOrderCell ()
{
    UIImageView* _overlapView;
    UILabel* _indexLabel;
}
@end


@implementation HTAssetsPickerOrderCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        self.backgroundColor = color;
        _overlapView = [[UIImageView alloc]init];
        _overlapView.hidden = YES;
        UIImage* image = [UIImage imageNamed:@"overlap_image"];
        _overlapView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 30, 30) resizingMode:UIImageResizingModeStretch];
        [self addSubview:_overlapView];
        
        _indexLabel = [[UILabel alloc]init];
        _indexLabel.font = [UIFont systemFontOfSize:14];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.hidden = YES;
        [self addSubview:_indexLabel];
    }
    return self;
}
- (void)selectedWithIndex:(NSInteger)index
{
    _overlapView.hidden = NO;
    _indexLabel.text = [NSString stringWithFormat:@"%ld",(long)index];
    _indexLabel.hidden = NO;
    
}
- (void)deselected
{
    _overlapView.hidden = YES;
    _indexLabel.hidden = YES;
}


- (void)reset
{
    [super reset];
    _overlapView.hidden = YES;
    _indexLabel.hidden = YES;
}





- (void)onInteracted:(HTAssetPickerCellInteactType)interactType
{
    if (!self.assetItem.selected) {
        if([self trySelect]){
            _indexLabel.alpha = 0;
            [UIView animateWithDuration:0.5 animations:^{
                _indexLabel.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        }
    }else{
        [self tryDeselect];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    _overlapView.frame = self.bounds;
    _indexLabel.frame = CGRectMake(self.bounds.size.width - 16, self.bounds.size.height - 20, 20, 20);
}
@end
