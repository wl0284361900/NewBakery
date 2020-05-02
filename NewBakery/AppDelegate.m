//
//  AppDelegate.m
//  NewBakery
//
//  Created by ChunYi on 2020/4/3.
//  Copyright © 2020 ES711-apple-2. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Singleton.h"

#import <FirebaseFirestore/FirebaseFirestore.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FirebaseAuth/FirebaseAuth.h>
@import Firebase;
@interface AppDelegate (){
    NSUserDefaults *orderUserDefault;
}

@end


@implementation AppDelegate


//FB導向
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey] ]; // Add any custom logic here.
    return handled;
}
    

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FIRApp configure];

    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    // Add any custom logic here.
    
    //初始化內存和Singleton
    orderUserDefault = [NSUserDefaults standardUserDefaults];
    [Singleton sharedInstance].orderListTemp = [[NSMutableArray alloc]initWithCapacity:0];
    
    //如果有上次未完成的訂單，則將內存資料copy一份到Singleton
    if([orderUserDefault objectForKey:@"orderListTemp"] != nil){
        [Singleton sharedInstance].orderListTemp = [[NSMutableArray alloc]initWithArray:[orderUserDefault objectForKey:@"orderListTemp"]];
    }
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
