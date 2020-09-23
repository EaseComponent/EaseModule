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
                    @"google",@"facebook",@"youtube",@"amazon",@"apple",@"Microsoft",@"Alphabet",@"IBM",
                    @"Vue组件",
                    @"swift语法",
                    @"爬虫",
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

- (NSArray<__kindof EaseComponent *> *)defaultComponents{
    
    SearchHistoryComponent * historyComp = [[SearchHistoryComponent alloc] initWithTitle:@"搜索历史"];
    [historyComp addDatas:searchData[@"history"]];
    
    return @[historyComp];
}

@end
