//
//  DemoShoppingRequest.h
//  EaseModule_Example
//
//  Created by rocky on 2020/10/16.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShoppingKeywordRequest : YTKRequest
@property (nonatomic ,copy) NSArray * list;
@end

@interface ShoppingAllCategoryRequest : YTKRequest
@property (nonatomic ,copy) NSArray * list;
@end

@interface ShoppingItemsRequest : YTKRequest
@property (nonatomic ,copy) NSArray * list;
@end

NS_ASSUME_NONNULL_END
