//
//  DemoNewsModule.m
//  EaseModule_Example
//
//  Created by rocky on 2020/9/28.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "DemoNewsModule.h"
#import "DemoNewsComponent.h"
#import "DemoNewsRequest.h"

@implementation DemoNewsModule{
    NSArray *_tempKeys;
}

- (instancetype)initWithName:(NSString *)name{
    self = [super initWithName:name];
    if (self) {
        _tempKeys = @[@(100),@(11873),@(103),@(106),@(140),@(11741),@(6723)];
        self.loadMoreDifferentWithRefresh= YES;
    }
    return self;
}

- (BOOL)shouldLoadMore{
    return YES;
}

- (__kindof YTKRequest *)fetchModuleRequest{
    return DemoNewsRequest.new;
}

- (__kindof YTKRequest *)loadMoreRequest{
    NSInteger key;
    if (_index >= _tempKeys.count) {
        key = [_tempKeys[0] integerValue];
    } else {
        key = [_tempKeys[_index] integerValue];
    }
    return [[DemoNewsRecommendRequest alloc] initWithKey:key];
}

- (NSArray<__kindof YTKRequest *> *)fetchModuleRequests{
    return @[
        DemoNewsRequest.new,
        [[DemoNewsRecommendRequest alloc] initWithKey:5823]
    ];
}

- (EaseQueueRequestModuleType)queueType{
    return EaseQueueRequestModuleAllDone;
}

- (void)parseModuleDataWithRequests:(NSArray<__kindof YTKRequest *> *)requests{
    for (YTKRequest * request in requests) {
        [self parseModuleDataWithRequest:request];
    }
}

- (void)parseModuleDataWithRequest:(__kindof YTKRequest *)request{
   
    if ([request isKindOfClass:[DemoNewsRequest class]]) {
        
        DemoNewsRequest * newsReq = (DemoNewsRequest *)request;
        
        NewsInfoComponent * infoComp = [NewsInfoComponent new];
        [infoComp addData:newsReq.articleInfo];
        
        NewsContentComponent * contentComp = [NewsContentComponent new];
        [contentComp addData:newsReq.content];
        
        NewsKeywordComponent * keywoardComp = [NewsKeywordComponent new];
        [keywoardComp addDatas:newsReq.keyWords];
        
        [self.dataSource addComponents:@[
            infoComp,
            contentComp,
            keywoardComp,
        ]];
    } else if ([request isKindOfClass:[DemoNewsRecommendRequest class]]) {
        
        DemoNewsRecommendRequest * recommendReq = (DemoNewsRecommendRequest *)request;
        
        NewsRecommendComponent * recommendComp =
        [self.dataSource componentAtIndex:3];
        if (!recommendComp) {
            recommendComp = [NewsRecommendComponent new];
            [recommendComp addDatas:recommendReq.list];
            [self.dataSource addComponent:recommendComp];
        } else {        
            [recommendComp addDatas:recommendReq.list];
            [recommendComp reloadData];
        }
    }
}

@end
