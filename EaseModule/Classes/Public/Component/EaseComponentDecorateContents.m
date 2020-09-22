//
//  EaseComponentBackgroundDecorateContents.m
//  EaseModule
//
//  Created by rocky on 2020/8/19.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "EaseComponentDecorateContents.h"
#import "EaseComponent_Private.h"

@implementation EaseComponentDecorateContents

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.shadowColor = UIColor.clearColor;
        self.shadowOffset = CGSizeZero;
        self.shadowRadius = 0;
        self.shadowOpacity = 0;
    }
    return self;
}

+ (instancetype)colorContents:(UIColor *)color{
    EaseComponentDecorateContents * mine = [self new];
    mine.color = color;
    mine.isColor = YES;
    return mine;;
}

+ (instancetype)imageContents:(UIImage *)image{
    EaseComponentDecorateContents * mine = [self new];
    mine.image = image;
    mine.isImage = YES;
    return mine;
}

+ (instancetype) gradientContents:(void(^)(id<EaseComponentDecorateGradientContentsAble>contents))builder{
    EaseComponentDecorateContents * mine = [self new];
    mine.isGradient = YES;
    // TODO:消除警告
    if (builder) {
        builder(mine);
    }
    return mine;;
}

@end
