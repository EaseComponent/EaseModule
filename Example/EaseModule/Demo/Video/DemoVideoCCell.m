//
//  DemoVideoCCell.m
//  QILievModule
//
//  Created by rocky on 2020/8/18.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "DemoVideoCCell.h"

@implementation DemoVideoCCell{
    UIImageView *_imageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _imageView = [UIImageView new];
        _imageView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
        _imageView.layer.cornerRadius = 4.0f;
        _imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_imageView];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void) setupImageURLString:(NSString *)imageUrlString{
    [_imageView sd_setImageWithURL:QLSafeURL(imageUrlString)];
}
@end

@implementation DemoVideoCategoryCCell{
    UILabel *_categoryLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
        self.contentView.layer.cornerRadius = 6;
        self.contentView.layer.masksToBounds = YES;
        
        _categoryLabel = [UILabel new];
        _categoryLabel.textColor = [UIColor colorWithHexString:@"5c5c5c"];
        _categoryLabel.textAlignment = NSTextAlignmentCenter;
        _categoryLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_categoryLabel];
        
        [_categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void) setupCategory:(NSString *)category{
    _categoryLabel.text = QLSafeString(category);
}

@end

@implementation DemoVideoRankCCell{
    UILabel *_rankLabel;
    UILabel *_nameLabel;
    UIView *_sepLineView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _rankLabel = [UILabel new];
        _rankLabel.font = [UIFont boldSystemFontOfSize:30];
        _rankLabel.textColor = [UIColor colorWithHexString:@"d5d5d5"];;
        _rankLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_rankLabel];
        
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont boldSystemFontOfSize:17];
        [self.contentView addSubview:_nameLabel];
        
        _sepLineView = [UIView new];
        _sepLineView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        [self.contentView addSubview:_sepLineView];
        
        [_rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(30);
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.mas_equalTo(_rankLabel.mas_right).mas_offset(10);
        }];
        [_sepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel);
            make.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void) setupRank:(NSInteger)rank name:(NSString *)name showSepLine:(BOOL)showSepLine{
    NSString * text;
    text = [NSString stringWithFormat:@"%ld",(long)rank];
    _rankLabel.text = text;
    _nameLabel.text = [NSString stringWithFormat:@"%@",name];
    
    _sepLineView.hidden = !showSepLine;
    
//    self.layer.shadowColor
}

@end

@implementation DemoVideoChangeFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor colorWithHexString:@"#333333"];

        UIButton * changeButton = [UIButton new];
        [changeButton addTarget:self action:@selector(onChange)
               forControlEvents:UIControlEventTouchUpInside];
        [changeButton setTitle:@"换一换" forState:UIControlStateNormal];
        [changeButton setTitleColor:[UIColor colorWithHexString:@"#f25b20"]
                           forState:UIControlStateNormal];
        changeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        changeButton.layer.borderWidth = 1.0f;
        changeButton.layer.borderColor = [UIColor colorWithHexString:@"#f25b20"].CGColor;
        changeButton.layer.cornerRadius = 20;
        changeButton.layer.masksToBounds = 1;
        [self addSubview:changeButton];
        
        [changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.left.mas_equalTo(self).mas_offset(20);
            make.right.equalTo(self).mas_offset(-20);
            make.center.equalTo(self);
        }];
    }
    return self;
}

- (void) onChange{
    if (self.bChangeAction) {
        self.bChangeAction();
    }
}

@end
