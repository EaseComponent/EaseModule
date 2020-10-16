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
        self.independentDatas = YES;
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

- (NSString *) title{
    return @"热搜关键字";
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    
    ShoppingKeywordCCell * ccell = [self.dataSource dequeueReusableCellOfClass:ShoppingKeywordCCell.class forComponent:self atIndex:index];
    [ccell setupWithData:[self dataAtIndex:index]];
    return ccell;
}

@end

@implementation ShoppingAllCategoryComponent

- (instancetype)init
{
    self = [super init];
    if (self) {
        
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

@end
