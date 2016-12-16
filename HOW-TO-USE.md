#HTAssetsPicker使用文档


##简介

HTAssetsPicker是一个灵活的资源选择器，支持iOS系统上图片、视频资源的选择。HTAssetsPicker继承自UICollectionView，是基于AssetsLibrary实现，接收数据model类型为ALAssetsGroup，需要用户传入。

###[使用说明](#使用说明)

[1.导入头文件](#导入头文件)

[2.自定义HTAssetsPickerCell](#自定义HTAssetsPickerCell)

[3.实例化HTAssetsPickerView](#实例化HTAssetsPickerView)


###[功能扩展和自定义说明](#功能扩展和自定义说明)

[1.自定义HTAssetItem](#自定义HTAssetItem)


<p id="使用说明">
##使用说明

<p id="导入头文件">
1) 导入头文件

```
#import "HTAssetsPickerView.h"
```
<p id="自定义HTAssetsPickerCell">
2) 自定义HTAssetsPickerCell

```
@interface MyCell : HTAssetsPickerCell
@end

@interface MyCell ()
//本例中，当点击选中cell，用于表示选中状态的外框视图
@property (nonatomic,strong) UIImageView* overlapView;
@end

@implementation MyCell

...//其他代码

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        ...//其他代码
        _overlapView = [[UIImageView alloc]init];
        _overlapView.hidden = YES;
        _overlapView.image = [UIImage imageNamed:@"overlap_image"];
        [self addSubview:_overlapView];
        ...//其他代码
    }
    return self;
}

//cell被选中，显示overlapView
- (void)selectedWithIndex:(NSInteger)index{
    _overlapView.hidden = NO;    
}

//cell取消选中，隐藏overlapView
- (void)deselected{
    _overlapView.hidden = YES;
}

//重置cell状态
- (void)reset{
    [super reset];
    _overlapView.hidden = YES;
}

//cell响应交互
- (void)onInteracted:(HTAssetPickerCellInteactType)interactType{
	//只响应单击事件
	if(interactType != HTAssetPickerCellInteactTypeSingleTapped){
		return;
	}
	//选择
    if (!self.assetItem.selected) {
        [self trySelect];
    }else{//取消选择
        [self tryDeselect];
    }
}

...//其他代码

@end

```
<p id="实例化HTAssetsPickerView">
3) 实例化HTAssetsPickerView，设置model，并添加到视图中

```
//HTAssetsPickerView的代理需要遵循HTAssetsPickerDelegate
@interface MyViewController ()<HTAssetsPickerDelegate>
@property (nonatomic, strong) ALAssetsLibrary* library;
//...
@end

@implementation MyViewController

- (void)viewDidLoad{

	//根据自定义cell创建资源选择视图
	HTAssetsPickerView* assetsPicker = [[HTAssetsPickerView alloc]initWithCellClass:MyCell.class];

	//设置代理，资源选择器的相关事件通过代理通知，具体查看HTAssetsPickerDelegate协议
	assetsPicker.assetsPickerDelegate = self;
	
	//设置交互类型(如果需要关闭交互，设置为HTAssetPickerCellInteactTypeNone)
	assetsPicker.interactTypes = HTAssetPickerCellInteactTypeSingleTapped | HTAssetPickerCellInteactTypeLongPressed;

	//设置选择资源类型为图片
	assetsPicker.assetsType = HTAssetsTypePhoto;

	//通过间距来设置cell的布局，排版会计算出每个cell的尺寸，也可直接通过itemSize属性来设置cell尺寸
	assetsPicker.interitemSpacing = 4;
	assetsPicker.lineSpacing = 8;
	assetsPicker.inset = UIEdgeInsetsMake(4, 2, 0, 2);
	assetsPicker.itemsCountEachRow = 4;

	//设置相机所在位置和图片名称
	assetsPicker.cameraItemIndex = 0;
	assetsPicker.cameraImageName = @"HTAssetsPickerCamera";

	//设置最大选择数
	assetsPicker.maxSelectedCount = 9;
	
	
	//此处需要参考首页README中“设置相册信息说明”一节说明
	//创建ALAssetsLibrary
	_library = [[ALAssetsLibrary alloc]init];

	//为assets picker设置ALAssetsGroup(model)，此示例设置为系统默认相册
	[_library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
	        if (group) {
	            [assetsPicker setAssetGroup:group];
	        }
	        *stop = YES;
	    } failureBlock:^(NSError *error) {
	        NSLog(@"enumerateGroupsWithTypes failed:%@",error);
	    }];

	//添加图片选择视图
	[self.view addSubview:assetsPicker];
}
@end
```

<p id="功能扩展和自定义说明">
##功能扩展和自定义说明

<p id="自定义HTAssetItem">
####自定义HTAssetItem
HTAssetItem是HTAssetsPickerCell内部所使用的数据类型，即Cell所使用的model，组件提供默认的类型HTAssetItem，一般使用HTAssetItem即可，如果有需要，用户也可以自定义HTAssetItem，并通过HTAssetsPickerView的构造函数

```
- (instancetype)initWithCellClass:(Class)cellClass assetItemClass:(Class)assetItemClass;
```
或者

```
- (instancetype)initWithSelectedAssets:(NSArray<HTAsset*>*)assets cellClass:(Class)cellClass assetItemClass:(Class)assetItemClass;
```
来传入自定义的model，并在自定义的HTAssetsPickerCell中使用自定义的HTAssetItem。

典型的应用场景示例：**当选中最大可选个数之后，将其余的未选中的cell置为不可选状态。**此时可以在HTAssetItem扩展新的属性，如下面示例中的**BOOL enable**。

下面展示使用示例：

```
@interface YXAssetItem : HTAssetItem
@property (nonatomic, assign) BOOL enable;
@end
```

在自定义HTAssetsPickerCell使用

```
- (void)setAssetItem:(HTAssetItem *)assetItem
{
    [super setAssetItem:assetItem];
    _selectButton.enable = assetItem.enable;
}
```

创建HTAssetsPicker，传入自定义cell和item类型

```
HTAssetsPickerView* assetsPicker = [[HTAssetsPickerView alloc]initWithCellClass:MyCell.class assetItemClass: YXAssetItem.class];
```

在HTAssetsPicker代理事件中，修改YXAssetItem状态

```
- (void)assetsPicker:(HTAssetsPickerView*)assetsPicker didSelectAsset:(HTAsset*)asset
{
    [self selectedAssetsChangeConfig:assetsPicker];
    
    //达到最大选择数量，禁止其他cell选择能力
    if ([assetsPicker selectedAssetsCount] == 5) {
        NSArray<HTAssetItem*> items = [assetsPicker assetItems];
        for (HTAssetItem* item in items) {
        	  YXAssetItem* yxItem = (YXAssetItem*)item;
            yxItem.enable = yxItem.selected;
        }
    }
    [assetsPicker reloadData];
   
}

- (void)assetsPicker:(HTAssetsPickerView *)assetsPicker didDeselectAsset:(HTAsset *)asset
{
    [self selectedAssetsChangeConfig:assetsPicker];
    
    //开启其他cell的选择能力
    NSArray<HTAssetItem*> items = [assetsPicker assetItems];
    for (HTAssetItem* item in items) {
        YXAssetItem* yxItem = (YXAssetItem*)item;
        yxItem.enable = YES;
    }
    [assetsPicker reloadData];
}
```
