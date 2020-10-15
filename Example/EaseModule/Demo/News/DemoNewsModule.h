//
//  DemoNewsModule.h
//  EaseModule_Example
//
//  Created by rocky on 2020/9/28.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "EaseModuler.h"

NS_ASSUME_NONNULL_BEGIN

// 使用不同的Module来测试单个请求、串行、并行请求下的逻辑
//@interface DemoNewsModule : EaseChainModule
@interface DemoNewsModule : EaseBatchModule
//@interface DemoNewsModule : EaseSingleModule

@end

NS_ASSUME_NONNULL_END
