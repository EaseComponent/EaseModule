//
//  DemoMusicComponent.m
//  QILievModule
//
//  Created by rocky on 2020/8/25.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "DemoMusicComponent.h"
#import "DemoMusicCCell.h"
#import "DemoContentCCell.h"

@implementation DemoMusicComponent{
    NSString * _name;
}

- (instancetype) initWithName:(NSString *)name{
    self = [super init];
    if (self) {
        self.headerPin = YES;
        _name = name;
    }
    return self;;
}

- (NSArray<NSString *> *)supportedElementKinds{
    return @[UICollectionElementKindSectionHeader];
}
- (__kindof UICollectionReusableView *)viewForSupplementaryElementOfKind:(NSString *)elementKind{
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        DemoHeaderView * headerView = [self.dataSource dequeueReusableSupplementaryViewOfKind:elementKind forComponent:self clazz:DemoHeaderView.class];
        headerView.titleLabel.textColor = [UIColor redColor];
        headerView.titleLabel.font = [UIFont systemFontOfSize:17
        weight:UIFontWeightMedium];
        headerView.backgroundColor = [UIColor whiteColor];
        [headerView setupHeaderTitle:_name];
        return headerView;;
    }
    return nil;;
}
- (CGSize)sizeForSupplementaryViewOfKind:(NSString *)elementKind{
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        return CGSizeMake(200, 40);
    }
    return CGSizeZero;
}

@end

@implementation MusicBannerComponent

- (instancetype)init
{
    self = [super init];
    if (self) {
        EaseListLayout * layout = [EaseListLayout new];
        layout.distribution = [EaseLayoutDimension distributionDimension:1];
        // 1080*420
        layout.itemRatio = [EaseLayoutDimension fractionalDimension:1080.0f/420.0f];
        _layout = layout;
    }
    return self;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    DemoBannerCCell * ccell = [self.dataSource dequeueReusableCellOfClass:DemoBannerCCell.class forComponent:self atIndex:index];
    [ccell setupBannerDatas:[self dataAtIndex:index]];
    return ccell;
}

@end
@implementation MusicTodayComponent

- (instancetype)initWithName:(NSString *)name
{
    self = [super initWithName:name];
    if (self) {
        EaseFlexLayout * layout = [EaseFlexLayout new];
        layout.justifyContent = EaseFlexLayoutCenter;
        layout.inset = UIEdgeInsetsMake(0, 0, 20, 0);
        layout.itemSpacing = 0;
        layout.itemHeight = 120;
        layout.delegate = self;
        _layout = layout;
        [self addDecorateWithBuilder:^(id<EaseComponentDecorateAble>  _Nonnull builder) {
            builder.decorate = EaseComponentDecorateAll;
            builder.contents =
            [EaseComponentDecorateContents gradientContents:^(id<EaseComponentDecorateGradientContentsAble>  _Nonnull contents) {
                contents.colors = @[
                    [UIColor colorWithHexString:@"#B3FFAB"],
                    [UIColor colorWithHexString:@"#12FFF7"]
                ];
                contents.locations = @[@(0.3),@(1)];
                contents.startPoint = CGPointMake(0, 0.5);
                contents.endPoint = CGPointMake(1, 1);
            }];
        }];
    }
    return self;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    MusicTodayCCell * ccell = [self.dataSource dequeueReusableCellOfClass:MusicTodayCCell.class forComponent:self atIndex:index];
    [ccell setupSong:[self dataAtIndex:index] atIndex:index];
    return ccell;
}

- (CGSize) layoutCustomItemSize:(EaseFlexLayout *)layout atIndex:(NSInteger)index{
    return (CGSize){
        ((layout.insetContainerWidth - layout.itemSpacing * 2) / 3) * 0.9,
        layout.itemHeight
    };
}

@end

@implementation MusicWeekRankComponent

- (instancetype)initWithName:(NSString *)name
{
    self = [super initWithName:name];
    if (self) {
        EaseListLayout * layout = [EaseListLayout new];
        layout.arrange = EaseLayoutArrangeHorizontal;
        layout.inset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.itemSpacing = 10;
        layout.horizontalScrollingBehavior = EaseLayoutHorizontalScrollingBehaviorItemPaging;
        layout.distribution = [EaseLayoutDimension absoluteDimension:300];
        layout.itemRatio = [EaseLayoutDimension absoluteDimension:60];
        layout.row = 4;
        _layout = layout;
    }
    return self;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    MusicRankCCell * ccell = [self.dataSource dequeueReusableCellOfClass:MusicRankCCell.class forComponent:self atIndex:index];
    [ccell setupSong:[self dataAtIndex:index] atIndex:index];
    ccell.contentView.backgroundColor = [UIColor systemOrangeColor];
    return ccell;
}
@end

@implementation MusicSongListComponent

- (instancetype)initWithName:(NSString *)name
{
    self = [super initWithName:name];
    if (self) {
        EaseListLayout * layout = [EaseListLayout new];
        layout.inset = UIEdgeInsetsMake(0, 10, 0, 10);
        layout.itemSpacing = 5;
        layout.lineSpacing = 5;
        layout.distribution = [EaseLayoutDimension distributionDimension:4];
        layout.itemRatio = [EaseLayoutDimension fractionalDimension:0.7];
        _layout = layout;
    }
    return self;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    MusicSongListCCell * ccell = [self.dataSource dequeueReusableCellOfClass:MusicSongListCCell.class forComponent:self atIndex:index];
    [ccell setupSong:[self dataAtIndex:index] atIndex:index];
    return ccell;
}
@end

@implementation MusicSongCardComponent

- (instancetype)initWithName:(NSString *)name
{
    self = [super initWithName:name];
    if (self) {
        EaseListLayout * layout = [EaseListLayout new];
        layout.inset = UIEdgeInsetsMake(0, 20, 0, 20);
        layout.itemSpacing = 5;
        layout.lineSpacing = 5;
        layout.distribution = [EaseLayoutDimension distributionDimension:3];
        layout.itemRatio = [EaseLayoutDimension fractionalDimension:0.8];
        _layout = layout;
        
        [self addDecorateWithBuilder:^(id<EaseComponentDecorateAble>  _Nonnull builder) {
            builder.decorate = EaseComponentDecorateAll;
            builder.inset = UIEdgeInsetsMake(0, -10, 0, -10);
            builder.radius = 10.0f;
            builder.contents = ({
                EaseComponentDecorateContents * contents =
                [EaseComponentDecorateContents colorContents:({
                    [UIColor colorWithHexString:@"F3F3F3"];
                })];
                contents.shadowColor = [UIColor colorWithHexString:@"c4c4c4"];
                contents.shadowRadius = 3;
                contents.shadowOffset = CGSizeZero;
                contents.shadowOpacity = 0.5;
                contents;
            });
        }];
    }
    return self;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    MusicSongListCCell * ccell = [self.dataSource dequeueReusableCellOfClass:MusicSongListCCell.class forComponent:self atIndex:index];
    [ccell setupSong:[self dataAtIndex:index] atIndex:index];
    return ccell;
}
@end
