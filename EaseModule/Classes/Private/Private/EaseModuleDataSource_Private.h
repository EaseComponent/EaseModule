//
//  EaseModuleDataSource+Private.h
//  EaseModule
//
//  Created by rocky on 2020/8/7.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "EaseModuleDataSource.h"
#import "EaseModuleEnvironment_Protocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface EaseModuleDataSource ()

@property (nonatomic ,strong) id<EaseModuleEnvironment> environment;

- (EaseComponent *) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout componentAtSection:(NSInteger)section;
@end

NS_ASSUME_NONNULL_END
