//
//  NSArray+Sugar.m
//  Ease
//
//  Created by 洛奇 on 2019/6/10.
//  Copyright © 2019 huayang. All rights reserved.
//

#import "NSArray+Sugar.h"
#import "NSObject+EaseRuntime.h"

@implementation NSArray (Sugar)
- (id) ease_first{
    
    if (self.count) {
        return [self firstObject];
    }
    return nil;
}

- (id) ease_last{
    
    if (self.count) {
        return [self lastObject];
    }
    return nil;
}

- (id) ease_sample{
    
    if (self.count == 0)    return nil;
    
    return self[arc4random_uniform((UInt32)self.count)];
}

- (void) ease_each:(void (^)(id))handle{
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        handle(obj);
    }];
}

- (void)ease_eachWithOptions:(void (^)(id))handle options:(NSEnumerationOptions)options{
    [self ease_each:handle options:options];
}

- (void) ease_each:(void (^)(id))handle options:(NSEnumerationOptions)options{
    @autoreleasepool{
        [self enumerateObjectsWithOptions:options usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            handle(obj);
        }];
    }
}

- (void) ease_eachWithIndex:(void(^)(id ,NSInteger))handle{
    
    @autoreleasepool{
        [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            handle(obj,idx);
        }];
    }
}

- (void) ease_eachWithStop:(BOOL(^)(id obj))handle{
    
    @autoreleasepool{
        [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            *stop = handle(obj);
        }];
    }
}

- (void) ease_eachWithIndexStop:(BOOL(^)(id obj ,NSUInteger index))handle{
    @autoreleasepool{
        [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            *stop = handle(obj ,idx);
        }];
    }
}
- (BOOL) ease_includes:(id)obj{
    
    return [self containsObject:obj];
}

- (BOOL (^)(id obj)) ease_have{
    
    return ^BOOL(id obj){
        return [self ease_includes:obj];
    };
}

- (NSArray *) ease_map:(id (^)(id))handle{
    
    NSMutableArray * _self = [NSMutableArray arrayWithCapacity:self.count];
    @autoreleasepool{
        for (id obj in self) {
            [_self addObject:handle(obj) ? : [NSNull null]];
        }
    }
    return [_self copy];
}

- (NSArray *) ease_mapWithIndex:(id (^)(id,NSUInteger))handle{
    
    NSMutableArray * _self = [NSMutableArray arrayWithCapacity:self.count];
    @autoreleasepool{
        NSUInteger index = 0;
        for (id obj in self) {
            [_self addObject:handle(obj,index) ? : [NSNull null]];
            index ++;
        }
    }
    return [_self copy];
}

- (NSArray *) ease_mapWithskip:(id (^)(id obj, BOOL *skip))handle{
    
    NSMutableArray * _self = [NSMutableArray arrayWithCapacity:self.count];
    @autoreleasepool{
        for( id obj in self ){
            
            BOOL skip = NO;
            
            id mapObj = handle(obj, &skip);
            
            if( !skip ){
                [_self addObject:mapObj];
            }
        }
    }
    return [_self copy];
}

- (NSArray *) ease_mapWithSkipIndex:(id (^)(id obj, BOOL *skip, NSUInteger idnex))handle{
    
    NSMutableArray * _self = [NSMutableArray arrayWithCapacity:self.count];
    @autoreleasepool{
        NSUInteger index = 0;
        for( id obj in self ){
            
            BOOL skip = NO;
            
            id mapObj = handle(obj, &skip, index);
            
            if( !skip ){
                [_self addObject:mapObj];
            }
            index ++;
        }
    }
    return [_self copy];
}

- (NSArray *) ease_compactMap:(id (^)(id))handle{
    
    NSMutableArray * _self = [NSMutableArray arrayWithCapacity:self.count];
    @autoreleasepool{
        for (id obj in self) {
            id mappedObj = handle(obj);
            if (mappedObj) {
                [_self addObject:mappedObj];
            }
        }
    }
    return [_self copy];
}

- (NSArray *) ease_select:(BOOL (^)(id obj))handle{
    
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return handle(evaluatedObject);
    }]];
}

- (NSArray *) ease_select:(NSInteger)pageSize pageNumber:(NSInteger)pageNumber{
    
    if (pageSize > self.count) {
        return nil;
    }
    if (pageSize * (pageNumber - 1) >= self.count) {
        return nil;
    }
    NSRange range;
    if (pageSize * pageNumber >= self.count) {
        range = NSMakeRange(pageSize * (pageNumber - 1), self.count - pageSize * (pageNumber - 1));
    }else{
        range = NSMakeRange(pageSize * (pageNumber - 1), pageSize);
    }
    return [self subarrayWithRange:range];
}

- (NSArray *) ease_filter:(BOOL (^)(id obj))handle{
    
    return [self ease_select:handle];
}

- (NSArray *) ease_compat{
    
    return [self ease_select:^BOOL(id obj) {
        return obj != [NSNull null];
    }];
}

- (NSArray *) ease_merge:(NSArray *)other{
    
    NSMutableArray * _self = [NSMutableArray arrayWithArray:self];
    [_self addObjectsFromArray:other];
    return [_self copy];
}

- (NSArray *) ease_distinctUnion2{
    @autoreleasepool {
        NSMutableArray * _self = [@[] mutableCopy];
        [self ease_each:^(id  _Nonnull obj) {
            if (!_self.ease_have(obj)) {
                [_self addObject:obj];
            }
        }];
        return [_self copy];
    }
}

- (NSArray *) ease_distinctUnion{
    return [self ease_distinctUnionWithKey:@"self"];
}

- (NSArray *) ease_distinctUnionWithKey:(NSString *)key{
    
    NSAssert([[[self ease_sample] ease_getAllProperties] containsObject:key] ||
             [key isEqualToString:@"self"],
             @"the `key` must be one of properties with T class or is `self`");
    
    NSString * keyPath = [NSString stringWithFormat:@"@distinctUnionOfObjects.%@",key];
    return [self valueForKeyPath:keyPath];
}


- (NSArray *) ease_append:(NSArray *)other{
    NSMutableArray * _self = [self mutableCopy];
    
    [_self ease_each:^(id  _Nonnull obj) {
        if (!_self.ease_have(obj)) {
            [_self addObject:obj];
        }
    }];
    
    return [_self copy];
}
#pragma mark - 布尔运算

- (NSArray *) ease_intersect:(NSArray *)other{
    
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF IN %@",other];
    
    return [self filteredArrayUsingPredicate:pred];
}

- (NSArray *) ease_union:(NSArray *)other{
    
    NSArray * tmp = [self ease_subtract:other];
    
    return [tmp arrayByAddingObjectsFromArray:other];
}

- (NSArray *) ease_difference:(NSArray *)other{
    
    NSArray * selfSubtractOther = [self ease_subtract:other];
    NSArray * otherSubtractSelf = [other ease_subtract:self];
    
    return [selfSubtractOther ease_union:otherSubtractSelf];
}

- (NSArray *) ease_subtract:(NSArray *)other{
    
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"NOT SELF IN %@",other];
    
    return [self filteredArrayUsingPredicate:pred];
}

- (NSArray *) ease_intersect:(BOOL(^)(id obj))filter other:(NSArray *)other{
    
    return [[self ease_filter:filter] ease_intersect:other];
}

- (NSArray *) ease_sort:(NSComparisonResult (^)(id, id))handle{
    
    return [self sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if (handle) {
            return handle(obj1,obj2);
        }
        return NSOrderedAscending;
    }];
}

- (NSString *) ease_join {
    return [self componentsJoinedByString:@""];
}

- (NSString *) ease_join:(NSString *)separator {
    return [self componentsJoinedByString:separator];
}

- (NSArray<id> *) ease_randomObjects{
    
    if (self.count == 0) {
        return nil;
    }
//    // for temp
//    return self;
    
    NSInteger loc = arc4random_uniform((UInt32)self.count);
    NSInteger len = (loc == self.count - 1) ? 0 : (arc4random_uniform((UInt32)(self.count - loc)));
    return [self subarrayWithRange:NSMakeRange(loc, len)];
}
@end
