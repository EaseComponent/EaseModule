//
//  EaseModuleAdapterProxy.h
//  EaseModule
//
//  Created by rocky on 2020/8/6.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EaseModuleDataSourceAble;
@interface EaseModuleAdapterProxy : NSProxy

- (instancetype)initWithCollectionViewTarget:(nullable id<UICollectionViewDelegate>)collectionViewTarget
                            scrollViewTarget:(nullable id<UIScrollViewDelegate>)scrollViewTarget
                                 dataSource:(id<EaseModuleDataSourceAble>)dataSource;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
