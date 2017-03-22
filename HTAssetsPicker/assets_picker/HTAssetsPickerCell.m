//
//  HTAssetPickerCell.m
//  JWAssetsPicker
//
//  Created by jw-mbp on 9/17/15.
//  Copyright (c) 2015 jw. All rights reserved.
//

#import "HTAssetsPickerCell.h"
#import "HTAssetPickerCache.h"
#import "HTCameraAssetItem.h"

@interface HTAssetsPickerCell ()
@property (nonatomic,assign) NSInteger requestID;
@end

@implementation HTAssetsPickerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _contentImageView = [[UIImageView alloc]init];
        [_contentImageView setContentMode:UIViewContentModeScaleAspectFill];
        _contentImageView.clipsToBounds = YES;
        [self.contentView addSubview:_contentImageView];
        _requestID = -1;
    }
    return self;
}

- (void)selectedWithIndex:(NSInteger)index
{
    NSAssert(NO, @"should be implemented by subclass.");
}

- (void)deselected
{
    NSAssert(NO, @"should be implemented by subclass.");
}

- (void)reset
{
    _contentImageView.image = nil;
    _requestID= -1;
}

- (void)onInteracted:(HTAssetPickerCellInteactType)interactType
{
    //should be override by subclass
}

- (void)setAssetItem:(HTAssetItem *)assetItem{
    _assetItem = assetItem;
    [self reset];
    if (!assetItem) {
        return;
    }
    
    if ([assetItem isKindOfClass:[HTCameraAssetItem class]]) {
        //cameraAsset 无需缓存
        _requestID = [assetItem itemImageWithCompletion:^(UIImage *image, NSDictionary *info) {
            if (image) {
                if (_requestID != -1 && info && _requestID != [[info valueForKey:PHImageResultRequestIDKey] integerValue]) {
                    return;
                }
                _contentImageView.image = image;
            }
        }];
    } else {
        //imageAsset 缓存
        if (![[HTAssetPickerCache shareAssetPickerCache] objectForKey:assetItem.asset.localIdentifier]) {
            _requestID = [assetItem itemImageWithCompletion:^(UIImage *image, NSDictionary *info) {
                if (image) {
                    
                    if (_requestID != -1 && info && _requestID != [[info valueForKey:PHImageResultRequestIDKey] integerValue]) {
                        return;
                    }
                    _contentImageView.image = image;
                    BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                    if (downloadFinined) {
                        [[HTAssetPickerCache shareAssetPickerCache] setObject:image forKey: assetItem.asset.localIdentifier];
                    }
                }
            }];
        } else {
            _contentImageView.image = [[HTAssetPickerCache shareAssetPickerCache] objectForKey:assetItem.asset.localIdentifier];
        }
    }
    if (assetItem.isSelected) {
        [self selectedWithIndex:assetItem.index];
    }else{
        [self deselected];
    }
}

- (BOOL)trySelect
{
    BOOL shouldSelect = YES;
    if ([_delegate respondsToSelector:@selector(shouldSelectAssetsPickerCell:)]) {
        shouldSelect = [_delegate shouldSelectAssetsPickerCell:self];
    }
    if (shouldSelect) {
        [_assetItem setSelected:YES];
        //由于此时还不知道index，传给代理，有代理来调用selectedWithIndex
        if ([_delegate respondsToSelector:@selector(didSelectAssetsPickerCell:)]) {
            [_delegate didSelectAssetsPickerCell:self];
        }
    }
    return shouldSelect;
}

-(BOOL)tryDeselect
{
    BOOL shouldDeselect = YES;
    if ([_delegate respondsToSelector:@selector(shouldDeselectAssetsPickerCell:)]) {
        shouldDeselect = [_delegate shouldDeselectAssetsPickerCell:self];
    }
    if (shouldDeselect) {
        [_assetItem setSelected:NO];
        [self deselected];
        if ([_delegate respondsToSelector:@selector(didDeselectAssetsPickerCell:)]) {
            [_delegate didDeselectAssetsPickerCell:self];
        }
    }
    return shouldDeselect;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _contentImageView.frame = self.bounds;
}
@end
