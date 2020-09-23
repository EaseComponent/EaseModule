//
//  NSObject+EaseRuntime.h
//  Ease
//
//  Created by 洛奇 on 2019/6/10.
//  Copyright © 2019 huayang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (EaseRuntime)

+ (NSArray<NSString *> *) ease_getAllProperties;
- (NSArray<NSString *> *) ease_getAllProperties;

+ (NSArray<NSString *> *) ease_getAllMethods;
- (NSArray<NSString *> *) ease_getAllMethods;

+ (BOOL) ease_implementationMethod:(SEL)method;
- (BOOL) ease_implementationMethod:(SEL)method;

+ (BOOL) ease_implementationMethodWith:(NSString *)methodName;
- (BOOL) ease_implementationMethodWith:(NSString *)methodName;

@end

NS_ASSUME_NONNULL_END
