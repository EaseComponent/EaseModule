//
//  DemoSearchComponent.h
//  QILievModule
//
//  Created by rocky on 2020/8/19.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "EaseModuler.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchComponent : EaseComponent

@property (nonatomic ,copy ,readonly) NSString * title;

- (instancetype) initWithTitle:(NSString *)title;
@end

@interface SearchHistoryComponent : SearchComponent<
EaseFlexLayoutDelegate>

@end

@interface SearchHotRankComponent : SearchComponent

@end

@interface SearchRecommendComponent : SearchComponent<
EaseWaterfallLayoutDelegate>

@end
NS_ASSUME_NONNULL_END
