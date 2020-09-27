//
//  XXViewController.m
//  EaseModule
//
//  Created by Yrocky on 09/22/2020.
//  Copyright (c) 2020 Yrocky. All rights reserved.
//

#import "XXViewController.h"
#import "DemoContentCCell.h"

@interface XXViewController ()
@end

@implementation XXViewController
@end

@implementation DemoModule

static NSDictionary * demoData;

- (instancetype)initWithName:(NSString *)name{
    self = [super initWithName:name];
    if (self) {
        demoData = @{
            @"flex":@[
                    @"google",@"facebook",@"youtube",
                    @"amazon",@"apple",@"Microsoft",
                    @"Alphabet",@"IBM"
            ],
            @"languages":@[
                    @"#swift#",
                    @"#java#",
                    @"#js#"
            ],
            @"languages-orthogonal":@[
                    @"#swift#",
                    @"#java#",
                    @"#js#",
                    @"#flutter#",
                    @"#oc#",
            ],
            @"weather":@[@"晴天",@"阴天",@"雨天",@"大风",@"雷电",@"冰雹",@"大雪",@"小雪"],
            @"city":@[
                    @"上海",
                    @"北京",
                    @"广州",
                    @"杭州",
                    @"深圳",
                    @"南京",
                    @"郑州",
                    @"武汉",
                    @"西安"
            ],
            @"Cocoa":@[@"NSObject",@"UIView",@"UIImageView",@"UILabel",@"CALayer",@"NSRunloop"],
            @"word":@[@"a",@"b",@"c",@"d",@"e"],
            @"video":@[@"爱奇艺",@"腾讯视频",@"优酷",@"西瓜视频",@"哔哩哔哩"],
            @"number":@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"],
            @"company":@[@"google",@"facebook",@"youtube",@"amazon",@"apple",@"Microsoft",@"Alphabet",@"IBM"],
            @"music":@[
                    @"0 Love of My Life",
                    @"1 Thank You",
                    @"2 Yesterday Once More",
                    @"3 You Are Not Alone",
                    @"4 Billie Jean",
                    @"5 Smooth Criminal",
                    @"6 Earth Song",
                    @"7 I will always love you",
                    @"8 black or white"
            ],
            @"waterFlow":@[
                    @(170),@(130),@(190),@(100),
                    @(110),@(135),@(130),
                    @(90),@(155),@(65),
            ],
        };
    }
    return self;
}
- (BOOL)shouldLoadMore{
    return NO;
}

// 这里使用refresh来模拟网络加载
- (void)refresh{
    [super refresh];
    [self.dataSource clear];
    
    [self setupComponents:demoData];
    
    [self.collectionView reloadData];
}

// 真正业务中是实现如下方法
- (__kindof YTKRequest *)fetchModuleRequest{
    // 1.返回当前module的网络请求
    return nil;
}

- (void)parseModuleDataWithRequest:(__kindof YTKRequest *)request{
    // 2.根据request中的数据来进行component的组装
    [self setupComponents:demoData];
}

- (void) setupComponents:(NSDictionary *)data{
    
    
    //    [self.dataSource addComponent:({
    //        DemoPlaceholdComponent * comp = [[DemoPlaceholdComponent alloc] initWithTitle:@"placehold"];
    //        comp.needPlacehold = YES;
    //        if (temp_flag % 2) {
    //            [comp addDatas:data[@"city"]];
    //        }
    //        comp;
    //    })];
}
@end

@interface DemoBaseComponent : EaseComponent
- (instancetype) initWithTitle:(NSString *)title;
@end

@interface DemoPlaceholdComponent : DemoBaseComponent<
EaseFlexLayoutDelegate,
EaseWaterfallLayoutDelegate>
- (instancetype) initWithTitle:(NSString *)title layoutType:(NSInteger)layoutType;
@end

@interface DemoFlexComponent : DemoBaseComponent<EaseFlexLayoutDelegate>
- (void) setupFlexLayout:(EaseFlexLayout *)flexLayout;
@end

@interface DemoListComponent : DemoBaseComponent
- (void) setupListLayout:(EaseListLayout *)listLayout;
@end

@interface DemoWaterfallComponent : DemoBaseComponent<EaseWaterfallLayoutDelegate>
- (void) setupWaterfallLayout:(EaseWaterfallLayout *)waterfallLayout;
@end

@interface DemoBackgroundDecorateComponent : DemoBaseComponent
- (instancetype)initWithTitle:(NSString *)title orthogonalScroll:(BOOL)orthogonalScroll;
@end


@implementation DemoFlexLayoutModule

- (void)setupComponents:(NSDictionary *)data{
    
    [self.dataSource addComponent:({
        DemoFlexComponent * comp = [[DemoFlexComponent alloc] initWithTitle:@"EaseFlexLayout：orthogonal scroll"];
        [comp setupFlexLayout:({
            EaseFlexLayout * flexLayout = [EaseFlexLayout new];
            flexLayout.arrange = EaseLayoutArrangeHorizontal;
            flexLayout.inset = UIEdgeInsetsMake(0, 0, 0, 0);
            flexLayout;
        })];
        [comp addDatas:data[@"flex"]];
        comp;
    })];
    [self.dataSource addComponent:({
        DemoPlaceholdComponent * comp = [[DemoPlaceholdComponent alloc] initWithTitle:@"EaseFlexLayout：placehold" layoutType:0];
        comp;
    })];
    [self.dataSource addComponent:({
        DemoPlaceholdComponent * comp = [[DemoPlaceholdComponent alloc] initWithTitle:@"EaseFlexLayout：orthogonal scroll & placehold" layoutType:10];
        comp;
    })];
    [self.dataSource addComponent:({
        DemoFlexComponent * comp = [[DemoFlexComponent alloc] initWithTitle:@"EaseFlexLayout：flex-start"];
        comp.headerPin = YES;
        [comp setupFlexLayout:({
            EaseFlexLayout * flexLayout = [EaseFlexLayout new];
            flexLayout.justifyContent = EaseFlexLayoutFlexStart;
            flexLayout.inset = UIEdgeInsetsMake(0, 0, 0, 0);
            flexLayout;
        })];
        [comp addDatas:data[@"flex"]];
        comp;
    })];
    [self.dataSource addComponent:({
        DemoFlexComponent * comp = [[DemoFlexComponent alloc] initWithTitle:@"EaseFlexLayout：center"];
//        comp.headerPin = YES;
        [comp setupFlexLayout:({
            EaseFlexLayout * flexLayout = [EaseFlexLayout new];
            flexLayout.justifyContent = EaseFlexLayoutCenter;
            flexLayout.inset = UIEdgeInsetsMake(0, 0, 0, 0);
            flexLayout;
        })];
        [comp addDatas:data[@"flex"]];
        comp;
    })];
    [self.dataSource addComponent:({
        DemoFlexComponent * comp = [[DemoFlexComponent alloc] initWithTitle:@"EaseFlexLayout：flex-end"];
        [comp setupFlexLayout:({
            EaseFlexLayout * flexLayout = [EaseFlexLayout new];
            flexLayout.justifyContent = EaseFlexLayoutFlexEnd;
            flexLayout.inset = UIEdgeInsetsMake(0, 0, 0, 0);
            flexLayout;
        })];
        [comp addDatas:data[@"flex"]];
        comp;
    })];
    
    [self.dataSource addComponent:({
        DemoFlexComponent * comp = [[DemoFlexComponent alloc] initWithTitle:@"EaseFlexLayout：space-around"];
        [comp setupFlexLayout:({
            EaseFlexLayout * flexLayout = [EaseFlexLayout new];
            flexLayout.justifyContent = EaseFlexLayoutSpaceAround;
            flexLayout.inset = UIEdgeInsetsMake(0, 0, 0, 0);
            flexLayout;
        })];
        [comp addDatas:data[@"flex"]];
        comp;
    })];
    
    [self.dataSource addComponent:({
        DemoFlexComponent * comp = [[DemoFlexComponent alloc] initWithTitle:@"EaseFlexLayout：space-between"];
        [comp setupFlexLayout:({
            EaseFlexLayout * flexLayout = [EaseFlexLayout new];
            flexLayout.justifyContent = EaseFlexLayoutSpaceBetween;
            flexLayout.inset = UIEdgeInsetsMake(0, 0, 0, 0);
            flexLayout;
        })];
        [comp addDatas:data[@"flex"]];
        comp;
    })];
}
@end

@implementation DemoListLayoutModule

- (void)setupComponents:(NSDictionary *)data{
    
    [self.dataSource addComponent:({
        DemoListComponent * comp = [[DemoListComponent alloc] initWithTitle:@"EaseListLayout：orthogonal scroll"];
        [comp setupListLayout:({
            EaseListLayout * listLayout = [EaseListLayout new];
            listLayout.arrange = EaseLayoutArrangeHorizontal;
            listLayout.inset = UIEdgeInsetsMake(10, 10, 10, 10);
            listLayout.distribution = [EaseLayoutDimension fractionalDimension:0.55];
            listLayout.itemRatio = [EaseLayoutDimension absoluteDimension:50];
            listLayout.row = 3;
            listLayout;
        })];
        [comp addDatas:data[@"music"]];
        comp;
    })];
    [self.dataSource addComponent:({
        DemoPlaceholdComponent * comp = [[DemoPlaceholdComponent alloc] initWithTitle:@"EaseListLayout：placehold" layoutType:1];
        comp;
    })];
    [self.dataSource addComponent:({
        DemoPlaceholdComponent * comp = [[DemoPlaceholdComponent alloc] initWithTitle:@"EaseListLayout：orthogonal scroll & placehold" layoutType:11];
        comp;
    })];
    [self.dataSource addComponent:({
        DemoListComponent * comp = [[DemoListComponent alloc] initWithTitle:@"EaseListLayout：table-view like"];
        [comp setupListLayout:({
            EaseListLayout * listLayout = [EaseListLayout new];
            listLayout.lineSpacing = 0.5f;
            listLayout.inset = UIEdgeInsetsMake(0, 0, 0, 0);
            listLayout.distribution = [EaseLayoutDimension distributionDimension:1];
            listLayout.itemRatio = [EaseLayoutDimension absoluteDimension:44.0f];
            listLayout;
        })];
        [comp addDatas:data[@"music"]];
        comp;
    })];
    
    [self.dataSource addComponent:({
        DemoListComponent * comp = [[DemoListComponent alloc] initWithTitle:@"EaseListLayout：collection-view like"];
        [comp setupListLayout:({
            EaseListLayout * listLayout = [EaseListLayout new];
            listLayout.inset = UIEdgeInsetsMake(0, 10, 0, 10);
            listLayout.distribution = [EaseLayoutDimension distributionDimension:3];
            listLayout.itemRatio = [EaseLayoutDimension fractionalDimension:0.8];
            listLayout;
        })];
        [comp addDatas:data[@"music"]];
        comp;
    })];
}

@end

@implementation DemoWaterfallLayoutModule

- (void)setupComponents:(NSDictionary *)data{
    
    [self.dataSource addComponent:({
        DemoWaterfallComponent * comp = [[DemoWaterfallComponent alloc] initWithTitle:@"EaseWaterfallLayout：orthogonal scroll"];
        [comp setupWaterfallLayout:({
            EaseWaterfallLayout * waterfallLayout = [EaseWaterfallLayout new];
            waterfallLayout.row = 2;
            waterfallLayout.horizontalArrangeContentHeight = 300;
            waterfallLayout.arrange = EaseLayoutArrangeHorizontal;
            waterfallLayout.renderDirection = EaseWaterfallItemRenderShortestFirst;
            waterfallLayout;
        })];
        [comp addDatas:data[@"waterFlow"]];
        comp;
    })];
    [self.dataSource addComponent:({
        DemoPlaceholdComponent * comp = [[DemoPlaceholdComponent alloc] initWithTitle:@"EaseWaterfallLayout：placehold" layoutType:2];
        comp;
    })];
    [self.dataSource addComponent:({
        DemoPlaceholdComponent * comp = [[DemoPlaceholdComponent alloc] initWithTitle:@"EaseWaterfallLayout：orthogonal scroll & placehold" layoutType:12];
        comp;
    })];
    [self.dataSource addComponent:({
        DemoWaterfallComponent * comp = [[DemoWaterfallComponent alloc] initWithTitle:@"EaseWaterfallLayout：shortest first"];
        comp.headerPin = YES;
        [comp setupWaterfallLayout:({
            EaseWaterfallLayout * waterfallLayout = [EaseWaterfallLayout new];
            waterfallLayout.column = 3;
            waterfallLayout.renderDirection = EaseWaterfallItemRenderShortestFirst;
            waterfallLayout;
        })];
        [comp addDatas:data[@"waterFlow"]];
        comp;
    })];
    [self.dataSource addComponent:({
        DemoWaterfallComponent * comp = [[DemoWaterfallComponent alloc] initWithTitle:@"EaseWaterfallLayout：left to right"];
        [comp setupWaterfallLayout:({
            EaseWaterfallLayout * waterfallLayout = [EaseWaterfallLayout new];
            waterfallLayout.column = 3;
            waterfallLayout.renderDirection = EaseWaterfallItemRenderLeftToRight;
            waterfallLayout;
        })];
        [comp addDatas:data[@"waterFlow"]];
        comp;
    })];
    [self.dataSource addComponent:({
        DemoWaterfallComponent * comp = [[DemoWaterfallComponent alloc] initWithTitle:@"EaseWaterfallLayout：right to left"];
        [comp setupWaterfallLayout:({
            EaseWaterfallLayout * waterfallLayout = [EaseWaterfallLayout new];
            waterfallLayout.column = 3;
            waterfallLayout.renderDirection = EaseWaterfallItemRenderRightToLeft;
            waterfallLayout;
        })];
        [comp addDatas:data[@"waterFlow"]];
        comp;
    })];
}
@end

@implementation DemoBackgroundDecorateModule

- (void)setupComponents:(NSDictionary *)data{
    
    [self.dataSource addComponent:({
        DemoBackgroundDecorateComponent * comp = [[DemoBackgroundDecorateComponent alloc] initWithTitle:@"BackgroundDecorate：image"];
        comp.layout.inset = UIEdgeInsetsMake(100, 20, 10, 20);
        [comp addDecorateWithBuilder:^(id<EaseComponentDecorateAble>  _Nonnull builder) {
            builder.decorate = EaseComponentDecorateOnlyItem;
            builder.radius = 10.0f;
            builder.inset = UIEdgeInsetsMake(0, -10, 0, -10);
            builder.contents = ({
                EaseComponentDecorateContents * contents =
                [EaseComponentDecorateContents imageContents:[UIImage imageNamed:@"forbid"]];
                contents;
            });
        }];
        [comp addDatas:data[@"languages"]];
        comp;
    })];
    [self.dataSource addComponent:({
        DemoBackgroundDecorateComponent * comp = [[DemoBackgroundDecorateComponent alloc] initWithTitle:@"BackgroundDecorate：image & orthogonal scroll" orthogonalScroll:YES];
        comp.layout.inset = UIEdgeInsetsMake(10, 20, 130, 20);
        [comp addDecorateWithBuilder:^(id<EaseComponentDecorateAble>  _Nonnull builder) {
            builder.decorate = EaseComponentDecorateOnlyItem;
            builder.radius = 10.0f;
            builder.inset = UIEdgeInsetsMake(0, -10, 0, -10);
            builder.contents = ({
                EaseComponentDecorateContents * contents =
                [EaseComponentDecorateContents imageContents:[UIImage imageNamed:@"the_Great_Wall"]];
                contents;
            });
        }];
        [comp addDatas:data[@"languages-orthogonal"]];
        comp;
    })];
    [self.dataSource addComponent:({
        DemoBackgroundDecorateComponent * comp = [[DemoBackgroundDecorateComponent alloc] initWithTitle:@"BackgroundDecorate：gradient"];
        comp.layout.inset = UIEdgeInsetsMake(10, 20, 10, 20);
        [comp addDecorateWithBuilder:^(id<EaseComponentDecorateAble>  _Nonnull builder) {
            builder.decorate = EaseComponentDecorateOnlyItem;
            builder.radius = 4.0f;
            builder.inset = UIEdgeInsetsMake(0, -10, 0, -10);
            builder.contents = ({
                EaseComponentDecorateContents * contents =
                [EaseComponentDecorateContents gradientContents:^(id<EaseComponentDecorateGradientContentsAble>  _Nonnull contents) {
                    contents.startPoint = CGPointMake(0.5, 0);
                    contents.endPoint = CGPointMake(0.5, 1);
                    contents.colors = @[
                        [UIColor colorWithHexString:@"#FF9E5C"],
                        [UIColor colorWithHexString:@"#FF659F"]
                    ];
                    contents.locations = @[@(0), @(1.0f)];
                }];
                contents;
            });
        }];
        [comp addDatas:data[@"languages"]];
        comp;
    })];
    
    [self.dataSource addComponent:({
        DemoBackgroundDecorateComponent * comp = [[DemoBackgroundDecorateComponent alloc] initWithTitle:@"BackgroundDecorate：only item"];
        [comp addDecorateWithBuilder:^(id<EaseComponentDecorateAble>  _Nonnull builder) {
            builder.decorate = EaseComponentDecorateOnlyItem;
            builder.radius = 4.0f;
            builder.contents = ({
                EaseComponentDecorateContents * contents =
                [EaseComponentDecorateContents colorContents:[UIColor colorWithHexString:@"#8091a5"]];
                contents;
            });
        }];
        [comp addDatas:data[@"languages"]];
        comp;
    })];
    
    [self.dataSource addComponent:({
        DemoBackgroundDecorateComponent * comp = [[DemoBackgroundDecorateComponent alloc] initWithTitle:@"BackgroundDecorate：contain header"];
        [comp addDecorateWithBuilder:^(id<EaseComponentDecorateAble>  _Nonnull builder) {
            builder.decorate = EaseComponentDecorateContainHeader;
            builder.radius = 4.0f;
            builder.contents = ({
                EaseComponentDecorateContents * contents =
                [EaseComponentDecorateContents colorContents:[UIColor colorWithHexString:@"#8091a5"]];
                contents;
            });
        }];
        [comp addDatas:data[@"languages"]];
        comp;
    })];
    [self.dataSource addComponent:({
        DemoBackgroundDecorateComponent * comp = [[DemoBackgroundDecorateComponent alloc] initWithTitle:@"BackgroundDecorate：all"];
        [comp addDecorateWithBuilder:^(id<EaseComponentDecorateAble>  _Nonnull builder) {
            builder.decorate = EaseComponentDecorateAll;
            builder.radius = 4.0f;
            builder.contents = ({
                EaseComponentDecorateContents * contents =
                [EaseComponentDecorateContents colorContents:[UIColor colorWithHexString:@"#8091a5"]];
                contents;
            });
        }];
        [comp addDatas:data[@"languages"]];
        comp;
    })];
    
    [self.dataSource addComponent:({
        DemoBackgroundDecorateComponent * comp = [[DemoBackgroundDecorateComponent alloc] initWithTitle:@"BackgroundDecorate：contain footer"];
        [comp addDecorateWithBuilder:^(id<EaseComponentDecorateAble>  _Nonnull builder) {
            builder.decorate = EaseComponentDecorateContainFooter;
            builder.radius = 4.0f;
            builder.contents = ({
                EaseComponentDecorateContents * contents =
                [EaseComponentDecorateContents colorContents:[UIColor colorWithHexString:@"#8091a5"]];
                contents;
            });
        }];
        [comp addDatas:data[@"languages"]];
        comp;
    })];
    [self.dataSource addComponent:({
        DemoBackgroundDecorateComponent * comp = [[DemoBackgroundDecorateComponent alloc] initWithTitle:@"BackgroundDecorate：only item & insets"];
        comp.layout.inset = UIEdgeInsetsMake(10, 20, 10, 20);
        [comp addDecorateWithBuilder:^(id<EaseComponentDecorateAble>  _Nonnull builder) {
            builder.decorate = EaseComponentDecorateOnlyItem;
            builder.radius = 4.0f;
            builder.inset = UIEdgeInsetsMake(0, -10, 0, -10);
            builder.contents = ({
                EaseComponentDecorateContents * contents =
                [EaseComponentDecorateContents colorContents:[UIColor colorWithHexString:@"#8091a5"]];
                contents;
            });
        }];
        [comp addDatas:data[@"languages"]];
        comp;
    })];
    [self.dataSource addComponent:({
        DemoBackgroundDecorateComponent * comp = [[DemoBackgroundDecorateComponent alloc] initWithTitle:@"BackgroundDecorate：all & insets"];
        comp.layout.inset = UIEdgeInsetsMake(10, 20, 10, 20);
        [comp addDecorateWithBuilder:^(id<EaseComponentDecorateAble>  _Nonnull builder) {
            builder.decorate = EaseComponentDecorateAll;
            builder.radius = 4.0f;
            builder.inset = UIEdgeInsetsMake(0, -10, 0, -10);
            builder.contents = ({
                EaseComponentDecorateContents * contents =
                [EaseComponentDecorateContents colorContents:[UIColor colorWithHexString:@"#8091a5"]];
                contents;
            });
        }];
        [comp addDatas:data[@"languages"]];
        comp;
    })];
    
    [self.dataSource addComponent:({
        DemoBackgroundDecorateComponent * comp = [[DemoBackgroundDecorateComponent alloc] initWithTitle:@"BackgroundDecorate：shadow"];
        comp.layout.inset = UIEdgeInsetsMake(10, 20, 10, 20);
        [comp addDecorateWithBuilder:^(id<EaseComponentDecorateAble>  _Nonnull builder) {
            builder.decorate = EaseComponentDecorateOnlyItem;
            builder.radius = 4.0f;
            builder.inset = UIEdgeInsetsMake(0, -10, 0, -10);
            [builder setContents:({
                EaseComponentDecorateContents * contents =
                [EaseComponentDecorateContents colorContents:[UIColor whiteColor]];
                contents.shadowColor = [UIColor redColor];
                contents.shadowOffset = CGSizeMake(0, 0);
                contents.shadowOpacity = 0.5;
                contents.shadowRadius = 3;
                contents;
            })];
        }];
        [comp addDatas:data[@"languages"]];
        comp;
    })];
}
@end


@implementation DemoBaseComponent{
    NSString *_title;
}

- (instancetype) initWithTitle:(NSString *)title{
    self = [super init];
    if (self) {
        _title = title;
    }
    return self;
}

- (NSArray<NSString *> *)supportedElementKinds{
    return @[
        UICollectionElementKindSectionHeader,
        UICollectionElementKindSectionFooter
    ];
}

- (__kindof UICollectionReusableView *)viewForSupplementaryElementOfKind:(NSString *)elementKind{
    if (elementKind == UICollectionElementKindSectionHeader) {
        
        DemoHeaderView *view = [self.dataSource dequeueReusableSupplementaryViewOfKind:elementKind forComponent:self clazz:DemoHeaderView.class];
        view.titleLabel.textColor = [UIColor redColor];
        [view setupHeaderTitle:[NSString stringWithFormat:@"%@",_title]];
        return view;
    } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        DemoFooterView * footerView =
        [self.dataSource dequeueReusableSupplementaryViewOfKind:elementKind forComponent:self clazz:DemoFooterView.class];
        return footerView;
    }
    return nil;
}
- (CGSize)sizeForSupplementaryViewOfKind:(NSString *)elementKind{
    if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        return CGSizeMake(200, 30);
    }
    return CGSizeMake(200, 45);
}

//- (UIEdgeInsets) insetForSupplementaryViewOfKind:(NSString *)elementKind{
//    return UIEdgeInsetsMake(0, 10, 0, 10);
//}

@end

@implementation DemoPlaceholdComponent

- (instancetype) initWithTitle:(NSString *)title layoutType:(NSInteger)layoutType{
    self = [super initWithTitle:title];
    if (self) {
        self.needPlacehold = YES;
        self.placeholdHeight = 60;
        // 这里设置layout仅仅是为了测试不同layout下的placehold效果
        if (layoutType == 0) {
            EaseListLayout * layout = [EaseListLayout new];
            layout.distribution = [EaseLayoutDimension distributionDimension:1];
            layout.itemRatio = [EaseLayoutDimension absoluteDimension:50];
            _layout = layout;
        } else if (layoutType == 1) {
            EaseFlexLayout * layout = [EaseFlexLayout new];
            layout.itemHeight = 30.0f;
            layout.justifyContent = EaseFlexLayoutFlexStart;
            layout.delegate = self;
            _layout = layout;
        } else if (layoutType == 2) {
            EaseWaterfallLayout * layout = [EaseWaterfallLayout new];
            layout.column = 3;
            layout.delegate = self;
            _layout = layout;
        }
        if (layoutType == 10) {
            EaseListLayout * layout = [EaseListLayout new];
            layout.distribution = [EaseLayoutDimension distributionDimension:1];
            layout.itemRatio = [EaseLayoutDimension absoluteDimension:50];
            layout.arrange = EaseLayoutArrangeHorizontal;
            layout.horizontalArrangeContentHeight = 100;
            _layout = layout;
        } else if (layoutType == 11) {
            EaseFlexLayout * layout = [EaseFlexLayout new];
            layout.itemHeight = 30.0f;
            layout.justifyContent = EaseFlexLayoutFlexStart;
            layout.delegate = self;
            layout.arrange = EaseLayoutArrangeHorizontal;
            _layout = layout;
        } else if (layoutType == 12) {
            EaseWaterfallLayout * layout = [EaseWaterfallLayout new];
            layout.column = 3;
            layout.delegate = self;
            layout.arrange = EaseLayoutArrangeHorizontal;
            layout.horizontalArrangeContentHeight = 100;
            _layout = layout;
        }
    }
    return self;;
}
- (__kindof UICollectionViewCell *)placeholdCellForItemAtIndex:(NSInteger)index{
    
    DemoPlaceholdCCell * ccell = [self.dataSource dequeueReusablePlaceholdCellOfClass:DemoPlaceholdCCell.class forComponent:self];
    return ccell;
}
// 由于该component展示的是placehod效果，并不会有数据，所以该override方法基本不会调用
- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    
    DemoContentCCell * ccell = [self.dataSource dequeueReusableCellOfClass:DemoContentCCell.class forComponent:self atIndex:index];
    ccell.contentView.layer.cornerRadius = 4.0f;
    ccell.oneLabel.font = [UIFont systemFontOfSize:15];
    [ccell setupWithData:[self dataAtIndex:index]];
    return ccell;
}

- (NSArray<NSString *> *)supportedElementKinds{
    return @[UICollectionElementKindSectionHeader];
}

#pragma mark - EaseFlexLayoutDelegate
// 由于该component展示的是placehod效果，并不会有数据，所以该代理方法基本不会调用
- (CGSize)layoutCustomItemSize:(EaseFlexLayout *)layout atIndex:(NSInteger)index{
    NSString * category = [self dataAtIndex:index];
    CGSize size = [category YYY_sizeWithFont:[UIFont systemFontOfSize:15]
                                     maxSize:CGSizeMake(CGFLOAT_MAX, layout.itemHeight)];
    size.width = size.width + 30;///30 是字体的左右间距
    size.height = layout.itemHeight;
    return size;
}
@end

@implementation DemoFlexComponent

- (void) setupFlexLayout:(EaseFlexLayout *)flexLayout{
//    flexLayout.inset = UIEdgeInsetsMake(10, 10, 10, 10);
    flexLayout.itemHeight = 30;
    flexLayout.delegate = self;
    _layout = flexLayout;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    
    DemoContentCCell * ccell = [self.dataSource dequeueReusableCellOfClass:DemoContentCCell.class forComponent:self atIndex:index];
    ccell.contentView.layer.cornerRadius = 4.0f;
    ccell.oneLabel.font = [UIFont systemFontOfSize:12];
    [ccell setupWithData:@""];
    return ccell;
}

- (NSArray<NSString *> *)supportedElementKinds{
    return @[UICollectionElementKindSectionHeader];
}
#pragma mark - EaseFlexLayoutDelegate

- (CGSize)layoutCustomItemSize:(EaseFlexLayout *)layout atIndex:(NSInteger)index{
    NSString * category = [self dataAtIndex:index];
    CGSize size = [category YYY_sizeWithFont:[UIFont systemFontOfSize:12]
                                     maxSize:CGSizeMake(CGFLOAT_MAX, layout.itemHeight)];
    size.width = size.width + 30;///30 是字体的左右间距
    size.height = layout.itemHeight;
    return size;
}
@end

@implementation DemoListComponent

- (void) setupListLayout:(EaseListLayout *)listLayout{
    listLayout.inset = UIEdgeInsetsMake(10, 10, 10, 10);
    _layout = listLayout;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    
    DemoContentCCell * ccell = [self.dataSource dequeueReusableCellOfClass:DemoContentCCell.class forComponent:self atIndex:index];
    ccell.contentView.layer.cornerRadius = 0.0f;
    ccell.oneLabel.font = [UIFont systemFontOfSize:16];
    [ccell setupWithData:[self dataAtIndex:index]];
    return ccell;
}
- (NSArray<NSString *> *)supportedElementKinds{
    return @[UICollectionElementKindSectionHeader];
}
@end

@implementation DemoWaterfallComponent

- (void) setupWaterfallLayout:(EaseWaterfallLayout *)waterfallLayout{
    waterfallLayout.inset = UIEdgeInsetsMake(10, 10, 10, 10);
    waterfallLayout.delegate = self;
    waterfallLayout.maxDisplayCount = 5;
    _layout = waterfallLayout;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    
    DemoContentCCell * ccell = [self.dataSource dequeueReusableCellOfClass:DemoContentCCell.class forComponent:self atIndex:index];
    ccell.contentView.layer.cornerRadius = 4.0f;
    ccell.oneLabel.font = [UIFont systemFontOfSize:16];
    [ccell setupWithData:[NSString stringWithFormat:@"%d %@",index,[self dataAtIndex:index]]];
    return ccell;
}
- (NSArray<NSString *> *)supportedElementKinds{
    return @[UICollectionElementKindSectionHeader];
}
#pragma mark - EaseWaterfallLayoutDelegate

- (CGSize)layoutCustomItemSize:(EaseWaterfallLayout *)layout atIndex:(NSInteger)index{
    CGFloat itemHeight = [[self dataAtIndex:index] floatValue];
    if (layout.arrange == EaseLayoutArrangeHorizontal) {
        return CGSizeMake(itemHeight, layout.itemHeight);
    }
    return CGSizeMake(layout.itemWidth, itemHeight);
}

@end

@implementation DemoBackgroundDecorateComponent

- (instancetype)initWithTitle:(NSString *)title{
    return [self initWithTitle:title orthogonalScroll:NO];
}

- (instancetype)initWithTitle:(NSString *)title orthogonalScroll:(BOOL)orthogonalScroll{
    self = [super initWithTitle:title];
    if (self) {
        EaseListLayout * listLayout = [EaseListLayout new];
        listLayout.inset = UIEdgeInsetsMake(0, 10, 0, 10);
        listLayout.distribution = [EaseLayoutDimension distributionDimension:3];
        listLayout.itemRatio = [EaseLayoutDimension fractionalDimension:183.0/267.0];
        if (orthogonalScroll) {
            listLayout.arrange = EaseLayoutArrangeHorizontal;
            listLayout.row = 1;
        }
        _layout = listLayout;
    }
    return self;;
}
- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    
    DemoContentCCell * ccell = [self.dataSource dequeueReusableCellOfClass:DemoContentCCell.class forComponent:self atIndex:index];
    ccell.contentView.layer.cornerRadius = 4.0f;
    ccell.oneLabel.font = [UIFont systemFontOfSize:16];
    [ccell setupWithData:@""];
    ccell.contentView.backgroundColor = [UIColor colorWithHexString:@"#7CBDFF"];
    return ccell;
}

//- (NSArray<NSString *> *)supportedElementKinds{
//    return @[
//        UICollectionElementKindSectionHeader,
//        UICollectionElementKindSectionFooter
//    ];
//}
//
//- (__kindof UICollectionReusableView *)viewForSupplementaryElementOfKind:(NSString *)elementKind{
//    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
//        return [super viewForSupplementaryElementOfKind:elementKind];
//    } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
//        DemoFooterView * footerView =
//        [self.dataSource dequeueReusableSupplementaryViewOfKind:elementKind forComponent:self clazz:DemoFooterView.class];
//        return footerView;
//    }
//    return nil;
//}
//
//- (CGSize)sizeForSupplementaryViewOfKind:(NSString *)elementKind{
//    if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
//        return CGSizeMake(200, 30);
//    }
//    return CGSizeMake(200, 50);
//}
//
//- (UIEdgeInsets) insetForSupplementaryViewOfKind:(NSString *)elementKind{
//    return UIEdgeInsetsMake(0, 10, 0, 10);
//}
@end
