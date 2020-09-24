//
//  DemoSearchComponent.m
//  QILievModule
//
//  Created by rocky on 2020/8/19.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "DemoSearchComponent.h"
#import "EaseAttributedBuilder.h"
#import "DemoSearchCCell.h"

@implementation SearchComponent{
    NSString *_title;
}

- (instancetype)initWithTitle:(NSString *)title{
    self = [super init];
    if (self) {
        _title = title;
    }
    return self;
}

- (NSArray<NSString *> *)supportedElementKinds{
    return @[UICollectionElementKindSectionHeader];
}

- (__kindof UICollectionReusableView *)viewForSupplementaryElementOfKind:(NSString *)elementKind{
    DemoHeaderView * headerView = [self.dataSource dequeueReusableSupplementaryViewOfKind:elementKind forComponent:self clazz:DemoHeaderView.class];
    [headerView setupHeaderTitle:_title];
    return headerView;;
}

- (CGSize)sizeForSupplementaryViewOfKind:(NSString *)elementKind{
    return CGSizeMake(200, 30);
}

@end

@implementation SearchHistoryComponent{
    BOOL _fold;
}

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super initWithTitle:title];
    if (self) {
        EaseFlexLayout * layout = [EaseFlexLayout new];
        layout.inset = UIEdgeInsetsMake(5, 10, 10, 10);
        layout.delegate = self;
        layout.itemHeight = 30;
        layout.maxDisplayLines = 2;
        _layout = layout;
        
        _fold = YES;
    }
    return self;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    DemoContentCCell * ccell = [self.dataSource dequeueReusableCellOfClass:DemoContentCCell.class forComponent:self atIndex:index];
    ccell.contentView.layer.cornerRadius = 15.0f;
    ccell.contentView.layer.masksToBounds = YES;
    [ccell setupWithData:[self dataAtIndex:index]];
    ccell.oneLabel.font = [UIFont systemFontOfSize:15];
    ccell.oneLabel.textAlignment = NSTextAlignmentCenter;
    ccell.oneLabel.textColor = [UIColor redColor];
    return ccell;
}

- (CGSize) layoutCustomItemSize:(EaseFlexLayout *)layout atIndex:(NSInteger)index{
    NSString * category = [self dataAtIndex:index];
    CGSize size = [category YYY_sizeWithFont:[UIFont systemFontOfSize:15]
                                     maxSize:CGSizeMake(CGFLOAT_MAX, layout.itemHeight)];
    size.width = size.width + 30;///30 是字体的左右间距
    size.height = layout.itemHeight;
    return size;
}

- (__kindof UICollectionReusableView *)viewForSupplementaryElementOfKind:(NSString *)elementKind{
    
    @weakify(self);
    SearchHistoryHeaderView * headerView =
    [self.dataSource dequeueReusableSupplementaryViewOfKind:elementKind forComponent:self clazz:SearchHistoryHeaderView.class];
    [headerView setBChangeAction:^(void) {
        @strongify(self);
        [self toggle];
    }];
    [headerView setupFoldState:_fold];
    [headerView setupHeaderTitle:self.title];
    return headerView;;
}

- (void) toggle{
    _fold = !_fold;
    EaseFlexLayout * layout = (EaseFlexLayout *)self.layout;
    layout.maxDisplayLines = _fold ? 2 : EaseLayoutMaxedDisplayValue;
    [self reloadData];
}

@end

@implementation SearchHotRankComponent{
    BOOL _showAllRank;
}

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super initWithTitle:title];
    if (self) {
        EaseListLayout * layout = [EaseListLayout new];
        layout.inset = UIEdgeInsetsMake(5, 10, 10, 10);
        layout.lineSpacing = 1.0f;
        layout.distribution = [EaseLayoutDimension distributionDimension:1];
        layout.itemRatio = [EaseLayoutDimension absoluteDimension:50];
        layout.maxDisplayLines = 4;
        _layout = layout;
    }
    return self;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    DemoContentCCell * ccell = [self.dataSource dequeueReusableCellOfClass:DemoContentCCell.class forComponent:self atIndex:index];
    ccell.oneLabel.textAlignment = NSTextAlignmentLeft;
    ccell.oneLabel.numberOfLines = 1;
    ccell.contentView.layer.cornerRadius = 4.0f;
    ccell.contentView.layer.masksToBounds = YES;
    [ccell setupWithData:({
        [[[EaseAttributedBuilder builderWithString:({
            [NSString stringWithFormat:@"%ld. ",index + 1];
        }) defaultStyle:@{
            NSFontAttributeName : [UIFont systemFontOfSize:23 weight:UIFontWeightMedium],
            NSForegroundColorAttributeName: [UIColor redColor]
        }] appendString:[self dataAtIndex:index] forStyle:@{
            NSFontAttributeName : [UIFont systemFontOfSize:16],
            NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#5C5F66"]
        }] attributedString];
    })];
    return ccell;
}
- (NSArray<NSString *> *)supportedElementKinds{
    if (_showAllRank) {
        return [super supportedElementKinds];
    }
    return @[
        UICollectionElementKindSectionHeader,
        UICollectionElementKindSectionFooter
    ];
}

- (__kindof UICollectionReusableView *)viewForSupplementaryElementOfKind:(NSString *)elementKind{
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader] || _showAllRank) {
        return [super viewForSupplementaryElementOfKind:elementKind];
    }
    @weakify(self);
    SearchRankShowMoreFooterView * footerView =
    [self.dataSource dequeueReusableSupplementaryViewOfKind:elementKind forComponent:self clazz:SearchRankShowMoreFooterView.class];
    [footerView setBChangeAction:^{
        @strongify(self);
        [self onShowAllRank];
    }];
    return footerView;
}

- (CGSize)sizeForSupplementaryViewOfKind:(NSString *)elementKind{
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader] || _showAllRank) {
        return [super sizeForSupplementaryViewOfKind:elementKind];
    }
    return CGSizeMake(300, 40);
}

#pragma mark - private

- (void) onShowAllRank{
    _showAllRank = YES;
    EaseListLayout * layout = (EaseListLayout *)self.layout;
    layout.maxDisplayLines = EaseLayoutMaxedDisplayValue;
    [self reloadData];
}
@end

@implementation SearchRecommendComponent{
    BOOL _showAll;
}

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super initWithTitle:title];
    if (self) {
        EaseWaterfallLayout * layout = [EaseWaterfallLayout new];
        layout.inset = UIEdgeInsetsMake(5, 10, 10, 10);
        layout.maxDisplayCount = 3;
        layout.column = 3;
        layout.delegate = self;
        _layout = layout;
    }
    return self;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    SearchRecommendCCell * ccell = [self.dataSource dequeueReusableCellOfClass:SearchRecommendCCell.class forComponent:self atIndex:index];
    [ccell setupWithData:[self dataAtIndex:index]];
    return ccell;
}

- (NSArray<NSString *> *)supportedElementKinds{
    return @[
        UICollectionElementKindSectionHeader,
        UICollectionElementKindSectionFooter
    ];
}

- (__kindof UICollectionReusableView *)viewForSupplementaryElementOfKind:(NSString *)elementKind{
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        return [super viewForSupplementaryElementOfKind:elementKind];
    }
    @weakify(self);
    SearchRankShowMoreFooterView * footerView =
    [self.dataSource dequeueReusableSupplementaryViewOfKind:elementKind forComponent:self clazz:SearchRankShowMoreFooterView.class];
    [footerView setupTitle:_showAll];
    [footerView setBChangeAction:^{
        @strongify(self);
        [self onShowAll];
    }];
    return footerView;
}

- (CGSize)sizeForSupplementaryViewOfKind:(NSString *)elementKind{
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        return [super sizeForSupplementaryViewOfKind:elementKind];
    }
    return CGSizeMake(300, 40);
}

#pragma mark - EaseWaterfallLayoutDelegate

- (CGSize)layoutCustomItemSize:(EaseWaterfallLayout *)layout atIndex:(NSInteger)index{
    
    CGFloat picHeight = [[self dataAtIndex:index][@"height"] floatValue];
    NSString * title = [self dataAtIndex:index][@"title"];
    CGSize size = [title YYY_sizeWithFont:[UIFont systemFontOfSize:15]
                                  maxSize:CGSizeMake(layout.itemWidth - 8, CGFLOAT_MAX)];
    size.height = size.height + 8 + picHeight;///8 是title的上下间距
    size.width = layout.itemWidth;
    
    return size;;
}

#pragma mark - private

- (void) onShowAll{
    _showAll = !_showAll;
    EaseWaterfallLayout * layout = (EaseWaterfallLayout *)self.layout;
    layout.maxDisplayCount = _showAll ? EaseLayoutMaxedDisplayValue : 3;
    [self reloadData];
}

@end
