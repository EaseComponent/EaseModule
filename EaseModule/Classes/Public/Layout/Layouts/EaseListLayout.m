//
//  EaseListLayout.m
//  EaseModule
//
//  Created by rocky on 2020/8/12.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "EaseListLayout.h"
#import "EaseBaseLayout_Private.h"

typedef NS_ENUM(NSUInteger, EaseLayoutSemantic) {
    
    EaseLayoutSemanticNormal,
    
    EaseLayoutSemanticEmbed,
    EaseLayoutSemanticAbsolute,
    EaseLayoutSemanticFractional,
};

@interface EaseLayoutDimension ()

@property (nonatomic, readwrite) CGFloat value;
@property (nonatomic) EaseLayoutSemantic semantic;

@property (nonatomic, readonly) BOOL isEmbed;
@property (nonatomic, readonly) BOOL isAbsolute;
@property (nonatomic, readonly) BOOL isFractional;
@end

@implementation EaseListLayout{
    CGFloat _itemWidth;
    CGFloat _itemHeight;
    BOOL _didSetupMaxDisplayLines;
    BOOL _didSetupMaxDisplayCount;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.row = NSNotFound;
        _maxDisplayLines = EaseLayoutMaxedDisplayValue;
    }
    return self;
}

- (void)setMaxDisplayLines:(NSInteger)maxDisplayLines{
    _maxDisplayLines = maxDisplayLines;
    _didSetupMaxDisplayLines = YES;
}

- (void)setMaxDisplayCount:(NSInteger)maxDisplayCount{
    _maxDisplayCount = maxDisplayCount;
    _didSetupMaxDisplayCount = YES;
}

- (NSInteger)innerMaxDisplayLines{
    if (self.arrange == EaseLayoutArrangeHorizontal) {
        return 1;
    }
    return MAX(1, MIN(_maxDisplayLines, EaseLayoutMaxedDisplayValue));
}

- (void) _calculatorItemSize{
    
    CGFloat width = 0;
    CGFloat height = 0;
    
    // distribution -> width
    if (self.distribution.isAbsolute) {
        width = self.distribution.value;
    } else if (self.distribution.isFractional) {
        width = self.insetContainerWidth * MIN(1, self.distribution.value);
    } else {
        NSInteger count = MAX(1, self.distribution.value);
        width = (self.insetContainerWidth - (count - 1) * self.itemSpacing) / count;
    }
    // itemRatio -> height
    if (nil == self.itemRatio) {
        self.itemRatio = [EaseLayoutDimension fractionalDimension:1];
    }
    if (self.itemRatio.isAbsolute) {
        height = self.itemRatio.value;
    } else if (self.itemRatio.isFractional){
        height = width / MAX(0.01, self.itemRatio.value);
    } else {
        NSLog(@"[layout]⚠️ itemRatio不支持其他类型的Dimension");
    }
    _itemWidth = width;
    _itemHeight = height;
}

#pragma mark - calculator Horizontal

- (void)calculatorHorizontalLayoutWithDatas:(NSArray *)datas{
    
    [self _calculatorItemSize];
    
    if (self.row != NSNotFound) {
        // 根据row计算出来 horizontalArrangeContentHeight
        self.horizontalArrangeContentHeight = ({
            self.row * _itemHeight +
            (self.row - 1) * self.lineSpacing;
        });
    } else if (self.horizontalArrangeContentHeight == 0.0f) {
        // 既没有设置 row 也没有设置 horizontalArrangeContentHeight
        NSLog(@"[layout]⚠️ 既没有设置 row 也没有设置 horizontalArrangeContentHeight");
        return;
    }
    
    // for safe
    _itemHeight = MIN(self.horizontalArrangeContentHeight, _itemHeight);
    
    NSArray * maxDisplayCountDatas = datas;
    if (self.maxDisplayCount <= datas.count && _didSetupMaxDisplayCount) {
        maxDisplayCountDatas = [datas subarrayWithRange:NSMakeRange(0, self.maxDisplayCount)];
    }
    
    CGFloat maxY = 0;
    CGFloat maxX = 0;
    BOOL lastOneNeedShift = NO;
    for (NSInteger index = 0; index < maxDisplayCountDatas.count; index ++) {
        
        CGRect frame = (CGRect){
            maxX,maxY,
            (CGSizeMake(_itemWidth, _itemHeight))
        };
        lastOneNeedShift = CGRectGetMaxY(frame) > self.horizontalArrangeContentHeight;
        if (lastOneNeedShift) {
            // 需要换行
            maxY = 0;
            maxX += (_itemWidth + self.itemSpacing);
            frame.origin.x = maxX;
            frame.origin.y = maxY;
        }
        
        [self cacheItemFrame:frame at:index];
        // 更新y
        maxY += (_itemHeight + self.lineSpacing);
    }
    if (_didSetupMaxDisplayCount &&
        self.maxDisplayCount < self.row) {
        self.horizontalArrangeContentHeight =
        self.maxDisplayCount * _itemHeight + (self.maxDisplayCount - 1) * self.lineSpacing;
    }
    _contentWidth = CGRectGetMaxX([self itemFrameAtIndex:maxDisplayCountDatas.count - 1]);
}

#pragma mark - calculator Vertical

- (void) calculatorVerticalLayoutWithDatas:(NSArray *)datas{
    
    [self _calculatorItemSize];

    __block CGFloat maxY = 0;
    __block CGFloat maxX = self.inset.left;
    
    NSInteger lineNumber = 1;
    BOOL needDrop = NO;
    
    for (NSInteger index = 0; index < datas.count; index ++) {
        CGFloat x = maxX;
        CGFloat y = maxY;
        CGRect frame = (CGRect){
            x,y,
            _itemWidth,_itemHeight
        };
        if (_didSetupMaxDisplayLines) {
            needDrop = lineNumber > self.innerMaxDisplayLines;
        } else if (_didSetupMaxDisplayCount) {
            needDrop = index >= self.maxDisplayCount;
        }
        
        if (needDrop) {
            break;
        }
        // cache
        [self cacheItemFrame:frame at:index];
        maxX += (_itemWidth + self.itemSpacing);
        if (maxX > self.insetContainerWidth) {
            // 换行
            maxX = self.inset.left;
            maxY += (_itemHeight + self.lineSpacing);
            lineNumber ++;
        }
        _contentHeight = CGRectGetMaxY(frame);
    }
}

@end

@implementation EaseLayoutDimension

+ (instancetype)distributionDimension:(NSInteger)value{
    return [[self alloc] initWithDistribution:(CGFloat)value
                                     semantic:EaseLayoutSemanticNormal];
}
+ (instancetype)absoluteDimension:(CGFloat)value{
    return [[self alloc] initWithDistribution:value
                                     semantic:EaseLayoutSemanticAbsolute];
}
+ (instancetype)fractionalDimension:(CGFloat)value{
    return [[self alloc] initWithDistribution:value
                                     semantic:EaseLayoutSemanticFractional];
}
- (instancetype)initWithDistribution:(CGFloat)distribution
                            semantic:(EaseLayoutSemantic)semantic {

    self = [super init];
    if (self) {
        self.value = distribution;
        self.semantic = semantic;
    }
    return self;
}

- (BOOL)isEmbed{
    return self.semantic == EaseLayoutSemanticEmbed;
}

- (BOOL)isAbsolute{
    return self.semantic == EaseLayoutSemanticAbsolute;
}

- (BOOL)isFractional{
    return self.semantic == EaseLayoutSemanticFractional;
}

@end
