//
//  EaseModuleDataSource.h
//  EaseModule
//
//  Created by rocky on 2020/6/28.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EaseComponent.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EaseModuleDataSourceAble;

@interface EaseModuleDataSource : NSObject<
UICollectionViewDataSource,
UICollectionViewDelegate,
EaseModuleDataSourceAble>{
    
    NSMutableArray<__kindof EaseComponent *> *_innerComponents;
}

@property (nonatomic, nullable, weak) id <UICollectionViewDelegate> collectionViewDelegate;
@property (nonatomic, nullable, weak) id <UIScrollViewDelegate> scrollViewDelegate;

@end

@interface EaseModuleDataSource (ComponentsHandle)

- (void) clear;///<清空已有的全部comp数据
- (void) clearExceptComponents:(NSArray<__kindof EaseComponent *> *)components;

- (void) addComponent:(__kindof EaseComponent *)component NS_SWIFT_NAME(add(_:));
- (void) addComponents:(NSArray<__kindof EaseComponent *> *)components NS_SWIFT_NAME(add(_:));

- (void) insertComponent:(__kindof EaseComponent *)component atIndex:(NSInteger)index;
- (void) replaceComponent:(__kindof EaseComponent *)component atIndex:(NSInteger)index;

- (void) removeComponent:(__kindof EaseComponent *)component NS_SWIFT_NAME(remove(_:));
- (void) removeComponentAtIndex:(NSInteger)index  NS_SWIFT_NAME(removeComponentAt(_:));

- (__kindof EaseComponent *) componentAtIndex:(NSInteger)index;
- (NSInteger) indexOfComponent:(__kindof EaseComponent *)comp;

- (NSArray<__kindof EaseComponent *> *) components;

- (NSInteger) count;

- (BOOL)empty;
@end

NS_ASSUME_NONNULL_END
