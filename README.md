# EaseModule

[![CI Status](https://img.shields.io/travis/Yrocky/EaseModule.svg?style=flat)](https://travis-ci.org/Yrocky/EaseModule)
[![Version](https://img.shields.io/cocoapods/v/EaseModule.svg?style=flat)](https://cocoapods.org/pods/EaseModule)
[![License](https://img.shields.io/cocoapods/l/EaseModule.svg?style=flat)](https://cocoapods.org/pods/EaseModule)
[![Platform](https://img.shields.io/cocoapods/p/EaseModule.svg?style=flat)](https://cocoapods.org/pods/EaseModule)

## Example

进入`example`文件夹，在终端执行`pod install`，然后打开对应的工程文件即可。

Demo共分为Objective-C和Swift两种类型的，前者使用样式比较丰富，后者仅仅用来实现了一个Resume效果。

## Installation

EaseModule is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'EaseModule'
```

由于内部是使用`YTKNetwork`来担当网络请求角色的，所以会依赖`YTKNetwork`，如果有独立的网络层，可以考虑修改源码。

## Framework

在使用之前可以参考[这篇文章](http://yrocky.github.io/2020/07/15/use-Self-Manager-make-Module/)，该文章讲述了EaseModule最初的实现架构。随着参考了更多的app，观察了更多的界面展示 ，逐渐添加了一些比较实用的功能，具体的特性下面会一一介绍。

在前面提到的文章中的架构中，要实现更多样的布局样式比较麻烦，更多的时候需要借助额外的UICollectionViewLayout，并且在多样式混用的时候性能还不是很理想。另外，随着iOS13、14这样的新版本release之后，苹果的主流UI样式也发生了很大的变化，更多的使用圆角，单元素圆角、区域圆角等等，像是为某个section设置背景颜色这种需求，在`UICollectionViewCompositionalLayout`布局出来之后实现起来就更简单了。

在这样的背景下，重新优化了项目的架构，使用一个私有的`EaseModuleFlowLayout : UICollectionViewFlowLayout`布局类来强化布局，为提供更多布局效果的核心，提供`EaseBaseLayout`及子类来完成具体的布局效果，主要是将以前`Layout`部分中的功能分离成常用的布局效果。同时提供更多业务场景下的Module类，以应对更多的业务逻辑。

## How to use

`EaseModule`主要的目的是将具体业务场景下的展示进行组件化，所以主要业务逻辑都是在`Module`和`Component`中进行处理的：Module中处理数据和一些业务逻辑、Component中提供布局和具体的样式。

1.创建一个业务Module

``` objective-c
// in DemoModule.h

@interface DemoModule : EaseSingleModule
@end
```

2.重写`-fetchModuleRequest`返回对应的请求，在`-parseModuleDataWithRequest:`方法中对请求数据进行处理，主要是根据业务进行Component的转换。

``` objective-c
// in DemoModule.m

- (__kindof YTKRequest *)fetchModuleRequest{
    return SomeRequest.new;
}

- (void)parseModuleDataWithRequest:(__kindof YTKRequest *)request{

    [self.dataSource addComponent:({
        SomeComponent * comp = 
        [[SomeComponent alloc] init];
        [comp addDatas:request.datas];
        comp;
    })];
}
```

`SomeComponent`是`EaseComponent`的子类，内部需要创建对应的`layout`来决定布局，指明要展示数据的`cell`，以及可选创建`placehold cell`、`header view`、`footer view`等。

``` objective-c
// in SomeComponent.m

- (instancetype) init{
    self = [super init];
    if (self) {
        EaseListLayout * layout = [EaseListLayout new];
        layout.distribution = [EaseLayoutDimension distributionDimension:1];
        layout.itemRatio = [EaseLayoutDimension absoluteDimension:50];
        _layout = layout;
    }
    return self;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    
    YourCustomCCell * ccell = [self.dataSource dequeueReusableCellOfClass:YourCustomCCell.class forComponent:self atIndex:index];
    ...
    return ccell;
}
```

3.在视图控制器中使用Module

``` objective-c
// in ViewController.m

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // collectionvView
    self.collectionView = [UICollectionView new];
    ...
    
    // module
    self.module = [[DemoModule alloc] initWithName:@"Home"];
    self.module.delegate = self;
    [self.module setupViewController:self 
                      collectionView:self.collectionView];
    [self.module refresh];
}
```

4.Module还提供了`EaseModuleDelegate`协议的代理，以供对网络请求回调进行处理。

``` objective-c
// in ViewController.m

- (void)liveModuleDidSuccessUpdateComponent:(EaseModule *)module{
    [self.collectionView reloadData];
}

- (void)liveModule:(EaseModule *)module didFailUpdateComponent:(NSError *)error{
    // show Toast with error
}
```

## Feature

* 更贴近实际业务的module
* 多样、实用的布局
* 黏性header
* 无数据时候的占位效果
* 为section添加背景、阴影效果
* 设置当前section最多展示数量
* 水平布局多种分页选择

### module

`EaseModule`作为一个抽象类，仅仅提供在模块中的一些公有逻辑处理，针对不同的业务场景，具象化了几个子类：
* `EaseCompositeModule`，具有**嵌套功能**的容器Module
* `EaseSingleModule`，提供**单个网络请求**的Module
* `EasePureListModule`，提供单个请求下**单一展示样式**的Module
* `EaseBatchModule`，提供多网络请求**并行**业务下的Module
* `EaseChainModule`，提供多网络请求**串行**业务下的Module

下拉刷新、上拉加载等基础功能都在`EaseModule`中，另外上拉加载可能会与下拉刷新的网络请求不同，可以通过设置`loadMoreDifferentWithRefresh`属性，然后重写具体子类的`-loadMoreRequest`方法返回对应的请求。

#### composite

> DemoCompositeListViewController

主要用于Module中会嵌套多Module的场景，`EaseCompositeModule`仅用来作为一个容器子类，没有具体的业务逻辑，只有对子模块的承载，使用`-addModule:`添加子模块，通过`-modules`来获取子模块，需要说明的是，嵌套是支持多层的。

``` Objective-C
// in SomeViewController

EaseCompositeModule * module = [[EaseCompositeModule alloc] initWithName:@"demo"];
[module addModule:someSubEaseModuleObj];
...
[module addModule:({
    EaseCompositeModule * demoModule = [[EaseCompositeModule alloc] initWithName:@"DEMO"];
    [demoModule addModule:otherSubEaseModuleObj];
    ...
    demoModule;
})];
```

#### single

> DemoNewsModule

一般来说，Module都是通过网络请求驱动的，并且更多的时候是只需要一个网络请求即可，所以这里提供了单个网络请求驱动的`EaseSingleModule`。子类只需要重写下面两个方法:分别提供网络抽象类（这里使用的是YTKRequest）、针对网络请求数据进行解析。

``` Objective-C
/// 当前module的网络请求
- (__kindof YTKRequest *) fetchModuleRequest;

/// 根据网络数据进行解析，解析出来对应的Component
- (void) parseModuleDataWithRequest:(__kindof YTKRequest *)request;
```
    
重写`-parseModuleDataWithRequest:`方法，在内部根据网络数据映射成对应的`Component`，然后将component添加到`DataSource`中：

``` Objective-C
// in SomeModule.m

- (__kindof YTKRequest *)fetchModuleRequest{
    return SomeRequest.new;
}

- (void) parseModuleDataWithRequest:(SomeRequest *)request{
    
    ...
    [self.dataSource addComponent:oneComponentObj];
    // or
    [self.dataSource addComponents:someComponentObjs];
}
```

默认`refresh`和`loadMore`操作都会使用同一个request，当`loadMore`操作为不同于`refresh`操作请求的时候，可以通过设置`loadMoreDifferentWithRefresh`为YES，并且重写`-loadMoreRequest`方法来完成这个业务逻辑。

``` Objective-C
// in SomeModule.m

- (instancetype)initWithName:(NSString *)name{
    self = [super initWithName:name];
    if (self) {
        ...
        self.loadMoreDifferentWithRefresh= YES;
    }
    return self;
}

...
- (__kindof YTKRequest *)loadMoreRequest{
    return [SomeLoadMoreRequest new];
}

```

同样还是使用`-parseModuleDataWithRequest:`来完成数据的解析，只需要对不同的request做对应的数据映射即可。

#### pure List

单个请求驱动的Module中如果数据只有一种展示样式，或者说，网络数据只会映射成`一种Component`，可以使用`EasePureListModule`。该Module提供了两种数据处理方式：整体替换、追加，使用`EasePureListModuleType`来表示。

``` Objective-C
// in SomeModule.m

- (EasePureListModuleType) pureListModuleType{
    return EasePureListModuleAppend;
}

/// 指明comp的类型
- (Class) pureListComponentClass{
    return SomeComponent.class;
}

- (__kindof YTKRequest *)fetchModuleRequest{
    return SomeRequest.new;
}

- (void)parseModuleDataWithRequest:(SomeRequest *)request{
    // 如果没有其他逻辑，可以直接写这行代码完成数据的映射
    [self setupPureComponentWithDatas:request.datas];
    
    // 如果还有其他逻辑，可以获取到 SomeComponent 的实例对象
    SomeComponent * comp = [self setupPureComponentWithDatas:request.datas];
    // 然后对comp进行一些具体的逻辑处理
}
```

#### queue

> DemoNewsModule

复杂的模块中，可能会有不止一个网络请求，如果是并行的多个请求，可以使用`EaseBatchModule`；如果是串行的的可以使用`EaseChainModule`。

这两个Module都可以选择在所有请求结束之后做数据映射，也可以选择在每一个请求结束之后做映射，通过重写`-queueType`返回`EaseQueueRequestModuleType`类型来决定。子类需要重写`-fetchModuleRequests`来设定所有请求，通过`-parseModuleDataWithRequest:`来对请求数据进行解析，需要说明的是，如果是`EaseChainModule`，数组的顺序就是请求的执行先后顺序

``` Objective-C
// in SomeModule.m

...
- (NSArray<__kindof YTKRequest *> *)fetchModuleRequests{
    return @[
        OneRequest.new,
        OtherRequest.new
    ];
}

- (EaseQueueRequestModuleType)queueType{
    return EaseQueueRequestModuleAllDone;
}

- (void)parseModuleDataWithRequest:(__kindof YTKRequest *)request{
    if ([request isKindOfClass:[OneRequest class]]) {
        ... 
    } else if ([request isKindOfClass:[OtherRequest class]]) {
        ...
    }  
}
```

这两个Module同样也支持为`loadMore`操作提供单独的请求，同上。

### layout

目前支持三种主流的布局样式：`list`、`flex`、`waterfall`，`grid布局`目前还在构思中，不日就会添加到项目中，目前的三种layout都支持**垂直**和**水平**两种布局样式。

#### list

> DemoListLayoutModule

常规布局效果，可以实现像是UITableView、UICollectionView这样的展示样式。

在水平布局中，如果通过 `distribution` 和 `itemRatio`计算出来的 cell高度大于 `horizontalArrangeContentHeight`，则会限制为`horizontalArrangeContentHeight`。如果小于则会按照`从上之下、从左至右`的顺序进行排列。另外，还可以设置`row`来决定 `horizontalArrangeContentHeight`，此时设置 `horizontalArrangeContentHeight`将无效。

* table-view like

    ``` Objective-C
    // in SomeComponent.m
    
    EaseListLayout * listLayout = [EaseListLayout new];
    listLayout.lineSpacing = 0.5f;
    listLayout.distribution = [EaseLayoutDimension distributionDimension:1];
    listLayout.itemRatio = [EaseLayoutDimension absoluteDimension:44.0f];
    ```
	![table-view-like](./Resource/list/table-view-like.png)
	
* collection-view like

    ``` Objective-C
    // in SomeComponent.m
    ...
    listLayout.distribution = [EaseLayoutDimension distributionDimension:3];
    listLayout.itemRatio = [EaseLayoutDimension fractionalDimension:0.8];
    ...
    ```
	![collection-view-like](./Resource/list/collection-view-like.png)
	
*  orthogonal scroll

    ``` Objective-C
    // in SomeComponent.m
    ...
    listLayout.arrange = EaseLayoutArrangeHorizontal;
    listLayout.inset = UIEdgeInsetsMake(10, 10, 10, 10);
    listLayout.distribution = [EaseLayoutDimension fractionalDimension:0.55];
    listLayout.itemRatio = [EaseLayoutDimension absoluteDimension:50];
    // 可以设置行数
    listLayout.row = 3;
    // 或者设置一个垂直方向的高度限制
    //listLayout.horizontalArrangeContentHeight = 150;
    ...
    ```

#### flex

> DemoFlexLayoutModule

参考前端的`Flex-layout`，提供`flex-start`、`center`、`flex-end`、`space-around`、`space-between`4种效果来布局元素，该布局的水平效果不支持多行效果，只能显示`1行`。

* flex-start

    ``` Objective-C
    // in SomeComponent.m
    
    EaseFlexLayout * flexLayout = [EaseFlexLayout new];
    flexLayout.justifyContent = EaseFlexLayoutFlexStart;
    flexLayout.inset = UIEdgeInsetsMake(0, 0, 0, 0);
    // itemHeight在水平和垂直显示效果中都需要设置
    flexLayout.itemHeight = 30;
    // 通过代理方法来返回每一个元素的显示尺寸
    flexLayout.delegate = self;
    ```
    ![flex-start](./Resource/flex/flex-start.png)

* center

    ``` Objective-C
    // in SomeComponent.m
    ...
    flexLayout.justifyContent = EaseFlexLayoutCenter;
    ...
    ```
    
    ![center](./Resource/flex/center.png)

* flex-end

    ``` Objective-C
    // in SomeComponent.m 
    ...
    flexLayout.justifyContent = EaseFlexLayoutFlexEnd;
    ...
    ```
    
    ![flex-end](./Resource/flex/flex-end.png)

* space-around

    ``` Objective-C
    // in SomeComponent.m
    ...
    flexLayout.justifyContent = EaseFlexLayoutSpaceAround;
    ...
    ```

	![space-around](./Resource/flex/space-around.png)

* space-between

    ``` Objective-C
    // in SomeComponent.m
    ...
    flexLayout.justifyContent = EaseFlexLayoutSpaceBetween;
    ...
    ```

	![space-between](./Resource/flex/space-between.png)
  
* orthogonal scroll

    ``` Objective-C
    // in SomeComponent.m
    ...
    flexLayout.arrange = EaseLayoutArrangeHorizontal;
    ...
    ```

    ![orthogonal-scroll](./Resource/flex/orthogonal-scroll.png)

#### waterfall

> DemoWaterfallLayoutModule

在瀑布流的垂直布局中，需要指明`column`来决定有多少列，可选的追加类型`renderDirection`有：`EaseWaterfallItemRenderShortestFirst`、`EaseWaterfallItemRenderLeftToRight`、`EaseWaterfallItemRenderRightToLeft`。

与其他布局一样，水平效果的时候需要设置`horizontalArrangeContentHeight`，另外需要设置`row`来决定可以展示多少行，水平的瀑布流效果支持的数据追加类型有：`EaseWaterfallItemRenderShortestFirst`、`EaseWaterfallItemRenderBottomToTop`、`EaseWaterfallItemRenderTopToBottom`三种。

* shortest first

    ``` Objective-C
    // in SomeComponent.m
    
    ...
    EaseWaterfallLayout * waterfallLayout = [EaseWaterfallLayout new];
    waterfallLayout.column = 3;
    waterfallLayout.renderDirection = EaseWaterfallItemRenderShortestFirst;
    waterfallLayout;
    ...
    ```

    ![shortest first](./Resource/waterfall/shortest-first.png)

* left to right

    ``` Objective-C
    // in SomeComponent.m
    
    ...
    waterfallLayout.column = 3;
    waterfallLayout.renderDirection = EaseWaterfallItemRenderLeftToRight;
    ...
    ```

    ![left to right](./Resource/waterfall/left-to-right.png)
    
* right to left

    ``` Objective-C
    // in SomeComponent.m
    
    ...
    waterfallLayout.column = 3;
    waterfallLayout.renderDirection = EaseWaterfallItemRenderRightToLeft;
    ...
    ```
    
    ![right to left](./Resource/waterfall/right-to-left.png)
    
* orthogonal scroll

    ``` Objective-C
    // in SomeComponent.m
    
    ...
    waterfallLayout.row = 3;
    waterfallLayout.horizontalArrangeContentHeight = 300;
    waterfallLayout.arrange = EaseLayoutArrangeHorizontal;
    waterfallLayout.renderDirection = EaseWaterfallItemRenderBottomToTop;
    ...
    ```
    
    ![orthogonal scroll](./Resource/waterfall/orthogonal-scroll.png)


### sticky header

>  DemoMusicModule

只需要为Component的`headerPin`属性设置为YES，就可以拥有一个黏性的header-view。

### placehold

> DemoLivingModule

以上3中布局效果都支持placehold功能，为Component设置`needPlacehold`以及`placeholdHeight`，然后在`-placeholdCellForItemAtIndex:`中返回对应的place-cell即可，这样在没有数据的时候就会展示对应的占位视图。

由于3种布局都支持水平方向的展示，因此`placeholdHeight`可能会和`horizontalArrangeContentHeight`有计算上的冲突，基于无数据占位显示这样的使用场景，这个时候以`placeholdHeight`为最终的展示高度。

``` objective-c

// in SomeComponent.m

- (instancetype) init{
    self = [super init];
    if (self) {
        self.needPlacehold = YES;
        self.placeholdHeight = 60;
        ...
    }
    return self;
}

- (__kindof UICollectionViewCell *)placeholdCellForItemAtIndex:(NSInteger)index{
    
    DemoPlaceholdCCell * ccell = [self.dataSource dequeueReusablePlaceholdCellOfClass:DemoPlaceholdCCell.class forComponent:self];
    return ccell;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    ...
}

...

```

在Module中将该component进行添加，如果通过`-addDatas:`为component添加的数组有数据，则展示其通过`-cellForItemAtIndex:`指定的cell，如果数组中没有数据就会展示通过`-placeholdCellForItemAtIndex:`指定的占位cell。

``` objective-c

// in SomeModule.m

...

- (void)parseModuleDataWithRequest:(__kindof YTKRequest *)request{

    ...
    [self.dataSource addComponent:({
        SomeComponent * comp = 
        [[SomeComponent alloc] init];
        [comp addDatas:@[]];
        comp;
    })];
    ...
}
```

### decorate

> DemoBackgroundDecorateModule

使用**builder模式**来实现装饰功能，除了提供为section添加背景颜色这样的基础功能外，还增加了`图片`、`渐变`、`阴影`效果，这个主要通过设置builder的`contents`属性来完成，它是`EaseComponentDecorateContents`类的实例。同时还支持设置圆角`radius`，边距`inset`。

除了提供以上功能，还支持背景区域的包含范围，通过设置builder的`decorate`属性来决定，这是一个`EaseComponentDecorate`枚举，它的定义如下：

``` c
typedef NS_ENUM(NSInteger, EaseComponentDecorate) {
    /// 没有背景装饰效果
    EaseComponentDecorateNone,
    /// 只有item
    EaseComponentDecorateOnlyItem,
    /// header+item
    EaseComponentDecorateContainHeader,
    /// item+footer
    EaseComponentDecorateContainFooter,
    /// header+item+footer
    EaseComponentDecorateAll,
};
```

* 背景颜色

    ``` Objective-C
    // in someModule.m
    DemoBackgroundDecorateComponent * comp = [DemoBackgroundDecorateComponent new];
    comp.layout.inset = UIEdgeInsetsMake(100, 20, 10, 20);
    [comp addDecorateWithBuilder:^(id<EaseComponentDecorateAble>  _Nonnull builder) {
        builder.decorate = EaseComponentDecorateAll;
        builder.radius = 4.0f;
        builder.contents = ({
            EaseComponentDecorateContents * contents =
            [EaseComponentDecorateContents colorContents:[UIColor colorWithHexString:@"#8091a5"]];
            contents;
        });
    }];
    ...
    ```
	![color](./Resource/decorate/color.png)

* 图片

    ``` Objective-C
    // in someModule.m
    ...
    [comp addDecorateWithBuilder:^(id<EaseComponentDecorateAble>  _Nonnull builder) {
        builder.decorate = EaseComponentDecorateOnlyItem;
        builder.radius = 10.0f;
        builder.inset = UIEdgeInsetsMake(0, -10, 0, -10);
        builder.contents = ({
            EaseComponentDecorateContents * contents =
            [EaseComponentDecorateContents imageContents:[UIImage imageNamed:@"forbid"]];
            contents;
        });
    }];
    ...
    ```
	![image](./Resource/decorate/image.png)
	
* 渐变

    ``` Objective-C
    ...
    [comp addDecorateWithBuilder:^(id<EaseComponentDecorateAble>  _Nonnull builder) {
        builder.decorate = EaseComponentDecorateOnlyItem;
        builder.radius = 4.0f;
        builder.inset = UIEdgeInsetsMake(0, -10, 0, -10);
        builder.contents = ({
            EaseComponentDecorateContents * contents =
            [EaseComponentDecorateContents gradientContents:^(id<EaseComponentDecorateGradientContentsAble>  _Nonnull contents) {
                contents.startPoint = CGPointMake(0.5, 0);
                contents.endPoint = CGPointMake(0.5, 1);
                contents.colors = @[
                    [UIColor colorWithHexString:@"#FF9E5C"],
                    [UIColor colorWithHexString:@"#FF659F"]
                ];
                contents.locations = @[@(0), @(1.0f)];
            }];
            contents;
        });
    }];
    ```
	![gradient](./Resource/decorate/gradient.png)
	
* 阴影

    ``` Objective-C
    ...
    [comp addDecorateWithBuilder:^(id<EaseComponentDecorateAble>  _Nonnull builder) {
        builder.decorate = EaseComponentDecorateOnlyItem;
        builder.radius = 4.0f;
        builder.inset = UIEdgeInsetsMake(0, -10, 0, -10);
        [builder setContents:({
            EaseComponentDecorateContents * contents =
            [EaseComponentDecorateContents colorContents:[UIColor whiteColor]];
            contents.shadowColor = [UIColor redColor];
            contents.shadowOffset = CGSizeMake(0, 0);
            contents.shadowOpacity = 0.5;
            contents.shadowRadius = 3;
            contents;
        })];
    }];
    ```
	![shadow](./Resource/decorate/shadow.png)
	
### maxDisplay

> DemoSearchModule

最大展示功能在不同的布局中有不同的体现。

比如由于计算的原因，`EaseWaterfallLayout`中只能限制最大展示个数：`maxDisplayCount`。

而在`EaseFlexLayout`中，垂直布局可以分别设置最大显示行数：`maxDisplayLines`以及最大显示个数：`maxDisplayCount`，但是在水平布局中只能设置`maxDisplayCount`。

对于`EaseListLayout`来说，在垂直展示的时候，同时支持`maxDisplayLines`和`maxDisplayCount`，但是在水平布局的时候由于行数可以根据`row`来决定，所以仅支持`maxDisplayCount`。

> 对于既支持`maxDisplayCount`又支持`maxDisplayLines`的layout来说，如果同时设置了这两个属性，最后的计算结果将以`maxDisplayLines`为准，考虑到实际业务情况中并不会这么做，并且这么做也没有意义，但这里还是提前做了准则约束。

### scrolling behavior

仅仅在水平展示效果的时候有用，Component通过设置属性来决定分页效果，为`EaseLayoutHorizontalScrollingBehavior`枚举类型，定义如下：

```objective-c
typedef NS_ENUM(NSInteger, EaseLayoutHorizontalScrollingBehavior) {
    EaseLayoutHorizontalScrollingBehaviorNone,
    EaseLayoutHorizontalScrollingBehaviorContinuous,
    EaseLayoutHorizontalScrollingBehaviorPaging,
    EaseLayoutHorizontalScrollingBehaviorItemPaging,
    EaseLayoutHorizontalScrollingBehaviorCentered,
};
```



## Author

Yrocky, 983272765@qq.com

## Thanks

* [IGListKit](https://github.com/Instagram/IGListKit)
* [IBPCollectionViewCompositionalLayout](https://github.com/kishikawakatsumi/IBPCollectionViewCompositionalLayout)
* [CHTCollectionViewWaterfallLayout](https://github.com/chiahsien/CHTCollectionViewWaterfallLayout)

## License

EaseModule is available under the MIT license. See the LICENSE file for more info.
