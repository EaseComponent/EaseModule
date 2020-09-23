//
//  DemoMineCCell.m
//  QILievModule
//
//  Created by rocky on 2020/8/24.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "DemoMineCCell.h"

@implementation DemoMineInfoCCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView * iconView = [UIView new];
        iconView.backgroundColor = [UIColor colorWithHexString:@"e3e3e3"];
        iconView.layer.masksToBounds = YES;
        iconView.layer.cornerRadius = 40;
        [self.contentView addSubview:iconView];
        
        UIView * nameView = [UIView new];
        nameView.backgroundColor = [UIColor colorWithHexString:@"F3F3F3"];
        [self.contentView addSubview:nameView];
        
        UIView * infoView = [UIView new];
        infoView.backgroundColor = [UIColor colorWithHexString:@"F3F3F3"];
        [self.contentView addSubview:infoView];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(80, 80));
            make.left.mas_equalTo(20);
        }];
        
        [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconView.mas_right).mas_offset(10);
            make.top.equalTo(iconView);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(30);
        }];
        
        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameView);
            make.bottom.equalTo(iconView);
            make.width.mas_equalTo(200);
            make.top.equalTo(nameView.mas_bottom).mas_offset(5);
        }];
    }
    return self;
}
@end

@implementation DemoMineBannerCCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.layer.cornerRadius = 4.0f;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"e3e3e3"];
    }
    return self;
}
@end

@implementation DemoMineAccountCCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView * iconView = [UIView new];
        iconView.backgroundColor = [UIColor colorWithHexString:@"e3e3e3"];
        iconView.layer.masksToBounds = YES;
        iconView.layer.cornerRadius = 30;
        [self.contentView addSubview:iconView];
        
        UIView * infoView = [UIView new];
        infoView.backgroundColor = [UIColor colorWithHexString:@"F3F3F3"];
        [self.contentView addSubview:infoView];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).mas_offset(10);
            make.centerX.equalTo(self.contentView);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(60);
        }];
        
        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(iconView);
            make.top.equalTo(iconView.mas_bottom).mas_offset(10);
            make.width.mas_equalTo(self.contentView.mas_width).mas_offset(-20);
            make.height.mas_equalTo(20);
        }];
    }
    return self;
}
@end

@implementation DemoMineFuncCCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView * iconView = [UIView new];
        iconView.backgroundColor = [UIColor colorWithHexString:@"F3F3F3"];
        iconView.layer.masksToBounds = YES;
        iconView.layer.cornerRadius = 4;
        [self.contentView addSubview:iconView];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(4, 4, 4, 4));
        }];
    }
    return self;
}
@end
