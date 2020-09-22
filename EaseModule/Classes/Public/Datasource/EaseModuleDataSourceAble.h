//
//  EaseModuleDataSourceAble.h
//  EaseModule
//
//  Created by rocky on 2020/7/9.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class EaseComponent;

@protocol EaseModuleDataSourceAble <NSObject>

- (__kindof UICollectionViewCell *)dequeueReusableCellOfClass:(Class)cellClass
                                                 forComponent:(__kindof EaseComponent *)component
                                                      atIndex:(NSInteger)index;

- (__kindof UICollectionViewCell *)dequeueReusablePlaceholdCellOfClass:(Class)cellClass
                                                          forComponent:(__kindof EaseComponent *)component;

- (__kindof UICollectionReusableView *)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind
                                                                 forComponent:(__kindof EaseComponent *)component
                                                                        clazz:(Class)viewClass;
@end

NS_ASSUME_NONNULL_END
