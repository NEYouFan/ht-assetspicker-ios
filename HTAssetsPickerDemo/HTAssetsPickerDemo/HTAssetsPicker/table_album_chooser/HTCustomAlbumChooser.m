//
//  HTCustomAlbumChooser.m
//  HTUIDemo
//
//  Created by jw on 3/23/16.
//  Copyright © 2016 HT. All rights reserved.
//

#import "HTCustomAlbumChooser.h"

@implementation HTCustomAlbumChooser

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"照片";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19]};
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)cancel:(id)sender{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
