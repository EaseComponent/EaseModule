//
//  EaseGridLayout.h
//  EaseModule
//
//  Created by rocky on 2020/8/12.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "EaseBaseLayout.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, EaseGridLayoutRowRepeat) {
    /*
     根据设置的所有areas重复
     */
    EaseGridLayoutRowRepeatAll =       0,
    /*
     根据最后一行的areas重复
     */
    EaseGridLayoutRowRepeatLastRow =        1,
} NS_SWIFT_NAME(EaseGridLayout.RowRepeat);

@interface EaseGridLayoutColumn : NSObject
/*
 
 */
+ (instancetype)fractionalDimension:(NSInteger)value NS_SWIFT_NAME(fractional(_:));
/*
 固定数值
 */
+ (instancetype)absoluteDimension:(CGFloat)value NS_SWIFT_NAME(absolute(_:));
/*
 根据剩余空间自动决定大小
 */
+ (instancetype) autoDimension NS_SWIFT_NAME(auto());

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, readonly) CGFloat value;

- (BOOL)isFractional;
- (BOOL)isAbsolute;
- (BOOL)isAuto;
@end

@interface EaseGridLayoutRow : NSObject

@property (nonatomic ,assign ,readonly) CGFloat height;
@property (nonatomic ,copy ,readonly) NSArray<EaseGridLayoutColumn *> * columns;

+ (instancetype) rowWithHeight:(CGFloat)height NS_SWIFT_NAME(row(with:));

- (void) setupColumns:(NSArray<EaseGridLayoutColumn *> *)columns NS_SWIFT_NAME(setup(_:));
- (void) setupColumn:(EaseGridLayoutColumn *)cloumn repeat:(NSInteger)repeat;

@end

@interface EaseGridLayout : EaseBaseLayout
/*
 当数据超过设定的row数量的时候，使用重复之前的row来解决布局问题
 */
@property (nonatomic ,assign) EaseGridLayoutRowRepeat rowRepeat;

- (void) addRows:(NSArray<EaseGridLayoutRow *> *)rows;
- (void) addRow:(EaseGridLayoutRow *)row repeat:(NSInteger)reapeat;

/*
 '''
 . h h h r;
 l c c c r;
 l b b b .;
 '''
 
 '''
 l t t t r;
 l c c c r;
 l b b b b;
 '''
 
 '''
 a a b c;
 a a d e;
 f f f f;
 '''
 
 '''
 a a b c;
 d e f f;
 // repeat
 a a b c;
 d e f f;
 '''
 
 使用字符串设定区域，相同并且相邻的字符串占用同样的区域，
 使用`;`进行区分row，使用`空格`区分每一个格子
 */
- (void) setupAreas:(NSString *)areas;
@end

@interface EaseGridLayoutAreas : NSObject

+ (instancetype)areasName:(NSString *)name NS_SWIFT_NAME(areas(_:));
+ (instancetype)none NS_SWIFT_NAME(none());

+ (NSArray<EaseGridLayoutAreas *> *) repeat;
@end

NS_ASSUME_NONNULL_END
