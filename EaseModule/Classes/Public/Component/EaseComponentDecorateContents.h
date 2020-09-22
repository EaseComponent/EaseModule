//
//  EaseComponentBackgroundDecorateContents.h
//  EaseModule
//
//  Created by rocky on 2020/8/19.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EaseComponentDecorateGradientContentsAble <NSObject>

@property (nonatomic ,copy) NSArray <UIColor *>* colors;
@property (nonatomic ,copy) NSArray <NSNumber *>* locations;
@property (nonatomic) CGPoint startPoint;// 0,0
@property (nonatomic) CGPoint endPoint;// 1,0
@end

// 用swift中的枚举会比较好，oc就只能用对象了
@interface EaseComponentDecorateContents : NSObject

+ (instancetype) colorContents:(UIColor *)color NS_SWIFT_NAME(color(_:));
+ (instancetype) imageContents:(UIImage *)image NS_SWIFT_NAME(image(_:));
+ (instancetype) gradientContents:(void(^)(id<EaseComponentDecorateGradientContentsAble>contents))builder NS_SWIFT_NAME(gradient(_:));

// shadow
@property (nonatomic ,strong) UIColor * shadowColor;
@property (nonatomic ,assign) float shadowOpacity;
@property (nonatomic ,assign) CGSize shadowOffset;
@property (nonatomic ,assign) CGFloat shadowRadius;

@property (nonatomic ,assign ,readonly) BOOL isColor;
@property (nonatomic ,assign ,readonly) BOOL isImage;
@property (nonatomic ,assign ,readonly) BOOL isGradient;

@end

NS_ASSUME_NONNULL_END
