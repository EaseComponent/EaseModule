//
//  DemoNewsComponent.h
//  EaseModule_Example
//
//  Created by rocky on 2020/9/28.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "EaseModuler.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewsInfoComponent : EaseComponent<
EaseWaterfallLayoutDelegate>

@end

@interface NewsContentComponent : EaseComponent<
EaseWaterfallLayoutDelegate>

@end

@interface NewsKeywordComponent : EaseComponent<
EaseFlexLayoutDelegate>

@end

@interface NewsRecommendComponent : EaseComponent

@end
NS_ASSUME_NONNULL_END
