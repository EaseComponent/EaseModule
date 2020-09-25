//
//  DemoLivingCCell.m
//  EaseModule_Example
//
//  Created by rocky on 2020/9/25.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "DemoLivingCCell.h"

@implementation LivingCCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 4.0f;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    }
    return self;
}
@end

@implementation LivingPlaceholdCCell{
    UILabel * _titleLabel;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 4.0f;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
        
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#7C7D7E"];
        _titleLabel.text = @"暂时没有热门主播";
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
    }
    return self;
}

@end
