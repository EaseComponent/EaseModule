//
//  DemoNewsRequest.h
//  EaseModule_Example
//
//  Created by rocky on 2020/9/28.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

NS_ASSUME_NONNULL_BEGIN

@interface DemoNewsRequest : YTKRequest
@property (nonatomic ,copy ,readonly) NSDictionary * articleInfo;
@property (nonatomic ,copy ,readonly) NSString * content;
@property (nonatomic ,copy ,readonly) NSArray<NSString *> * keyWords;
@end

@interface DemoNewsRecommendRequest : YTKRequest
@property (nonatomic ,copy ,readonly) NSArray<NSDictionary *> * list;
- (instancetype) initWithKey:(NSInteger)key;
@end

NS_ASSUME_NONNULL_END
