//
//  EaseWaterfallLayout.h
//  EaseModule
//
//  Created by rocky on 2020/8/12.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "EaseBaseLayout.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSUInteger, EaseWaterfallItemRenderDirection) {
    EaseWaterfallItemRenderShortestFirst = 0,
    EaseWaterfallItemRenderLeftToRight = 1, // 只有 arrange = ..Vertical的时候有效
    EaseWaterfallItemRenderRightToLeft = 2, // 只有 arrange = ..Vertical的时候有效
    EaseWaterfallItemRenderTopToBottom = 3, // 只有 arrange = ..Horizontal的时候有效
    EaseWaterfallItemRenderBottomToTop = 4, // 只有 arrange = ..Horizontal的时候有效
} NS_SWIFT_NAME(EaseWaterfallLayout.RenderDirection);

@protocol EaseWaterfallLayoutDelegate;
@interface EaseWaterfallLayout : EaseBaseLayout

@property (nonatomic ,assign) EaseWaterfallItemRenderDirection renderDirection;

@property (nonatomic ,weak) id<EaseWaterfallLayoutDelegate> delegate;
/*
 当 arrange 为 ...Vertical 的时候
 决定一共有几列
*/
@property (nonatomic ,assign) NSInteger column;
/*
 当 arrange 为 ...Vertical 的时候
 根据 column、spacing、insets 得出cell的宽度
*/
@property (nonatomic ,assign ,readonly) CGFloat itemWidth;
/*
 当 arrange 为 ...Horizontal 的时候
 决定一共有几行
 */
@property (nonatomic ,assign) NSInteger row;
/*
 当 arrange 为 ...Horizontal 的时候
 根据 row、spacing、insets 得出cell的高度
 */
@property (nonatomic ,assign ,readonly) CGFloat itemHeight;

@end

@protocol EaseWaterfallLayoutDelegate <NSObject>
/*
 当 arrange 为 ...Vertical 的时候，返回的size.width可以是任意值
 当 arrange 为 ...Horizontal 的时候，返回的size.height可以是任意值
 */
- (CGSize) layoutCustomItemSize:(EaseWaterfallLayout *)layout atIndex:(NSInteger)index;
@end
NS_ASSUME_NONNULL_END
