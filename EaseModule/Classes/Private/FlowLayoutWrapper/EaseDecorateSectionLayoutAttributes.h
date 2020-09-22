//
//  EaseDecorateSectionLayoutAttributes.h
//  EaseModule
//
//  Created by rocky on 2020/8/18.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol EaseComponentDecorateAble;
@interface EaseDecorateSectionLayoutAttributes : UICollectionViewLayoutAttributes

@property (nonatomic ,assign) id<EaseComponentDecorateAble> builder;
@end

@interface EaseDecorateSectionView : UICollectionReusableView

@end

NS_ASSUME_NONNULL_END
