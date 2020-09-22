//
//  EaseComponent+Private.h
//  EaseModule
//
//  Created by rocky on 2020/7/10.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "EaseComponent.h"
#import "EaseModuleEnvironment_Protocol.h"
#import "EaseModuleEnvironment_Protocol.h"

NS_ASSUME_NONNULL_BEGIN

// 用于构建背景装饰效果的私有类
@interface EaseComponentDecorateBuilder : NSObject<
EaseComponentDecorateAble>

@property (nonatomic ,assign) EaseComponentDecorate decorate;

@property (nonatomic ,assign) CGFloat radius;
@property (nonatomic ,assign) UIEdgeInsets inset;

// color/image/gradient
@property (nonatomic ,strong) EaseComponentDecorateContents * contents;

@end

@interface EaseComponent ()

@property (nonatomic, weak, readwrite) id<EaseModuleDataSourceAble> dataSource;
@property (nonatomic ,weak) id<EaseModuleEnvironment> environment;
@property (nonatomic ,assign ,readwrite) NSInteger index;

@property (nonatomic ,strong) EaseComponentDecorateBuilder * decorateBuilder;

- (void) calculatorLayout;
@end

@interface EaseComponentDecorateContents ()

@property (nonatomic ,strong) UIColor * color;

@property (nonatomic ,strong) UIImage * image;

@property (nonatomic ,copy) NSArray <UIColor *>* colors;
@property (nonatomic ,copy) NSArray <NSNumber *>* locations;
@property (nonatomic) CGPoint startPoint;// 0,0
@property (nonatomic) CGPoint endPoint;// 1,0

@property (nonatomic ,assign ,readwrite) BOOL isColor;
@property (nonatomic ,assign ,readwrite) BOOL isImage;
@property (nonatomic ,assign ,readwrite) BOOL isGradient;
@end
NS_ASSUME_NONNULL_END
