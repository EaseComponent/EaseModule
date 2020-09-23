//
//  DemoVideoComponent.m
//  QILievModule
//
//  Created by rocky on 2020/8/18.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "DemoVideoComponent.h"
#import "DemoVideoCCell.h"
#import "DemoContentCCell.h"

@implementation VideoBannerComponent

- (instancetype)init
{
    self = [super init];
    if (self) {
        EaseListLayout * layout = [EaseListLayout new];
        layout.inset = UIEdgeInsetsMake(0, 10, 0, 10);
        layout.distribution = [EaseLayoutDimension distributionDimension:1];
        layout.itemRatio = [EaseLayoutDimension fractionalDimension:498.0f/280.0];
        _layout = layout;
    }
    return self;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    DemoBannerCCell * ccell =
    [self.dataSource dequeueReusableCellOfClass:DemoBannerCCell.class
                                   forComponent:self atIndex:index];
    [ccell setupBannerDatas:[self dataAtIndex:index]];
    return ccell;
}
@end

@interface VideoCategoryComponent ()<EaseFlexLayoutDelegate>
@end
@implementation VideoCategoryComponent

- (instancetype)init
{
    self = [super init];
    if (self) {
        EaseFlexLayout * layout = [EaseFlexLayout new];
        layout.inset = UIEdgeInsetsMake(10, 10, 0, 10);
        layout.arrange = EaseLayoutArrangeHorizontal;
        layout.itemHeight = 40;
        layout.delegate = self;
        _layout = layout;
    }
    return self;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    DemoVideoCategoryCCell * ccell =
    [self.dataSource dequeueReusableCellOfClass:DemoVideoCategoryCCell.class
                                   forComponent:self atIndex:index];
    [ccell setupCategory:[self dataAtIndex:index]];
    return ccell;
}

#pragma mark EaseFlexLayoutDelegate

- (CGSize)layoutCustomItemSize:(EaseFlexLayout *)layout atIndex:(NSInteger)index{
    NSString * category = [self dataAtIndex:index];
    CGSize size = [category YYY_sizeWithFont:[UIFont systemFontOfSize:15]
                                   maxSize:CGSizeMake(CGFLOAT_MAX, layout.itemHeight)];
    size.width = size.width + 30;///30 是字体的左右间距
    size.height = layout.itemHeight;
    return size;
}
@end

@implementation VideoFilmComponent{
    NSMutableArray * _tmp;
    NSInteger _changeIndex;
    BOOL _change;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        EaseListLayout * layout = [EaseListLayout new];
        layout.inset = UIEdgeInsetsMake(0, 10, 0, 10);
        layout.distribution = [EaseLayoutDimension distributionDimension:3];
        layout.itemRatio = [EaseLayoutDimension fractionalDimension:183.0/267.0];
        _layout = layout;
        
        _changeIndex = 0;
    }
    return self;
}

- (void)clear{
    [super clear];
    if (!_change) {
        [_tmp removeAllObjects];
        _tmp = nil;
    }
}

- (void)addDatas:(NSArray *)datas{
    if (!_tmp) {
        _tmp = [NSMutableArray array];
        [_tmp addObjectsFromArray:datas];
    }
    [super addDatas:({
        [_tmp subarrayWithRange:NSMakeRange(_changeIndex * 3, 3)];
    })];
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    DemoVideoCCell * ccell =
    [self.dataSource dequeueReusableCellOfClass:DemoVideoCCell.class
                                   forComponent:self atIndex:index];
    [ccell setupImageURLString:[self dataAtIndex:index]];
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
        DemoHeaderView * headerView = [self.dataSource dequeueReusableSupplementaryViewOfKind:elementKind forComponent:self clazz:DemoHeaderView.class];
        [headerView setupHeaderTitle:@"🎬热门电影"];
        return headerView;
    } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        DemoVideoChangeFooterView * footerView =
        [self.dataSource dequeueReusableSupplementaryViewOfKind:elementKind forComponent:self clazz:DemoVideoChangeFooterView.class];
        @weakify(self);
        footerView.bChangeAction = ^{
            @strongify(self);
//            [self change];
        };
        return footerView;
    }
    return nil;
}

- (CGSize)sizeForSupplementaryViewOfKind:(NSString *)elementKind{
    return CGSizeMake(200, 50);
}
- (UIEdgeInsets) insetForSupplementaryViewOfKind:(NSString *)elementKind{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (void) change{
    
    _change = YES;
    
    [self clear];
    
    _changeIndex ++;
    if (_changeIndex > 2) {
        _changeIndex = 0;
    }

    [self addDatas:nil];
    
    [self reloadData];
    
    _change = NO;
}
@end

@interface VideoComponent ()<EaseWaterfallLayoutDelegate>
@end
@implementation VideoComponent

- (instancetype)init
{
    self = [super init];
    if (self) {
        EaseWaterfallLayout * layout = [EaseWaterfallLayout new];
        layout.inset = UIEdgeInsetsMake(5, 10, 0, 10);
        layout.column = 2;
        layout.delegate = self;
        _layout = layout;
    }
    return self;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    DemoContentCCell * ccell =
    [self.dataSource dequeueReusableCellOfClass:DemoContentCCell.class
                                   forComponent:self atIndex:index];
    [ccell setupWithData:[NSString stringWithFormat:@"%d %@",index,[self dataAtIndex:index]]];
    return ccell;
}

#pragma mark - EaseWaterfallLayoutDelegate

- (CGSize)layoutCustomItemSize:(EaseWaterfallLayout *)layout atIndex:(NSInteger)index{
    
    CGFloat itemHeight = [[self dataAtIndex:index] floatValue];
    return CGSizeMake(100, itemHeight);
}
@end

@implementation VideoRankComponent

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addDecorateWithBuilder:^(id<EaseComponentDecorateAble>  _Nonnull builder) {
            builder.decorate = EaseComponentDecorateOnlyItem;
            builder.radius = 4.0f;
            builder.contents = ({
                [EaseComponentDecorateContents colorContents:[UIColor colorWithHexString:@"f3f3f3"]];
            });
            builder.inset = UIEdgeInsetsMake(0, 0, 0, 0);
        }];
        EaseListLayout * layout = [EaseListLayout new];
        layout.lineSpacing = 0;
        layout.inset = UIEdgeInsetsMake(0, 10, 0, 10);
        layout.distribution = [EaseLayoutDimension distributionDimension:1];
        layout.itemRatio = [EaseLayoutDimension absoluteDimension:44];
        _layout = layout;
    }
    return self;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    DemoVideoRankCCell * ccell =
    [self.dataSource dequeueReusableCellOfClass:DemoVideoRankCCell.class
                                   forComponent:self atIndex:index];
    [ccell setupRank:index + 1
                name:[self dataAtIndex:index]
         showSepLine:(index != self.datas.count - 1)];
    return ccell;
}
@end
