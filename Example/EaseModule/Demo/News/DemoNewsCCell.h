//
//  DemoNewsCCell.h
//  EaseModule_Example
//
//  Created by rocky on 2020/9/28.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsInfoCCell : UICollectionViewCell
- (void) setupWithData:(id)data;
@end

@protocol NewsContentCCellDelegate;
@interface NewsContentCCell : UICollectionViewCell
@property (nonatomic ,weak) id<NewsContentCCellDelegate> delegate;
- (void) setupWithData:(id)data;
@end

@interface NewsKeywordCCell : UICollectionViewCell
- (void) setupWithData:(id)data;
@end

@interface NewsRecommendCCell : UICollectionViewCell
- (void) setupWithData:(id)data;
- (void) test:(NSString *)data;
@end

@protocol NewsContentCCellDelegate <NSObject>

- (void) newsContentCCell:(NewsContentCCell *)ccell didFinishUpdateHeight:(CGFloat)height;

@end
NS_ASSUME_NONNULL_END
