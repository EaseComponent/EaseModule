//
//  DemoShoppingCCell.h
//  EaseModule_Example
//
//  Created by rocky on 2020/10/16.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShoppingKeywordCCell : UICollectionViewCell
- (void) setupWithData:(id)data;
@end

@interface ShoppingCategoryCCell : UICollectionViewCell
- (void) setupWithData:(id)data;
@end

@interface ShoppingItemCCell : UICollectionViewCell
- (void) setupWithData:(id)data;
@end

@interface ShoppingHeaderView : UICollectionReusableView
- (void) setupTitle:(NSString *)title;
@end

@interface ShoppingFooterView : UICollectionReusableView
@property (nonatomic ,copy) void(^bRefresh)(void);
@end

NS_ASSUME_NONNULL_END
