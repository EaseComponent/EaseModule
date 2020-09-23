//
//  DemoSearchComponent.m
//  QILievModule
//
//  Created by rocky on 2020/8/19.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "DemoSearchComponent.h"
#import "DemoContentCCell.h"
#import "NSString+Common.h"

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

@implementation SearchHistoryComponent

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super initWithTitle:title];
    if (self) {
        EaseFlexLayout * layout = [EaseFlexLayout new];
        layout.inset = UIEdgeInsetsMake(10, 0, 10, 0);
        layout.delegate = self;
        layout.itemHeight = 30;
        _layout = layout;
    }
    return self;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    DemoContentCCell * ccell = [self.dataSource dequeueReusableCellOfClass:DemoContentCCell.class forComponent:self atIndex:index];
    ccell.contentView.layer.cornerRadius = 15.0f;
    ccell.contentView.layer.masksToBounds = YES;
    [ccell setupWithData:[self dataAtIndex:index]];
    ccell.oneLabel.font = [UIFont systemFontOfSize:15];
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

@end

@implementation SearchHotRankComponent

@end

@implementation SearchRecommendComponent

@end
