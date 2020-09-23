//
//  DemoCompositeListViewController.m
//  QILievModule
//
//  Created by rocky on 2020/8/9.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "DemoCompositeListViewController.h"
#import "JXCategoryView.h"
#import "DemoListViewController.h"

@interface DemoCompositeListViewController ()<
JXCategoryListContainerViewDelegate,
JXCategoryViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView * categoryView;
@property (nonatomic ,strong) EaseCompositeModule * module;

@end

@implementation DemoCompositeListViewController

- (instancetype)initWithModule:(EaseCompositeModule *)module{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.module = module;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.categoryView = [[JXCategoryTitleView alloc] init];
    self.categoryView.titles = [self.module.modules ease_map:^id(__kindof EaseModule * obj) {
        return obj.name;
    }];
    self.categoryView.delegate = self;
    self.categoryView.cellWidth = 70;
    self.categoryView.titleFont = [UIFont systemFontOfSize:18];
    self.categoryView.titleSelectedFont = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    self.categoryView.titleColor = [UIColor grayColor];
    self.categoryView.titleSelectedColor = [UIColor redColor];
    [self.view addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    //
    _mainPageView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    [self.view addSubview:_mainPageView];
    [_mainPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.categoryView.mas_bottom);
    }];

    self.categoryView.contentScrollView = _mainPageView.scrollView;
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    [_mainPageView didClickSelectedItemAtIndex:index];
}

#pragma mark - JXCategoryListContainerViewDelegate

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    EaseModule * module = self.module.modules[index];
    if ([module isKindOfClass:[EaseCompositeModule class]]) {
        EaseCompositeModule * compositeModule = (EaseCompositeModule *)module;
        DemoCompositeListViewController * vc = [[DemoCompositeListViewController alloc] initWithModule:compositeModule];
        [self addChildViewController:vc];
        return vc;
    } else {
        DemoListViewController * vc = [[DemoListViewController alloc] initWithModule:module];
        [self addChildViewController:vc];
        return vc;
    }
    return nil;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.module.modules.count;
}

#pragma mark - JXCategoryListContentViewDelegate

- (UIScrollView *)listScrollView {
    return _mainPageView.scrollView;
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
@end

