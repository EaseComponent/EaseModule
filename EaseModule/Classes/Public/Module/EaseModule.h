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

typedef NS_ENUM(NSInteger, EasePureListModuleType) {
    EasePureListModuleReplace,/// 直接替换原有的数据
    EasePureListModuleAppend/// 在原有的数据后追加数据
};

@class YTKRequest;
@protocol EaseModuleDelegate;

@interface EaseModule : NSObject{
    BOOL _isRefresh;
    NSInteger _index;
    NSInteger _pageSize;
    
    EaseModuleDataSource *_dataSource;
}

@property (nonatomic ,copy ,readonly) NSString * name;

/// 能否加载更多，默认为YES
@property (nonatomic ,assign) BOOL shouldLoadMore;

@property (nonatomic ,assign ,readonly) BOOL empty;

@property (nonatomic ,weak) id<EaseModuleDelegate> delegate;

@property (nonatomic ,assign) BOOL didAppeared;

- (instancetype) initWithName:(NSString *)name;

@property (nonatomic, readonly) UIViewController * viewController;
@property (nonatomic, readonly) UICollectionView * collectionView;

@property (nonatomic ,strong ,readonly) EaseModuleDataSource * dataSource;

// 如果一部分需要网络请求，另一部分不需要网络请求
- (NSArray<__kindof EaseComponent *> *) defaultComponents;

- (void) refresh;///< 刷新数据
- (void) loadMore;///< 加载下一页

- (void) setupViewController:(UIViewController *)viewController
              collectionView:(UICollectionView *)collectionView NS_SWIFT_NAME(setup(viewController:collectionView:));
@end

@interface EaseModule (SubclassingOverride)

- (__kindof YTKRequest *) fetchModuleRequest;
- (void) parseModuleDataWithRequest:(__kindof YTKRequest *)request;

- (UIView *) blankPageView;

@end

@interface EaseCompositeModule : EaseModule

- (void) addModule:(__kindof EaseModule *)module;
- (NSArray<__kindof EaseModule *> *) modules;

@end

@interface EasePureListModule : EaseModule

/// 指明类型，替换和追加
- (EasePureListModuleType) pureListModuleType;

/// 指明comp的类型
- (Class) pureListComponentClass;

/// 将请求的数据通过该方法过滤，获取comp
- (__kindof EaseComponent *) setupPureComponentWithDatas:(NSArray *)datas;
@end

@protocol EaseModuleDelegate <NSObject>

- (void) liveModuleDidSuccessUpdateComponent:(EaseModule *)module;
- (void) liveModule:(EaseModule *)module didFailUpdateComponent:(NSError *)error;
@end


NS_ASSUME_NONNULL_END
