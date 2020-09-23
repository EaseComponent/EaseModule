//
//  NSString+Common.m
//  QILievModule
//
//  Created by rocky on 2020/8/10.
//  Copyright © 2020 Rocky. All rights reserved.
//

#import "NSString+Common.h"

@implementation NSString (Common)
- (CGSize)YYY_sizeWithFont:(UIFont*)font maxSize:(CGSize)maxSize{
    if(self && [self isKindOfClass:[NSString class]] && self.length){
        CGSize size = [self boundingRectWithSize: maxSize
                                         options: NSStringDrawingUsesLineFragmentOrigin
                                      attributes: @{ NSFontAttributeName: font }
                                         context: nil].size;
        return size;
    }
    return CGSizeMake(0, 0);
}

@end
