//
//  EaseFlexLayout.m
//  EaseModule
//
//  Created by rocky on 2020/8/12.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "EaseFlexLayout.h"

@implementation EaseFlexLayout{
    BOOL _didSetupMaxDisplayLines;
    BOOL _didSetupMaxDisplayCount;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.justifyContent = EaseFlexLayoutFlexStart;
        _maxDisplayLines = EaseLayoutMaxedDisplayValue;
    }
    return self;
}

- (CGFloat)horizontalArrangeContentHeight{
    return self.itemHeight;
}

- (EaseFlexLayoutGravity)justifyContent{
    if (self.arrange == EaseLayoutArrangeHorizontal) {
        return EaseFlexLayoutFlexStart;
    }
    return _justifyContent;
}

- (void)setMaxDisplayLines:(NSInteger)maxDisplayLines{
    _maxDisplayLines = maxDisplayLines;
    _didSetupMaxDisplayLines = YES;
}

- (void)setMaxDisplayCount:(NSInteger)maxDisplayCount{
    _maxDisplayCount = maxDisplayCount;
    _didSetupMaxDisplayCount = YES;
}

- (NSInteger) innerMaxDisplayLines{
    if (self.arrange == EaseLayoutArrangeHorizontal) {
        return 1;
    }
    return MAX(1, MIN(_maxDisplayLines, EaseLayoutMaxedDisplayValue));
}

#pragma mark - calculator Horizontal

- (void) calculatorHorizontalLayoutWithDatas:(NSArray *)datas{
    
    if (self.itemHeight == 0.0f) {
        NSLog(@"[layout]⚠️ 没有设置 self.itemHeight");
        return;
    }
    _contentWidth = 0;
    for (NSInteger index = 0; index < datas.count; index ++) {
        CGFloat itemWidth = 0.0f;
        if ([self.delegate respondsToSelector:@selector(layoutCustomItemSize:atIndex:)]) {
            itemWidth = [self.delegate layoutCustomItemSize:self atIndex:index].width;
        }
        CGSize itemSize = (CGSize){
            itemWidth,self.itemHeight
        };
        CGRect frame = (CGRect){
            _contentWidth,0,
            itemSize
        };
        if (_didSetupMaxDisplayCount &&
            index > self.maxDisplayCount - 1) {
            break;
        }
        [self cacheItemFrame:frame at:index];
        _contentWidth += (itemWidth + self.itemSpacing);
    }
    _contentWidth -= self.itemSpacing;
}

#pragma mark - calculator Vertical

- (void) calculatorVerticalLayoutWithDatas:(NSArray *)datas{
    
    CGFloat maxWidth = 0.0f;
    NSMutableArray<NSValue *> * result = [NSMutableArray new];

    NSMutableArray<NSMutableArray<NSValue *> *> * lines = [NSMutableArray new];
    NSMutableArray<NSValue *> * line = [NSMutableArray new];
    [lines addObject:line];
    NSInteger lineNumber = 1;

    BOOL needDrop = NO;
    
    for (NSInteger index = 0; index < datas.count; index ++) {
        CGFloat itemWidth = 0.0f;
        if ([self.delegate respondsToSelector:@selector(layoutCustomItemSize:atIndex:)]) {
            itemWidth = [self.delegate layoutCustomItemSize:self atIndex:index].width;
        }
        CGSize itemSize = (CGSize){
            MIN(self.insetContainerWidth, itemWidth),
            self.itemHeight
        };

        maxWidth += (itemSize.width + self.itemSpacing);

        if (_didSetupMaxDisplayLines) {
            needDrop = lineNumber > self.innerMaxDisplayLines;
        } else if (_didSetupMaxDisplayCount){
            needDrop = index > self.maxDisplayCount;
        }
        if (needDrop) {
            break;
        }
        
        // 需要换行了
        if ((maxWidth - self.itemSpacing) > self.insetContainerWidth) {
            CGFloat currentLineMaxWidth = maxWidth - self.itemSpacing * 2 - itemSize.width;
            [self _calculatorFlexLayoutLineMaxWidth:currentLineMaxWidth
                                               line:line
                                         lineNumber:lineNumber
                                             result:result];
            maxWidth = itemSize.width + self.itemSpacing;
            [lines removeObject:line];
            line = [NSMutableArray new];
            [lines addObject:line];
            lineNumber ++;
        }
        [line addObject:[NSValue valueWithCGSize:itemSize]];
    }
    
    if (_didSetupMaxDisplayLines) {
        needDrop = lineNumber > self.innerMaxDisplayLines;
    } else if (_didSetupMaxDisplayCount) {
        needDrop = result.count > self.maxDisplayCount;
    }
    
    if (line.count && !needDrop) {
        // 最后一行
        [self _calculatorFlexLayoutLineMaxWidth:maxWidth - self.itemSpacing
                                           line:line
                                     lineNumber:lineNumber
                                         result:result];
    } else if(needDrop){
        lineNumber -= 1;
    }
    _contentHeight = lineNumber * self.itemHeight +
    (lineNumber - 1) * self.lineSpacing;
}

- (void) _calculatorFlexLayoutLineMaxWidth:(CGFloat)lineMaxWidth line:(NSMutableArray<NSValue *> *)line lineNumber:(NSInteger)lineNumber result:(NSMutableArray<NSValue *> *)result{
    /*
     |<--spacing1-->口<-itemSpacing->口<--spacing2-->|
     lineMaxWidth: 口+口+itemSpacing
     totalSpacing: spacing1 + spacing2 + itemSpacing
     totalItemsWidth: = 口+口
    */
    CGFloat totalSpacing = self.insetContainerWidth - lineMaxWidth + (line.count - 1) * self.itemSpacing;
    CGFloat totalItemsWidth = lineMaxWidth - (line.count - 1) * self.itemSpacing;

    __block CGFloat preItemX = 0.0f;
    if (self.justifyContent == EaseFlexLayoutFlexEnd) {
        preItemX = self.insetContainerWidth - lineMaxWidth;
    } else if (self.justifyContent == EaseFlexLayoutCenter) {
        preItemX = (self.insetContainerWidth - lineMaxWidth) / 2.0;
    } else if (self.justifyContent == EaseFlexLayoutSpaceAround){
        preItemX = (self.insetContainerWidth - totalItemsWidth) / (line.count + 1);
    }
    preItemX += self.inset.left;
    // 为line中的元素进行布局
    __block BOOL needContinue = NO;
    [line enumerateObjectsUsingBlock:^(NSValue * item, NSUInteger idx, BOOL * _Nonnull stop) {
        needContinue = [self needContinueWithResultCount:result.count];
        if (needContinue) {
            
            CGSize innerItemSize = item.CGSizeValue;
            CGFloat x = 0;
            CGFloat y = 0;
            if (self.justifyContent == EaseFlexLayoutFlexStart ||
                self.justifyContent == EaseFlexLayoutFlexEnd ||
                self.justifyContent == EaseFlexLayoutCenter) {
                x = preItemX;
                preItemX += (innerItemSize.width + self.itemSpacing);
            } else if (self.justifyContent == EaseFlexLayoutSpaceBetween){
                x = preItemX;
                preItemX += (innerItemSize.width + totalSpacing / (line.count - 1));
            } else {
                x = preItemX;
                preItemX += (innerItemSize.width + totalSpacing / (line.count + 1));
            }
            y = (lineNumber - 1) * (innerItemSize.height + self.lineSpacing);
            CGRect frame = (CGRect){
                CGPointMake(x, y), innerItemSize
            };
            // cache
            [self cacheItemFrame:frame at:result.count];
            [result addObject:[NSValue valueWithCGRect:frame]];
        }
    }];
}

- (BOOL) needContinueWithResultCount:(NSInteger)resultCount{
    if (_didSetupMaxDisplayCount) {
        return resultCount < self.maxDisplayCount;
    }
    return YES;
}
@end
