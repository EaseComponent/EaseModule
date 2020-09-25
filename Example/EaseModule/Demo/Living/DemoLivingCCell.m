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
