//
//  DemoLivingModule.m
//  QILievModule
//
//  Created by rocky on 2020/8/10.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "DemoLivingModule.h"
#import "DemoLivingComponent.h"

static NSDictionary * livingData;

@implementation DemoLivingModule

- (instancetype)initWithName:(NSString *)name{
    self = [super initWithName:name];
    if (self) {
        livingData = @{
            @"banner":@[
                    @"#B0F566",@"#F78AE0",@"#5CC9F5",@"#6638F0"
            ],
            @"hot":@[
                    @"11",
                    @"22",
                    @"3",
                    @"4",
            ],
            @"rocket": @[
                    @"red",@"green",@"orange",@"blue",@"white",@"yellow"
            ],
            @"recommend": @[
                    @"aaa",@"bbb",@"c",@"ddd",@"eee",@"ff",@"gg"
            ],
        };
    }
    return self;
}

- (BOOL)shouldLoadMore{
    return NO;
}

/**
 这里使用refresh来模拟网络加载，
 在开发中，一般是使用下面2步进行数据的获取、处理以及展示
 */
- (void)refresh{
    [super refresh];
    [self.dataSource clear];
    
    [self setupComponents:livingData];
    
    [self.collectionView reloadData];
}

// 真正业务中是如下2步
- (__kindof YTKRequest *)fetchModuleRequest{
    // 1.返回当前module的网络请求
    return nil;
}

- (void)parseModuleDataWithRequest:(__kindof YTKRequest *)request{
    // 2.根据request中的数据来进行component的组装
    [self setupComponents:livingData];
}

- (void) setupComponents:(NSDictionary *)data{
    
    [self.dataSource addComponent:({
        LivingBannerComponent * comp = [LivingBannerComponent new];
        [comp addData:data[@"banner"]];
        comp;
    })];
    [self.dataSource addComponent:({
        LivingHotComponent * comp = [[LivingHotComponent alloc] initWithTitle:@"热门主播"];
        [comp addDatas:data[@"hot"]];
        comp;
    })];
    [self.dataSource addComponent:({
        LivingRocketComponent * comp = [[LivingRocketComponent alloc] initWithTitle:@"龙虎榜"];
        comp.hiddenWhenEmpty = YES;
        // 注释掉下面的代码，该component就会隐藏
        [comp addDatas:data[@"rocket"]];
        comp;
    })];
    
    [self.dataSource addComponent:({
        LivingRecommendComponent * comp = [[LivingRecommendComponent alloc] initWithTitle:@"推荐主播"];
        [comp addDatas:data[@"recommend"]];
        comp;
    })];
}

@end
