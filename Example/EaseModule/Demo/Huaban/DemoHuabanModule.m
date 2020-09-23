//
//  DemoHuabanModule.m
//  QILievModule
//
//  Created by rocky on 2020/8/19.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "DemoHuabanModule.h"

@interface DemoHuabanComponent : EaseComponent<
EaseWaterfallLayoutDelegate>

@end

@implementation DemoHuabanModule{
    id demoData;
}

- (instancetype)initWithName:(NSString *)name{
    self = [super initWithName:name];
    if (self) {
//        demoData =
        NSString *path = [[NSBundle mainBundle] pathForResource:@"huaban" ofType:@"json"];
        // 将文件数据化
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        
        demoData = [NSJSONSerialization JSONObjectWithData:data
                                                   options:kNilOptions
                                                     error:nil];
    }
    return self;
}
- (BOOL)shouldLoadMore{
    return NO;
}

// 这里使用refresh来模拟网络加载
- (void)refresh{
    [super refresh];
    [self.dataSource clear];
    
    [self setupComponents:demoData];
    
    [self.collectionView reloadData];
}

- (void) setupComponents:(NSArray *)data{

    if ([data isKindOfClass:[NSArray class]]) {
        DemoHuabanComponent * component = [DemoHuabanComponent new];
        [component addDatas:data];
        [self.dataSource addComponent:component];
    }
}
@end

@interface DemoHuabanCCell : UICollectionViewCell
- (void) setupImageURLString:(NSString *)imageURLString;
@end
@implementation DemoHuabanComponent

- (instancetype)init
{
    self = [super init];
    if (self) {
        EaseWaterfallLayout * layout = [EaseWaterfallLayout new];
        layout.inset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.delegate = self;
        layout.column = 2;
        _layout = layout;
    }
    return self;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    DemoHuabanCCell * ccell = [self.dataSource dequeueReusableCellOfClass:DemoHuabanCCell.class forComponent:self atIndex:index];
    [ccell setupImageURLString:[self dataAtIndex:index][@"img"]];
    return ccell;
}

#pragma mark - EaseWaterfallLayoutDelegate

- (CGSize)layoutCustomItemSize:(EaseWaterfallLayout *)layout atIndex:(NSInteger)index{
    id data = [self dataAtIndex:index];
    CGFloat width = [data[@"width"] floatValue];
    CGFloat height = [data[@"height"] floatValue];
    
    CGFloat scale = width / height;
    width = layout.itemWidth;
    height = width / scale;
    return CGSizeMake(width, height);
}
@end

@implementation DemoHuabanCCell{
    UIImageView *_imageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
        self.contentView.layer.cornerRadius = 4.0f;
        self.contentView.layer.masksToBounds = YES;
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void) setupImageURLString:(NSString *)imageURLString{
    [_imageView sd_setImageWithURL:QLSafeURL(imageURLString)];
}

@end
