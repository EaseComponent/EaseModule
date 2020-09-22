//
//  EaseBaseLayout.h
//  EaseModule
//
//  Created by rocky on 2020/8/12.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, EaseLayoutArrange) {
    /// 垂直
    EaseLayoutArrangeVertical,
    /// 水平
    EaseLayoutArrangeHorizontal,
};

typedef NS_ENUM(NSInteger, EaseLayoutHorizontalScrollingBehavior) {
    EaseLayoutHorizontalScrollingBehaviorNone,
    EaseLayoutHorizontalScrollingBehaviorContinuous,
    EaseLayoutHorizontalScrollingBehaviorPaging,
    EaseLayoutHorizontalScrollingBehaviorItemPaging,
    EaseLayoutHorizontalScrollingBehaviorCentered,
};

@protocol EaseModuleEnvironment;
@interface EaseBaseLayout : NSObject{
    NSMutableDictionary * _cacheItemFrame;
    /// 减去insets的left、right之后的宽度
    CGFloat _insetContainerWidth;
    CGFloat _contentWidth;
    CGFloat _contentHeight;
}

@property (nonatomic ,strong ,readonly) id<EaseModuleEnvironment> environment;

/// default zero
@property (nonatomic ,assign) UIEdgeInsets inset;
@property (nonatomic ,assign ,readonly) CGFloat insetContainerWidth;

/*
 行间距，default 5
 */
@property (nonatomic ,assign) CGFloat lineSpacing;
/*
 视图之间的水平间距，default 5
 */
@property (nonatomic ,assign) CGFloat itemSpacing;
/*
 经过计算之后的内容宽度，仅用于 arrange = EaseLayoutArrangeHorizontal
 */
@property (nonatomic ,assign ,readonly) CGFloat contentWidth;
/*
 经过计算之后的内容高度，仅用于 arrange = EaseLayoutArrangeVertical
 */
@property (nonatomic ,assign ,readonly) CGFloat contentHeight;
/*
 layout的布局方向，默认为 EaseLayoutArrangeVertical 垂直
 */
@property (nonatomic ,assign) EaseLayoutArrange arrange;
/*
 arrange = EaseLayoutArrangeHorizontal 的时候
 限制垂直方向的高度
 */
@property (nonatomic ,assign) CGFloat horizontalArrangeContentHeight;
/*
 arrange = EaseLayoutArrangeHorizontal 的时候
 内嵌ScrollView的滚动效果
 */
@property (nonatomic ,assign) EaseLayoutHorizontalScrollingBehavior horizontalScrollingBehavior;

/*
 缓存每一个索引下的frame，子类调用
 */
- (void) cacheItemFrame:(CGRect)itemFrame at:(NSInteger)index;
/*
 清除缓存的frame
 */
- (void) clear;
@end

@interface EaseBaseLayout (SubclassingOverride)
/*
 计算水平布局情况下的cell位置
 */
- (void) calculatorHorizontalLayoutWithDatas:(NSArray *)datas;
/*
 计算垂直布局情况下的cell位置
*/
- (void) calculatorVerticalLayoutWithDatas:(NSArray *)datas;
@end

NS_ASSUME_NONNULL_END
