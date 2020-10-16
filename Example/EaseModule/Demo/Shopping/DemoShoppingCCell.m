//
//  DemoShoppingCCell.m
//  EaseModule_Example
//
//  Created by rocky on 2020/10/16.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "DemoShoppingCCell.h"

@implementation ShoppingKeywordCCell{
    UILabel * _textLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.layer.cornerRadius = 15.0f;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];

        _textLabel = [UILabel new];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        _textLabel.textColor = [UIColor colorWithHexString:@"#282828"];
        [self.contentView addSubview:_textLabel];
        
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setupWithData:(id)data{
    _textLabel.text = EaseSafeString(data);
}

@end

@implementation ShoppingCategoryCCell{
    UILabel *_nameLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.layer.cornerRadius = 4.0f;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
        
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#282828"];
        _nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        [self.contentView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setupWithData:(id)data{
    _nameLabel.text = EaseSafeString(data[@"name"]);
}
@end

@implementation ShoppingItemCCell{
    UIImageView *_picImageView;
    UILabel *_nameLabel;
    UILabel *_descLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _picImageView = [UIImageView new];
        _picImageView.contentMode = UIViewContentModeScaleAspectFill;
        _picImageView.clipsToBounds = YES;
        _picImageView.layer.cornerRadius = 4.0;
        [self.contentView addSubview:_picImageView];
        
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#282828"];
        _nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        _nameLabel.numberOfLines = 0;
        [self.contentView addSubview:_nameLabel];
        
        _descLabel = [UILabel new];
        _descLabel.textColor = [UIColor colorWithHexString:@"#5B5B5B"];
        _descLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightThin];
        _descLabel.numberOfLines = 0;
        [self.contentView addSubview:_descLabel];
        
        [_picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.height.mas_equalTo(self.contentView.mas_width);
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(6);
            make.top.equalTo(self->_picImageView.mas_bottom).mas_offset(4);
            make.right.equalTo(self.contentView).mas_offset(-6);
        }];
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self->_nameLabel);
            make.top.equalTo(self->_nameLabel.mas_bottom).mas_offset(4);
        }];
        
    }
    return self;
}

- (void)setupWithData:(id)data{
    [_picImageView sd_setImageWithURL:EaseSafeURL(data[@"pic"])];
    _nameLabel.text = EaseSafeString(data[@"name"]);
    _descLabel.text = EaseSafeString(data[@"desc"]);
}

@end

@implementation ShoppingHeaderView{
    UILabel *_titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
        _titleLabel.textColor = UIColor.redColor;
        [self addSubview:_titleLabel];
        
        UIView * leftView = [UIView new];
        leftView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
        [self addSubview:leftView];
        
        UIView * rightView = [UIView new];
        rightView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
        [self addSubview:rightView];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.height.equalTo(self);
        }];
        
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(2);
            make.left.equalTo(self).mas_offset(30);
            make.right.equalTo(self->_titleLabel.mas_left).mas_offset(-10);
            make.centerY.equalTo(self);
        }];
        
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.centerY.equalTo(leftView);
            make.left.equalTo(self->_titleLabel.mas_right).mas_offset(10);
            make.right.equalTo(self).mas_offset(-30);
        }];
    }
    return self;
}

- (void)setupTitle:(NSString *)title{
    _titleLabel.text = EaseSafeString(title);
}

@end
