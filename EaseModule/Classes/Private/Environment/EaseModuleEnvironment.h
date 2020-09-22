//
//  EaseModuleEnvironment.h
//  EaseModule
//
//  Created by rocky on 2020/7/14.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EaseModuleEnvironment_Protocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface EaseModuleEnvironment : NSObject<EaseModuleEnvironment>

@property (nonatomic, weak, readwrite) UIViewController * viewController;
@property (nonatomic, weak, readwrite) UICollectionView * collectionView;

@end

NS_ASSUME_NONNULL_END
