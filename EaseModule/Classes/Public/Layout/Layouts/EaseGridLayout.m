//
//  EaseGridLayout.m
//  EaseModule
//
//  Created by rocky on 2020/8/12.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "EaseGridLayout.h"

@interface EaseGridLayout ()

@property (nonatomic ,copy) NSMutableArray<EaseGridLayoutRow *> * rows;
@end

@implementation EaseGridLayout

- (void) addRows:(NSArray<EaseGridLayoutRow *> *)rows{
    [self.rows addObjectsFromArray:rows];
}

- (void) addRow:(EaseGridLayoutRow *)row repeat:(NSInteger)reapeat{
    for (NSInteger index = 0; index < reapeat; index ++) {
        [self.rows addObject:row];
    }
}
- (void)setupAreas:(NSString *)areas{
    
}
#pragma mark - calculator Horizontal

- (void) calculatorHorizontalLayoutWithDatas:(NSArray *)datas{
}

#pragma mark - calculator Vertical

- (void) calculatorVerticalLayoutWithDatas:(NSArray *)datas{
}
@end

@implementation EaseGridLayoutRow

@end


@implementation EaseGridLayoutColumn


@end

@implementation EaseGridLayoutAreas


@end
