//
//  SpecificImagePicker.m
//  JWAssetsPicker
//
//  Created by jw-mbp on 9/21/15.
//  Copyright (c) 2015 jw. All rights reserved.
//

#import "SpecificImagePicker.h"
#import "HTAssetsPickerView.h"
#import "HTAssetsPickerOrderCell.h"
#import "HTAssetsPickerUnorderCell.h"

@interface SpecificImagePicker ()<HTAssetsPickerDelegate>
@property (nonatomic,weak) UIButton *numberButton;
@property (nonatomic,weak) UIButton *previewButton;
@property (nonatomic,weak) UIButton *sendPictureButton;
@property (nonatomic,assign) BOOL isOrderImagePicker;
@end

@implementation SpecificImagePicker



- (instancetype)initWithType:(SpecificImagePickerType)type{
    self = [super init];
    if (self) {
        if (type == SpecificImagePickerTypeOrder) {
            _assetsPicker = [[HTAssetsPickerView alloc]initWithCellClass:[HTAssetsPickerOrderCell class]];
            _isOrderImagePicker = YES;
        }else{
            _assetsPicker = [[HTAssetsPickerView alloc]initWithCellClass:[HTAssetsPickerUnorderCell class]];
            _isOrderImagePicker = NO;
        }        
        _assetsPicker.assetsPickerDelegate = self;
        _assetsPicker.interItemSpacing = 4;
        _assetsPicker.lineSpacing = 4;
        _assetsPicker.itemsCountEachRow = 4;
        _assetsPicker.inset = UIEdgeInsetsMake(4, 4, 4, 4);
        _assetsPicker.cameraItemIndex = 4;
        _assetsPicker.maxSelectedCount = 3;
        _assetsPicker.cameraImageName = @"HTAssetsPickerCamera";
        _assetsPicker.assetsType = HTAssetsTypePhoto;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"相机胶卷";
    [self.view addSubview:_assetsPicker];
    
    if (_isOrderImagePicker) {
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:70/255.0 green:206/255.0 blue:138/255.0 alpha:1];
        
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:19]};
        [self setupOrderBottomBar];
    }else{
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleButtonClicked:)];
        self.navigationItem.rightBarButtonItem = cancelButton;
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19]};
        [self setupUnorderBottomBar];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    if (_isOrderImagePicker) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        
    }
    else{
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)setupOrderBottomBar
{
    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50, [UIScreen mainScreen].bounds.size.width, 50)];
    bottomBar.backgroundColor = [UIColor colorWithRed:223/255.0 green:247/255.0 blue:237/255.0 alpha:1];
    CGRect barFrame = bottomBar.frame;
    UIButton *previewButton = [[UIButton alloc] initWithFrame:CGRectMake(7, 10, 60, 30)];
    [previewButton setTitle:@"预览" forState:UIControlStateNormal];
    [previewButton setTitleColor:[UIColor colorWithRed:70/255.0 green:206/255.0 blue:138/255.0 alpha:1] forState:UIControlStateNormal];
    [previewButton setTitleColor:bottomBar.backgroundColor forState:UIControlStateHighlighted];
    [previewButton setEnabled:NO];
    [bottomBar addSubview:previewButton];
    
    UIButton *sendPictureButton = [[UIButton alloc] initWithFrame:CGRectMake(barFrame.size.width - 82, 7,70, 35)];
    _sendPictureButton = sendPictureButton;
    [sendPictureButton setTitle:@"完成" forState:UIControlStateNormal];
    [sendPictureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendPictureButton setBackgroundColor:[UIColor colorWithRed:144/255.0 green:227/255.0 blue:190/255.0 alpha:1]];
    sendPictureButton.layer.cornerRadius = 15;
    sendPictureButton.layer.masksToBounds = YES;
    [sendPictureButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sendPictureButton setEnabled:NO];
    [bottomBar addSubview:sendPictureButton];
    
    [self.view addSubview:bottomBar];
    
}

- (void)dealloc
{
    
}

- (void)setupUnorderBottomBar
{
    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 44, [UIScreen mainScreen].bounds.size.width, 44)];
    bottomBar.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    CGRect barFrame = bottomBar.frame;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, barFrame.size.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [bottomBar addSubview:lineView];
    UIButton *previewButton = [[UIButton alloc] initWithFrame:CGRectMake(7, 7, 60, 30)];
    _previewButton = previewButton;
    [previewButton setTitle:@"预览" forState:UIControlStateNormal];
    [previewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [previewButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [previewButton setEnabled:NO];
    [bottomBar addSubview:previewButton];
    
    UIButton *sendPictureButton = [[UIButton alloc] initWithFrame:CGRectMake(barFrame.size.width - 67, 7, 60, 30)];
    _sendPictureButton = sendPictureButton;
    [sendPictureButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendPictureButton setTitleColor:[UIColor colorWithRed:184/255.0 green:225/255.0 blue:188/255.0 alpha:1] forState:UIControlStateNormal];
    [sendPictureButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [sendPictureButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sendPictureButton setEnabled:NO];
    [bottomBar addSubview:sendPictureButton];
    
    UIButton *numberButton = [[UIButton alloc] initWithFrame:CGRectMake(barFrame.size.width - 92, 9, 25, 25)];
    _numberButton = numberButton;
    [numberButton setTitle:@"0" forState:UIControlStateNormal];
    [numberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    numberButton.layer.cornerRadius = 12;
    numberButton.layer.masksToBounds = YES;
    [numberButton setBackgroundColor:[UIColor colorWithRed:9/255.0 green:187/255.0 blue:7/255.0 alpha:1]];
    [numberButton setEnabled:NO];
    numberButton.hidden = YES;
    [bottomBar addSubview:numberButton];

    [self.view addSubview:bottomBar];
}

- (void)transformWithButton:(UIButton *)button
{
    button.alpha = 0;
    CGAffineTransform transform = button.transform;
    button.transform = CGAffineTransformScale(transform, 0.1, 0.1);
    [UIView animateWithDuration:0.2 animations:^{
        button.transform = CGAffineTransformScale(transform, 1.2, 1.2);
        button.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            button.transform = CGAffineTransformScale(transform, 0.9, 0.9);;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                button.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}

//selectedAssents变化后设置底部栏的变化
- (void)selectedAssetsChangeConfig:(HTAssetsPickerView*)assetsPicker
{
    
    if (_isOrderImagePicker) {
        if (assetsPicker.selectedAssets.count > 0) {
            _previewButton.enabled = YES;
            _sendPictureButton.enabled = YES;
            [_sendPictureButton setBackgroundColor:[UIColor colorWithRed:70/255.0 green:206/255.0 blue:138/255.0 alpha:1]];
            if (_sendPictureButton.frame.size.width != 90) {
                [_sendPictureButton setFrame:CGRectMake(_sendPictureButton.frame.origin.x - 15, 7, 90, 35)];
            }
            [_sendPictureButton setTitle:[NSString stringWithFormat:@"完成(%@)",@(assetsPicker.selectedAssets.count)] forState:UIControlStateNormal];
        }
        else{
            [_sendPictureButton setTitle:@"完成" forState:UIControlStateNormal];
            if (_sendPictureButton.frame.size.width != 70) {
                [_sendPictureButton setFrame:CGRectMake(_sendPictureButton.frame.origin.x + 15, 7,70, 35)];
            }
            [_sendPictureButton setBackgroundColor:[UIColor colorWithRed:144/255.0 green:227/255.0 blue:190/255.0 alpha:1]];
            _previewButton.enabled = NO;
            _sendPictureButton.enabled = NO;
        }
    }
    else{
        if (assetsPicker.selectedAssets.count > 0) {
            _numberButton.hidden = NO;
            _previewButton.enabled = YES;
            _sendPictureButton.enabled = YES;
            [_previewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_sendPictureButton setTitleColor:[UIColor colorWithRed:9/255.0 green:187/255.0 blue:7/255.0 alpha:1] forState:UIControlStateNormal];
            [_numberButton setTitle:[NSString stringWithFormat:@"%@",@(assetsPicker.selectedAssets.count)] forState:UIControlStateNormal];
            [self transformWithButton:_numberButton];
        }
        else
        {
            _numberButton.hidden = YES;
            _previewButton.enabled = NO;
            _sendPictureButton.enabled = NO;
            [_previewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [_sendPictureButton setTitleColor:[UIColor colorWithRed:184/255.0 green:225/255.0 blue:188/255.0 alpha:1] forState:UIControlStateNormal];
        }
    }
}


- (void)sendButtonClicked:(id)sender
{
    [_assetsPicker finishSelection];
}

- (void)cancleButtonClicked:(id)sender
{
    [_assetsPicker cancelSelection];
}

- (void)viewWillLayoutSubviews
{
    _assetsPicker.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height -50 - 64);

}


#pragma mark - HTAssetsPickerDelegate

- (void)assetsPicker:(HTAssetsPickerView*)assetsPicker didFinishPickingWithAssets:(NSArray<HTAsset*>*)assets
{
    [_delegate assetsPicker:self didFinishPickingWithAssets:assets];
}

- (void) assetsPickerDidCancelPicking:(HTAssetsPickerView*)assetsPicker
{
    [_delegate assetsPickerDidCancelPicking:self];
}

- (void)assetsPicker:(HTAssetsPickerView*)assetsPicker didSelectAsset:(HTAsset*)asset
{
    [self selectedAssetsChangeConfig:assetsPicker];
}

- (void)assetsPicker:(HTAssetsPickerView *)assetsPicker didDeselectAsset:(HTAsset *)asset
{
    [self selectedAssetsChangeConfig:assetsPicker];
}

- (void)assetsPickerSwitchAssetsGroup:(HTAssetsPickerView*)assetsPicker
{
    
}

- (void)assetsPickerDidExceedMaxSelectedCount:(HTAssetsPickerView*)assetsPicker
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"最多选择%ld张",(long)_assetsPicker.maxSelectedCount] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
}


- (void)assetsPickerCameraClicked:(HTAssetsPickerView *)assetsPicker
{
    NSLog(@"camera");
}


@end
