//
//  DemoShoppingModule.m
//  QILievModule
//
//  Created by rocky on 2020/8/10.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "DemoShoppingModule.h"
#import "DemoShoppingComponent.h"

@implementation DemoShoppingModule

- (instancetype)initWithName:(NSString *)name{
    self = [super initWithName:name];
    if (self) {
        
    }
    return self;
}

- (NSArray<__kindof EaseComponent *> *)defaultComponents{
    return @[
        ShoppingKeywordComponent.new,
        ShoppingAllCategoryComponent.new,
        ShoppingItemsComponent.new,
    ];
}

@end
