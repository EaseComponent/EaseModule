//
//  EaseRXBuilder.h
//  Ease
//
//  Created by skynet on 2020/4/23.
//  Copyright © 2020 huayang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef EaseRX
#define EaseRX(pattern) [[NSRegularExpression alloc] initWithPattern:pattern]
#endif

@interface EaseRXBuilder : NSObject

@property (readonly, nonatomic) EaseRXBuilder *(^start)(BOOL);
@property (readonly, nonatomic) EaseRXBuilder *(^end)(BOOL);

@property (nonatomic, readonly) EaseRXBuilder *(^find)(NSString *value);
@property (nonatomic, readonly) EaseRXBuilder *(^then)(NSString *value);
@property (nonatomic, readonly) EaseRXBuilder *(^maybe)(NSString *value);
@property (nonatomic, readonly) EaseRXBuilder *(^anything)(void);
@property (nonatomic, readonly) EaseRXBuilder *(^anythingBut)(NSString *value);
@property (nonatomic, readonly) EaseRXBuilder *(^something)(void);
@property (nonatomic, readonly) EaseRXBuilder *(^somethingBut)(NSString *value);
@property (nonatomic, readonly) EaseRXBuilder *(^lineBreak)(void);
@property (nonatomic, readonly) EaseRXBuilder *(^br)(void);
@property (nonatomic, readonly) EaseRXBuilder *(^tab)(void);
@property (nonatomic, readonly) EaseRXBuilder *(^word)(void);
@property (nonatomic, readonly) EaseRXBuilder *(^anyOf)(NSString *value);
@property (nonatomic, readonly) EaseRXBuilder *(^any)(NSString *value);
@property (nonatomic, readonly) EaseRXBuilder *(^range)(NSArray *args);
@property (nonatomic, readonly) EaseRXBuilder *(^withAnyCase)(BOOL enable);
@property (nonatomic, readonly) EaseRXBuilder *(^searchOneLine)(BOOL enable);
@property (nonatomic, readonly) EaseRXBuilder *(^multiple)(NSString *value);
@property (nonatomic, readonly) EaseRXBuilder *(^or)(NSString *value);
@property (nonatomic, readonly) EaseRXBuilder *(^beginCapture)(void);
@property (nonatomic, readonly) EaseRXBuilder *(^endCapture)(void);

@property (nonatomic, readonly) NSString *(^replace)(NSString *source, NSString *value);

@property (nonatomic, readonly) BOOL (^test)(NSString *toTest);

@property (nonatomic, readonly) NSRegularExpression *regularExpression;
@property (nonatomic, readonly) NSRegularExpression *regex;

+ (EaseRXBuilder *)instantiate:(void (^)(EaseRXBuilder *ve))block;
+ (EaseRXBuilder *)expressions;

@end

@interface NSRegularExpression (RX)

- (instancetype) initWithPattern:(NSString *)pattern;
// 在str中找寻匹配pattern的字符串
- (NSArray <NSTextCheckingResult *>*) matches:(NSString *)str;
// 在str中找寻匹配pattern的第一个字符串
- (nullable NSTextCheckingResult *) firstMatch:(NSString *)str;
// 遍历找到的字符串
- (void) enumMatches:(void(^)(NSTextCheckingResult * result,NSUInteger index))handle
            inString:(NSString *)string;
// 对查找到的字符串进行替换
- (NSString *) replaceMatchedStringsWith:(NSString *(^)(NSString *matchedString))replace
                                inString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
