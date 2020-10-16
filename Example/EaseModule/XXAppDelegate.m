//
//  XXAppDelegate.m
//  EaseModule
//
//  Created by Yrocky on 09/22/2020.
//  Copyright (c) 2020 Yrocky. All rights reserved.
//

#import "XXAppDelegate.h"

#import "XXViewController.h"
#import "DemoVideoModule.h"
#import "DemoSearchModule.h"
#import "DemoLivingModule.h"
#import "DemoShoppingModule.h"
#import "DemoMusicModule.h"
#import "DemoMineModule.h"
#import "DemoHuabanModule.h"
#import "DemoNewsModule.h"
#import <WebKit/WKWebView.h>

@interface YYYViewController : UIViewController

@end
@implementation XXAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
//    self.window.rootViewController = YYYViewController.new;
//    return YES;
    
    XXViewController * vc = [[XXViewController alloc] initWithModule:({
        EaseCompositeModule * module = [[EaseCompositeModule alloc] initWithName:@"demo"];
        
        [module addModule:({
            [[DemoNewsModule alloc] initWithName:@"新闻详情"];
        })];
        [module addModule:({
            [[DemoShoppingModule alloc] initWithName:@"购物app"];
        })];
        [module addModule:({
            EaseCompositeModule * demoModule = [[EaseCompositeModule alloc] initWithName:@"DEMO"];
            [demoModule addModule:[[DemoFlexLayoutModule alloc] initWithName:@"Flex"]];
            [demoModule addModule:[[DemoBackgroundDecorateModule alloc] initWithName:@"Decorate"]];
            [demoModule addModule:[[DemoListLayoutModule alloc] initWithName:@"List"]];
            [demoModule addModule:[[DemoWaterfallLayoutModule alloc] initWithName:@"Waterfall"]];
            demoModule;
        })];
        [module addModule:({
            [[DemoSearchModule alloc] initWithName:@"搜索界面"];
        })];
        [module addModule:({
            [[DemoLivingModule alloc] initWithName:@"直播app"];
        })];
        [module addModule:({
            [[DemoMusicModule alloc] initWithName:@"音乐app"];
        })];
        [module addModule:({
            [[DemoVideoModule alloc] initWithName:@"视频app"];
        })];
        [module addModule:({
            [[DemoHuabanModule alloc] initWithName:@"花瓣app"];
        })];
        [module addModule:({
            [[DemoMineModule alloc] initWithName:@"个人中心"];
        })];
        module;
    })];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = vc;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

struct XXXIndexPath {
    NSInteger section;
    NSInteger row;
    
//    bool operator==(const XXXIndexPath &other) const {
//        return (section == other.section && row == other.row);
//    }
};

@implementation YYYViewController{
    WKWebView *_webView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSURL * baseURL = [NSURL URLWithString:@"file:///assets/"];
    NSString * HTMLString = @"<p class=\"ql-align-center\"><img src=\"http://p7.itc.cn/images01/20200927/797af3d4e1584debb9a3162fe30e302/e.jpeg\" max-width=\"600\"><span class=\"img-desc\" style=\"font-size: 16px;\">歼16是在歼11的基础上改进而来而不是苏30</span></p>\n<p>歼16是我国在歼11战斗机的基础上改进而来的一款重型三代半多功能战斗机。在歼16之前，歼11已经发展出了双座版歼11BS，歼11BS配备了全新的地形匹配系统和火控系统，已经具备了相当的对地攻击能力，在其基础上改进而来的歼16战斗机更是青出于蓝！歼16一大特点就是载弹量大，歼16的最大载弹量可达12吨，比早期轰6轰炸机的载弹量还多出3吨。</p>";
    
    NSMutableString * HTML = [NSMutableString new];
    [HTML appendString:@"<html>"];
    [HTML appendString:@"<head>"];
    [HTML appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">",[[NSBundle mainBundle] URLForResource:@"style" withExtension:@"css"]];
    [HTML appendString:@"</head>"];
    
    [HTML appendString:@"<body style=\"background:##FF457E\">"];
    [HTML appendString:@"<h1>This 地方圣诞节粉红色的</h1>"];
    [HTML appendString:HTMLString];
    [HTML appendString:@"</body>"];
    
    [HTML appendString:@"</html>"];
    
    _webView = [WKWebView new];
    [_webView loadHTMLString:HTML baseURL:baseURL];

    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    NSMethodSignature * funcReturnString =
    [self methodSignatureForSelector:@selector(funcReturnString)];
    
    NSMethodSignature * funcReturnVoid =
    [self methodSignatureForSelector:@selector(funcReturnVoid)];
    
    NSMethodSignature * funcOneArgumentAndReturnVoid =
    [self methodSignatureForSelector:@selector(funcOneArgumentAndReturnVoid:)];
    
    NSMethodSignature * funcOneArgumentAndReturnString =
    [self methodSignatureForSelector:@selector(funcOneArgumentAndReturnString:)];
    
    NSMethodSignature * funcTwoArgumentAndReturnString =
    [self methodSignatureForSelector:@selector(funcTwoArgumentAndReturnString:two:)];
    
}

- (NSString *) funcReturnString{
    return @"aaa";
}

- (void) funcReturnVoid{
    
}

- (void) funcOneArgumentAndReturnVoid:(NSString *)as{
    
}

- (NSString *) funcOneArgumentAndReturnString:(NSString *)as{
    return as;
}

- (NSString *) funcTwoArgumentAndReturnString:(NSString *)as two:(NSInteger)bs{
    if (bs == 1) {
        return as;
    }
    return @"unknow";
}
@end
