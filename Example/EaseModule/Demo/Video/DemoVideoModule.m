//
//  DemoVideoModule.m
//  QILievModule
//
//  Created by rocky on 2020/8/10.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "DemoVideoModule.h"
#import "DemoVideoComponent.h"

static NSDictionary * videoData;

@implementation DemoVideoModule

- (instancetype)initWithName:(NSString *)name{
    self = [super initWithName:name];
    if (self) {
        videoData = @{
            @"banner":@[
                    @"https://puui.qpic.cn/tv/0/1221861328_498280/0",
                    @"https://puui.qpic.cn/tv/0/841100946_498280/0",
                    @"https://puui.qpic.cn/tv/0/1221860096_498280/0",
                    @"https://puui.qpic.cn/tv/0/1221855502_498280/0"
            ],
            @"category":@[
                    @"精选",
                    @"电视剧",
                    @"电影",
                    @"综艺",
                    @"动漫",
                    @"少儿",
                    @"纪录片",
                    @"音乐"
            ],
            @"hot":@[@"https://puui.qpic.cn/vcover_vt_pic/0/0pj8vuntnocu7971572426589/350",
                     @"https://puui.qpic.cn/vcover_vt_pic/0/mzc00200msasbht1594277675206/350",
                     @"https://puui.qpic.cn/vcover_vt_pic/0/mzc00200sdazhw61595925306553/350",
                     @"https://puui.qpic.cn/vcover_vt_pic/0/c6jz9bdhtz6a8k41539140824/350",
                     @"https://puui.qpic.cn/vcover_vt_pic/0/mzc00200iq4oevy1587546092886/350",
                     @"https://puui.qpic.cn/vcover_vt_pic/0/mzc00200vef064r1597137067757/350"],
            @"film":@[
                    @"https://puui.qpic.cn/vcover_vt_pic/0/c2seabnsfozypl81523522065/220",
                    @"https://puui.qpic.cn/vcover_vt_pic/0/e0bk8kf7wllv7r81595899463119/220",
                    @"https://puui.qpic.cn/vcover_vt_pic/0/v2098lbuihuqs111587100715029/220",
                    @"https://puui.qpic.cn/vcover_vt_pic/0/f7pqur8uhmzltps1559809738/220",
                    @"https://puui.qpic.cn/vcover_vt_pic/0/r5trbf8xs5uwok11590989398026/220",
                    @"https://puui.qpic.cn/vcover_vt_pic/0/803p673mlosoeog1559758979/220",
                    @"https://puui.qpic.cn/vcover_vt_pic/0/xg95sxi4q7zc4uot1460107848.jpg/220",
                    @"https://puui.qpic.cn/vcover_vt_pic/0/380idj4s3fxn1mz1543994759/220",
                    @"https://puui.qpic.cn/vcover_vt_pic/0/is7os79rewv1iuk1560166900/220"
            ],
            @"rank":@[
                    @"盗梦空间",
                    @"楚门的世界",
                    @"星际穿越",
                    @"黑客帝国",
                    @"蝴蝶效应",
                    @"2001太空漫游",
                    @"回到未来",
                    @"超能陆战队",
                    @"守望者",
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

// 这里使用refresh来模拟网络加载
- (void)refresh{
    [super refresh];
    [self.dataSource clear];
    
    [self setupComponents:videoData];
    
    [self.collectionView reloadData];
}

// 真正业务中是实现如下方法
- (__kindof YTKRequest *)fetchModuleRequest{
    // 1.返回当前module的网络请求
    return nil;
}

- (void)parseModuleDataWithRequest:(__kindof YTKRequest *)request{
    // 2.根据request中的数据来进行component的组装
    [self setupComponents:videoData];
}

- (void) setupComponents:(NSDictionary *)data{
    
    [self.dataSource addComponent:({
        VideoBannerComponent * comp = [VideoBannerComponent new];
        [comp addData:data[@"banner"]];
        comp;
    })];

    [self.dataSource addComponent:({
        VideoCategoryComponent * comp = [VideoCategoryComponent new];
        [comp addDatas:data[@"category"]];
        comp;
    })];

    [self.dataSource addComponent:({
        VideoFilmComponent * comp = [VideoFilmComponent new];
        [comp addDatas:data[@"film"]];
        comp;
    })];
    
    [self.dataSource addComponent:({
        VideoRankComponent * comp = [VideoRankComponent new];
        [comp addDatas:data[@"rank"]];
        comp;
    })];
    [self.dataSource addComponent:({
        VideoComponent * comp = [VideoComponent new];
        [comp addDatas:data[@"video"]];
        comp;
    })];
}
@end
