//
//  EaseModuleFlowLayout.m
//  EaseModule
//
//  Created by rocky on 2020/8/8.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "EaseModuleFlowLayout.h"
#import "EaseDecorateSectionLayoutAttributes.h"
#import "EaseComponent_Private.h"
#import "EaseBaseLayout_Private.h"

@interface EaseModuleFlowLayout ()

@property (nonatomic, strong) NSMutableArray *columnHeights;
@property (nonatomic, strong) NSMutableArray *itemHeights;

@property (nonatomic, strong) NSMutableArray<NSNumber *> *sectionHeights;

/// Array to store attributes for all items includes headers, cells, and footers
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> * allItemAttributes;
/// Array of arrays. Each array stores item attributes for each section
@property (nonatomic, strong) NSMutableArray<NSMutableArray<UICollectionViewLayoutAttributes *> *> *sectionItemAttributes;
@property (nonatomic ,strong) NSMutableDictionary * decorateViewAttributes;
/// Dictionary to store section headers' attribute
@property (nonatomic, strong) NSMutableDictionary *headersAttribute;
/// Dictionary to store section footers' attribute
@property (nonatomic, strong) NSMutableDictionary *footersAttribute;

/// Array to store union rectangles
@property (nonatomic, strong) NSMutableArray *unionRects;

/// pin
@property (nonatomic ,assign) BOOL hasPinnedSupplementaryItems;
@property (nonatomic, strong) NSMutableArray *layoutAttributesForPinnedSupplementaryItems;

@end

@implementation EaseModuleFlowLayout

/// How many items to be union into a single rectangle
static const NSInteger unionSize = 50;
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registerClass:[EaseDecorateSectionView class]
    forDecorationViewOfKind:@"EaseDecorateSectionView"];
    }
    return self;
}

- (void) resetState {
    
    self.hasPinnedSupplementaryItems = NO;
    [self.layoutAttributesForPinnedSupplementaryItems removeAllObjects];
    
    // clear datas
    [self.unionRects removeAllObjects];
    [self.columnHeights removeAllObjects];
    [self.sectionHeights removeAllObjects];
    [self.itemHeights removeAllObjects];
    [self.allItemAttributes removeAllObjects];
    [self.headersAttribute removeAllObjects];
    [self.sectionItemAttributes removeAllObjects];
    [self.footersAttribute removeAllObjects];
    [self.decorateViewAttributes removeAllObjects];
}

#pragma mark - override

- (void)prepareLayout {
    [super prepareLayout];

    UICollectionView *collectionView = self.collectionView;
    if (!collectionView) {
        return;
    }
    CGRect collectionViewBounds = collectionView.bounds;
    if (CGRectIsEmpty(collectionViewBounds)) {
        return;
    }
    
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    if (numberOfSections == 0) {
        // for safe
        return;
    }

    [self resetState];
    
    CGFloat collectionViewWidth = collectionViewBounds.size.width;
    
    UICollectionViewLayoutAttributes *attributes;

    CGFloat top = 0;
    for (NSInteger section = 0; section < numberOfSections; ++section) {
     
        EaseComponent * component;
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:componentAtSection:)]) {
            component = [self.delegate collectionView:collectionView layout:self componentAtSection:section];
        }
        
        EaseBaseLayout * layout = component.layout;
        UIEdgeInsets sectionInset = layout.inset;
        
        NSArray * supportedKinds = [component supportedElementKinds];
        CGFloat headerHeight = 0.0f;
        // header
        if ([supportedKinds containsObject:UICollectionElementKindSectionHeader] &&
            self.scrollDirection != UICollectionViewScrollDirectionHorizontal) {
            headerHeight =
            [component sizeForSupplementaryViewOfKind:UICollectionElementKindSectionHeader].height;
            if (headerHeight > 0) {
                UIEdgeInsets headerInset =
                [component insetForSupplementaryViewOfKind:UICollectionElementKindSectionHeader];
                attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
                attributes.frame = (CGRect){
                    headerInset.left,
                    headerInset.top + top,
                    collectionViewWidth - (headerInset.left + headerInset.right),
                    headerHeight
                };
                
                if (component.headerPin) {
                    self.hasPinnedSupplementaryItems = YES;
                    attributes.zIndex = 1;
                    [self.layoutAttributesForPinnedSupplementaryItems addObject:@{
                       @"section":@(section),
                       @"attributes":attributes
                    }];
                }
                self.headersAttribute[@(section)] = attributes;
                [self.allItemAttributes addObject:attributes];
                
                // 更新top
                top = CGRectGetMaxY(attributes.frame) + headerInset.bottom;
            }
        }
        if (!component.empty) {
            top += sectionInset.top;
        }
        
        // items
        NSInteger itemCount = [collectionView numberOfItemsInSection:section];
        NSMutableArray * itemAttributes = [NSMutableArray new];
        
        BOOL currentCompWasEmptyAndNeedPlacehold =
        component.dataCount == 0 &&
        component.needPlacehold &&
        (component.placeholdHeight > 0);
        
        if (component.isOrthogonallyScrolls &&
            self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            if (!currentCompWasEmptyAndNeedPlacehold) {
                CGRect frame = CGRectZero;
                frame.origin.y = top;
                frame.origin.x = layout.inset.left;
                frame.size.width = layout.insetContainerWidth;
                frame.size.height = layout.horizontalArrangeContentHeight;
                attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:({
                    [NSIndexPath indexPathForItem:0 inSection:section];
                })];
                attributes.frame = frame;
                [itemAttributes addObject:attributes];
                [self.allItemAttributes addObject:attributes];
            }
        } else {
            for (NSInteger item = 0; item < itemCount; item++) {
                CGRect frame = [layout itemFrameAtIndex:item];
                frame.origin.y += ({
                    (self.scrollDirection == UICollectionViewScrollDirectionHorizontal ?
                    0 : top);
                });
                attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:({
                    [NSIndexPath indexPathForItem:item inSection:section];
                })];
                attributes.frame = frame;
                [itemAttributes addObject:attributes];
                [self.allItemAttributes addObject:attributes];
            }
        }
        if (currentCompWasEmptyAndNeedPlacehold) {
            
            attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:({
                [NSIndexPath indexPathForItem:0 inSection:section];
            })];
            attributes.frame = (CGRect){
                layout.inset.left, top,
                layout.insetContainerWidth,
                component.placeholdHeight
            };
            [itemAttributes addObject:attributes];
            [self.allItemAttributes addObject:attributes];
            top += component.placeholdHeight;
        }
        [self.sectionItemAttributes addObject:itemAttributes];
        
        if (!component.empty && !currentCompWasEmptyAndNeedPlacehold) {
            top += layout.contentHeight;
            top += layout.inset.bottom;
        }
        
        // footer
        CGFloat footerHeight = 0.0f;
        if ([supportedKinds containsObject:UICollectionElementKindSectionFooter] &&
            self.scrollDirection != UICollectionViewScrollDirectionHorizontal) {
            footerHeight =
            [component sizeForSupplementaryViewOfKind:UICollectionElementKindSectionFooter].height;
            if (footerHeight > 0) {
                UIEdgeInsets footerInset =
                [component insetForSupplementaryViewOfKind:UICollectionElementKindSectionFooter];
                attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
                attributes.frame = (CGRect){
                    footerInset.left,
                    footerInset.top + top,
                    collectionViewWidth - (footerInset.left + footerInset.right),
                    footerHeight
                };
                
                self.footersAttribute[@(section)] = attributes;
                [self.allItemAttributes addObject:attributes];
                
                // 更新top
                top = CGRectGetMaxY(attributes.frame) + footerInset.bottom;
            }
        }
        
        EaseComponentDecorateBuilder * builder = component.decorateBuilder;
        if (builder &&
            builder.decorate != EaseComponentDecorateNone &&
            self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            CGFloat y = 0;
            if (self.sectionHeights.count) {
                y = self.sectionHeights[self.sectionHeights.count - 1].floatValue;
            }
            CGFloat height = top - y;
            if (builder.decorate == EaseComponentDecorateOnlyItem) {
                y += headerHeight;
                height -= (footerHeight + headerHeight);
            } else if (builder.decorate == EaseComponentDecorateContainHeader) {
                height -= footerHeight;
            } else if (builder.decorate == EaseComponentDecorateContainFooter) {
                y += headerHeight;
                height -= headerHeight;
            }
            
            EaseDecorateSectionLayoutAttributes * attr =
            [EaseDecorateSectionLayoutAttributes layoutAttributesForDecorationViewOfKind:@"EaseDecorateSectionView" withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            attr.frame = [self calculatfDecorationViewFrame:sectionInset
                                               sectionFrame:CGRectMake(0, y, collectionViewWidth, height)
                                              decorateInset:builder.inset];
            attr.zIndex = -1;
            attr.builder = builder;
            self.decorateViewAttributes[@(section)] = attr;
            [self.allItemAttributes addObject:attr];
        }
        
        [self.sectionHeights addObject:@(top)];

    }
    
    // Build union rects
    NSInteger idx = 0;
    NSInteger itemCounts = [self.allItemAttributes count];
    while (idx < itemCounts) {
        CGRect unionRect = ((UICollectionViewLayoutAttributes *)self.allItemAttributes[idx]).frame;
        NSInteger rectEndIndex = MIN(idx + unionSize, itemCounts);

        for (NSInteger i = idx + 1; i < rectEndIndex; i++) {
            unionRect = CGRectUnion(unionRect, ((UICollectionViewLayoutAttributes *)self.allItemAttributes[i]).frame);
        }

        idx = rectEndIndex;

        [self.unionRects addObject:[NSValue valueWithCGRect:unionRect]];
    }
}

- (CGSize)collectionViewContentSize {
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    if (numberOfSections == 0) {
        return CGSizeZero;
    }
    
    CGSize contentSize = self.collectionView.bounds.size;
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        contentSize.height = self.sectionHeights.lastObject.floatValue;
    } else {
        // 水平布局的时候，就只会有一个section，这里先这么获取数据，不是很优雅
        EaseBaseLayout * layout = [self.delegate collectionView:({
            self.collectionView;
        }) layout:self componentAtSection:0].layout;
        contentSize.width = layout.contentWidth;
    }
    return contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path {
    if (path.section >= [self.sectionItemAttributes count]) {
        return nil;
    }
    if (path.item >= [self.sectionItemAttributes[path.section] count]) {
        return nil;
    }
    return (self.sectionItemAttributes[path.section])[path.item];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        attribute = self.headersAttribute[@(indexPath.section)];
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        attribute = self.footersAttribute[@(indexPath.section)];
    }
    return attribute;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attribute = nil;
    if ([elementKind isEqualToString:@"EaseDecorateSectionView"]) {
        attribute = self.decorateViewAttributes[@(indexPath.section)];
    }
    return attribute;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSInteger i;
    NSInteger begin = 0, end = self.unionRects.count;
    NSMutableDictionary *cellAttrDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *supplHeaderAttrDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *supplFooterAttrDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *decorAttrDict = [NSMutableDictionary dictionary];
    
    for (i = 0; i < self.unionRects.count; i++) {
        if (CGRectIntersectsRect(rect, [self.unionRects[i] CGRectValue])) {
            begin = i * unionSize;
            break;
        }
    }
    for (i = self.unionRects.count - 1; i >= 0; i--) {
        if (CGRectIntersectsRect(rect, [self.unionRects[i] CGRectValue])) {
            end = MIN((i + 1) * unionSize, self.allItemAttributes.count);
            break;
        }
    }
    for (i = begin; i < end; i++) {
        UICollectionViewLayoutAttributes *attr = self.allItemAttributes[i];
        
        if (!CGRectIntersectsRect(rect, attr.frame)) {
            continue;
        }
        UICollectionElementCategory elementCategory = attr.representedElementCategory;
        if (elementCategory == UICollectionElementCategorySupplementaryView) {
            if ([attr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
                supplHeaderAttrDict[attr.indexPath] = attr;
            } else if ([attr.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]) {
                supplFooterAttrDict[attr.indexPath] = attr;
            }
        } else if (elementCategory == UICollectionElementCategoryDecorationView) {
            decorAttrDict[attr.indexPath] = attr;
        } else {
            cellAttrDict[attr.indexPath] = attr;
        }
    }
    
    // 黏性header
    for (NSInteger pinnedIndex = 0;
         pinnedIndex < self.layoutAttributesForPinnedSupplementaryItems.count;
         pinnedIndex++) {
        
        CGPoint contentOffset = self.collectionView.contentOffset;
        NSDictionary * pinnedSupplementaryData = self.layoutAttributesForPinnedSupplementaryItems[pinnedIndex];
        UICollectionViewLayoutAttributes *attributes = pinnedSupplementaryData[@"attributes"];
        NSInteger sectionIndex = [pinnedSupplementaryData[@"section"] integerValue];
        
        CGFloat currentSectionHeight =
        self.sectionHeights[sectionIndex].floatValue -
        (sectionIndex == 0 ? 0 : self.sectionHeights[sectionIndex - 1].floatValue);
        CGRect sectionFrame = attributes.frame;
        sectionFrame.size.height = currentSectionHeight;
        
        if (!CGRectIntersectsRect(sectionFrame, rect)) {
            continue;
        }
        
        if (@available(iOS 11.0, *)) {
            if ([self.collectionView respondsToSelector:@selector(safeAreaInsets)]) {
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    contentOffset.y += self.collectionView.safeAreaInsets.top;
                }
            }
        }
        CGRect frame = attributes.frame;
        CGFloat sectionBottomY = [self.sectionHeights[sectionIndex] floatValue] - CGRectGetHeight(frame);
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            CGFloat targetY = 0.0f;
            NSInteger condition = 0;
            if (contentOffset.y <= frame.origin.y) {
                targetY = frame.origin.y;
                condition = 1;
            } else if (contentOffset.y < sectionBottomY) {
                targetY = contentOffset.y;
                condition = 2;
            } else {
                targetY = sectionBottomY;
                condition = 3;
            }
            frame.origin.y = MIN(MAX(contentOffset.y, frame.origin.y), sectionBottomY);
            NSLog(@"condition %d sectionBottomY:%.0f frame:%.0f contentOffset:%.0f targetY:%.0f ",condition,sectionBottomY,frame.origin.y,contentOffset.y,targetY);
//            frame.origin.y = targetY;
        }
//        NSLog(@"[layout] targetY:%.0f",frame.origin.y);
        
        attributes.frame = frame;
    }
    
    NSArray *result = [cellAttrDict.allValues arrayByAddingObjectsFromArray:supplHeaderAttrDict.allValues];
    result = [result arrayByAddingObjectsFromArray:supplFooterAttrDict.allValues];
    result = [result arrayByAddingObjectsFromArray:decorAttrDict.allValues];
    return result;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    if (!self.collectionView) {
        return NO;
    }
    if (self.hasPinnedSupplementaryItems) {
        return YES;
    }
    return !CGSizeEqualToSize(newBounds.size, self.collectionView.bounds.size);
}
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    CGPoint targetPoint = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    return targetPoint;
    // TODO
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        return targetPoint;
    }
    
    EaseLayoutHorizontalScrollingBehavior orthogonalScrollingBehavior =
//    EaseLayoutHorizontalScrollingBehaviorContinuous;
//    EaseLayoutHorizontalScrollingBehaviorPaging;
    EaseLayoutHorizontalScrollingBehaviorItemPaging;
//    EaseLayoutHorizontalScrollingBehaviorCentered;

    if (orthogonalScrollingBehavior == EaseLayoutHorizontalScrollingBehaviorPaging) {
        return targetPoint;
    }
    //    IBPCollectionCompositionalLayoutSolver *solver = solvers.lastObject;
    CGPoint contentOffset = CGPointZero;
    
    CGRect layoutFrame;// = solver.layoutFrame;
    CGFloat interGroupSpacing = 10.0f;//solver.layoutSection.interGroupSpacing;
    
    CGFloat width = 300;//CGRectGetWidth(layoutFrame);// cell的宽度
    CGFloat height = self.collectionView.bounds.size.height;//CGRectGetHeight(layoutFrame);

    CGSize containerSize = self.collectionView.bounds.size;
    CGPoint translation = [self.collectionView.panGestureRecognizer translationInView:self.collectionView.superview];
    
    if (orthogonalScrollingBehavior == EaseLayoutHorizontalScrollingBehaviorContinuous) {
        contentOffset.x += width * floor(proposedContentOffset.x / width) + interGroupSpacing * floor(proposedContentOffset.x / width) + width * (translation.x < 0 ? 1 : 0);
    }
    if (orthogonalScrollingBehavior == EaseLayoutHorizontalScrollingBehaviorItemPaging) {
        if (fabs(velocity.x) > 0.2) {
            translation.x = width / 2 * (translation.x < 0 ? -1 : 1);
        }
        contentOffset.x += width * round((proposedContentOffset.x + translation.x) / width);
        contentOffset.y += height * round((proposedContentOffset.y + translation.y) / height);
        
        contentOffset.x += width * round(-translation.x / (width / 2)) + interGroupSpacing * round(-translation.x / (width / 2));
    }
    if (orthogonalScrollingBehavior == EaseLayoutHorizontalScrollingBehaviorCentered) {
        if (fabs(velocity.x) > 0.2) {
            translation.x = width / 2 * (translation.x < 0 ? -1 : 1);
        }
        contentOffset.x += width * round((proposedContentOffset.x + translation.x) / width);
        contentOffset.y += height * round((proposedContentOffset.y + translation.y) / height);
        
        contentOffset.x += width * round(-translation.x / (width / 2)) + interGroupSpacing * round(-translation.x / (width / 2)) - (containerSize.width - width) / 2;
    }
    return [super targetContentOffsetForProposedContentOffset:contentOffset withScrollingVelocity:velocity];;
}
//
//- (CGPoint)orthogonalContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
//                                         scrollingVelocity:(CGPoint)velocity {
//    IBPCollectionCompositionalLayoutSolver *solver = solvers.lastObject;
//    CGPoint contentOffset = CGPointZero;
//
//    CGRect layoutFrame = solver.layoutFrame;
//    CGFloat interGroupSpacing = solver.layoutSection.interGroupSpacing;
//
//    CGFloat width = CGRectGetWidth(layoutFrame);
//    CGFloat height = CGRectGetHeight(layoutFrame);
//
//    CGSize containerSize = self.collectionView.bounds.size;
//    CGPoint translation = [self.collectionView.panGestureRecognizer translationInView:self.collectionView.superview];
//
//    UICollectionViewScrollDirection scrollDirection = self.scrollDirection;
//    IBPUICollectionLayoutSectionOrthogonalScrollingBehavior orthogonalScrollingBehavior = self.containerSection.orthogonalScrollingBehavior;
//
//    if (orthogonalScrollingBehavior == IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorContinuousGroupLeadingBoundary) {
//        if (scrollDirection == UICollectionViewScrollDirectionHorizontal) {
//            contentOffset.x += width * floor(proposedContentOffset.x / width) + interGroupSpacing * floor(proposedContentOffset.x / width) + width * (translation.x < 0 ? 1 : 0);
//            return contentOffset;
//        }
//    }
//    if (orthogonalScrollingBehavior == IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorGroupPaging) {
//        if (fabs(velocity.x) > 0.2) {
//            translation.x = width / 2 * (translation.x < 0 ? -1 : 1);
//        }
//        contentOffset.x += width * round((proposedContentOffset.x + translation.x) / width);
//        contentOffset.y += height * round((proposedContentOffset.y + translation.y) / height);
//
//        if (scrollDirection == UICollectionViewScrollDirectionHorizontal) {
//            contentOffset.x += width * round(-translation.x / (width / 2)) + interGroupSpacing * round(-translation.x / (width / 2));
//            return contentOffset;
//        }
//    }
//    if (orthogonalScrollingBehavior == IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorGroupPagingCentered) {
//        if (fabs(velocity.x) > 0.2) {
//            translation.x = width / 2 * (translation.x < 0 ? -1 : 1);
//        }
//        contentOffset.x += width * round((proposedContentOffset.x + translation.x) / width);
//        contentOffset.y += height * round((proposedContentOffset.y + translation.y) / height);
//
//        if (scrollDirection == UICollectionViewScrollDirectionHorizontal) {
//            contentOffset.x += width * round(-translation.x / (width / 2)) + interGroupSpacing * round(-translation.x / (width / 2)) - (containerSize.width - width) / 2;
//            return contentOffset;
//        }
//    }
//
//    return [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
//}
#pragma mark - Private Methods

- (CGRect) calculatfDecorationViewFrame:(UIEdgeInsets)sectionInset sectionFrame:(CGRect)sectionFrame decorateInset:(UIEdgeInsets)decorateInset{

    CGRect decorateViewFrame = sectionFrame;
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        decorateViewFrame.origin.x = sectionFrame.origin.x - (sectionInset.left - decorateInset.left);
        decorateViewFrame.origin.y -= (sectionInset.top - decorateInset.top);
        decorateViewFrame.size.width += (sectionInset.left - decorateInset.left) +
        (sectionInset.right - decorateInset.right);
        decorateViewFrame.size.height = sectionFrame.size.height + sectionInset.top + sectionInset.bottom - decorateInset.top - decorateInset.bottom;
    } else {
        decorateViewFrame.origin.x = sectionInset.left + decorateInset.left;
        decorateViewFrame.origin.y += (decorateInset.top);
        decorateViewFrame.size.width = sectionFrame.size.width - decorateInset.left - decorateInset.right - sectionInset.left - sectionInset.right;
        decorateViewFrame.size.height += (- decorateInset.top - decorateInset.bottom);
    }
    return decorateViewFrame;
}

#pragma mark - Private Accessors

- (NSMutableArray *)unionRects {
    if (!_unionRects) {
        _unionRects = [NSMutableArray array];
    }
    return _unionRects;
}

- (NSMutableArray *)columnHeights {
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

- (NSMutableArray *)itemHeights {
    if (!_itemHeights) {
        _itemHeights = [NSMutableArray array];
    }
    return _itemHeights;
}

- (NSMutableArray *)sectionHeights {
    if (!_sectionHeights) {
        _sectionHeights = [NSMutableArray array];
    }
    return _sectionHeights;
}

- (NSMutableArray *)allItemAttributes {
    if (!_allItemAttributes) {
        _allItemAttributes = [NSMutableArray array];
    }
    return _allItemAttributes;
}

- (NSMutableArray *)sectionItemAttributes {
    if (!_sectionItemAttributes) {
        _sectionItemAttributes = [NSMutableArray array];
    }
    return _sectionItemAttributes;
}

- (NSMutableDictionary *)decorateViewAttributes{
    if (!_decorateViewAttributes) {
        _decorateViewAttributes = [NSMutableDictionary new];
    }
    return _decorateViewAttributes;
}

- (NSMutableDictionary *)headersAttribute {
    if (!_headersAttribute) {
        _headersAttribute = [NSMutableDictionary dictionary];
    }
    return _headersAttribute;
}

- (NSMutableDictionary *)footersAttribute {
    if (!_footersAttribute) {
        _footersAttribute = [NSMutableDictionary dictionary];
    }
    return _footersAttribute;
}

- (NSMutableArray *)layoutAttributesForPinnedSupplementaryItems{
    if (!_layoutAttributesForPinnedSupplementaryItems) {
        _layoutAttributesForPinnedSupplementaryItems = [NSMutableArray new];
    }
    return _layoutAttributesForPinnedSupplementaryItems;
}

- (id <EaseModuleFlowLayout> )delegate {
    return (id <EaseModuleFlowLayout> )self.collectionView.delegate;
}
@end
