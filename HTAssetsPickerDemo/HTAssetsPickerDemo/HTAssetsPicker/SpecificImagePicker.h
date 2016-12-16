//
//  SpecificImagePicker.h
//  JWAssetsPicker
//
//  Created by jw-mbp on 9/21/15.
//  Copyright (c) 2015 jw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTAsset;

@protocol SpecificImagePickerDelegate;
@class HTAssetsPickerView;


typedef NS_ENUM(NSInteger, SpecificImagePickerType)
{
    SpecificImagePickerTypeOrder = 1,
    SpecificImagePickerTypeUnorder
};


/**
 *  包装了带有确定和取消按钮的图片选择器
 */
@interface SpecificImagePicker : UIViewController


@property (nonatomic,weak) id<SpecificImagePickerDelegate> delegate;
@property (nonatomic,strong) HTAssetsPickerView* assetsPicker;
- (instancetype)initWithType:(SpecificImagePickerType)type;

@end

@protocol SpecificImagePickerDelegate <NSObject>

- (void)assetsPicker:(SpecificImagePicker*)assetsPicker didFinishPickingWithAssets:(NSArray<HTAsset*>*)assets;
- (void)assetsPickerDidCancelPicking:(SpecificImagePicker*)assetsPicker;
@end