//
//  DemoShoppingComponent.h
//  QILievModule
//
//  Created by rocky on 2020/8/25.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "EaseModuler.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShoppingComponent : EaseComponent
- (void) refresh;
@end

@interface ShoppingKeywordComponent : ShoppingComponent<
EaseFlexLayoutDelegate>

@end

@interface ShoppingAllCategoryComponent : ShoppingComponent

@end

@interface ShoppingItemsComponent : ShoppingComponent<
EaseWaterfallLayoutDelegate>

@end

NS_ASSUME_NONNULL_END
