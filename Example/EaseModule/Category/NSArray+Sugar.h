//
//  NSArray+Sugar.h
//  Ease
//
//  Created by 洛奇 on 2019/6/10.
//  Copyright © 2019 huayang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<T> (Sugar)

- (T) ease_first;

- (T) ease_last;

- (T) ease_sample;
- (NSArray<T> *) ease_randomObjects;

- (NSArray *) ease_map:(id (^)(T obj))handle;
- (NSArray *) ease_mapWithskip:(id (^)(T obj, BOOL *skip))handle;
- (NSArray *) ease_mapWithIndex:(id (^)(T obj,NSUInteger index))handle;
- (NSArray *) ease_mapWithSkipIndex:(id (^)(T obj, BOOL *skip, NSUInteger idnex))handle;

- (NSArray *) ease_compactMap:(id (^)(T obj))handle;

- (void) ease_each:(void(^)(T obj))handle;
- (void) ease_eachWithOptions:(void (^)(T))handle options:(NSEnumerationOptions)options;
- (void) ease_eachWithIndex:(void(^)(T obj,NSInteger index))handle;

- (void) ease_eachWithStop:(BOOL(^)(T obj))handle;
- (void) ease_eachWithIndexStop:(BOOL(^)(T obj ,NSUInteger index))handle;

- (BOOL (^)(T obj)) ease_have;

- (NSArray<T> *) ease_select:(BOOL (^)(T obj))handle;
- (NSArray<T> *) ease_filter:(BOOL (^)(T obj))handle;
- (NSArray<T> *) ease_select:(NSInteger)pageSize pageNumber:(NSInteger)pageNumber;

///< same as addFromArray:
- (NSArray<T> *) ease_merge:(NSArray<T> *)other;
//- (NSArray *) ease_special:(NSString *(^)(id obj))handle1 merge:(NSArray *)other special:(NSString * (^)(id obj))handle;

- (NSArray<T> *) ease_distinctUnion2;
///<distinct union objectives, default is `@distinctUnionOfObjects.self`
- (NSArray<T> *) ease_distinctUnion;
///<base on `T.key` for distinct union objectives ,`key` is one of properties from T
- (NSArray<T> *) ease_distinctUnionWithKey:(NSString *)key;

///<self：[a,b,c,d,e] other:[x,d,y,e,o,m] result:[a,b,c,d,e,x,y,o,m] ,base on `isEqual:`
- (NSArray<T> *) ease_append:(NSArray<T> *)other;

#pragma mark - 布尔运算
///< self:[1,2,3,4] oher:[1,4,6,7,8] result:[1,4]
- (NSArray<T> *) ease_intersect:(NSArray<T> *)other;

///< self:[1,2,3,4] oher:[1,4,6,7,8] result:[1,2,3,4,6,7,8]
- (NSArray<T> *) ease_union:(NSArray<T> *)other;

///< self:[1,2,3,4] oher:[1,4,6,7,8] result:[2,3,6,7,8]
- (NSArray<T> *) ease_difference:(NSArray<T> *)other;

///< self:[1,2,3,4] oher:[1,4,6,7,8] result:[2,3]
- (NSArray<T> *) ease_subtract:(NSArray<T> *)other;

///< ease_intersect:函数的变形，可以选取哪些成员参与到布尔运算中
- (NSArray<T> *) ease_intersect:(BOOL(^)(T obj))filter other:(NSArray<T> *)other;

#pragma mark - 排序
///< 排序
- (NSArray<T> *) ease_sort:(NSComparisonResult (^)(T obj1, T obj2))handle;

- (NSString *) ease_join;
- (NSString *) ease_join:(NSString *)separator;
@end

NS_ASSUME_NONNULL_END
