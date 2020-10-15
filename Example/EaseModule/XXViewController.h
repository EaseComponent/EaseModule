//
//  XXViewController.h
//  EaseModule
//
//  Created by Yrocky on 09/22/2020.
//  Copyright (c) 2020 Yrocky. All rights reserved.
//


#import "DemoCompositeListViewController.h"

@interface XXViewController : DemoCompositeListViewController

@end

@interface DemoModule : EaseSingleModule
- (void) setupComponents:(NSDictionary *)data;
@end

@interface DemoFlexLayoutModule : DemoModule

@end

@interface DemoListLayoutModule : DemoModule

@end

@interface DemoWaterfallLayoutModule : DemoModule

@end

@interface DemoBackgroundDecorateModule : DemoModule

@end

