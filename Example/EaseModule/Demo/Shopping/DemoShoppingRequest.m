//
//  DemoShoppingRequest.m
//  EaseModule_Example
//
//  Created by rocky on 2020/10/16.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "DemoShoppingRequest.h"

@implementation ShoppingItemsRequest

- (NSString *)requestUrl{
    return @"http://you.163.com/xhr/item/saleRankItems.json";
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (void)requestCompleteFilter{
    [super requestCompleteFilter];
    NSMutableArray * result = [NSMutableArray new];
    for (NSDictionary * data in self.responseObject[@"data"]) {
        [result addObject:@{
            @"name":data[@"name"],
            @"pic":data[@"listPicUrl"],
            @"desc":data[@"simpleDesc"],
        }];
    }
    _list = [result ease_randomObjects];
}
@end

@implementation ShoppingAllCategoryRequest

- (NSString *)requestUrl{
    return [NSString stringWithFormat:@"http://you.163.com/xhr/globalinfo//queryTop.json?__timestamp=1602836155148"];
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (void)requestCompleteFilter{
    [super requestCompleteFilter];
    NSMutableArray * cateList = self.responseObject[@"data"][@"cateList"];
    NSMutableArray * result = [NSMutableArray new];
    
    for (NSDictionary * cate in cateList) {
        NSArray * subCateList = cate[@"subCateList"];
        for (NSDictionary *subCate in subCateList) {
            [result addObject:@{
                @"name":subCate[@"name"],
                @"pic":subCate[@"bannerUrl"],
            }];
        }
    }
    _list = [result ease_randomObjects];
}
 
@end

@implementation ShoppingKeywordRequest

- (NSString *)requestUrl{
    return [NSString stringWithFormat:@"http://you.163.com/xhr/search/queryHotKeyWord.json?__timestamp=1602836155148"];
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (void)requestCompleteFilter{
    [super requestCompleteFilter];
    _list = @[
        @"iPhone 12",@"华为 Mate 40",@"秋裤",
        @"叮当猫",@"沾化冬枣",@"N95口罩",@"防毒面具",
        @"加湿器",@"无线蓝牙耳机",@"保温杯",@"Type C数据线"
    ];
}


@end
