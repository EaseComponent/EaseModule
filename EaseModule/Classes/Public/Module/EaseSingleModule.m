//
//  EaseSingleModule.m
//  EaseModule
//
//  Created by rocky on 2020/10/14.
//

#import "EaseSingleModule.h"
#import <YTKNetwork/YTKNetwork.h>
#import "EaseModule_Private.h"

@implementation EaseSingleModule

- (instancetype)initWithName:(NSString *)name{
    self = [super initWithName:name];
    if (self) {
        _pageSize = 20;
    }
    return self;
}

- (void) _fetchModuleDataFromService{
    
    YTKRequest * request;
    if (self.needUseSpecialLoadMore) {
        request = [self loadMoreRequest];
    } else {
        request = [self fetchModuleRequest];
    }
    
    [request startWithCompletionBlockWithSuccess:^(YTKRequest * _Nonnull innerRequest) {
        if (self->_isRefresh) {
            // clear
            [self _clear];
        }
        [self increaseIndex];
        [self parseModuleDataWithRequest:innerRequest];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _wrapperSuccessUpdateForDelegate];
        });
    } failure:^(YTKRequest * _Nonnull innerRequest) {
        [self _wrapperFailUpdateForDelegate:innerRequest.error];
    }];
}

- (__kindof YTKRequest *)fetchModuleRequest{
    // override
    return nil;
}
- (__kindof YTKRequest *)loadMoreRequest{
    // override
    return nil;
}

- (void)parseModuleDataWithRequest:(__kindof YTKRequest *)request{
    // override
}
@end

@implementation EasePureListModule

- (EasePureListModuleType) pureListModuleType{
    return EasePureListModuleReplace;
}

- (Class) pureListComponentClass{
    return EaseComponent.class;
}

- (__kindof EaseComponent *) setupPureComponentWithDatas:(NSArray *)datas{
    
    Class componentClass = [self pureListComponentClass];
    
    if (self.pureListModuleType == EasePureListModuleReplace) {
        [self.dataSource clear];
        if (datas.count) {
            EaseComponent * component = [componentClass new];
            if (![component isKindOfClass:EaseComponent.class]) {
                return nil;
            }
            [component addDatas:datas];
            [self.dataSource addComponent:component];
            return component;
        }
    } else if (self.pureListModuleType == EasePureListModuleAppend) {
        EaseComponent * component = [self.dataSource componentAtIndex:0];
        if (!component && datas.count) {
            component = [componentClass new];
            if (![component isKindOfClass:EaseComponent.class]) {
                return nil;
            }
            [self.dataSource addComponent:component];
        }
        [component addDatas:datas];
        return component;
    }
    return nil;
}
@end

