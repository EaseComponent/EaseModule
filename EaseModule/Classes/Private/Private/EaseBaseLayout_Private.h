//
//  EaseBaseLayout+Private.h
//  EaseModule
//
//  Created by rocky on 2020/8/18.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "EaseBaseLayout.h"
#import "EaseModuleEnvironment_Protocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface EaseBaseLayout ()
@property (nonatomic ,strong ,readwrite) id<EaseModuleEnvironment> environment;

// 获取每一个index的位置
- (CGRect) itemFrameAtIndex:(NSInteger)index;

// 根据数据计算cell的位置
- (void) calculatorLayoutWithDatas:(NSArray *)datas;

@end

NS_ASSUME_NONNULL_END
