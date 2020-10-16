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
        _textLabel.textColor = UIColor.redColor;
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

@implementation ShoppingCategoryCCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setupWithData:(id)data{
    
}
@end

@implementation ShoppingItemCCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setupWithData:(id)data{
    
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
