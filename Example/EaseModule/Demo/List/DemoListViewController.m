//
//  DemoListViewController.m
//  QILievModule
//
//  Created by rocky on 2020/8/9.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "DemoListViewController.h"
#import "EaseRefreshProxy.h"

@interface DemoListViewController ()<
EaseModuleDelegate,
UICollectionViewDelegate>

@property (nonatomic ,strong) UICollectionView * collectionView;
@property (nonatomic ,strong) EaseModule * module;
@property (nonatomic ,strong) EaseRefreshProxy * refreshProxy;

@end

@implementation DemoListViewController

- (instancetype) initWithModule:(EaseModule *)module{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.module = module;
        self.module.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                         collectionViewLayout:({
        [[UICollectionViewFlowLayout alloc] init];
    })];
    if (@available(ios 11.0, *)) {
        [_collectionView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        [_collectionView setScrollIndicatorInsets:[UIScrollView appearance].contentInset];
    }
    _collectionView.backgroundColor = UIColor.whiteColor;
//    _collectionView.emptyDataSetSource = self;
//    _collectionView.emptyDataSetDelegate = self;
    _collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
    
    // module
    [self.module setupViewController:self collectionView:self.collectionView];
    
    // refresh proxy
    self.refreshProxy = [[EaseRefreshProxy alloc] initWithScrollView:self.collectionView];
    [self.refreshProxy addRefresh:^(NSInteger index) {
        @strongify(self);
        [self.module refresh];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.refreshProxy endRefresh];
        });
    }];
    if (self.module.shouldLoadMore) {
        [self.refreshProxy addLoadMore:@"人家也是有底线的" callback:^(NSInteger index) {
            @strongify(self);
            [self.module loadMore];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.refreshProxy endLoadMore];
            });
        }];
    }
}

#pragma mark - JXCategoryListContentViewDelegate

- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (UIView *)listView {
    return self.view;
}

- (void)listDidAppear{

    if (self.module.didAppeared) {
        NSLog(@"[home] error: %@ did appeared",self.module.name);
        return;
    }
    
    self.module.didAppeared = YES;
    // 出现的时候刷新数据
    [self.module refresh];
    
    NSLog(@"[home] %@ appear",self.module.name);
}

- (void)listDidDisappear{
    self.module.didAppeared = NO;
    NSLog(@"[home] %@ disappear", self.module.name);
}

#pragma mark - EaseModuleDelegate

- (void)liveModuleDidSuccessUpdateComponent:(EaseModule *)module{
    [self.refreshProxy endRefreshOrLoadMore];
    [self.collectionView reloadData];
}

- (void)liveModule:(EaseModule *)module didFailUpdateComponent:(NSError *)error{
    [self.refreshProxy endRefreshOrLoadMore];

    [module.dataSource clear];
    [self.collectionView reloadData];
}

@end
