//
//  DemoContentCCell.h
//  QILievModule
//
//  Created by rocky on 2020/8/10.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DemoContentCCell : UICollectionViewCell{
    
}
@property (nonatomic ,strong) UILabel * oneLabel;
- (void) setupWithData:(id)data;

@end

@interface DemoBannerCCell : UICollectionViewCell
- (void) setupBannerDatas:(NSArray<NSString *> *)datas;
@end

@interface DemoPlaceholdCCell : UICollectionViewCell

@end

@interface DemoHeaderView : UICollectionReusableView
@property (nonatomic ,strong) UILabel * titleLabel;
- (void) setupHeaderTitle:(NSString *)title;
@end

@interface DemoFooterView : UICollectionReusableView
@end

NS_ASSUME_NONNULL_END
