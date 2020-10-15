//
//  EaseSingleModule.h
//  EaseModule
//
//  Created by rocky on 2020/10/14.
//

#import <EaseModule/EaseModule.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, EasePureListModuleType) {
    EasePureListModuleReplace,/// 直接替换原有的数据
    EasePureListModuleAppend/// 在原有的数据后追加数据
};

@class YTKRequest;

/*
 单个的网络请求组成的模块
 */
@interface EaseSingleModule : EaseModule

/// 当前module的网络请求，override
- (__kindof YTKRequest *) fetchModuleRequest;
/*
 loadMoreDifferentWithRefresh 为YES，
 loadMore操作是单独的网络请求，override
 */
- (__kindof YTKRequest *) loadMoreRequest;

/// 根据网络数据进行解析，解析出来对应的Component，override
- (void) parseModuleDataWithRequest:(__kindof YTKRequest *)request;

@end

/*
 请求映射成的component是同一种类型，
 是 EaseSingleRequestModule 的一个特殊情形
*/
@interface EasePureListModule : EaseSingleModule

/// 指明类型，`替换`或者`追加`，override
- (EasePureListModuleType) pureListModuleType;

/// 指明comp的类型，override
- (Class) pureListComponentClass;

/// 将请求的数据通过该方法过滤，获取comp，在`parseModuleDataWithRequest`中调用
- (__kindof EaseComponent *) setupPureComponentWithDatas:(NSArray *)datas;
@end

NS_ASSUME_NONNULL_END
