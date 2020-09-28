//
//  EaseOrthogonalScrollerEmbeddedScrollView.h
//  EaseModule
//
//  Created by rocky on 2020/7/7.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EaseOrthogonalScrollerEmbeddedScrollView : UICollectionView

@end

@interface EaseOrthogonalScrollerEmbeddedCCell : UICollectionViewCell

@property (nonatomic ,strong ,readonly) EaseOrthogonalScrollerEmbeddedScrollView * orthogonalScrollView;

+ (NSString *) reuseIdentifier;
@end

@interface EaseOrthogonalScrollerSectionController: NSObject

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic) EaseOrthogonalScrollerEmbeddedScrollView *scrollView;
@property (nonatomic) NSInteger sectionIndex;

- (instancetype)initWithSectionIndex:(NSInteger)sectionIndex
                      collectionView:(UICollectionView *)collectionView
                          scrollView:(EaseOrthogonalScrollerEmbeddedScrollView *)scrollView;

- (__kindof UICollectionViewCell *) dequeueReusableCell:(Class)cellClass
                                    withReuseIdentifier:(NSString *)reuseIdentifier
                                            atIndexPath:(NSIndexPath *)indexPath;

- (void) removeFromSuperview;
@end

NS_ASSUME_NONNULL_END
