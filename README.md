# EaseModule

[![CI Status](https://img.shields.io/travis/Yrocky/EaseModule.svg?style=flat)](https://travis-ci.org/Yrocky/EaseModule)
[![Version](https://img.shields.io/cocoapods/v/EaseModule.svg?style=flat)](https://cocoapods.org/pods/EaseModule)
[![License](https://img.shields.io/cocoapods/l/EaseModule.svg?style=flat)](https://cocoapods.org/pods/EaseModule)
[![Platform](https://img.shields.io/cocoapods/p/EaseModule.svg?style=flat)](https://cocoapods.org/pods/EaseModule)

## Example

进入`example`文件夹，在终端执行`pod install`，然后打开对应的工程文件即可。

Demo共分为Objective-C和Swift两种类型的，前者使用样式比较丰富，后者仅仅用来实现了一个Resume效果。

## Framework

在使用之前可以参考这篇文章，该文章讲述了EaseModule的最初的实现架构。随着参考了更多的app，观察了更多的界面展示 ，逐渐添加了一些比较实用的功能，具体的特性下面会一一介绍。

在前面提到的文章中的架构中，要实现更多样的布局样式比较麻烦，更多的时候需要借助额外的UICollectionViewLayout，并且在多样式混用的时候性能还不是很理想。另外，随着iOS13、14这样的新版本release之后，苹果的主流UI样式也发生了很大的变化，更多的使用圆角，单元素圆角、区域圆角等等，像是为某个section设置背景颜色这种需求，在`UICollectionViewCompositionalLayout`布局出来之后实现起来就更简单了。

在这样的背景下，重新优化了项目的架构，使用一个私有的`EaseModuleFlowLayout : UICollectionViewFlowLayout`布局类来强化布局，为提供更多布局效果的核心，提供`EaseBaseLayout`及子类来完成具体的布局效果，主要是将以前`Layout`部分中的功能分离成常用的布局效果。

## Feature

* 多样、实用的布局
* 黏性header
* 无数据时候的占位效果
* 为section添加背景、阴影效果
* 设置当前section最多展示数量

### layout

目前支持三种主流的布局样式：`list`、`flex`、`waterfall`，`grid布局`目前还在构思中，不日就会添加到项目中。目前的三种layout都支持**垂直**和**水平**两种布局样式。


#### list

常规布局效果，像是UITableView、UICollectionView的展示样式，水平效果的时候，支持设定`row`来决定行数。

* 

#### flex

参考前端的Flex-layout功能，提供`flex-start`、`center`、`flex-end`、`space-around`、`space-between`4中效果来布局cell。改布局的水平效果不支持多行效果，只能显示`1行`。

* flex-start

``` Objective-C

// in SomeComponent.m

EaseFlexLayout * flexLayout = [EaseFlexLayout new];
flexLayout.justifyContent = EaseFlexLayoutFlexStart;
flexLayout.inset = UIEdgeInsetsMake(0, 0, 0, 0);
flexLayout.itemHeight = 30;
flexLayout.delegate = self;
_layout = flexLayout;

```
[flex-start](../Resource/flex-start.png)

* center

``` Objective-C

// in SomeComponent.m

...
flexLayout.justifyContent = EaseFlexLayoutCenter;
...
```

[center](/Resource/center.png)

* flex-end

``` Objective-C

// in SomeComponent.m

...
flexLayout.justifyContent = EaseFlexLayoutFlexEnd;
...
```

[flex-end](Resource/flex-end.png)

* space-around

``` Objective-C

// in SomeComponent.m

...
flexLayout.justifyContent = EaseFlexLayoutSpaceAround;
...
```

[space-around](../Resource/space-around.png)

* space-between

``` Objective-C

// in SomeComponent.m

...
flexLayout.justifyContent = EaseFlexLayoutSpaceBetween;
...
```

[space-between](../Resource/space-between.png)

#### waterfall

瀑布流的布局效果支持3种追加策略：`shortest first`、`left to right`、`right to left`，并且这三种策略在水平和垂直中都支持。另外，水平效果的时候还支持设置行数。

* shortest first

* left to right

* right to left

* orthogonal scroll

### placehold

以上3中布局效果都支持placehold功能，在没有数据的时候为Component设置`needPlacehold`以及`placeholdHeight`，然后返回对应的cell即可。


### decorate

除了提供为section添加背景颜色这样的功能外，还增加了`图片`、`渐变`、`阴影`效果，同时这些功能都支持decorate的区域。

* 背景颜色

* 图片

* 渐变

* 阴影



## Installation

EaseModule is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'EaseModule'
```

由于内部是使用`YTKNetwork`来担当网络请求角色的，所以会依赖`YTKNetwork`，如果有独立的网络层，可以考虑修改源码。

## Author

Yrocky, 983272765@qq.com

## License

EaseModule is available under the MIT license. See the LICENSE file for more info.
