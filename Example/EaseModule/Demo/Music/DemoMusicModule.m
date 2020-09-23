//
//  DemoMusicModule.m
//  QILievModule
//
//  Created by rocky on 2020/8/10.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "DemoMusicModule.h"
#import "DemoMusicComponent.h"
#import "NSArray+Sugar.h"

@implementation DemoMusicModule{
    id demoData;
}

- (instancetype)initWithName:(NSString *)name{
    self = [super initWithName:name];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"json"];
        // 将文件数据化
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        
        demoData = [NSJSONSerialization JSONObjectWithData:data
                                                   options:kNilOptions
                                                     error:nil];
    }
    return self;
}

- (BOOL)shouldLoadMore{
    return NO;
}

// 这里使用refresh来模拟网络加载
- (void)refresh{
    [super refresh];
    [self.dataSource clear];
    
    [self setupComponents:demoData];
    
    [self.collectionView reloadData];
}

- (void) setupComponents:(NSDictionary *)datas{

    if ([datas isKindOfClass:[NSDictionary class]]) {
        
        __block NSInteger index = 0;
        
        NSArray * songs = datas[@"songs"];
        
        NSArray *(^subarrayData)(NSInteger) = ^NSArray*(NSInteger length) {
            NSArray * result = [songs subarrayWithRange:NSMakeRange(index, length)];
            index += length;
            return result;
        };

        MusicBannerComponent * bannerComp = [MusicBannerComponent new];
        [bannerComp addData:[datas[@"banner"] ease_map:^id _Nonnull(id  _Nonnull obj) {
            return obj[@"picUrl"];
        }]];
        
        MusicTodayComponent * todayComp = [[MusicTodayComponent alloc] initWithName:@"今日最佳"];
//        todayComp.headerPin = YES;
        [todayComp addDatas:subarrayData(3)];
        
        MusicWeekRankComponent * weekRankComp = [[MusicWeekRankComponent alloc] initWithName:@"本周热门"];
//        weekRankComp.headerPin = YES;
        [weekRankComp addDatas:subarrayData(60)];

//        MusicSongListComponent * songListComp = [[MusicSongListComponent alloc] initWithName:@"夏日午后的小歇"];
//        songListComp.headerPin = YES;
//        [songListComp addDatas:subarrayData(12)];
//        
//        MusicSongCardComponent * songCardComp = [[MusicSongCardComponent alloc] initWithName:@"自习/考研加油站"];
////        songCardComp.headerPin = YES;
//        [songCardComp addDatas:subarrayData(3)];
//        
//        MusicSongListComponent * songListComp3 = [[MusicSongListComponent alloc] initWithName:@"情人节虐狗专用"];
////        songListComp3.headerPin = YES;
//        [songListComp3 addDatas:subarrayData(12)];
//        
//        MusicSongListComponent * songListComp4 = [[MusicSongListComponent alloc] initWithName:@"你还记得么"];
////        songListComp4.headerPin = YES;
//        [songListComp4 addDatas:subarrayData(12)];
//        
//        MusicSongListComponent * songListComp5 = [[MusicSongListComponent alloc] initWithName:@"飞行员的歌单"];
//        [songListComp5 addDatas:subarrayData(12)];
        
        [self.dataSource addComponents:@[
//            bannerComp,
//            todayComp,
            weekRankComp,
//            songListComp,songCardComp,
//            songListComp3,songListComp4,songListComp5
        ]];
    }
}

@end
