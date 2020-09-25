//
//  DemoLivingComponent.h
//  EaseModule_Example
//
//  Created by rocky on 2020/9/25.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "EaseModuler.h"

NS_ASSUME_NONNULL_BEGIN

@interface LivingComponent : EaseComponent
- (instancetype)initWithTitle:(NSString *)title;
@end

@interface LivingBannerComponent : EaseComponent

@end

@interface LivingHotComponent : LivingComponent

@end

@interface LivingRocketComponent : LivingComponent

@end

@interface LivingRecommendComponent : LivingComponent

@end

NS_ASSUME_NONNULL_END
