//
//  EaseFlexLayout.h
//  EaseModule
//
//  Created by rocky on 2020/8/12.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "EaseBaseLayout.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, EaseFlexLayoutGravity) {
    /*
     |口口口........|
     */
    EaseFlexLayoutFlexStart =     0,
    /*
     |........口口口|
     */
    EaseFlexLayoutFlexEnd =       1,
    /*
     |....口口口....|
     */
    EaseFlexLayoutCenter =        2,
    /*
     |口....口....口|
     */
    EaseFlexLayoutSpaceBetween =  3,
    /*
     |..口..口..口..|
     */
    EaseFlexLayoutSpaceAround =   4,
} NS_SWIFT_NAME(EaseFlexLayout.Gravity);

@protocol EaseFlexLayoutDelegate;
@interface EaseFlexLayout : EaseBaseLayout
/*
 如果是水平布局，horizontalArrangeHeight 的值将等于 itemHeight
 设置 horizontalArrangeContentHeight 无效
 */
@property (nonatomic ,assign) CGFloat itemHeight;

/*
 当 arrange 为 ...Horizontal 的时候
 justifyContent 固定为 EaseFlexLayoutFlexStart，设置无效
*/
@property (nonatomic ,assign) EaseFlexLayoutGravity justifyContent;

@property (nonatomic ,weak) id<EaseFlexLayoutDelegate> delegate;
@end

@protocol EaseFlexLayoutDelegate <NSObject>
/*
 返回的size.height可以是任意值，内部会使用 itemHeight
*/
- (CGSize) layoutCustomItemSize:(EaseFlexLayout *)layout atIndex:(NSInteger)index;
@end
NS_ASSUME_NONNULL_END
