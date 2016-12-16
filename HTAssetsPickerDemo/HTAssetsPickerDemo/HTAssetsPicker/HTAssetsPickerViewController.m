//
//  HTAssetsPickerViewController.m
//  HTUIDemo
//
//  Created by jw-mbp on 9/23/15.
//  Copyright (c) 2015 HT. All rights reserved.
//

#import "HTAssetsPickerViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import "HTAssetsPickerView.h"
#import "HTAssetsPickerOrderCell.h"
#import "HTTableAlbumChooser.h"
#import "SpecificImagePicker.h"
#import <Photos/Photos.h>
#import "HTCustomAlbumChooser.h"
#import "HTAsset.h"
#import <Photos/Photos.h>

@interface HTAssetsPickerViewController ()<SpecificImagePickerDelegate,HTTableAlbumChooserDelegate>

@property (nonatomic, strong) ALAssetsLibrary* library;
@property (nonatomic, strong) HTTableAlbumChooser* albumChooser;
@property (nonatomic, strong) SpecificImagePicker* imagePicker;
@property (nonatomic, strong) UINavigationController* navController;
@property (nonatomic, strong) NSMutableArray<HTAsset*>* selectedResult;
@property (nonatomic, strong) UIButton* orderPickerButton;
@property (nonatomic, strong) UIButton* unorderPickerButton;

@end

@implementation HTAssetsPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _selectedResult = [[NSMutableArray alloc]init];
    
    _library = [[ALAssetsLibrary alloc]init];
    [_library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        NSLog(@"%li",(long)[group numberOfAssets]);
    } failureBlock:^(NSError *error) {
        if (error.code == ALAssetsLibraryAccessUserDeniedError) {
            NSLog(@"user denied access, code: %li",(long)error.code);
        }else{
            NSLog(@"Other error code: %li",(long)error.code);
        }
    }];
    UIButton* button = _orderPickerButton = [[UIButton alloc]init];
    button.frame = CGRectMake(self.view.bounds.size.width / 2 - 50, 250, 100, 50);
    button.layer.cornerRadius = 15;
    button.layer.masksToBounds = YES;
    [button setTitle:@"有序选择" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(presentAssetsPicker:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor colorWithRed:70/255.0 green:206/255.0 blue:138/255.0 alpha:1]];
    [self.view addSubview:button];
    
    
    button = _unorderPickerButton = [[UIButton alloc]init];
    button.frame = CGRectMake(self.view.bounds.size.width / 2 - 50, 150, 100, 50);
    button.layer.cornerRadius = 15;
    button.layer.masksToBounds = YES;
    [button setTitle:@"无序选择" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(presentAssetsPicker:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor colorWithRed:70/255.0 green:206/255.0 blue:138/255.0 alpha:1]];
    [self.view addSubview:button];
    
    _albumChooser = [[HTCustomAlbumChooser alloc]init];
    _albumChooser.delegate = self;
    
}

- (void)presentAssetsPicker:(id)sender{
    if (sender == _orderPickerButton) {
        _imagePicker = [[SpecificImagePicker alloc]initWithType:SpecificImagePickerTypeOrder];
    }else{
        _imagePicker = [[SpecificImagePicker alloc]initWithType:SpecificImagePickerTypeUnorder];
    }
    
    _imagePicker.assetsPicker.assetsType = HTAssetsTypePhoto;
    _imagePicker.delegate = self;
    
    //ios8+,use photokit
    if (HTASSETSPICKER_USE_PHOTOKIT) {
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                              subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
        if (smartAlbums.count == 1) {
            PHCollection *collection = smartAlbums[0];
            if ([collection isKindOfClass:[PHAssetCollection class]]) {
                PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
                [_imagePicker.assetsPicker setAssetCollection:assetCollection];
                
            } else {
                NSAssert(NO, @"Fetch collection not PHCollection: %@", collection);
            }
        }
        //相册选择器
        NSMutableArray* assetsGroups = [[NSMutableArray alloc]init];
        [_library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group) {
                [group setAssetsFilter:[HTAssetsHelper assetsFilterFromType:HTAssetsTypePhoto]];
                [assetsGroups addObject:group];
                
            }else{
                
            }
            if (stop) {
                [_albumChooser setAssetsGroups:assetsGroups];
            }
        } failureBlock:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }else{
        //相片选择器
        [_library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group) {
                [_imagePicker.assetsPicker setAssetGroup:group];
            }
            *stop = YES;
        } failureBlock:^(NSError *error) {
            NSLog(@"enumerateGroupsWithTypes failed:%@",error);
        }];
        
        //相册选择器
        NSMutableArray* assetsGroups = [[NSMutableArray alloc]init];
        [_library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group) {
                [group setAssetsFilter:[HTAssetsHelper assetsFilterFromType:HTAssetsTypePhoto]];
                [assetsGroups addObject:group];
                
            }else{
                
            }
            if (stop) {
                [_albumChooser setAssetsGroups:assetsGroups];
            }
        } failureBlock:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    _navController = [[UINavigationController alloc]initWithRootViewController:_albumChooser];
    [_navController pushViewController:_imagePicker animated:NO];
    
    [self presentViewController:_navController animated:YES completion:nil];
    
}

- (void)viewWillLayoutSubviews{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SpecificImagePickerDelegate

- (void)assetsPicker:(SpecificImagePicker*)assetsPicker didFinishPickingWithAssets:(NSArray<HTAsset*>*)assets
{
    NSLog(@"选中：%lu张图片",(unsigned long)[assets count]);
    [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [_selectedResult addObject:obj];
    }];
    [self dismissViewControllerAnimated:YES completion:^{
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"选择了%ld张照片",(long)assets.count] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }];
}

- (void)assetsPickerDidCancelPicking:(SpecificImagePicker*)assetsPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - HTTableAlbumChooserDelegate

- (void)tableAlbumChooser:(HTTableAlbumChooser*)tableAlbumChooser didSelectAssetGroup:(ALAssetsGroup*)group
{
    [_imagePicker.assetsPicker setAssetGroup:group];
    [_imagePicker.assetsPicker selectAssets:_selectedResult];
    ALAssetsGroupType type = [[group valueForProperty:ALAssetsGroupPropertyType] integerValue];
    if (type != ALAssetsGroupSavedPhotos) {
        [_imagePicker.assetsPicker setCameraItemIndex:-1];
    }else{
        [_imagePicker.assetsPicker setCameraItemIndex:4];
    }
    [_navController pushViewController:_imagePicker animated:YES];
    
}

@end
