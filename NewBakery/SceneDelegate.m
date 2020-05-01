//
//  SceneDelegate.m
//  NewBakery
//
//  Created by ChunYi on 2020/4/3.
//  Copyright © 2020 ES711-apple-2. All rights reserved.
//

#import "SceneDelegate.h"
#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@interface SceneDelegate ()

@end

@implementation SceneDelegate


// Objective-C
// SceneDelegate.m



    
- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
    UIOpenURLContext *openURLContext = URLContexts.allObjects.firstObject;
    if (openURLContext) {
        [[FBSDKApplicationDelegate sharedInstance] application:UIApplication.sharedApplication openURL:openURLContext.URL sourceApplication:openURLContext.options.sourceApplication annotation:openURLContext.options.annotation];
        
    } // Add any custom logic here.
    
}
    
- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    
    //创建 Window 对象
    self.window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    
    //不加這行，畫面會是黑的
    self.window.backgroundColor = [UIColor whiteColor];
    
    LoginViewController *home = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:home];
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
