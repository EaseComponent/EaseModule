//
//  EaseModule.m
//  EaseModule
//
//  Created by rocky on 2020/7/9.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "EaseModuler.h"
//#import <YTKNetwork/YTKNetwork.h>
#import "EaseModuleEnvironment.h"
#import "EaseModuleDataSource_Private.h"
#import "EaseModule_Private.h"

@interface EaseModule (){
    NSArray<__kindof EaseComponent *> * _defaultComponents;
}
@end

@implementation EaseModule

- (void)dealloc{
    NSLog(@"%@ dealloc",self);
}

- (instancetype)init{
    return [self initWithName:@""];
}

- (instancetype)initWithName:(NSString *)name{
    return [self initWithName:name viewController:nil];
}

- (instancetype)initWithName:(NSString *)name
              viewController:(nullable UIViewController *)viewController{
    self = [super init];
    if (self) {
        _name = name;

        _dataSource = [EaseModuleDataSource new];
        
        self.originIndex = 1;
        _index = self.originIndex;
        _isRefresh = YES;
        _shouldLoadMore = YES;
    }
    return self;
}

- (NSArray<__kindof EaseComponent *> *) defaultComponents{
    return nil;
}

- (BOOL)needUseSpecialLoadMore{
    return self.loadMoreDifferentWithRefresh && !_isRefresh;
}

- (void)setupViewController:(UIViewController *)viewController
             collectionView:(UICollectionView *)collectionView{
    EaseModuleEnvironment * environment = [EaseModuleEnvironment new];
    environment.viewController = viewController;
    environment.collectionView = collectionView;
    
    self.dataSource.environment = environment;
}

- (UIViewController *)viewController {
    return self.dataSource.environment.viewController;
}

- (UICollectionView *)collectionView {
    return self.dataSource.environment.collectionView;
}
- (BOOL)empty{
    return [self.dataSource empty];
}

- (UIView *) blankPageView{
    return nil;
}

- (void) refresh{
    [self _addDefaultComponentsIfNeeds];
    _isRefresh = YES;
    [self resetIndex];
    [self _fetchModuleDataFromService];
}

- (void) loadMore{
    if (self.shouldLoadMore) {
        _isRefresh = NO;
        [self _fetchModuleDataFromService];
    }
}

- (void) resetIndex{
    _index = self.originIndex;
}

- (void) increaseIndex{
    _index ++;
}

#pragma mark - private M

- (void) _clear{
    if (self.haveDefaultComponents) {
        [self.dataSource clearExceptComponents:self->_defaultComponents];
    } else {
        [self.dataSource clear];
    }
}

- (void) _addDefaultComponentsIfNeeds{
    
    // 如果有默认的comp，就先展示出来
    if (!_defaultComponents) {
        _defaultComponents = [self defaultComponents];
        self.haveDefaultComponents = _defaultComponents.count != 0;
        if (self.haveDefaultComponents) {
            [self.collectionView layoutIfNeeded];
            [self.dataSource addComponents:_defaultComponents];
            [self.collectionView reloadData];
        }
    }
}
- (void) _fetchModuleDataFromService{
    
}

- (void) _wrapperSuccessUpdateForDelegate{
    if ([self.delegate respondsToSelector:@selector(moduleDidSuccessUpdateComponent:)]) {
        [self.delegate moduleDidSuccessUpdateComponent:self];
    }
}

- (void) _wrapperFailUpdateForDelegate:(NSError *)error{
    if ([self.delegate respondsToSelector:@selector(module:didFailUpdateComponent:)]) {
        [self.delegate module:self didFailUpdateComponent:error];
    }
}

@end

@implementation EaseCompositeModule{
@protected
    NSMutableArray<__kindof EaseModule *> *_innerModules;
}

- (instancetype)initWithName:(NSString *)name viewController:(nullable UIViewController *)viewController{
    
    self = [super initWithName:name viewController:viewController];
    if (self) {
        _innerModules = [NSMutableArray array];
    }
    return self;
}

- (void)addModule:(__kindof EaseModule *)module{
    if (module && [module isKindOfClass:EaseModule.class]) {
        [_innerModules addObject:module];
    }
}

- (NSArray<__kindof EaseModule *> *)modules{
    return [NSArray arrayWithArray:_innerModules];
}

@end

//@implementation EaseSingleRequestModule
//
//- (instancetype)initWithName:(NSString *)name{
//    self = [super initWithName:name];
//    if (self) {
//        _index = self.originIndex;
//        _pageSize = self.purePageSize;
//        
//        _isRefresh = YES;
//        _shouldLoadMore = YES;
//    }
//    return self;
//}
//
//- (void) refresh{
//    [self _addDefaultComponentsIfNeeds];
//    
//    _isRefresh = YES;
//    [self resetIndex];
//    [self _fetchModuleDataFromService];
//}
//
//- (void) loadMore{
//    if (self.shouldLoadMore) {
//        _isRefresh = NO;
//        [self _fetchModuleDataFromService];
//    }
//}
//
//- (void) resetIndex{
//    _index = 1;
//}
//
//- (void) increaseIndex{
//    _index ++;
//}
//
//- (NSInteger) originIndex{
//    return 1;
//}
//
//- (NSInteger) purePageSize{
//    return 20;
//}
//
//- (void) _fetchModuleDataFromService{
//    
//    [[self fetchModuleRequest]
//     startWithCompletionBlockWithSuccess:^(YTKRequest * _Nonnull request) {
//        if (_isRefresh) {
//            // clear
//            [self _clear];
//        }
//        [self parseModuleDataWithRequest:request];
//        [self increaseIndex];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self _wrapperSuccessUpdateForDelegate];
//        });
//    } failure:^(YTKRequest * _Nonnull request) {
//        [self _wrapperFailUpdateForDelegate:request.error];
//    }];
//}
//@end
//
//@implementation EasePureListModule
//
//- (EasePureListModuleType) pureListModuleType{
//    return EasePureListModuleReplace;
//}
//
//- (Class) pureListComponentClass{
//    return EaseComponent.class;
//}
//
//- (__kindof EaseComponent *) setupPureComponentWithDatas:(NSArray *)datas{
//    
//    Class componentClass = [self pureListComponentClass];
//    
//    if (self.pureListModuleType == EasePureListModuleReplace) {
//        [self.dataSource clear];
//        if (datas.count) {
//            EaseComponent * component = [componentClass new];
//            if (![component isKindOfClass:EaseComponent.class]) {
//                return nil;
//            }
//            [component addDatas:datas];
//            [self.dataSource addComponent:component];
//            return component;
//        }
//    } else if (self.pureListModuleType == EasePureListModuleAppend) {
//        EaseComponent * component = [self.dataSource componentAtIndex:0];
//        if (!component && datas.count) {
//            component = [componentClass new];
//            if (![component isKindOfClass:EaseComponent.class]) {
//                return nil;
//            }
//            [self.dataSource addComponent:component];
//        }
//        [component addDatas:datas];
//        return component;
//    }
//    return nil;
//}
//@end
//
//@interface EaseBatchRequestModule ()<
//YTKBatchRequestDelegate>
//@end
//
//@implementation EaseBatchRequestModule
//
//- (YTKBatchRequest *) fetchModuleBatchRequest{
//    return nil;
//}
//
//- (void) parseModuleDataWithBatchRequest:(YTKBatchRequest *)request{
//}
//
//@end
//
//@interface EaseChainRequestModule ()<
//YTKChainRequestDelegate>
//@end
//
//@implementation EaseChainRequestModule
//
//- (NSArray<__kindof YTKRequest *> *) fetchModuleChainRequests{
//    return nil;
//}
//
//- (EaseChainRequestModuleType) chainType{
//    return EaseChainRequestModuleAllDone;
//}
//
//- (void)_fetchModuleDataFromService{
//
//    NSArray * requests = [self fetchModuleChainRequests];
//
//    YTKChainRequest * chainRequest = [YTKChainRequest new];
//    chainRequest.delegate = self;
//    for (__kindof YTKRequest * request in requests) {
//        __weak typeof(self) weakSelf = self;
//        [chainRequest addRequest:request callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
//            __strong typeof(weakSelf) strongSelf = weakSelf;
//            [strongSelf parseModuleDataWithRequest:baseRequest];
//        }];
//    }
//    if (self.chainType == EaseChainRequestModuleAllDone) {
//    } else {
//
//    }
//    [chainRequest start];
//}
//
//- (void) parseModuleDataWithChainRequest:(YTKChainRequest *)request{
//
//}
//
//#pragma mark - YTKChainRequestDelegate
//
//- (void)chainRequestFinished:(YTKChainRequest *)chainRequest{
//
//}
//
//- (void)chainRequestFailed:(YTKChainRequest *)chainRequest failedBaseRequest:(YTKBaseRequest*)request{
//    [self _wrapperFailUpdateForDelegate:request.error];
//}
//
//@end

//@implementation EaseModule (SubclassingOverride)
//
//- (__kindof YTKRequest *)fetchModuleRequest{
//    return nil;
//}
//
//- (void) parseModuleDataWithRequest:(__kindof YTKRequest *)request{
//
//}
//
//- (UIView *) blankPageView{
//    return nil;
//}
//
//@end
