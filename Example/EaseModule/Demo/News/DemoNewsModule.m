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
    return NO;
}

- (__kindof YTKRequest *)fetchModuleRequest{
    return NewsInfoRequest.new;
}

- (__kindof YTKRequest *)loadMoreRequest{
    NSInteger key;
    if (_index >= _tempKeys.count) {
        key = [_tempKeys[0] integerValue];
    } else {
        key = [_tempKeys[_index] integerValue];
    }
    return [[NewsRecommendRequest alloc] initWithKey:key];
}

- (NSArray<__kindof YTKRequest *> *)fetchModuleRequests{
    return @[
        NewsInfoRequest.new,
        [[NewsRecommendRequest alloc] initWithKey:11873]
    ];
}

- (EaseQueueRequestModuleType)queueType{
    return EaseQueueRequestModuleAllDone;
}

- (void)parseModuleDataWithRequest:(__kindof YTKRequest *)request{
   
    NSLog(@"[Ease] :%@",request.class);
    if ([request isKindOfClass:[NewsInfoRequest class]]) {
        
        NewsInfoRequest * newsReq = (NewsInfoRequest *)request;
        
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
    } else if ([request isKindOfClass:[NewsRecommendRequest class]]) {
        
        NewsRecommendRequest * recommendReq = (NewsRecommendRequest *)request;

        NewsRecommendComponent * recommendComp =
        [self.dataSource componentAtIndex:3];
        if (!recommendComp) {
            recommendComp = [NewsRecommendComponent new];
            [recommendComp addDatas:recommendReq.list];
            [self.dataSource addComponent:recommendComp];
        } else {
            [recommendComp addDatas:recommendReq.list];
            [recommendComp reloadData];
            [self.collectionView reloadData];
        }
    }
}

@end
