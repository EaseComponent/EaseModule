//
//  EaseModuleDataSource.m
//  EaseModule
//
//  Created by rocky on 2020/6/28.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "EaseModuleDataSource.h"
#import "EaseModuleDataSource_Private.h"
#import "EaseOrthogonalScrollerEmbeddedScrollView.h"
#import "EaseComponent_Private.h"
#import "EaseModuleAdapterProxy.h"
#import "EaseModuleFlowLayout.h"

@interface NSArray (Ease)
- (NSArray *) ease_select:(BOOL (^)(id obj))handle;
- (void) ease_each:(void (^)(id))handle;
- (NSArray *) ease_map:(id (^)(id))handle;
@end

@interface EaseModuleDataSource (){
    __weak UICollectionView *_collectionView;
    NSArray<__kindof EaseComponent *> * _hidenWhenEmptyComponents;
}

@property (nonatomic, strong) EaseModuleAdapterProxy *delegateProxy;

@property (nonatomic, strong) NSMutableSet<NSString *> *registeredCellIdentifiers;
@property (nonatomic, strong) NSMutableSet<NSString *> *registeredPlaceholdCellIdentifiers;
@property (nonatomic, strong) NSMutableSet<NSString *> *registeredSupplementaryViewIdentifiers;

@property (nonatomic ,strong) NSMutableDictionary<NSNumber *, EaseOrthogonalScrollerSectionController *> *orthogonalScrollerSectionControllers;
@end

@implementation EaseModuleDataSource

- (void)dealloc
{
    NSLog(@"%@ dealloc",self);
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _innerComponents = [NSMutableArray new];
        
        _orthogonalScrollerSectionControllers = [NSMutableDictionary new];
    }
    return self;
}

- (void)setEnvironment:(id<EaseModuleEnvironment>)environment{
    _environment = environment;
    
    UICollectionView * collectionView = environment.collectionView;
    
    if (_collectionView != environment.collectionView ||
        collectionView.dataSource != self) {
        _collectionView = collectionView;
        
        _registeredCellIdentifiers = [NSMutableSet new];
        _registeredPlaceholdCellIdentifiers = [NSMutableSet new];
        _registeredSupplementaryViewIdentifiers = [NSMutableSet new];

        collectionView.dataSource = self;
        
        [collectionView setCollectionViewLayout:({
            EaseModuleFlowLayout.new;
        }) animated:YES];
//        [collectionView.collectionViewLayout invalidateLayout];
        
        [self _updateCollectionViewDelegate];
    }
}

- (void)setCollectionViewDelegate:(id<UICollectionViewDelegate>)collectionViewDelegate{
    if (_collectionViewDelegate != collectionViewDelegate) {
        _collectionViewDelegate = collectionViewDelegate;
        [self _createProxyAndUpdateCollectionViewDelegate];
    }
}

- (void)setScrollViewDelegate:(id<UIScrollViewDelegate>)scrollViewDelegate{
    if (_scrollViewDelegate != scrollViewDelegate) {
        _scrollViewDelegate = scrollViewDelegate;
        [self _createProxyAndUpdateCollectionViewDelegate];
    }
}

- (void)_createProxyAndUpdateCollectionViewDelegate {
    // there is a known bug with accessibility and using an NSProxy as the delegate that will cause EXC_BAD_ACCESS
    // when voiceover is enabled. it will hold an unsafe ref to the delegate
    _collectionView.delegate = nil;

    self.delegateProxy = [[EaseModuleAdapterProxy alloc]
                          initWithCollectionViewTarget:_collectionViewDelegate
                          scrollViewTarget:_scrollViewDelegate
                          dataSource:self];
    [self _updateCollectionViewDelegate];
}

- (void)_updateCollectionViewDelegate {
    _collectionView.delegate = (id<UICollectionViewDelegate>)self.delegateProxy ?: self;
}

- (UICollectionView *)collectionView {
    return _collectionView;
}

#pragma mark - dequeue

- (__kindof UICollectionViewCell *)dequeueReusableCellOfClass:(Class)cellClass forComponent:(__kindof EaseComponent *)component atIndex:(NSInteger)index{

    if (!cellClass) {
        return nil;
    }
    NSInteger sectionIndex = [self usageHidenWhenMeptyIndexWithComponent:component];
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index inSection:sectionIndex];
    
    NSString * reuseIdentifier = [NSString stringWithFormat:@"Normal-%@",NSStringFromClass(cellClass)];

    // 水平内嵌的
    if (component.isOrthogonallyScrolls) {
        
        EaseOrthogonalScrollerSectionController * sectionController =
        _orthogonalScrollerSectionControllers[@(sectionIndex)];
        
        return [sectionController dequeueReusableCell:cellClass
                                  withReuseIdentifier:reuseIdentifier
                                          atIndexPath:indexPath];
    }
    
    return [self collectionView:self.collectionView
            dequeueReusableCell:self.registeredCellIdentifiers
            withReuseIdentifier:reuseIdentifier
                      cellClass:cellClass
                    atIndexPath:indexPath];
}

- (__kindof UICollectionViewCell *)dequeueReusablePlaceholdCellOfClass:(Class)cellClass forComponent:(__kindof EaseComponent *)component{
    
    if (!cellClass) {
        return nil;
    }
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:0 inSection:({
        [self usageHidenWhenMeptyIndexWithComponent:component];
    })];
    
    NSString * reuseIdentifier = [NSString stringWithFormat:@"Placehold-%@",NSStringFromClass(cellClass)];
    
    return [self collectionView:self.collectionView
            dequeueReusableCell:self.registeredPlaceholdCellIdentifiers
            withReuseIdentifier:reuseIdentifier
                      cellClass:cellClass
                    atIndexPath:indexPath];
}

- (__kindof UICollectionReusableView *)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind
                                                                 forComponent:(__kindof EaseComponent *)component
                                                                        clazz:(Class)viewClass{
    if (!elementKind) {
        return nil;
    }
    UICollectionView *collectionView = self.collectionView;
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:0 inSection:({
        [self usageHidenWhenMeptyIndexWithComponent:component];
    })];
    NSString * reuseIdentifier = [NSString stringWithFormat:@"Supplementary-%@-%@",NSStringFromClass(viewClass),elementKind];
    if (![self.registeredSupplementaryViewIdentifiers containsObject:reuseIdentifier]) {
        [self.registeredSupplementaryViewIdentifiers addObject:reuseIdentifier];
        [collectionView registerClass:viewClass
           forSupplementaryViewOfKind:elementKind
                  withReuseIdentifier:reuseIdentifier];
    }
    return [collectionView dequeueReusableSupplementaryViewOfKind:elementKind
                                              withReuseIdentifier:reuseIdentifier
                                                     forIndexPath:indexPath];
}

- (__kindof UICollectionViewCell *) collectionView:(__kindof UICollectionView *)collectionView dequeueReusableCell:(NSMutableSet *)registeredCellIdentifiers withReuseIdentifier:(NSString *)reuseIdentifier cellClass:(Class)cellClass atIndexPath:(NSIndexPath *)indexPath{
    
    if (![registeredCellIdentifiers containsObject:reuseIdentifier]) {
        [registeredCellIdentifiers addObject:reuseIdentifier];
        [collectionView registerClass:cellClass forCellWithReuseIdentifier:reuseIdentifier];
    }
    return [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
}

- (void) updateHideWhenEmptyComponents{
    __block NSInteger index = 0;
    _hidenWhenEmptyComponents = [_innerComponents ease_select:^BOOL(EaseComponent * component) {
        if ((component.needPlacehold || component.independentDatas) ||
            (!component.hiddenWhenEmpty || component.datas.count != 0)){
            component.index = index;
            index ++;
            return YES;
        }
        return NO;
    }];
}

- (NSArray<__kindof EaseComponent *> *) usageHidenWhenMeptyComponents{
    NSArray * tmp;
    @synchronized (_innerComponents) {
        tmp = [_innerComponents ease_select:^BOOL(EaseComponent * component) {
            if (component.needPlacehold || component.independentDatas) {
                return YES;
            }
            return !component.hiddenWhenEmpty || component.datas.count != 0;
        }];
    }
    return tmp;
}

- (__kindof EaseComponent *) usageHidenWhenMeptyComponentAtIndex:(NSInteger)index{
    NSArray * tmp = [self usageHidenWhenMeptyComponents];
    EaseComponent * component;
    if (index < tmp.count) {
        component = [self usageHidenWhenMeptyComponents][index];
    }
    return component;
}

- (NSInteger) usageHidenWhenMeptyIndexWithComponent:(__kindof EaseComponent *)component{
    NSArray * tmp = [self usageHidenWhenMeptyComponents];
    return [tmp indexOfObject:component];
}

- (BOOL) canForwardMethodToCollectionViewDelegate:(SEL)sel{
    return [self.collectionViewDelegate respondsToSelector:sel];
}

@end

@implementation EaseModuleDataSource (ComponentsHandle)

- (void)clear{
    
    @synchronized (_innerComponents) {
        [_innerComponents ease_each:^(__kindof EaseComponent * component) {
            [component clear];
        }];
        [_innerComponents removeAllObjects];
        [self updateHideWhenEmptyComponents];
    }
}
- (void) clearExceptComponents:(NSArray<__kindof EaseComponent *> *)components{
    @synchronized (_innerComponents) {
        
        NSPredicate * pred = [NSPredicate predicateWithFormat:@"NOT SELF IN %@",_innerComponents];
    
        [_innerComponents removeObjectsInArray:[[components filteredArrayUsingPredicate:pred] ease_map:^id(__kindof EaseComponent * component) {
            [component clear];
            return component;
        }]];
        
        [self updateHideWhenEmptyComponents];
    }
}

- (void) addComponent:(__kindof EaseComponent *)component{
    if (!component) {
        return;
    }
    @synchronized (_innerComponents) {
        component.dataSource = self;
        component.environment = self.environment;
        // component 计算自己的layout
        [component calculatorLayout];
        [_innerComponents addObject:component];
        [self updateHideWhenEmptyComponents];
    }
}

- (void) addComponents:(NSArray<__kindof EaseComponent *> *)components{
    [components enumerateObjectsUsingBlock:^(__kindof EaseComponent * component, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addComponent:component];
    }];
}

- (void) insertComponent:(__kindof EaseComponent *)component atIndex:(NSInteger)index{
    @synchronized (_innerComponents) {
        if (index < _innerComponents.count && index >= 0) {
            component.dataSource = self;
            component.environment = self.environment;
            // component 计算自己的layout
            [component calculatorLayout];
            [_innerComponents insertObject:component atIndex:index];
            [self updateHideWhenEmptyComponents];
        }
    }
}

- (void) removeComponent:(__kindof EaseComponent *)component{
    @synchronized (_innerComponents) {
        if ([_innerComponents containsObject:component]) {
            [component clear];
            [_innerComponents removeObject:component];
            [self updateHideWhenEmptyComponents];
        }
    }
}

- (void) removeComponentAtIndex:(NSInteger)index{
    @synchronized (_innerComponents) {
        if (index < _innerComponents.count && index >= 0) {
            EaseComponent * component = _innerComponents[index];
            [component clear];
            [_innerComponents removeObject:component];
            [self updateHideWhenEmptyComponents];
        }
    }
}

- (void) replaceComponent:(__kindof EaseComponent *)component atIndex:(NSInteger)index{
    @synchronized (_innerComponents) {
        if (index < _innerComponents.count) {
            component.dataSource = self;
            component.environment = self.environment;
            // component 计算自己的layout
            [_innerComponents replaceObjectAtIndex:index withObject:component];
            [self updateHideWhenEmptyComponents];
        }
    }
}

- (__kindof EaseComponent *) componentAtIndex:(NSInteger)index{
    __kindof EaseComponent * compontent;
    @synchronized (_innerComponents) {
        if (index < _innerComponents.count) {
            compontent = _innerComponents[index];
        }
    }
    return compontent;
}

- (NSInteger) indexOfComponent:(__kindof EaseComponent *)comp{
    NSInteger index = NSNotFound;
    @synchronized (_hidenWhenEmptyComponents) {
        index = [_hidenWhenEmptyComponents indexOfObject:comp];
    }
    return index;
}

- (NSArray<__kindof EaseComponent *> *) components{
    
    NSArray * components;
    @synchronized (_hidenWhenEmptyComponents) {
        components = [_hidenWhenEmptyComponents ease_select:^BOOL(__kindof EaseComponent * component) {
            return YES;//!component.empty;
        }];
    }
    return components;
}

- (NSInteger) count{
    NSInteger count = 0;
    @synchronized (_hidenWhenEmptyComponents) {
        count = _hidenWhenEmptyComponents.count;
    }
    return count;
}

- (BOOL)empty{
    BOOL isEmpty = NO;
    @synchronized (_innerComponents) {
//        isEmpty = [_innerComponents ease_any:^BOOL(__kindof EaseComponent * comp) {
//            return !comp.empty;
//        }];
    }
    return isEmpty;
}

@end

#pragma mark - UICollectionViewDataSource

@implementation EaseModuleDataSource (UICollectionViewDataSource)

- (BOOL) targetWasOrthogonalScrollView:(UICollectionView *)collectionView{
    return [collectionView isKindOfClass:[EaseOrthogonalScrollerEmbeddedScrollView class]];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _hidenWhenEmptyComponents.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    __kindof EaseComponent * component = [self usageHidenWhenMeptyComponentAtIndex:section];
    if (component.independentDatas ||
        (0 == component.datas.count && component.needPlacehold) ||
        (component.isOrthogonallyScrolls && ![self targetWasOrthogonalScrollView:collectionView])) {
        return 1;
    }
    return component.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    UICollectionViewCell * cell;
    __kindof EaseComponent * comp = [self usageHidenWhenMeptyComponentAtIndex:indexPath.section];
    
    if (comp.needPlacehold && comp.dataCount == 0) {
        cell = [comp placeholdCellForItemAtIndex:indexPath.item];
    } else {
        if (comp.isOrthogonallyScrolls) {
            
            if ([self targetWasOrthogonalScrollView:collectionView]) {
                //
                cell = [comp cellForItemAtIndex:indexPath.item];
            } else {
                
                EaseOrthogonalScrollerEmbeddedCCell * ccell = [self collectionView:self.collectionView dequeueReusableCell:({
                    self.registeredCellIdentifiers;
                }) withReuseIdentifier:({
                    EaseOrthogonalScrollerEmbeddedCCell.reuseIdentifier;
                }) cellClass:({
                    EaseOrthogonalScrollerEmbeddedCCell.class;
                }) atIndexPath:indexPath];

                EaseOrthogonalScrollerSectionController * sectionController;
                sectionController = _orthogonalScrollerSectionControllers[@(indexPath.section)];
                
                EaseOrthogonalScrollerEmbeddedScrollView * scrollView;
                scrollView = ccell.orthogonalScrollView;
    
                sectionController = [[EaseOrthogonalScrollerSectionController alloc] initWithSectionIndex:indexPath.section collectionView:self.collectionView scrollView:scrollView];
                switch (comp.layout.horizontalScrollingBehavior) {
                    case EaseLayoutHorizontalScrollingBehaviorNone:
                    case EaseLayoutHorizontalScrollingBehaviorContinuous:
                        scrollView.pagingEnabled = NO;
                        scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
                        break;
                    case EaseLayoutHorizontalScrollingBehaviorPaging:
                        scrollView.pagingEnabled = YES;
                        scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
                        break;
                    case EaseLayoutHorizontalScrollingBehaviorItemPaging:
                        scrollView.pagingEnabled = NO;
                        scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
                        break;
                    case EaseLayoutHorizontalScrollingBehaviorCentered:
                        scrollView.pagingEnabled = NO;
                        scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
                        break;
                }
                _orthogonalScrollerSectionControllers[@(indexPath.section)] = sectionController;
                
                cell = ccell;
            }
        } else {
            cell = [comp cellForItemAtIndex:indexPath.item];
        }
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    __kindof EaseComponent * comp = [self usageHidenWhenMeptyComponentAtIndex:indexPath.section];
    if ([comp.supportedElementKinds containsObject:kind]) {
        return [comp viewForSupplementaryElementOfKind:kind];
    }
    return nil;
}

@end

#pragma mark - UICollectionViewDelegateFlowLayout

@implementation EaseModuleDataSource (UICollectionViewDelegateFlowLayout)

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    /// component & layout
//    __kindof EaseComponent * component = [self usageHidenWhenMeptyComponentAtIndex:indexPath.section];
//    CGSize itemSize = [component.layout itemSizeAtIndex:indexPath.item];
//    if (component.isOrthogonallyScrolls &&
//        ![self targetWasOrthogonalScrollView:collectionView]) {
//        // 内嵌的效果需要将height修改一下，这样就可以完成垂直多个cell的效果了
//        itemSize = (CGSize){
//            component.layout.insetContainerWidth,
//            itemSize.height
//        };
//    }
//    return itemSize;
//}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    /// layout
//    return [self usageHidenWhenMeptyComponentAtIndex:section].layout.lineSpacing;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    /// layout
//    return [self usageHidenWhenMeptyComponentAtIndex:section].layout.interitemSpacing;
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    /// layout
//    return [self usageHidenWhenMeptyComponentAtIndex:section].layout.insets;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    /// component
//    __kindof EaseComponent * comp = [self usageHidenWhenMeptyComponentAtIndex:section];
//    if ([comp.supportedElementKinds containsObject:UICollectionElementKindSectionHeader]) {
//        return [comp sizeForSupplementaryViewOfKind:({
//            UICollectionElementKindSectionHeader;
//        })];
//    }
//    return CGSizeZero;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
//    /// component
//    __kindof EaseComponent * comp = [self usageHidenWhenMeptyComponentAtIndex:section];
//    if ([comp.supportedElementKinds containsObject:UICollectionElementKindSectionFooter]) {
//        return [comp sizeForSupplementaryViewOfKind:({
//            UICollectionElementKindSectionFooter;
//        })];
//    }
//    return CGSizeZero;
//}

@end

@implementation EaseModuleDataSource (CHTCollectionViewDelegateWaterfallLayout)

- (EaseComponent *) collectionView:(UICollectionView *)collectionView layout:(EaseModuleFlowLayout *)collectionViewLayout componentAtSection:(NSInteger)section{
    return [self usageHidenWhenMeptyComponentAtIndex:section];
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//}

//- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout columnCountForSection:(NSInteger)section{
//    __kindof EaseComponent * comp = [self usageHidenWhenMeptyComponentAtIndex:section];
//    if (comp.layout.distribution.isFractional ||
//        comp.layout.distribution.isAbsolute) {
//        return 1;
//    }
//    return comp.layout.distribution.value;
//}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section{
//    return [self collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section].height;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section{
//    return [self collectionView:collectionView layout:collectionViewLayout referenceSizeForFooterInSection:section].height;
//}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsZero;;
//}


//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForHeaderInSection:(NSInteger)section{
//    return UIEdgeInsetsMake(0, 5, 0, 5);;
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForFooterInSection:(NSInteger)section{
//    return UIEdgeInsetsMake(0, 5, 0, 5);;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    return 1;;
//}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumColumnSpacingForSectionAtIndex:(NSInteger)section{
//    return [self collectionView:collectionView layout:collectionViewLayout minimumLineSpacingForSectionAtIndex:section];
//}

@end

#pragma mark - UICollectionViewDelegate

@implementation EaseModuleDataSource (UICollectionViewDelegate)

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    __kindof EaseComponent * comp = (__kindof EaseComponent *)[self usageHidenWhenMeptyComponentAtIndex:indexPath.section];
    if (comp.independentDatas) {
        return;
    }
    if ([self canForwardMethodToCollectionViewDelegate:_cmd]) {
        [self.collectionViewDelegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
    [comp didSelectItemAtIndex:indexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    __kindof EaseComponent * comp = (__kindof EaseComponent *)[self usageHidenWhenMeptyComponentAtIndex:indexPath.section];
    if (comp.independentDatas) {
        return;
    }
    if ([self canForwardMethodToCollectionViewDelegate:_cmd]) {
        [self.collectionViewDelegate collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
    }
    [comp didDeselectItemAtIndex:indexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    __kindof EaseComponent * comp = (__kindof EaseComponent *)[self usageHidenWhenMeptyComponentAtIndex:indexPath.section];
    if (comp.independentDatas) {
        return;
    }
    if ([self canForwardMethodToCollectionViewDelegate:_cmd]) {
        [self.collectionViewDelegate collectionView:collectionView didHighlightItemAtIndexPath:indexPath];
    }
    [comp didHighlightItemAtIndex:indexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    __kindof EaseComponent * comp = (__kindof EaseComponent *)[self usageHidenWhenMeptyComponentAtIndex:indexPath.section];
    if (comp.independentDatas) {
        return;
    }
    if ([self canForwardMethodToCollectionViewDelegate:_cmd]) {
        [self.collectionViewDelegate collectionView:collectionView didUnhighlightItemAtIndexPath:indexPath];
    }
    [comp didUnhighlightItemAtIndex:indexPath.item];
}

@end

@implementation NSArray (Ease)

- (NSArray *) ease_select:(BOOL (^)(id obj))handle{
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return handle(evaluatedObject);
    }]];
}

- (void) ease_each:(void (^)(id))handle{
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        handle(obj);
    }];
}

- (NSArray *) ease_map:(id (^)(id))handle{
    
    NSMutableArray * _self = [NSMutableArray arrayWithCapacity:self.count];
    @autoreleasepool{
        for (id obj in self) {
            [_self addObject:handle(obj) ? : [NSNull null]];
        }
    }
    return [_self copy];
}

@end
