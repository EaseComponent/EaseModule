//
//  DemoSearchCCell.h
//  QILievModule
//
//  Created by rocky on 2020/8/26.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoContentCCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchCCell : UICollectionViewCell

@end

@interface SearchHotCCell : UICollectionViewCell

@property (nonatomic ,strong) UILabel * oneLabel;
- (void) setupWithData:(id)data;

@end

@interface SearchHistoryHeaderView : DemoHeaderView
@property (nonatomic ,copy) void(^bChangeAction)(void);

- (void) setupFoldState:(BOOL)fold;
@end

@interface SearchRankShowMoreFooterView : UICollectionReusableView

@property (nonatomic ,copy) void(^bChangeAction)(void);
- (void) setupTitle:(BOOL)showAll;
@end

@interface SearchRecommendCCell : UICollectionViewCell

- (void) setupWithData:(id)data;
@end
NS_ASSUME_NONNULL_END
