//
//  EaseQueueModule.h
//  EaseModule
//
//  Created by rocky on 2020/10/15.
//

#import <EaseModule/EaseModule.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, EaseQueueRequestModuleType) {
    EaseQueueRequestModuleOneByOne,/// 链式请求中的任意一个请求结束
    EaseQueueRequestModuleAllDone/// 链式请求中的所有请求都结束
};

@class YTKRequest;

@protocol EaseQueueModuleAble <NSObject>
/*
 要进行队列请求的所有请求，override
*/
- (NSArray<__kindof YTKRequest *> *) fetchModuleRequests;
/*
 loadMoreDifferentWithRefresh 为YES，
 loadMore操作是单独的网络请求，override
 */
- (__kindof YTKRequest *) loadMoreRequest;
/*
 根据请求解析数据的方式，默认为`EaseQueueRequestModuleAllDone`，override
 * 任意一个请求完成，EaseQueueRequestModuleOneByOne
 * 所有请求都完成之后，EaseQueueRequestModuleAllDone
 */
- (EaseQueueRequestModuleType) queueType;

/*
 用来解析每一个请求的数据，override
 */
- (void) parseModuleDataWithRequest:(__kindof YTKRequest *)request;
@end

@interface EaseBatchModule : EaseModule<EaseQueueModuleAble>

@end

@interface EaseChainModule : EaseModule<EaseQueueModuleAble>

@end
NS_ASSUME_NONNULL_END
