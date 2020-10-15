//
//  EaseModule+Private.h
//  EaseModule
//
//  Created by rocky on 2020/10/14.
//

#import <EaseModule/EaseModule.h>

NS_ASSUME_NONNULL_BEGIN

@interface EaseModule ()

@property (nonatomic ,assign) BOOL haveDefaultComponents;
@property (nonatomic ,assign ,readonly) BOOL needUseSpecialLoadMore;

- (void) resetIndex;
- (void) increaseIndex;

- (void) _clear;

- (void) _addDefaultComponentsIfNeeds;
- (void) _fetchModuleDataFromService;
- (void) _wrapperSuccessUpdateForDelegate;
- (void) _wrapperFailUpdateForDelegate:(NSError *)error;
@end

NS_ASSUME_NONNULL_END
