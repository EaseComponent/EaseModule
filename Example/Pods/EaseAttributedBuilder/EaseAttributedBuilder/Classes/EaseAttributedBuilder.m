//
//  EaseAttributedBuilder.m
//  Ease
//
//  Created by 洛奇 on 2019/6/4.
//  Copyright © 2019 huayang. All rights reserved.
//

#import "EaseAttributedBuilder.h"

@interface EaseInternalStringWrapper : NSObject

@property (nonatomic ,copy) NSString * string;
@property (nonatomic ,strong) NSAttributedString * attributedString;
@property (nonatomic ,assign) NSRange range;
@property (nonatomic ,copy) EaseAttributesStyle style;
@end

@implementation EaseInternalStringWrapper
- (void)dealloc {
#ifdef DEBUG
    NSLog(@"EaseInternalString:%@/%@ dealloc",self.string,self.attributedString);
#endif
}
@end

@interface EaseAttributedBuilder (){
    EaseAttributesStyle _defaultStyle;
    NSMutableArray<EaseInternalStringWrapper *> * _stringWrappers;
    NSMutableString * _originalString;
}
@property (nonatomic ,copy) EaseAttributesStyle defaultStyle;
@property (nonatomic ,strong) NSMutableArray<EaseInternalStringWrapper *> * stringWrappers;
@property (nonatomic ,strong) NSMutableString * originalString;
@end

@implementation EaseAttributedBuilder

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"EaseAttributedBuilder:%@ dealloc",self.originalString);
#endif
}

+ (instancetype)builder{
    
    EaseAttributesStyle defaultStyle = @{NSForegroundColorAttributeName:[UIColor blackColor],
                                         NSFontAttributeName:[UIFont systemFontOfSize:16]};
    return [self builderWithDefaultStyle:defaultStyle];
}

+ (instancetype)builderWithDefaultStyle:(EaseAttributesStyle)defaultStyle{
    
    EaseAttributedBuilder * builder = [[self alloc] init];
    builder.defaultStyle = defaultStyle;
    return builder;
}

+ (instancetype)builderWithString:(NSString *)originalString{
    
    EaseAttributesStyle defaultStyle = @{NSForegroundColorAttributeName:[UIColor blackColor],
                                         NSFontAttributeName:[UIFont systemFontOfSize:16]};
    return [self builderWithString:originalString defaultStyle:defaultStyle];
}

+ (instancetype)builderWithString:(NSString *)originalString
                     defaultStyle:(EaseAttributesStyle)defaultStyle{
    
    EaseAttributedBuilder * builder = [self builderWithDefaultStyle:defaultStyle];
    return [builder appendString:originalString];
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        _stringWrappers = [NSMutableArray array];
        _originalString = [NSMutableString string];
    }
    return self;
}

- (EaseAttributedBuilder *)appendString:(NSString *)string{
    
    return [self appendString:string forStyle:self.defaultStyle];
}

- (EaseAttributedBuilder *)appendString:(NSString *)string forStyle:(EaseAttributesStyle )style{
    
//    NSAssert(string.length, @"请输入非nil的字符串");
    if (!string) {
        string = @"";
    }
    @autoreleasepool {
        
        NSMutableDictionary * mergeStyle = [NSMutableDictionary dictionaryWithDictionary:self.defaultStyle];
        [mergeStyle addEntriesFromDictionary:style];
        
        NSRange range = NSMakeRange(_originalString.length - 1, string.length);
        
        [_originalString appendString:string];
        
        NSAttributedString * attString = [[NSAttributedString alloc] initWithString:string attributes:mergeStyle];
        
        EaseInternalStringWrapper * wrapper = [[EaseInternalStringWrapper alloc] init];
        wrapper.string = string;
        wrapper.attributedString = attString;
        wrapper.range = range;
        wrapper.style = mergeStyle;
        [_stringWrappers addObject:wrapper];
    }
    return self;
}

- (EaseAttributedBuilderStringBlock)appendString{
    
    return ^EaseAttributedBuilder *(NSString *str){
        return [self appendString:str];
    };
}

- (EaseAttributedBuilderStringAndStyleBlock)appendStringAndStyle{
    
    return ^EaseAttributedBuilder *(NSString *str ,EaseAttributesStyle style){
        return [self appendString:str forStyle:style];
    };;
}

- (EaseAttributedBuilder *) appendAttributedString:(NSAttributedString *)attributedString{

    if (!attributedString) {
        return self;
    }
    
    EaseInternalStringWrapper * wrapper = [[EaseInternalStringWrapper alloc] init];
    wrapper.attributedString = attributedString;
    [_stringWrappers addObject:wrapper];
    [_originalString appendString:attributedString.string];
    return self;
}

- (EaseAttributedBuilderAttributedStringBlock)appendAttributedString{
    return ^EaseAttributedBuilder *(NSAttributedString *att){
        return [self appendAttributedString:att];
    };
}

- (NSAttributedString *) attributedString{
    
    if (_stringWrappers && _stringWrappers.count) {
        
        NSMutableAttributedString * output = [[NSMutableAttributedString alloc] init];
        for (EaseInternalStringWrapper * wrapper in _stringWrappers) {
            [output appendAttributedString:wrapper.attributedString];
        }
        return output;
    }
    return nil;
}

@end

@implementation EaseAttributedBuilder (Attachment)

- (EaseAttributedBuilder *)appendAttachment:(NSTextAttachment *)attachment{
    
//    NSAssert(attachment, @"请输入非nil的attachment");
    if (!attachment) {
        return self;
    }
    NSAttributedString * attString = [NSAttributedString attributedStringWithAttachment:attachment];
    EaseInternalStringWrapper * wrapper = [[EaseInternalStringWrapper alloc] init];
    wrapper.attributedString = attString;
    [_stringWrappers addObject:wrapper];
    return self;
}

- (EaseAttributedBuilderAttachmentBlock)appendAttachment{
    return ^EaseAttributedBuilder *(NSTextAttachment *attachment){
        return [self appendAttachment:attachment];
    };
}

@end

@implementation EaseAttributedBuilder (Config)

- (EaseAttributedBuilder *) _config:(NSString *)string style:(EaseAttributesStyle)style isFirstMatch:(BOOL)firstMatch{
    
//    NSAssert(string.length, @"请输入非nil的字符串");
    if (!string) {
        string = @"";
    }
    NSMutableDictionary * mergeStyle = [NSMutableDictionary dictionaryWithDictionary:self.defaultStyle];
    [mergeStyle addEntriesFromDictionary:style];
    
    NSAssert(self.stringWrappers.count, @"请使用`builderWithString:`或者`builderWithString:defaultStyle:`初始化 EaseAttributedBuilder ");
    
    NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.stringWrappers.firstObject.attributedString];
    if (firstMatch) {
        NSTextCheckingResult * result = [EaseRX(string) firstMatch:self.originalString];
        [attributedText addAttributes:mergeStyle range:result.range];
    }else{
        [EaseRX(string) enumMatches:^(NSTextCheckingResult *result, NSUInteger index) {
            [attributedText addAttributes:mergeStyle range:result.range];
        } inString:self.originalString];
    }
    
    [self.stringWrappers removeAllObjects];
    
    EaseInternalStringWrapper * wrapper = [[EaseInternalStringWrapper alloc] init];
    wrapper.attributedString = attributedText;
    [self.stringWrappers addObject:wrapper];
    return self;
}

- (EaseAttributedBuilder *) firstMatchConfigString:(NSString *)string withStyle:(EaseAttributesStyle)style{
    return [self _config:string style:style isFirstMatch:YES];
}

- (EaseAttributedBuilderStringAndStyleBlock)firstMatchConfigStringWithStyle{
    return ^EaseAttributedBuilder *(NSString *str ,EaseAttributesStyle style){
        return [self firstMatchConfigString:str withStyle:style];
    };
}

- (EaseAttributedBuilder *)configString:(NSString *)string withStyle:(EaseAttributesStyle)style{
    return [self _config:string style:style isFirstMatch:NO];
}

- (EaseAttributedBuilderStringAndStyleBlock)configStringWithStyle{
    return ^EaseAttributedBuilder *(NSString *str ,EaseAttributesStyle style){
        return [self configString:str withStyle:style];
    };
}

@end
