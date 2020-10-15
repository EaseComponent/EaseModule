//
//  DemoNewsRequest.m
//  EaseModule_Example
//
//  Created by rocky on 2020/9/28.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "DemoNewsRequest.h"

@implementation DemoNewsRequest

- (NSString *)requestUrl{
    return @"https://v2.sohu.com/article-service-api/article/421252230_120126853";
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (void)requestCompleteFilter{
    [super requestCompleteFilter];
    BOOL success = [self.responseObject[@"code"] integerValue] == 200;
    
    if (success) {
        NSDictionary * data = self.responseObject[@"data"];
        _articleInfo = @{
            @"title": EaseSafeString(data[@"article"][@"title"]),
            @"author": EaseSafeString(data[@"author"][@"name"]),
            @"publicTime": EaseSafeString(data[@"article"][@"publicTime"]),
        };
        _content = EaseSafeString(data[@"article"][@"content"]);
        _keyWords = data[@"article"][@"tkd"][@"keywords"];
    }
    NSLog(@"DemoNewsRequest:%@",self);
}

@end

@implementation DemoNewsRecommendRequest{
    NSInteger _key;
}

- (instancetype) initWithKey:(NSInteger)key{
    self = [super init];
    if (self) {
        _key = key;
    }
    return self;
}
- (NSString *)requestUrl{
    
    return [NSString stringWithFormat:@"https://v2.sohu.com/integration-api/mix/region/%ld?mpId=421252230&channel=10",(long)_key];
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (void)requestCompleteFilter{
    [super requestCompleteFilter];
    NSMutableArray * tmp = [NSMutableArray arrayWithArray:self.responseObject[@"data"]];
    if (tmp.count >= 2) {
//        _list = [tmp subarrayWithRange:NSMakeRange(0, 2)];
    }
    _list = tmp;
    NSLog(@"DemoNewsRecommendRequest:%@",self);
}

@end
