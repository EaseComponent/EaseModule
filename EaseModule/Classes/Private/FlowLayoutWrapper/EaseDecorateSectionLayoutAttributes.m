//
//  EaseDecorateSectionLayoutAttributes.m
//  EaseModule
//
//  Created by rocky on 2020/8/18.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "EaseDecorateSectionLayoutAttributes.h"
#import "EaseComponent_Private.h"

@interface UIImage (EaseModule)

- (UIImage *) EaseModule_imageByRoundCornerRadius:(CGFloat)radius;

- (UIImage *) EaseModule_imageByRoundCornerRadius:(CGFloat)radius
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor;
- (UIImage *) EaseModule_imageByRoundCornerRadius:(CGFloat)radius
                                            corners:(UIRectCorner)corners
                                        borderWidth:(CGFloat)borderWidth
                                        borderColor:(UIColor *)borderColor
                                     borderLineJoin:(CGLineJoin)borderLineJoin;
@end

@implementation EaseDecorateSectionLayoutAttributes
@end

@implementation EaseDecorateSectionView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    [super applyLayoutAttributes:layoutAttributes];
    if ([layoutAttributes isKindOfClass:[EaseDecorateSectionLayoutAttributes class]]) {
        EaseDecorateSectionLayoutAttributes * att =
        (EaseDecorateSectionLayoutAttributes *)layoutAttributes;
        id<EaseComponentDecorateAble> builder = att.builder;
        EaseComponentDecorateContents * contents = builder.contents;

        self.layer.cornerRadius = builder.radius;
        self.layer.shadowColor = contents.shadowColor.CGColor;
        self.layer.shadowOffset = contents.shadowOffset;
        self.layer.shadowRadius = contents.shadowRadius;
        self.layer.shadowOpacity = contents.shadowOpacity;

        [self clear];
        if (contents.isColor) {
            ((CAGradientLayer *)self.layer).colors = @[
                (__bridge id)contents.color.CGColor,
                (__bridge id)contents.color.CGColor
            ];
            ((CAGradientLayer *)self.layer).locations = @[@(0), @(1.0f)];
            ((CAGradientLayer *)self.layer).startPoint = CGPointMake(0, 0);
            ((CAGradientLayer *)self.layer).endPoint = CGPointMake(1, 1);
        } else if (contents.isImage) {
            self.layer.contents = (__bridge id)[contents.image EaseModule_imageByRoundCornerRadius:builder.radius].CGImage;
            self.layer.contentsScale = contents.image.scale;
        } else if (contents.isGradient) {
            ((CAGradientLayer *)self.layer).colors = [self _transformColorsForLayer:contents.colors];
            ((CAGradientLayer *)self.layer).locations = contents.locations;
            ((CAGradientLayer *)self.layer).startPoint = contents.startPoint;
            ((CAGradientLayer *)self.layer).endPoint = contents.endPoint;
        }
    }
}

- (void) clear{
    self.layer.contents = nil;
    ((CAGradientLayer *)self.layer).colors = nil;
    ((CAGradientLayer *)self.layer).locations = nil;
    ((CAGradientLayer *)self.layer).startPoint = CGPointZero;
    ((CAGradientLayer *)self.layer).endPoint = CGPointZero;
}

+ (Class)layerClass{
    return [CAGradientLayer class];
}

- (NSArray *) _transformColorsForLayer:(NSArray <UIColor *>*)colors{
    // 将color转换成CGColor
    NSMutableArray *cgColors = [NSMutableArray array];
    for (UIColor *tmp in colors) {
        id cgColor = (__bridge id)tmp.CGColor;
        [cgColors addObject:cgColor];
    }
    
    return cgColors.copy;
}

@end

@implementation UIImage (EaseModule)


- (UIImage *)EaseModule_imageByRoundCornerRadius:(CGFloat)radius {
    return [self EaseModule_imageByRoundCornerRadius:radius borderWidth:0 borderColor:nil];
}

- (UIImage *)EaseModule_imageByRoundCornerRadius:(CGFloat)radius
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor {
    return [self EaseModule_imageByRoundCornerRadius:radius
                                  corners:UIRectCornerAllCorners
                              borderWidth:borderWidth
                              borderColor:borderColor
                           borderLineJoin:kCGLineJoinMiter];
}
- (UIImage *) EaseModule_imageByRoundCornerRadius:(CGFloat)radius
                              corners:(UIRectCorner)corners
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor
                       borderLineJoin:(CGLineJoin)borderLineJoin {
    
    if (corners != UIRectCornerAllCorners) {
        UIRectCorner tmp = 0;
        if (corners & UIRectCornerTopLeft) tmp |= UIRectCornerBottomLeft;
        if (corners & UIRectCornerTopRight) tmp |= UIRectCornerBottomRight;
        if (corners & UIRectCornerBottomLeft) tmp |= UIRectCornerTopLeft;
        if (corners & UIRectCornerBottomRight) tmp |= UIRectCornerTopRight;
        corners = tmp;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    CGFloat minSize = MIN(self.size.width, self.size.height);
    if (borderWidth < minSize / 2) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth, borderWidth) byRoundingCorners:corners cornerRadii:CGSizeMake(radius, borderWidth)];
        [path closePath];
        
        CGContextSaveGState(context);
        [path addClip];
        CGContextDrawImage(context, rect, self.CGImage);
        CGContextRestoreGState(context);
    }
    
    if (borderColor && borderWidth < minSize / 2 && borderWidth > 0) {
        CGFloat strokeInset = (floor(borderWidth * self.scale) + 0.5) / self.scale;
        CGRect strokeRect = CGRectInset(rect, strokeInset, strokeInset);
        CGFloat strokeRadius = radius > self.scale / 2 ? radius - self.scale / 2 : 0;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:strokeRect byRoundingCorners:corners cornerRadii:CGSizeMake(strokeRadius, borderWidth)];
        [path closePath];
        
        path.lineWidth = borderWidth;
        path.lineJoinStyle = borderLineJoin;
        [borderColor setStroke];
        [path stroke];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
