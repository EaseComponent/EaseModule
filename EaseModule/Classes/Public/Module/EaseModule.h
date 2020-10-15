//
//  EaseModule.h
//  EaseModule
//
//  Created by rocky on 2020/7/9.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EaseModuleDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EaseModuleDelegate;

@interface EaseModule : NSObject{
@public BOOL _isRefresh;
@public NSInteger _index;
@public NSInteger _pageSize;
    
@private EaseModuleDataSource *_dataSource;
}

// default 1
@property (nonatomic ,assign) NSInteger originIndex;

@property (nonatomic ,copy ,readonly) NSString * name;

@property (nonatomic ,assign ,readonly) BOOL empty;

@property (nonatomic ,weak) id<EaseModuleDelegate> delegate;

@property (nonatomic ,assign) BOOL didAppeared;

/// 能否加载更多，默认为YES
@property (nonatomic ,assign) BOOL shouldLoadMore;
/// 上拉加载与下拉刷新的网络请求不一致，默认为NO
@property (nonatomic ,assign) BOOL loadMoreDifferentWithRefresh;

@property (nonatomic, readonly) UIViewController * viewController;
@property (nonatomic, readonly) UICollectionView * collectionView;

@property (nonatomic ,strong ,readonly) EaseModuleDataSource * dataSource;

- (instancetype) initWithName:(NSString *)name;

/// 如果一部分需要网络请求，另一部分不需要网络请求，override
- (NSArray<__kindof EaseComponent *> *) defaultComponents;

/// 刷新数据
- (void) refresh;
/// 加载下一页
- (void) loadMore;

- (void) setupViewController:(UIViewController *)viewController
              collectionView:(UICollectionView *)collectionView NS_SWIFT_NAME(setup(viewController:collectionView:));

/// 该模块没有数据时候的空态视图，override
- (UIView *) blankPageView;
@end

/*
  对EaseModule的组合
 */
@interface EaseCompositeModule : EaseModule

- (void) addModule:(__kindof EaseModule *)module;
- (NSArray<__kindof EaseModule *> *) modules;

@end

#pragma mark - EaseModuleDelegate

@protocol EaseModuleDelegate <NSObject>

- (void) moduleDidSuccessUpdateComponent:(__kindof EaseModule *)module;
- (void) module:(__kindof EaseModule *)module didFailUpdateComponent:(NSError *)error;
@end

NS_ASSUME_NONNULL_END
