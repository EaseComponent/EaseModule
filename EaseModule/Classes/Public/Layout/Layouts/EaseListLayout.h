//
//  EaseListLayout.h
//  EaseModule
//
//  Created by rocky on 2020/8/12.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "EaseBaseLayout.h"

NS_ASSUME_NONNULL_BEGIN

@class EaseLayoutDimension;
/*
 在水平布局中，如果 通过 `distribution` 和 `itemRatio`计算出来的 cell高度大于 `horizontalArrangeContentHeight`，则会限制为`horizontalArrangeContentHeight`
 如果小于则会按照`从上之下、从左至右`的顺序进行排列，
 
 另外，还可以设置`row`来决定 `horizontalArrangeContentHeight`，
 此时设置 `horizontalArrangeContentHeight`将无效
 */
@interface EaseListLayout : EaseBaseLayout
/*
 用来决定cell的宽度
 可以设置根据 `insetContainerWidth` 的`比例`、`等分`或者`固定数值`三种
 */
@property (nonatomic ,strong) EaseLayoutDimension * distribution;
/*
 用来决定cell的高度，可以设置`宽高比`、`固定值`
 只支持 Fractional和 Absolute两种类型
*/
@property (nonatomic ,strong) EaseLayoutDimension * itemRatio;
/*
 当 arrange 为 ...Horizontal 的时候，可以通过这个来便捷计算出来cell的高度，
 如果设置了row，设置的horizontalArrangeContentHeight 将无效
 */
@property (nonatomic ,assign) NSInteger row;
/*
 最多可以展示多少行，[1,+∞]
 当为 `EaseLayoutMaxedDisplayValue`的时候表示根据具体数据展示多少行
 仅在 arrange 为 ...Vertical 的时候有效，
 为 ...Horizontal的时候无效，根据设置的row来决定行数
 */
@property (nonatomic ,assign) NSInteger maxDisplayLines;
/*
 最多可以展示多少个，[1,+∞]
 当为 `EaseLayoutMaxedDisplayValue`的时候表示根据具体数据展示多少个元素
 */
@property (nonatomic ,assign) NSInteger maxDisplayCount;

@end

@interface EaseLayoutDimension : NSObject
/*
 等分数
 */
+ (instancetype)distributionDimension:(NSInteger)value NS_SWIFT_NAME(distribution(_:));
/*
 固定数值
 */
+ (instancetype)absoluteDimension:(CGFloat)value NS_SWIFT_NAME(absolute(_:));
/*
 比例
 */
+ (instancetype)fractionalDimension:(CGFloat)value NS_SWIFT_NAME(fractional(_:));

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, readonly) CGFloat value;

- (BOOL)isAbsolute;
- (BOOL)isFractional;

@end

NS_ASSUME_NONNULL_END
