//
//  AppDelegate.m
//  LDBusBundle
//
//  Created by 庞辉 on 11/15/14.
//  Copyright (c) 2014 庞辉. All rights reserved.
//

#import "AppDelegate.h"

#import "LDBusCenter.h"
#import "LDBusContext.h"
#import "LDLoginService.h"
#import "UITabBarControllerAdditions.h"

@interface MyTabController : UITabBarController

@end

@implementation MyTabController
//如果没有定义Selector，则默认调用init的方法去启动程序应用
-(void) viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTabURLs:@[@"LDBusDemo://menu/1", @"LDBusDemo://menu/5"]];
}


- (void)setTabURLs:(NSArray*)URLs {
    NSMutableArray* controllers = [NSMutableArray array];
    for (NSString* URL in URLs) {
        UIViewController* controller = [LDBusContext controllerForURL:URL];
        if (controller) {
            UIViewController* tabController = [self rootControllerForController:controller];
            tabController.tabBarItem.title =URL;
            [controllers addObject:tabController];
        }
    }
    self.viewControllers = controllers;
}


@end


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //bus Center初始化，预加载所有bundle的配置
    [[LDBusCenter busCenter] preloadConfig];
    
    //打开一个初始ViewController
    [LDBusContext sendURL:@"LDBusDemo://mainTab"];
    return YES;
}


- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
