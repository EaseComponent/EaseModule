//
//  NSObject+EaseRuntime.m
//  Ease
//
//  Created by 洛奇 on 2019/6/10.
//  Copyright © 2019 huayang. All rights reserved.
//

#import "NSObject+EaseRuntime.h"
#import <objc/runtime.h>

@implementation NSObject (EaseRuntime)

+ (NSArray<NSString *> *)ease_getAllProperties{
    
    u_int count;
    objc_property_t *properties  = class_copyPropertyList([self class], &count);
    
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++){
        const char* propertyName = property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    // You must free the array with free().
    free(properties);
    
    return propertiesArray;
}

- (NSArray<NSString *> *)ease_getAllProperties{
    return [[self class] ease_getAllProperties];
}

+ (NSArray<NSString *> *) ease_getAllMethods{
    
    unsigned int methodCount = 0;
    Method* methodList = class_copyMethodList([self class],&methodCount);
    NSMutableArray *methodsArray = [NSMutableArray arrayWithCapacity:methodCount];
    
    for(int i = 0 ; i < methodCount ; i++) {
        Method temp = methodList[i];
        const char* name_s =sel_getName(method_getName(temp));
        int arguments = method_getNumberOfArguments(temp);
        const char* encoding =method_getTypeEncoding(temp);
        NSLog(@"方法名：%@,参数个数：%d,编码方式：%@",[NSString stringWithUTF8String:name_s],
              arguments,
              [NSString stringWithUTF8String:encoding]);
        [methodsArray addObject:[NSString stringWithUTF8String:name_s]];
    }
    free(methodList);
    return methodsArray;
}

- (NSArray<NSString *> *) ease_getAllMethods{
    return [[self class] ease_getAllMethods];
}

+ (BOOL) ease_implementationMethod:(SEL)method{
    NSString * methodName = NSStringFromSelector(method);
    return [self ease_implementationMethodWith:methodName];
}
- (BOOL) ease_implementationMethod:(SEL)method{
    return [[self class] ease_implementationMethod:method];
}

+ (BOOL) ease_implementationMethodWith:(NSString *)methodName{
    return [[self ease_getAllMethods] containsObject:methodName];
}
- (BOOL) ease_implementationMethodWith:(NSString *)methodName{
    return [[self class] ease_implementationMethodWith:methodName];
}
@end
