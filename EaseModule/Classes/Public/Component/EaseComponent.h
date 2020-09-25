//
//  EaseComponent.h
//  EaseModule
//
//  Created by rocky on 2020/7/9.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EaseModuleDataSourceAble.h"
#import "EaseBaseLayout.h"
#import "EaseComponentDecorateContents.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, EaseComponentArrange) {
    /// 垂直
    EaseComponentArrangeVertical,
    /// 水平
    EaseComponentArrangeHorizontal,
}NS_SWIFT_NAME(EaseComponent.Arrange);

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
};//NS_SWIFT_NAME(EaseComponent.Decorate);
//Warning: 这里不能够使用NS_SWIFT_NAME

@protocol EaseComponentDecorateAble <NSObject>

@property (nonatomic ,assign) EaseComponentDecorate decorate;

@property (nonatomic ,assign) CGFloat radius;
@property (nonatomic ,assign) UIEdgeInsets inset;

// color/image/gradient
@property (nonatomic ,strong) EaseComponentDecorateContents * contents;

@end

@interface EaseComponent : NSObject{
    NSMutableArray *_innerDatas;
    __kindof EaseBaseLayout * _layout;
}

@property (nonatomic, weak, readonly) id<EaseModuleDataSourceAble> dataSource;
/*
 是否需要独立请求数据，有的comp需要自己请求数据，
 有的comp是在一个统一的接口中返回数据，default NO
 */
@property (nonatomic ,assign) BOOL independentDatas;
/*
 是否需要使用占位视图，在empty的时候回返回一个数据用来展示占位,default NO
 */
@property (nonatomic ,assign) BOOL needPlacehold;
/*
 当需要展示占位视图的时候的展示高度，仅在 needPlacehold 为YES的时候有用
 */
@property (nonatomic ,assign) CGFloat placeholdHeight;
/*
 当没有数据的时候，不在UI中展示，default NO
 */
@property (nonatomic ,assign) BOOL hiddenWhenEmpty;
/*
 arrange == EaseComponentArrangeHorizontal
 */
@property (nonatomic ,assign ,readonly) BOOL isOrthogonallyScrolls;
/*
 布局
 */
@property (nonatomic ,strong ,readonly) __kindof EaseBaseLayout * layout;
/*
 headerView是否要黏性
 */
@property (nonatomic ,assign) BOOL headerPin;

// 在DataSource中的索引
@property (nonatomic ,assign ,readonly) NSInteger index;

- (void) setupLayout:(__kindof EaseBaseLayout *)layout NS_SWIFT_NAME(setup(_:));

- (void) addData:(id)data NS_SWIFT_NAME(add(data:));
- (void) addDatas:(NSArray *)datas NS_SWIFT_NAME(add(datas:));

- (id) dataAtIndex:(NSInteger)index NS_SWIFT_NAME(dataAt(_:));

- (NSInteger)numberOfItems;

@property (nonatomic ,copy ,readonly) NSArray * datas;

- (BOOL) empty;

- (void) clear;

// 刷新当前component
- (void) reloadData;
- (void) reloadDataAt:(NSArray<NSNumber *> *)indexs;
@end

@interface EaseComponent (SubclassOverride)

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index;
- (__kindof UICollectionViewCell *)placeholdCellForItemAtIndex:(NSInteger)index;

#pragma mark - event

- (void)didSelectItemAtIndex:(NSInteger)index;
- (void)didDeselectItemAtIndex:(NSInteger)index;
- (void)didHighlightItemAtIndex:(NSInteger)index;
- (void)didUnhighlightItemAtIndex:(NSInteger)index;

@end

@interface EaseComponent (Supplementary)

- (NSArray<NSString *> *)supportedElementKinds;
- (__kindof UICollectionReusableView *)viewForSupplementaryElementOfKind:(NSString *)elementKind;
- (CGSize)sizeForSupplementaryViewOfKind:(NSString *)elementKind;
- (UIEdgeInsets) insetForSupplementaryViewOfKind:(NSString *)elementKind;

@end

/// 背景修饰
@interface EaseComponent (BackgroundDecorate)

- (void) addDecorateWithBuilder:(void(^)(id<EaseComponentDecorateAble>builder))builder  NS_SWIFT_NAME(addDecorate(with:));
@end

NS_ASSUME_NONNULL_END
