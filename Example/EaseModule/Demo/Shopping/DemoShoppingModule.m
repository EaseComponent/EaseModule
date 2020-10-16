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

@implementation DemoShoppingModule

- (BOOL)shouldLoadMore{
    return NO;
}

//- (NSArray<__kindof EaseComponent *> *)defaultComponents{
//    return @[
//        ShoppingKeywordComponent.new,
//        ShoppingAllCategoryComponent.new,
//        ShoppingItemsComponent.new,
//    ];
//}

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
