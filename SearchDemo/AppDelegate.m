//
//  AppDelegate.m
//  SearchDemo
//
//  Created by Mr.Hong on 2018/4/20.
//  Copyright © 2018年 Mr.Hong. All rights reserved.
//

#import "AppDelegate.h"
#import "Product.h"
#import "MainTableViewController.h"

// 还有一种情形需要使用 @synthesize ，就是当在 protocol 中声明并实现属性时。协议中声明的属性不会自动生成setter和getter，[UIApplicationDelegate window] 就是个典型的例子

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSArray *products = @[[Product productWithName:@"iPhone" year:@2007 price:@599.00],
                          [Product productWithName:@"iPod" year:@2001 price:@399.00],
                          [Product productWithName:@"iPod touch" year:@2007 price:@210.00],
                          [Product productWithName:@"iPad" year:@2010 price:@499.00],
                          [Product productWithName:@"iPad mini" year:@2012 price:@659.00],
                          [Product productWithName:@"iMac" year:@1997 price:@1299.00],
                          [Product productWithName:@"Mac Pro" year:@2006 price:@2499.00],
                          [Product productWithName:@"MacBook Air" year:@2008 price:@1799.00],
                          [Product productWithName:@"MacBook Pro" year:@2006 price:@1499.00],
                          [Product productWithName:@"MacBook Air -- " year:@2008 price:@1799.00],
                          [Product productWithName:@"MacBook Pro -- " year:@2006 price:@1499.00]];
    
    // storyborad启动, 直接获取根控制器(storyborad中是以导航栏为根控制器)
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    // 获取导航栏链接的控制器
    MainTableViewController *main = (MainTableViewController *)navigationController.viewControllers[0];
    main.products = products;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
