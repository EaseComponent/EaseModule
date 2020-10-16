//
//  DemoShoppingModule.m
//  QILievModule
//
//  Created by rocky on 2020/8/10.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "DemoShoppingModule.h"
#import "DemoShoppingComponent.h"
#import "DemoShoppingRequest.h"

@interface DemoShoppingModule ()
@property (nonatomic ,copy) NSArray * independentComponents;
@end
@implementation DemoShoppingModule

- (instancetype)initWithName:(NSString *)name{
    self = [super initWithName:name];
    if (self) {
        self.independentComponents = @[
            ShoppingKeywordComponent.new,
            ShoppingAllCategoryComponent.new,
            ShoppingItemsComponent.new,
        ];
    }
    return self;
}
- (BOOL)shouldLoadMore{
    return NO;
}

- (NSArray<__kindof EaseComponent *> *)defaultComponents{
    return self.independentComponents;
}

- (void)refresh{
    [super refresh];
    for (ShoppingComponent * comp in self.independentComponents) {
        [comp refresh];
    }
}

- (NSArray<__kindof YTKRequest *> *)fetchModuleRequests{
    return @[
        ShoppingKeywordRequest.new,
        ShoppingAllCategoryRequest.new,
        ShoppingItemsRequest.new,
    ];
}

- (void)parseModuleDataWithRequest:(__kindof YTKRequest *)request{
    if ([request isKindOfClass:[ShoppingKeywordRequest class]]) {
        ShoppingKeywordComponent * component = [ShoppingKeywordComponent new];
        [component addDatas:((ShoppingKeywordRequest *)request).list];
        [self.dataSource addComponent:component];
    } else if ([request isKindOfClass:[ShoppingAllCategoryRequest class]]) {
        ShoppingAllCategoryComponent * component = [ShoppingAllCategoryComponent new];
        [component addDatas:((ShoppingAllCategoryRequest *)request).list];
        [self.dataSource addComponent:component];
    } else if ([request isKindOfClass:[ShoppingItemsRequest class]]) {
        ShoppingItemsComponent * component = [ShoppingItemsComponent new];
        [component addDatas:((ShoppingItemsRequest *)request).list];
        [self.dataSource addComponent:component];
    }
}
@end
