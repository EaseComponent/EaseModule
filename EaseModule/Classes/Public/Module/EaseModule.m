//
//  EaseModule.m
//  EaseModule
//
//  Created by rocky on 2020/7/9.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "EaseModuler.h"
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
