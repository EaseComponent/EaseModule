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
@end
