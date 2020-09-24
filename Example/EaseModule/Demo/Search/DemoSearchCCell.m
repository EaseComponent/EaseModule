//
//  DemoSearchCCell.m
//  QILievModule
//
//  Created by rocky on 2020/8/26.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "DemoSearchCCell.h"

@implementation SearchCCell

@end

@implementation SearchHistoryHeaderView{
    UIButton *_foldButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _foldButton = [UIButton new];
        [_foldButton setTitle:@"折叠" forState:UIControlStateNormal];
        [_foldButton setTitle:@"打开" forState:UIControlStateSelected];
        [_foldButton setTitleColor:[UIColor colorWithHexString:@"#7C7D7E"]
                          forState:UIControlStateNormal];
        [_foldButton setTitleColor:[UIColor redColor]
                          forState:UIControlStateSelected];
        _foldButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
        [_foldButton addTarget:self action:@selector(onFoldAction:)
              forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_foldButton];
        
        [_foldButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self);
            make.width.mas_equalTo(60);
            make.right.equalTo(self).mas_offset(0);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

- (void) onFoldAction:(UIButton *)button{
    if (self.bChangeAction) {
        self.bChangeAction();
    }
}

- (void) setupFoldState:(BOOL)fold{
    _foldButton.selected = fold;
}

@end

@implementation SearchRankShowMoreFooterView{
    UIButton *_showMoreButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _showMoreButton = [UIButton new];
        [_showMoreButton setTitle:@"show more"
                         forState:UIControlStateNormal];
        _showMoreButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        [_showMoreButton setTitleColor:[UIColor redColor]
                              forState:UIControlStateNormal];
        [_showMoreButton addTarget:self action:@selector(onShowMore:)
                  forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_showMoreButton];
        
        [_showMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_greaterThanOrEqualTo(100);
            make.height.mas_equalTo(self);
        }];
    }
    return self;
}

- (void) onShowMore:(UIButton *)button{
    if (self.bChangeAction) {
        self.bChangeAction();
    }
}

- (void) setupTitle:(BOOL)showAll{
    [_showMoreButton setTitle:(showAll ? @"hide more" : @"show more")
                     forState:UIControlStateNormal];
}
@end

@implementation SearchRecommendCCell{
    UILabel * _titleLabel;
    UIImageView * _picImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 4.0f;
        
        _picImageView = [UIImageView new];
        _picImageView.clipsToBounds = YES;
        _picImageView.backgroundColor = [UIColor randomColor];
        _picImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_picImageView];
        
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:_titleLabel];
        
        [_picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.contentView);
            make.bottom.equalTo(self->_titleLabel.mas_top).mas_offset(-4);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(4);
            make.right.equalTo(self.contentView).mas_offset(-4);
            make.bottom.equalTo(self.contentView).mas_offset(-4);
            make.height.mas_greaterThanOrEqualTo(20);
        }];
    }
    return self;
}
- (void) setupWithData:(id)data{
    _titleLabel.text = EaseSafeString(data[@"title"]);
    [_picImageView sd_setImageWithURL:EaseSafeURL(data[@"pic"])];
}

@end
