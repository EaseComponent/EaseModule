//
//  EaseAttributedBuilder.h
//  Ease
//
//  Created by 洛奇 on 2019/6/4.
//  Copyright © 2019 huayang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EaseRXBuilder.h"

NS_ASSUME_NONNULL_BEGIN

@class EaseAttributedBuilder;

typedef NSDictionary<NSAttributedStringKey, id> * EaseAttributesStyle;

#pragma mark - blocks

typedef EaseAttributedBuilder * _Nullable (^EaseAttributedBuilderStringBlock)(NSString * string);
typedef EaseAttributedBuilder * _Nullable (^EaseAttributedBuilderStringAndStyleBlock)(NSString * string, EaseAttributesStyle style);
typedef EaseAttributedBuilder * _Nullable (^EaseAttributedBuilderAttributedStringBlock)(NSAttributedString * att);
typedef EaseAttributedBuilder * _Nullable (^EaseAttributedBuilderAttachmentBlock)(NSTextAttachment * att);

@interface EaseAttributedBuilder : NSObject

// black 16
+ (instancetype) builder;
// { NS...AttributeName : (id)value}
+ (instancetype) builderWithDefaultStyle:(EaseAttributesStyle)defaultStyle;

+ (instancetype) builderWithString:(NSString *)originalString;
+ (instancetype) builderWithString:(NSString *)originalString
                      defaultStyle:(EaseAttributesStyle)defaultStyle;

@property (nonatomic ,copy ,readonly) EaseAttributedBuilderStringBlock appendString;
@property (nonatomic ,copy ,readonly) EaseAttributedBuilderStringAndStyleBlock appendStringAndStyle;
@property (nonatomic ,copy ,readonly) EaseAttributedBuilderAttributedStringBlock appendAttributedString;

- (EaseAttributedBuilder *) appendString:(NSString *)string;
- (EaseAttributedBuilder *) appendString:(NSString *)string forStyle:(EaseAttributesStyle)style;
- (EaseAttributedBuilder *) appendAttributedString:(NSAttributedString *)attributedString;

// 根据添加的字符串属性生成属性字符串
- (NSAttributedString *) attributedString;

@end

@interface EaseAttributedBuilder (Attachment)

// 可以根据图片设置属性字符串
@property (nonatomic ,copy ,readonly) EaseAttributedBuilderAttachmentBlock appendAttachment;

- (EaseAttributedBuilder *) appendAttachment:(NSTextAttachment *)attachment;

@end

// 给定文本，对需要的内容设置对应的属性字符串，并且区分大小写，支持使用正则匹配
@interface EaseAttributedBuilder (Config)

@property (nonatomic ,copy ,readonly) EaseAttributedBuilderStringAndStyleBlock firstMatchConfigStringWithStyle;
@property (nonatomic ,copy ,readonly) EaseAttributedBuilderStringAndStyleBlock configStringWithStyle;

///<string 为要修改样式的字符串，支持正则表达式
- (EaseAttributedBuilder *) firstMatchConfigString:(NSString *)string withStyle:(EaseAttributesStyle)style;
- (EaseAttributedBuilder *) configString:(NSString *)string withStyle:(EaseAttributesStyle)style;
@end

NS_ASSUME_NONNULL_END
