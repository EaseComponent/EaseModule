//
//  EaseWaterfallLayout.m
//  EaseModule
//
//  Created by rocky on 2020/8/12.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "EaseWaterfallLayout.h"

@interface EaseWaterfallLayout ()
@property (nonatomic ,strong) NSMutableArray * columnHeights;
@property (nonatomic ,strong) NSMutableArray * rowWidths;
@end

@implementation EaseWaterfallLayout

- (instancetype)init{
    self = [super init];
    if (self) {
        self.column = self.row = 1;
        self.maxDisplayCount = EaseLayoutMaxedDisplayValue;
    }
    return self;
}

- (CGFloat)itemWidth{
    return (self.insetContainerWidth - (self.column - 1) * self.itemSpacing) / self.column;
}

- (CGFloat)itemHeight{
    return (self.horizontalArrangeContentHeight - (self.row - 1) * self.itemSpacing) / self.row;
}

#pragma mark - override

- (void)clear{
    [super clear];
    [_columnHeights removeAllObjects];
    [_rowWidths removeAllObjects];
}

#pragma mark - calculator Horizontal

- (void)calculatorHorizontalLayoutWithDatas:(NSArray *)datas{
    
    if (self.horizontalArrangeContentHeight == 0.0f) {
        NSLog(@"[layout]⚠️ 没有设置 horizontalArrangeContentHeight");
        return;
    }
    if (self.renderDirection == EaseWaterfallItemRenderLeftToRight ||
        self.renderDirection == EaseWaterfallItemRenderRightToLeft) {
        NSLog(@"[layout] ⚠️ 水平布局的时候请设置正确的 renderDirection");
        return;
    }
    // 初始化每一列的最大值
    for (NSInteger index = 0; index < self.row; index ++) {
        [self.rowWidths addObject:@(0)];
    }

    CGFloat height = (self.horizontalArrangeContentHeight - (self.row - 1) * self.lineSpacing) / self.row;
    CGFloat width = 0.0f;
    
    for (NSInteger index = 0; index < datas.count; index ++) {
        if (index > self.maxDisplayCount - 1) {
            break;
        }
        if ([self.delegate respondsToSelector:@selector(layoutCustomItemSize:atIndex:)]) {
            width = [self.delegate layoutCustomItemSize:self atIndex:index].width;
        }
        NSUInteger rowIndex = [self _nextRowIndexForItem:index];
        CGFloat y = (height + self.lineSpacing) * rowIndex;
        CGFloat x = [self.rowWidths[rowIndex] floatValue];
        CGRect frame = CGRectMake(x, y, width, height);
        self.rowWidths[rowIndex] = @(CGRectGetMaxX(frame) + self.lineSpacing);
        // cache
        [self cacheItemFrame:frame at:index];
    }
    _contentWidth = [self _longestRowWidth] - self.itemSpacing;
}

#pragma mark - calculator Vertical

- (void) calculatorVerticalLayoutWithDatas:(NSArray *)datas{
    
    if (self.renderDirection == EaseWaterfallItemRenderTopToBottom ||
        self.renderDirection == EaseWaterfallItemRenderBottomToTop) {
        NSLog(@"[layout] ⚠️ 垂直布局的时候请设置正确的 renderDirection");
        return;
    }
    
    // 初始化每一列的最大值
    for (NSInteger index = 0; index < self.column; index ++) {
        [self.columnHeights addObject:@(0)];
    }

    CGFloat width = (self.insetContainerWidth - (self.column - 1) * self.itemSpacing) / self.column;
    CGFloat height = 0.0f;
    
    for (NSInteger index = 0; index < datas.count; index ++) {
            
        if (index > self.maxDisplayCount - 1) {
            break;
        }
        if ([self.delegate respondsToSelector:@selector(layoutCustomItemSize:atIndex:)]) {
            height = [self.delegate layoutCustomItemSize:self atIndex:index].height;
        }
        NSUInteger columnIndex = [self _nextColumnIndexForItem:index];

        CGFloat x = (width + self.itemSpacing) * columnIndex + self.inset.left;
        CGFloat y = [self.columnHeights[columnIndex] floatValue];
        CGRect frame = CGRectMake(x, y, width, height);
        self.columnHeights[columnIndex] = @(CGRectGetMaxY(frame) + self.lineSpacing);
        // cache
        [self cacheItemFrame:frame at:index];
    }
    _contentHeight = [self _longestColumnHeight] - self.lineSpacing;
}

#pragma mark - private

- (NSUInteger) _nextColumnIndexForItem:(NSInteger)item {

    NSUInteger index = 0;
    if (self.renderDirection == EaseWaterfallItemRenderLeftToRight) {
        index = (item % self.column);
    } else if (self.renderDirection == EaseWaterfallItemRenderRightToLeft) {
        index = (self.column - 1) - (item % self.column);
    } else {
        index = [self _shortestColumnIndex];
    }
    return index;
}

- (NSUInteger) _shortestColumnIndex{
    __block NSUInteger index = 0;
    __block CGFloat shortestHeight = MAXFLOAT;

    [self.columnHeights enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat height = [obj floatValue];
        if (height < shortestHeight) {
            shortestHeight = height;
            index = idx;
        }
    }];
    return index;
}

- (CGFloat) _longestColumnHeight{
    __block CGFloat longestHeight = 0;
    [self.columnHeights enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat height = [obj floatValue];
        if (height > longestHeight) {
            longestHeight = height;
        }
    }];
    return longestHeight;
}

- (NSUInteger) _nextRowIndexForItem:(NSInteger)item {

    NSUInteger index = 0;
    if (self.renderDirection == EaseWaterfallItemRenderTopToBottom) {
        index = (item % self.row);
    } else if (self.renderDirection == EaseWaterfallItemRenderBottomToTop) {
        index = (self.row - 1) - (item % self.row);
    } else {
        index = [self _shortestRowIndex];
    }
    return index;
}

- (NSUInteger) _shortestRowIndex{
    __block NSUInteger index = 0;
    __block CGFloat shortestWidth = MAXFLOAT;

    [self.rowWidths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat width = [obj floatValue];
        if (width < shortestWidth) {
            shortestWidth = width;
            index = idx;
        }
    }];
    return index;
}

- (CGFloat) _longestRowWidth{
    __block CGFloat longestWidth = 0;
    [self.rowWidths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat width = [obj floatValue];
        if (width > longestWidth) {
            longestWidth = width;
        }
    }];
    return longestWidth;
}

#pragma mark - Getter

- (NSMutableArray *)columnHeights{
    
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray new];
    }
    return _columnHeights;;
}

- (NSMutableArray *)rowWidths{
    
    if (!_rowWidths) {
        _rowWidths = [NSMutableArray new];
    }
    return _rowWidths;;
}
@end
