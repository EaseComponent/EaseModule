//
//  EaseQueueModule.m
//  EaseModule
//
//  Created by rocky on 2020/10/15.
//

#import "EaseQueueModule.h"
#import <YTKNetwork/YTKNetwork.h>
#import "EaseModule_Private.h"

@interface EaseBatchModule ()<
YTKBatchRequestDelegate>
@property (nonatomic ,assign) NSInteger requestFinishedCount;
@end

@implementation EaseBatchModule

- (instancetype)initWithName:(NSString *)name{
    self = [super initWithName:name];
    if (self) {
        self.requestFinishedCount = 0;
    }
    return self;
}
- (NSArray<__kindof YTKRequest *> *) fetchModuleRequests{
    // override
    return nil;
}
- (__kindof YTKRequest *) loadMoreRequest{
    // override
    return nil;
}
- (EaseQueueRequestModuleType) queueType{
    return EaseQueueRequestModuleAllDone;
}

- (void)_fetchModuleDataFromService{
    
    if (self.needUseSpecialLoadMore) {
        [[self loadMoreRequest]
         startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [self increaseIndex];
            [self parseModuleDataWithRequest:request];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self _wrapperSuccessUpdateForDelegate];
            });
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [self _wrapperFailUpdateForDelegate:request.error];
        }];
    } else {
        NSArray * requests = [self fetchModuleRequests];
        if (requests.count == 0) {
            return;
        }
        
        YTKBatchRequest * batchRequest =
        [[YTKBatchRequest alloc] initWithRequestArray:requests];
        batchRequest.delegate = self;
        [batchRequest start];
        [self _clear];
        if (self.queueType == EaseQueueRequestModuleOneByOne) {
            /// Warn: batchRequest将request的success、failed的block回调移除了，这里单独加一下，
            /// 但是可能会有先后顺序的问题
            __weak typeof(self) weakSelf = self;
            for (YTKRequest * request in requests) {
                [request setSuccessCompletionBlock:^(__kindof YTKBaseRequest * req) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    [strongSelf parseModuleDataWithRequest:req];
                    [self _wrapperSuccessUpdateForDelegate];
                }];
            }
        }
    }
}

- (void) parseModuleDataWithRequest:(__kindof YTKRequest *)request{
    // override
}

#pragma mark - YTKBatchRequestDelegate

- (void)batchRequestFinished:(YTKBatchRequest *)batchRequest{
    [self increaseIndex];
    if (self.queueType == EaseQueueRequestModuleAllDone) {
        for (YTKRequest * request in batchRequest.requestArray) {
            [self parseModuleDataWithRequest:request];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _wrapperSuccessUpdateForDelegate];
        });
    }
}

- (void)batchRequestFailed:(YTKBatchRequest *)batchRequest{
    [self _wrapperFailUpdateForDelegate:batchRequest.failedRequest.error];
}

@end

@interface EaseChainModule ()<
YTKChainRequestDelegate>
@end

@implementation EaseChainModule

- (NSArray<__kindof YTKRequest *> *) fetchModuleRequests{
    // override
    return nil;
}
- (__kindof YTKRequest *) loadMoreRequest{
    // override
    return nil;
}

- (EaseQueueRequestModuleType) queueType{
    return EaseQueueRequestModuleAllDone;
}

- (void)_fetchModuleDataFromService{

    if (self.needUseSpecialLoadMore) {
        [[self loadMoreRequest]
         startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [self increaseIndex];
            [self parseModuleDataWithRequest:request];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self _wrapperSuccessUpdateForDelegate];
            });
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [self _wrapperFailUpdateForDelegate:request.error];
        }];
    } else {
        NSArray * requests = [self fetchModuleRequests];
        if (requests.count == 0) {
            return;
        }
        YTKChainRequest * chainRequest = [YTKChainRequest new];
        chainRequest.delegate = self;
        __weak typeof(self) weakSelf = self;
        for (__kindof YTKRequest * request in requests) {
            YTKChainCallback chainCallback;
            if (self.queueType == EaseQueueRequestModuleOneByOne) {
                chainCallback = ^(YTKChainRequest *chainRequest, YTKBaseRequest *req){
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    [strongSelf parseModuleDataWithRequest:req];
                    [self _wrapperSuccessUpdateForDelegate];
                };
            }
            [chainRequest addRequest:request callback:chainCallback];
        }
        [chainRequest start];
        [self _clear];
    }
}

- (void) parseModuleDataWithRequest:(__kindof YTKBaseRequest *)request{
    // override
}

#pragma mark - YTKChainRequestDelegate

- (void)chainRequestFinished:(YTKChainRequest *)chainRequest{
    [self increaseIndex];
    if (self.queueType == EaseQueueRequestModuleAllDone) {
        for (YTKRequest * request in chainRequest.requestArray) {
            [self parseModuleDataWithRequest:request];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _wrapperSuccessUpdateForDelegate];
        });
    }
}

- (void)chainRequestFailed:(YTKChainRequest *)chainRequest failedBaseRequest:(YTKBaseRequest*)request{
    [self _wrapperFailUpdateForDelegate:request.error];
}

@end
