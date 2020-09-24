//
//  DemoSearchModule.m
//  QILievModule
//
//  Created by rocky on 2020/8/10.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "DemoSearchModule.h"
#import "DemoSearchComponent.h"

static NSDictionary * searchData;

@implementation DemoSearchModule

- (instancetype)initWithName:(NSString *)name{
    self = [super initWithName:name];
    if (self) {
        searchData = @{
            @"history":@[
                    @"google",@"facebook",@"youtube",@"amazon",
                    @"apple",@"Microsoft",@"Alphabet",@"IBM",
                    @"Vue组件",@"Vue.js 3.0",@"Vant",@"Ant.js",
                    @"swift语法",@"swiftUI",@"组件化",@"iOS开发",
                    @"Flutter & swift",
                    @"爬虫",
            ],
            @"rank":@[
                    @"关于适配XCode 12 跑模拟器编译报错的错误",
                    @"消息传递和消息转发",
                    @"iOS底层探索--方法慢速查找分析",
                    @"iOS Runtime02 - 方法查找流程分析",
                    @"iOS-objc_msgSend快速查找流程",
                    @"objc_msgSend 快速查找",
                    @"Flutter Route (路由) - 原生路由",
                    @"Flutter Dio 网络工具类封装",
                    @"Runtime面试题与栈区参数的一点小错误与另一种解题思路",
            ],
            @"recommend": @[
                    @{
                        @"title": @"字节研发设施下的 Git 工作流",
                        @"pic": @"https://imgkr2.cn-bj.ufileos.com/3d0117f1-1d05-41ab-b395-1a0065393268.png?UCloudPublicKey=TOKEN_8d8b72be-579a-4e83-bfd0-5f6ce1546f13&Signature=TJCclyrrSTaEcyRMdgSNnnOoYBI%253D&Expires=1600953513",
                        @"height": @(200)
                    },
                    @{
                        @"title": @"xnu内核调试",
                        @"pic": @"https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/2b5b965c0e3743a9930cd46c759a89b0~tplv-k3u1fbpfcp-zoom-1.image",
                        @"height": @(180)
                    },
                    @{
                        @"title": @"京喜小程序首页无障碍优化实践",
                        @"pic": @"https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/287dce6bdee540a0af9e50c454e2d7d2~tplv-k3u1fbpfcp-zoom-1.image",
                        @"height": @(100)
                    },
                    @{
                        @"title": @"iOS Crash防护",
                        @"pic": @"https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d9a39d1751bc4a12a3f07704e372be7c~tplv-k3u1fbpfcp-zoom-1.image",
                        @"height": @(190)
                    },
                    @{
                        @"title": @"autolayout中的线性规划算法 —— simplex",
                        @"pic": @"https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/fd1d4a7f16ee43929a1be96aa9f3d2bf~tplv-k3u1fbpfcp-zoom-1.image",
                        @"height": @(150)
                    },
                    @{
                        @"title": @"一文读懂崩溃原理",
                        @"pic": @"https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/fe4aab5d28324271b289c825eff50d31~tplv-k3u1fbpfcp-zoom-1.image",
                        @"height": @(150)
                    },
                    @{
                        @"title": @"HLS及M3U8介绍",
                        @"pic": @"https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/7a78f7db7f4142f2a8de19bf19feb9fb~tplv-k3u1fbpfcp-zoom-1.image",
                        @"height": @(110)
                    },
            ],
            @"video":@[
                    @(170),@(180),@(190),@(160),
                    @(210),@(220),@(230),
                    @(195),@(175),@(165),
            ],
            @"number":@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"],
            @"company":@[@"google",@"facebook",@"youtube",@"amazon",@"apple",@"Microsoft",@"Alphabet",@"IBM"],
            @"music":@[@"0 Love of My Life",@"1 Thank You",@"2 Yesterday Once More",@"3 You Are Not Alone",@"4 Billie Jean",@"5 Smooth Criminal",@"6 Earth Song",@"7 I will always love you",@"8 black or white"],
            @"waterFlow":@[
                    @(170),@(80),@(190),@(100),
                    @(110),@(200),@(130),
                    @(40),@(150),@(60),
            ],
        };
    }
    return self;
}

- (BOOL)shouldLoadMore{
    return NO;
}

- (NSArray<__kindof EaseComponent *> *)defaultComponents{
    
    SearchHistoryComponent * historyComp =
    [[SearchHistoryComponent alloc] initWithTitle:@"搜索历史"];
    [historyComp addDatas:searchData[@"history"]];
    
    SearchHotRankComponent * rankComp =
    [[SearchHotRankComponent alloc] initWithTitle:@"热搜文章"];
    [rankComp addDatas:searchData[@"rank"]];
    
    SearchRecommendComponent * recommendComp =
    [[SearchRecommendComponent alloc] initWithTitle:@"优质推荐"];
    [recommendComp addDatas:searchData[@"recommend"]];
    
    return @[
        historyComp,
        rankComp,
        recommendComp
    ];
}

@end
