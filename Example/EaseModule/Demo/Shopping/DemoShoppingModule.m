//
//  DemoShoppingModule.m
//  QILievModule
//
//  Created by rocky on 2020/8/10.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "DemoShoppingModule.h"
#import "DemoShoppingComponent.h"

static NSDictionary * shoppingData;

@implementation DemoShoppingModule

- (instancetype)initWithName:(NSString *)name{
    self = [super initWithName:name];
    if (self) {
        shoppingData = @{
            @"":@[],
            @"":@[],
        };
    }
    return self;
}
@end
