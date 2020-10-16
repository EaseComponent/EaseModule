//
//  DemoNewsComponent.m
//  EaseModule_Example
//
//  Created by rocky on 2020/9/28.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "DemoNewsComponent.h"
#import "DemoNewsCCell.h"
#import "DemoContentCCell.h"

@implementation NewsInfoComponent

- (instancetype)init
{
    self = [super init];
    if (self) {
        EaseWaterfallLayout * layout = [EaseWaterfallLayout new];
        layout.column = 1;
        layout.delegate = self;
        _layout = layout;
    }
    return self;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    
    NewsInfoCCell * ccell = [self.dataSource dequeueReusableCellOfClass:NewsInfoCCell.class forComponent:self atIndex:index];
    [ccell setupWithData:[self dataAtIndex:index]];
    return ccell;
}

#pragma mark - EaseWaterfallLayoutDelegate

- (CGSize)layoutCustomItemSize:(EaseWaterfallLayout *)layout atIndex:(NSInteger)index{

    NSDictionary * data = [self dataAtIndex:index];
    CGSize size = [data[@"title"] YYY_sizeWithFont:({
        [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    }) maxSize:CGSizeMake(layout.insetContainerWidth - 10, CGFLOAT_MAX)];
    size.height += (5 + 4 + 20 + 5);
    
    return size;
}

@end

@interface NewsContentComponent ()<
NewsContentCCellDelegate>
@end

@implementation NewsContentComponent{
    CGFloat _height;
    BOOL _didUpdateHeight;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        EaseWaterfallLayout * layout = [EaseWaterfallLayout new];
        layout.column = 1;
        layout.delegate = self;
        _layout = layout;
        
        _height = 200;
    }
    return self;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    NewsContentCCell * ccell = [self.dataSource dequeueReusableCellOfClass:NewsContentCCell.class forComponent:self atIndex:index];
    ccell.delegate = self;
    [ccell setupWithData:[self dataAtIndex:index]];
    ccell.layer.cornerRadius = 0;
    return ccell;
}

- (void)clear{
    [super clear];
    _didUpdateHeight = NO;
    _height = 200;
}
#pragma mark - EaseWaterfallLayoutDelegate

- (CGSize)layoutCustomItemSize:(EaseWaterfallLayout *)layout atIndex:(NSInteger)index{
    return CGSizeMake(10, _height);
}

#pragma mark - NewsContentCCellDelegate

- (void)newsContentCCell:(NewsContentCCell *)ccell didFinishUpdateHeight:(CGFloat)height{
    if (_didUpdateHeight) {
        return;
    }
    _height = height + 280;
    [self reloadData];
    _didUpdateHeight = YES;
}
@end

@implementation NewsKeywordComponent

- (instancetype)init
{
    self = [super init];
    if (self) {
        EaseFlexLayout * layout = [EaseFlexLayout new];
        layout.itemHeight = 30.0f;
        layout.delegate = self;
        layout.maxDisplayLines = 2;
        _layout = layout;
    }
    return self;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    NewsKeywordCCell * ccell = [self.dataSource dequeueReusableCellOfClass:NewsKeywordCCell.class forComponent:self atIndex:index];
    [ccell setupWithData:[self dataAtIndex:index]];
    return ccell;
}

- (NSArray<NSString *> *)supportedElementKinds{
    return @[
        UICollectionElementKindSectionHeader
    ];
}

- (__kindof UICollectionReusableView *)viewForSupplementaryElementOfKind:(NSString *)elementKind{
    DemoHeaderView * headerView = [self.dataSource dequeueReusableSupplementaryViewOfKind:elementKind forComponent:self clazz:DemoHeaderView.class];
    headerView.titleLabel.textColor = [UIColor colorWithHexString:@"#5B5B5B"];
    [headerView setupHeaderTitle:@"关键词"];
    return headerView;
}

- (CGSize)sizeForSupplementaryViewOfKind:(NSString *)elementKind{
    return CGSizeMake(200, 40);
}

#pragma mark - EaseFlexLayoutDelegate

- (CGSize)layoutCustomItemSize:(EaseFlexLayout *)layout atIndex:(NSInteger)index{

    CGSize size = [[self dataAtIndex:index] YYY_sizeWithFont:({
        [UIFont boldSystemFontOfSize:13];
    }) maxSize:CGSizeMake(CGFLOAT_MAX,layout.itemHeight)];
    size.width += 30;
    
    return size;
}

@end

@implementation NewsRecommendComponent

- (instancetype)init
{
    self = [super init];
    if (self) {
        EaseListLayout * layout = [EaseListLayout new];
        layout.inset = UIEdgeInsetsMake(0, 10, 10, 10);
        layout.lineSpacing = 4.0f;
        layout.itemSpacing = 4.0f;
        layout.arrange = EaseLayoutArrangeHorizontal;
        layout.row = 1;
        layout.distribution = [EaseLayoutDimension fractionalDimension:0.4];
        layout.itemRatio = [EaseLayoutDimension fractionalDimension:2.0];
        _layout = layout;
    }
    return self;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    NewsRecommendCCell * ccell = [self.dataSource dequeueReusableCellOfClass:NewsRecommendCCell.class forComponent:self atIndex:index];
    [ccell setupWithData:[self dataAtIndex:index]];
    return ccell;
}

- (NSArray<NSString *> *)supportedElementKinds{
    return @[
        UICollectionElementKindSectionHeader
    ];
}

- (__kindof UICollectionReusableView *)viewForSupplementaryElementOfKind:(NSString *)elementKind{
    DemoHeaderView * headerView = [self.dataSource dequeueReusableSupplementaryViewOfKind:elementKind forComponent:self clazz:DemoHeaderView.class];
    headerView.titleLabel.textColor = [UIColor colorWithHexString:@"#5B5B5B"];
    [headerView setupHeaderTitle:@"相关新闻"];
    return headerView;
}

- (CGSize)sizeForSupplementaryViewOfKind:(NSString *)elementKind{
    return CGSizeMake(200, 40);
}
@end

