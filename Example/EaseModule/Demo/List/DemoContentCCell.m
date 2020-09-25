//
//  DemoContentCCell.m
//  QILievModule
//
//  Created by rocky on 2020/8/10.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "DemoContentCCell.h"
#import "SDCycleScrollView.h"

@implementation DemoContentCCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.layer.cornerRadius = 4.0f;
        self.contentView.layer.masksToBounds = YES;
        
        self.oneLabel = [UILabel new];
        self.oneLabel.textAlignment = NSTextAlignmentCenter;
        self.oneLabel.numberOfLines = 2;
        self.oneLabel.font = [UIFont boldSystemFontOfSize:13];
        [self.contentView addSubview:self.oneLabel];
        
    }
    return self;
}

- (BOOL)needsUpdateConstraints{
    return NO;;
}
- (void)updateConstraints{
    
    [self.oneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).mas_offset(5);
        make.right.equalTo(self.contentView).mas_offset(-5);
//        make.height.mas_greaterThanOrEqualTo(20);
//        make.width.mas_greaterThanOrEqualTo(20);
    }];
    [super updateConstraints];
}

- (void) setupWithData:(id)data{
    if ([data isKindOfClass:NSString.class]) {
        self.oneLabel.attributedText = [[NSAttributedString alloc] initWithString:EaseSafeString(data)];
    } else if ([data isKindOfClass:NSAttributedString.class]) {
        self.oneLabel.attributedText = (NSAttributedString *)data;
    } else {
        self.oneLabel.attributedText = nil;
    }
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
}
@end

@implementation DemoBannerCCell{
    SDCycleScrollView * _cycleScrollView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _cycleScrollView = [SDCycleScrollView new];
//        _cycleScrollView.layer.cornerRadius = 4.0f;
//        _cycleScrollView.layer.masksToBounds = YES;
        _cycleScrollView.autoScrollTimeInterval = 3.5f;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.clipsToBounds = YES;
        [self.contentView addSubview:_cycleScrollView];
        
        [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}
- (void) setupBannerDatas:(NSArray<NSString *> *)datas{
    _cycleScrollView.imageURLStringsGroup = datas;
}
- (void) setupBannerImages:(NSArray<UIImage *> *)images{
    _cycleScrollView.localizationImageNamesGroup = images;
}
@end
@implementation DemoPlaceholdCCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
                
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#7CBDFF"];

        UILabel * oneLabel = [UILabel new];
        oneLabel.textAlignment = NSTextAlignmentCenter;
        oneLabel.text = @"This is Placehold cell.";
        oneLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        oneLabel.font = [UIFont boldSystemFontOfSize:20];
        [self.contentView addSubview:oneLabel];
        
        [oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
//            make.left.equalTo(self.contentView).mas_offset(5);
//            make.right.equalTo(self.contentView).mas_offset(-5);
        }];
    }
    return self;
}
@end

@implementation DemoHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [[UIColor colorWithHexString:@"#333333"] colorWithAlphaComponent:0.3];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        [self addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(16);
            make.height.equalTo(self);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}
- (void) setupHeaderTitle:(NSString *)title{
    self.titleLabel.text = EaseSafeString(title);
}
- (void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];
    NSLog(@"hidden");
}
@end

@implementation DemoFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [[UIColor colorWithHexString:@"#ff183e"] colorWithAlphaComponent:0.3];
        
        UILabel * titleLabel = [UILabel new];
        titleLabel.text = @"- This is Footer -";
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        [self addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self);
            make.center.equalTo(self);
        }];
    }
    return self;
}
@end
