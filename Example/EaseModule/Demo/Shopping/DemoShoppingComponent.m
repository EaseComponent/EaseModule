//
//  DemoShoppingComponent.m
//  QILievModule
//
//  Created by rocky on 2020/8/25.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "DemoShoppingComponent.h"
#import "DemoShoppingCCell.h"

@implementation ShoppingComponent

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.independentDatas = YES;
    }
    return self;
}

- (NSString *) title{
    return @"";
}

- (NSArray<NSString *> *)supportedElementKinds{
    return @[
        UICollectionElementKindSectionHeader
    ];
}

- (CGSize)sizeForSupplementaryViewOfKind:(NSString *)elementKind{
    return CGSizeMake(100, 40);
}

- (__kindof UICollectionReusableView *)viewForSupplementaryElementOfKind:(NSString *)elementKind{
    ShoppingHeaderView * headerView = [self.dataSource dequeueReusableSupplementaryViewOfKind:elementKind forComponent:self clazz:ShoppingHeaderView.class];
    [headerView setupTitle:self.title];
    return headerView;
}

@end

@implementation ShoppingKeywordComponent

- (instancetype)init
{
    self = [super init];
    if (self) {
        EaseFlexLayout * layout = [EaseFlexLayout new];
        layout.delegate = self;
        layout.inset = UIEdgeInsetsMake(0, 10, 0, 10);
        layout.itemHeight = 30;
        _layout = layout;
    }
    return self;
}

- (NSString *) title{
    return @"热搜关键字";
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    
    ShoppingKeywordCCell * ccell = [self.dataSource dequeueReusableCellOfClass:ShoppingKeywordCCell.class forComponent:self atIndex:index];
    [ccell setupWithData:[self dataAtIndex:index]];
    return ccell;
}

#pragma mark - EaseFlexLayoutDelegate

- (CGSize)layoutCustomItemSize:(EaseFlexLayout *)layout atIndex:(NSInteger)index{
    
    CGSize size = [[self dataAtIndex:index] YYY_sizeWithFont:({
        [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
    }) maxSize:CGSizeMake(CGFLOAT_MAX,layout.itemHeight)];
    size.width += 30;
    
    return size;
}
@end

@implementation ShoppingAllCategoryComponent

- (instancetype)init
{
    self = [super init];
    if (self) {
        EaseListLayout * layout = [EaseListLayout new];
        layout.inset = UIEdgeInsetsMake(0, 10, 0, 10);
        layout.distribution = [EaseLayoutDimension distributionDimension:2];
        layout.itemRatio = [EaseLayoutDimension absoluteDimension:40];
//        layout.arrange = EaseLayoutArrangeHorizontal;
//        layout.row = 3;
        _layout = layout;
    }
    return self;
}

- (NSString *) title{
    return @"分类";
}
- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    
    ShoppingCategoryCCell * ccell = [self.dataSource dequeueReusableCellOfClass:ShoppingCategoryCCell.class forComponent:self atIndex:index];
    [ccell setupWithData:[self dataAtIndex:index]];
    return ccell;
}

@end

@implementation ShoppingItemsComponent

- (instancetype)init
{
    self = [super init];
    if (self) {
        EaseWaterfallLayout * layout = [EaseWaterfallLayout new];
        layout.inset = UIEdgeInsetsMake(0, 10, 0, 10);
        layout.lineSpacing = 10;
        layout.delegate = self;
        layout.column = 2;
        _layout = layout;
    }
    return self;
}

- (NSString *) title{
    return @"所有商品";
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    
    ShoppingItemCCell * ccell = [self.dataSource dequeueReusableCellOfClass:ShoppingItemCCell.class forComponent:self atIndex:index];
    [ccell setupWithData:[self dataAtIndex:index]];
    return ccell;
}

#pragma mark - EaseWaterfallLayoutDelegate

- (CGSize)layoutCustomItemSize:(EaseWaterfallLayout *)layout atIndex:(NSInteger)index{
    
    NSDictionary * data = [self dataAtIndex:index];
    
    CGFloat height = layout.itemWidth;
    height += 4;
    // name height
    height += ({
        [data[@"name"] YYY_sizeWithFont:({
            [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        }) maxSize:CGSizeMake(layout.itemWidth - 12,CGFLOAT_MAX)].height;
    });
    height += 4;
    // desc height
    height += ({
        [data[@"desc"] YYY_sizeWithFont:({
            [UIFont systemFontOfSize:14 weight:UIFontWeightThin];
        }) maxSize:CGSizeMake(layout.itemWidth - 12,CGFLOAT_MAX)].height;
    });
    height += 4;
    return CGSizeMake(layout.itemWidth, height);
}

@end
