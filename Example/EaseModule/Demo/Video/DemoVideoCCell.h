//
//  DemoVideoCCell.h
//  QILievModule
//
//  Created by rocky on 2020/8/18.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DemoVideoCCell : UICollectionViewCell

- (void) setupImageURLString:(NSString *)imageUrlString;
@end

@interface DemoVideoCategoryCCell : UICollectionViewCell

- (void) setupCategory:(NSString *)category;
@end

@interface DemoVideoRankCCell : UICollectionViewCell

- (void) setupRank:(NSInteger)rank name:(NSString *)name showSepLine:(BOOL)showSepLine;
@end

@interface DemoVideoChangeFooterView : UICollectionReusableView
@property (nonatomic ,copy) void(^bChangeAction)(void);
@end

NS_ASSUME_NONNULL_END
