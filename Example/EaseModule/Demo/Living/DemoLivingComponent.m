//
//  DemoLivingComponent.m
//  EaseModule_Example
//
//  Created by rocky on 2020/9/25.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "DemoLivingComponent.h"
#import "DemoContentCCell.h"
#import "DemoLivingCCell.h"

@implementation LivingComponent{
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
//    headerView.backgroundColor = [UIColor orangeColor];
    [headerView setupHeaderTitle:_title];
    return headerView;;
}

- (CGSize)sizeForSupplementaryViewOfKind:(NSString *)elementKind{
    return CGSizeMake(200, 30);
}

@end

@implementation LivingBannerComponent

- (instancetype)init
{
    self = [super init];
    if (self) {
        EaseListLayout * layout = [EaseListLayout new];
        layout.inset = UIEdgeInsetsMake(0, 10, 10, 10);
        layout.distribution = [EaseLayoutDimension distributionDimension:1];
        // 1080*420
        layout.itemRatio = [EaseLayoutDimension fractionalDimension:1080.0f/420.0f];
        _layout = layout;
    }
    return self;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    DemoBannerCCell * ccell = [self.dataSource dequeueReusableCellOfClass:DemoBannerCCell.class forComponent:self atIndex:index];
    [ccell setupBannerImages:[[self dataAtIndex:index]
                              ease_map:^id _Nonnull(NSString * hex) {
        return [UIImage imageWithColor:[UIColor colorWithHexString:hex]];
    }]];
    ccell.contentView.layer.cornerRadius = 4.0f;
    ccell.contentView.layer.masksToBounds = YES;
    return ccell;
}
@end

@implementation LivingHotComponent

- (instancetype)initWithTitle:(NSString *)title{
    self = [super initWithTitle:title];
    if (self) {
        EaseListLayout * layout = [EaseListLayout new];
        layout.inset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.lineSpacing = 5.0f;
        layout.itemSpacing = 5.0f;
        layout.distribution = [EaseLayoutDimension distributionDimension:2];
        layout.itemRatio = [EaseLayoutDimension fractionalDimension:1.0];
        _layout = layout;
    }
    return self;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    LivingCCell * ccell = [self.dataSource dequeueReusableCellOfClass:LivingCCell.class forComponent:self atIndex:index];
    return ccell;
}

- (__kindof UICollectionViewCell *)placeholdCellForItemAtIndex:(NSInteger)index{
    LivingPlaceholdCCell * ccell = [self.dataSource dequeueReusablePlaceholdCellOfClass:LivingPlaceholdCCell.class forComponent:self];
    return ccell;
}

@end

@implementation LivingRocketComponent

- (instancetype)initWithTitle:(NSString *)title{
    self = [super initWithTitle:title];
    if (self) {
        EaseListLayout * layout = [EaseListLayout new];
        layout.inset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.arrange = EaseLayoutArrangeHorizontal;
        layout.lineSpacing = 5.0f;
        layout.itemSpacing = 5.0f;
        layout.row = 1;
        layout.distribution = [EaseLayoutDimension distributionDimension:4];
        layout.itemRatio = [EaseLayoutDimension fractionalDimension:1.0];
        _layout = layout;
    }
    return self;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    LivingCCell * ccell = [self.dataSource dequeueReusableCellOfClass:LivingCCell.class forComponent:self atIndex:index];
    return ccell;
}

@end

@implementation LivingRecommendComponent

- (instancetype)initWithTitle:(NSString *)title{
    self = [super initWithTitle:title];
    if (self) {
        EaseListLayout * layout = [EaseListLayout new];
        layout.inset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.lineSpacing = 5.0f;
        layout.itemSpacing = 5.0f;
        layout.distribution = [EaseLayoutDimension distributionDimension:2];
        layout.itemRatio = [EaseLayoutDimension fractionalDimension:1.0];
        _layout = layout;
    }
    return self;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    LivingCCell * ccell = [self.dataSource dequeueReusableCellOfClass:LivingCCell.class forComponent:self atIndex:index];
    return ccell;
}
@end
