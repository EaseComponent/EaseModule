//
//  DemoMusicCCell.h
//  QILievModule
//
//  Created by rocky on 2020/8/25.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MusicTodayCCell : UICollectionViewCell
- (void) setupSong:(id)songData atIndex:(NSInteger)index;
@end

@interface MusicRankCCell : UICollectionViewCell
- (void) setupSong:(id)songData atIndex:(NSInteger)index;
@end

@interface MusicSongListCCell : UICollectionViewCell
- (void) setupSong:(id)songData atIndex:(NSInteger)index;
@end
NS_ASSUME_NONNULL_END
