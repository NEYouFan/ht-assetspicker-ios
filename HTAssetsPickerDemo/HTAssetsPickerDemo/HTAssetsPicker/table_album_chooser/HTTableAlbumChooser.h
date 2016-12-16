//
//  HTTableAlbumChooser.h
//  JWAssetsPicker
//
//  Created by jw-mbp on 9/21/15.
//  Copyright (c) 2015 jw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "HTAssetsHelper.h"

@protocol HTTableAlbumChooserDelegate;


/**
 *  以tableview展示的相册选择器
 */
@interface HTTableAlbumChooser : UITableViewController

/**
 *  外部可读的资源组们
 */
@property (nonatomic,strong) NSArray* assetsGroups;

/**
 *  所要选择资源类型，支持图片、视频、all，默认HTAssetsPickerAssetTypeAll
 */
//@property (nonatomic, assign) HTAssetsType assetsType;


/**
 *  代理
 */
@property (nonatomic,weak) id<HTTableAlbumChooserDelegate> delegate;

@end


@protocol HTTableAlbumChooserDelegate <NSObject>

- (void)tableAlbumChooser:(HTTableAlbumChooser*)tableAlbumChooser didSelectAssetGroup:(ALAssetsGroup*)group;

@end