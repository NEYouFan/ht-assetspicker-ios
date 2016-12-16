//
//  HTTableAlbumChooser.m
//  JWAssetsPicker
//
//  Created by jw-mbp on 9/21/15.
//  Copyright (c) 2015 jw. All rights reserved.
//

#import "HTTableAlbumChooser.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface HTTableAlbumChooser ()
@end


@implementation HTTableAlbumChooser


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _assetsGroups = [[NSMutableArray alloc]init];
//        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([ALAssetsLibrary authorizationStatus] != ALAuthorizationStatusAuthorized) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"相册访问" message:@"相册访问未授权" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}


- (void)setAssetsGroups:(NSArray *)assetsGroups
{
    _assetsGroups = assetsGroups;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_assetsGroups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"HTTableAlbumChooserCellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    ALAssetsGroup* group = _assetsGroups[indexPath.row];
    cell.imageView.image = [UIImage imageWithCGImage:[group posterImage]];//海报图片
    cell.textLabel.text = [group valueForProperty:ALAssetsGroupPropertyName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld 张",(long)[group numberOfAssets]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(tableAlbumChooser:didSelectAssetGroup:)]) {
        [_delegate tableAlbumChooser:self didSelectAssetGroup:_assetsGroups[[indexPath row]]];
    }
}

@end
