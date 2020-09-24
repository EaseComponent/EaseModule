//
//  EaseRXBuilder.m
//  Ease
//
//  Created by skynet on 2020/4/23.
//  Copyright © 2020 huayang. All rights reserved.
//

#import "EaseRXBuilder.h"

@interface EaseRXBuilder ()
//@property (strong, nonatomic) NSString *prefixes;
//@property (strong, nonatomic) NSString *suffixes;
//@property (strong, nonatomic) NSMutableString *source;

@property (nonatomic) NSString *prefixes;
@property (nonatomic) NSString *source;
@property (nonatomic) NSString *suffixes;
@property (nonatomic) NSString *pattern;
@property (nonatomic) NSRegularExpressionOptions modifiers;

@property (nonatomic, copy) EaseRXBuilder *(^add)(NSString *value);

@end

@implementation EaseRXBuilder

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.prefixes = @"";
        self.source = @"";
        self.suffixes = @"";
        self.pattern = @"";
    }
    return self;
}

- (EaseRXBuilder *(^)(BOOL))start
{
    return ^EaseRXBuilder *(BOOL enable) {
        self.prefixes = enable ? @"^" : @"";
        self.add(@"");
        return self;
    };
}

- (EaseRXBuilder *(^)(BOOL))end
{
    return ^EaseRXBuilder *(BOOL enable) {
        self.suffixes = enable ? @"$" : @"";
        self.add(@"");
        return self;
    };
}

- (EaseRXBuilder *(^)(NSString *))find
{
    return ^EaseRXBuilder *(NSString *value) {
        return self.then(value);
    };
}

- (EaseRXBuilder *(^)(NSString *))then
{
    return ^EaseRXBuilder *(NSString *value) {
        value = [self sanitize:value];
        self.add([NSString stringWithFormat:@"(?:%@)", value]);
        return self;
    };
}

- (EaseRXBuilder *(^)(NSString *))maybe
{
    return ^EaseRXBuilder *(NSString *value) {
        value = [self sanitize:value];
        self.add([NSString stringWithFormat:@"(?:%@)?", value]);
        return self;
    };
}

- (EaseRXBuilder *(^)(void))anything
{
    return ^EaseRXBuilder *() {
        self.add(@"(?:.*)");
        return self;
    };
}

- (EaseRXBuilder *(^)(NSString *))anythingBut
{
    return ^EaseRXBuilder *(NSString *value) {
        value = [self sanitize:value];
        self.add([NSString stringWithFormat:@"(?:[^%@]*)", value]);
        return self;
    };
}

- (EaseRXBuilder *(^)(void))something
{
    return ^EaseRXBuilder *() {
        self.add(@"(?:.+)");
        return self;
    };
}

- (EaseRXBuilder *(^)(NSString *))somethingBut
{
    return ^EaseRXBuilder *(NSString *value) {
        value = [self sanitize:value];
        self.add([NSString stringWithFormat:@"(?:[^%@]+)", value]);
        return self;
    };
}

- (NSString *(^)(NSString *, NSString *))replace{
    return ^NSString *(NSString *source, NSString *value) {
        self.add(@"");
        return [self.regex stringByReplacingMatchesInString:source options:kNilOptions range:NSMakeRange(0, source.length) withTemplate:value];
    };
}

- (EaseRXBuilder *(^)(void))lineBreak{
    return ^EaseRXBuilder *() {
        self.add(@"(?:\\n|(?:\\r\\n))");
        return self;
    };
}

- (EaseRXBuilder *(^)(void))br{
    return ^EaseRXBuilder *() {
        self.lineBreak();
        return self;
    };
}

- (EaseRXBuilder *(^)(void))tab{
    return ^EaseRXBuilder *() {
        self.add(@"\\t");
        return self;
    };
}

- (EaseRXBuilder *(^)(void))word{
    return ^EaseRXBuilder *() {
        self.add(@"\\w+");
        return self;
    };
}

- (EaseRXBuilder *(^)(NSString *))anyOf{
    return ^EaseRXBuilder *(NSString *value) {
        value = [self sanitize:value];
        self.add([NSString stringWithFormat:@"[%@]", value]);
        return self;
    };
}

- (EaseRXBuilder *(^)(NSString *))any{
    return ^EaseRXBuilder *(NSString *value) {
        self.anyOf(value);
        return self;
    };
}

- (EaseRXBuilder *(^)(NSArray *))range{
    return ^EaseRXBuilder *(NSArray *args) {
        NSString *value = @"[";
        for (NSInteger fromIndex = 0; fromIndex < args.count; fromIndex += 2) {
            NSInteger toIndex = fromIndex + 1;
            if (args.count <= toIndex) {
                break;
            }
            
            NSString *from = [self sanitize:args[fromIndex]];
            NSString *to = [self sanitize:args[toIndex]];
            value = [value stringByAppendingFormat:@"%@-%@", from, to];
        }
        
        value = [value stringByAppendingString:@"]"];
        
        self.add(value);
        return self;
    };
}

- (EaseRXBuilder *(^)(BOOL))withAnyCase{
    return ^EaseRXBuilder *(BOOL enable) {
        if (enable) {
            self.addModifier('i');
        } else {
            self.removeModifier('i');
        }
        self.add(@"");
        return self;
    };
}

- (EaseRXBuilder *(^)(BOOL))searchOneLine{
    return ^EaseRXBuilder *(BOOL enable) {
        if (enable) {
            self.removeModifier('m');
        } else {
            self.addModifier('m');
        }
        self.add(@"");
        return self;
    };
}

- (EaseRXBuilder *(^)(NSString *))multiple{
    return ^EaseRXBuilder *(NSString *value) {
        value = [self sanitize:value];
        NSString *suffix = [value substringFromIndex:value.length - 1];
        if (![suffix isEqualToString:@"*"] && ![suffix isEqualToString:@"+"]) {
            value = [value stringByAppendingString:@"+"];
        }
        self.add(value);
        return self;
    };
}

- (EaseRXBuilder *(^)(NSString *))or{
    return ^EaseRXBuilder *(NSString *value) {
        if ([self.prefixes rangeOfString:@"("].location == NSNotFound) {
            self.prefixes = [self.prefixes stringByAppendingString:@"(?:"];
        }
        if ([self.suffixes rangeOfString:@")"].location == NSNotFound) {
            self.suffixes = [self.suffixes stringByAppendingString:@")"];
        }
        self.add(@")|(?:");
        if (value) {
            self.then(value);
        }
        return self;
    };
}

- (EaseRXBuilder *(^)(void))beginCapture{
    return ^EaseRXBuilder *() {
        self.suffixes = [self.suffixes stringByAppendingString:@")"];
        self.add(@"(");
        return self;
    };
}

- (EaseRXBuilder *(^)(void))endCapture{
    return ^EaseRXBuilder *() {
        self.suffixes = [self.suffixes substringToIndex:self.suffixes.length - 1];
        self.add(@")");
        return self;
    };
}

- (BOOL(^)(NSString *))test{
    return ^BOOL (NSString *toTest) {
        self.add(@"");
        
        NSRegularExpression *regex = self.regularExpression;
        NSUInteger matches = [regex numberOfMatchesInString:toTest options:kNilOptions range:NSMakeRange(0, toTest.length)];
        
        return matches > 0;
    };
}

- (NSRegularExpression *)regularExpression{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:self.pattern
                                                                           options:self.modifiers
                                                                             error:&error];
    if (error) {
        return nil;
    }
    return regex;
}

- (NSRegularExpression *)regex{
    return self.regularExpression;
}

- (NSString *)description{
    self.add(@"");
    return self.regularExpression.pattern;
}

#pragma mark praivate methods

- (NSString *)sanitize:(NSString *)value{
    if (!value) {
        return nil;
    }
    return [NSRegularExpression escapedPatternForString:value];
}

- (EaseRXBuilder *(^)(NSString *))add{
    return ^EaseRXBuilder *(NSString *value) {
        self.source = self.source ? [self.source stringByAppendingString:value] : value;
        if (self.source) {
            self.pattern = [NSString stringWithFormat:@"%@%@%@", self.prefixes, self.source, self.suffixes];
        }
        return self;
    };
}

- (EaseRXBuilder *(^)(unichar))addModifier
{
    return ^EaseRXBuilder *(unichar modifier) {
        switch (modifier) {
            case 'd': // UREGEX_UNIX_LINES
                self.modifiers |= NSRegularExpressionUseUnixLineSeparators;
                break;
            case 'i': // UREGEX_CASE_INSENSITIVE
                self.modifiers |= NSRegularExpressionCaseInsensitive;
                break;
            case 'x': // UREGEX_COMMENTS
                self.modifiers |= NSRegularExpressionAllowCommentsAndWhitespace;
                break;
            case 'm': // UREGEX_MULTILINE
                self.modifiers |= NSRegularExpressionAnchorsMatchLines;
                break;
            case 's': // UREGEX_DOTALL
                self.modifiers |= NSRegularExpressionDotMatchesLineSeparators;
                break;
            case 'u': // UREGEX_UWORD
                self.modifiers |= NSRegularExpressionUseUnicodeWordBoundaries;
                break;
            case 'U': // UREGEX_LITERAL
                self.modifiers |= NSRegularExpressionIgnoreMetacharacters;
                break;
            default:
                break;
        }
        
        self.add(@"");
        return self;
    };
}

- (EaseRXBuilder *(^)(unichar))removeModifier
{
    return ^EaseRXBuilder *(unichar modifier) {
        switch (modifier) {
            case 'd': // UREGEX_UNIX_LINES
                self.modifiers ^= NSRegularExpressionUseUnixLineSeparators;
                break;
            case 'i': // UREGEX_CASE_INSENSITIVE
                self.modifiers ^= NSRegularExpressionCaseInsensitive;
                break;
            case 'x': // UREGEX_COMMENTS
                self.modifiers ^= NSRegularExpressionAllowCommentsAndWhitespace;
                break;
            case 'm': // UREGEX_MULTILINE
                self.modifiers ^= NSRegularExpressionAnchorsMatchLines;
                break;
            case 's': // UREGEX_DOTALL
                self.modifiers ^= NSRegularExpressionDotMatchesLineSeparators;
                break;
            case 'u': // UREGEX_UWORD
                self.modifiers ^= NSRegularExpressionUseUnicodeWordBoundaries;
                break;
            case 'U': // UREGEX_LITERAL
                self.modifiers ^= NSRegularExpressionIgnoreMetacharacters;
                break;
            default:
                break;
        }
        
        self.add(@"");
        return self;
    };
}

@end

@implementation NSRegularExpression (RX)

- (id) initWithPattern:(NSString*)pattern{
    
    return [self initWithPattern:pattern options:0 error:nil];
}

- (NSTextCheckingResult *) firstMatch:(NSString *)str{
    
    return [self matches:str].firstObject;
}

- (NSArray<NSTextCheckingResult *>*) matches:(NSString*)str{
    
    return [self matchesInString:str options:0 range:NSMakeRange(0, str.length)];
}

- (void) enumMatches:(void(^)(NSTextCheckingResult * result,NSUInteger index))handle
            inString:(NSString *)string{
    
    NSArray * results = [self matches:string];
    if (results && results.count > 0) {
        
        [results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (handle) {
                handle(obj,idx);
            }
        }];
    }
}
- (NSString *) replaceMatchedStringsWith:(NSString *(^)(NSString *matchedString))replace
                                inString:(NSString *)string{
    
    if (!string) {
        return @"";
    }
    __block NSMutableString * replacedString = [NSMutableString stringWithString:string];
    [self enumMatches:^(NSTextCheckingResult * _Nonnull result, NSUInteger index) {
        
        NSString * template = replace ? replace([replacedString substringWithRange:result.range]) : @"";
        // NSMatchingReportCompletion : 找到任何一个匹配串后都回调一次block
        [self replaceMatchesInString:replacedString options:NSMatchingReportCompletion
                               range:result.range withTemplate:template];
    } inString:string];
    return replacedString.copy;
}
@end

