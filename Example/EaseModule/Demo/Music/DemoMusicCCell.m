//
//  DemoMusicCCell.m
//  QILievModule
//
//  Created by rocky on 2020/8/25.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "DemoMusicCCell.h"

@implementation MusicTodayCCell{
    UIImageView *_albumImageView;
    UILabel *_songNameLabel;
    MASConstraint * _heightConstraint;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _albumImageView = [UIImageView new];
        _albumImageView.backgroundColor = [UIColor randomColor];
        _albumImageView.contentMode = UIViewContentModeScaleAspectFill;
        _albumImageView.clipsToBounds = YES;
        _albumImageView.layer.cornerRadius = 4.0f;
        _albumImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_albumImageView];
        
        UIView * maskView = [UIView new];
        maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [_albumImageView addSubview:maskView];
        
        _songNameLabel = [UILabel new];
        _songNameLabel.textColor = [UIColor colorWithHexString:@"e8e8e8"];
        _songNameLabel.textAlignment = NSTextAlignmentCenter;
        _songNameLabel.font = [UIFont systemFontOfSize:15];
        _songNameLabel.numberOfLines = 1;
        [_albumImageView addSubview:_songNameLabel];
        
        [_albumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView);
            make.width.equalTo(self->_albumImageView.mas_height);
            self->_heightConstraint = make.height.mas_equalTo(self.contentView);
        }];
        
        [_songNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_albumImageView).mas_offset(-0);
            make.left.equalTo(_albumImageView).mas_offset((0));
            make.right.equalTo(_albumImageView).mas_offset(0);
            make.height.mas_greaterThanOrEqualTo(20);
        }];
        
        [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_songNameLabel);
        }];
    }
    return self;
}

- (void) setupSong:(id)songData atIndex:(NSInteger)index{
//    _heightConstraint.mas_equalTo(_albumImageView.mas_width);;
//    [_albumImageView sd_setImageWithURL:EaseSafeURL(@"http://p3.music.126.net/zel4pIUebw09fhwdirOUJw==/109951164310145356.jpg?param=140y140")];
    [_albumImageView sd_setImageWithURL:EaseSafeURL(songData[@"album"][@"picUrl"])];
    _songNameLabel.text = songData[@"name"];
}
@end

@implementation MusicRankCCell{
    UIImageView *_albumImageView;
    UILabel *_songNameLabel;
    UILabel *_artistsNameLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _albumImageView = [UIImageView new];
        _albumImageView.backgroundColor = [UIColor randomColor];
        _albumImageView.contentMode = UIViewContentModeScaleAspectFill;
        _albumImageView.clipsToBounds = YES;
        _albumImageView.layer.cornerRadius = 4.0f;
        _albumImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_albumImageView];
        
        _songNameLabel = [UILabel new];
        _songNameLabel.textColor = [UIColor colorWithHexString:@"505050"];
        _songNameLabel.textAlignment = NSTextAlignmentLeft;
        _songNameLabel.font = [UIFont systemFontOfSize:15];
        _songNameLabel.numberOfLines = 1;
        [self.contentView addSubview:_songNameLabel];
        
        _artistsNameLabel = [UILabel new];
        _artistsNameLabel.textColor = [UIColor colorWithHexString:@"a3a3a3"];
        _artistsNameLabel.textAlignment = NSTextAlignmentLeft;
        _artistsNameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_artistsNameLabel];
        
        [_albumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(0);
            make.top.equalTo(self.contentView).mas_offset(4);
            make.bottom.equalTo(self.contentView).mas_offset(-4);
            make.width.equalTo(self->_albumImageView.mas_height);
        }];
        [_songNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_albumImageView).mas_offset(4);
            make.left.equalTo(_albumImageView.mas_right).mas_offset((10));
            make.right.mas_lessThanOrEqualTo(self.contentView).mas_offset(-10);
        }];
        [_artistsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_songNameLabel);
            make.bottom.equalTo(_albumImageView).mas_offset(-4);
            make.right.mas_lessThanOrEqualTo(self.contentView).mas_offset(-10);
        }];
    }
    return self;
}

- (void) setupSong:(id)songData atIndex:(NSInteger)index{
    [_albumImageView sd_setImageWithURL:EaseSafeURL(songData[@"album"][@"picUrl"])];
//    [_albumImageView sd_setImageWithURL:EaseSafeURL(@"http://p3.music.126.net/zel4pIUebw09fhwdirOUJw==/109951164310145356.jpg?param=140y140")];
    _songNameLabel.text = songData[@"name"];
    _artistsNameLabel.text = songData[@"artists"][0][@"name"];
}

@end

@implementation MusicSongListCCell{
    UIImageView *_albumImageView;
    UILabel *_songNameLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _albumImageView = [UIImageView new];
        _albumImageView.backgroundColor = [UIColor randomColor];
        _albumImageView.contentMode = UIViewContentModeScaleAspectFill;
        _albumImageView.clipsToBounds = YES;
        _albumImageView.layer.cornerRadius = 4.0f;
        _albumImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_albumImageView];
        
        _songNameLabel = [UILabel new];
        _songNameLabel.textColor = [UIColor colorWithHexString:@"505050"];
        _songNameLabel.textAlignment = NSTextAlignmentLeft;
        _songNameLabel.font = [UIFont systemFontOfSize:15];
        _songNameLabel.numberOfLines = 1;
        [self.contentView addSubview:_songNameLabel];
        
        [_albumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(2);
            make.right.equalTo(self.contentView).mas_offset(-2);
            make.top.equalTo(self.contentView).mas_offset(0);
            make.width.equalTo(self->_albumImageView.mas_height);
        }];
        [_songNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_albumImageView.mas_bottom).mas_offset(5);
            make.left.equalTo(_albumImageView).mas_offset(0);
            make.right.equalTo(_albumImageView).mas_offset(0);
        }];
    }
    return self;
}

- (void) setupSong:(id)songData atIndex:(NSInteger)index{
    [_albumImageView sd_setImageWithURL:EaseSafeURL(songData[@"album"][@"picUrl"])];
//    [_albumImageView sd_setImageWithURL:EaseSafeURL(@"http://p3.music.126.net/zel4pIUebw09fhwdirOUJw==/109951164310145356.jpg?param=140y140")];
    _songNameLabel.text = songData[@"name"];
}

@end
