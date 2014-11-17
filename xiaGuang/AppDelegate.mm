//
//  AppDelegate.m
//  xiaGuang
//
//  Created by YunTop on 14-10-24.
//  Copyright (c) 2014年 YunTop. All rights reserved.
//

#import "AppDelegate.h"
#import "YTNavigationController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "YTDBManager.h"
#import <FCFileManager.h>



@interface AppDelegate () {
    double _timeInToBackground;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [AVOSCloud setApplicationId:@"p8eq0otfz420q56dsn8s1yp8dp82vopaikc05q5h349nd87w" clientKey:@"kzx1ajhbxkno0v564rcremcz18ub0xh2upbjabbg5lruwkqg"]; 
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = [UIColor blackColor];
    [[YTBeaconManager sharedBeaconManager] startRangingBeacons];
    self.window.rootViewController = [[YTNavigationController alloc]initWithCreateHomeViewController];
    [self.window makeKeyAndVisible];
    
    [[YTDBManager sharedManager] startBackgroundDownload];
    [[YTDBManager sharedManager] checkAndSwitchToNewDB];
    
    
    /*
    NSString *mainbundle = [FCFileManager pathForMainBundleDirectory];
    NSString *document = [FCFileManager pathForDocumentsDirectory];
    NSArray *files = [FCFileManager listFilesInDirectoryAtPath:mainbundle withExtension:@"mbtiles"];
    NSError *err = nil;
    for(NSString *file in files){
        NSLog(@"%@",file);
        NSString *mapName = [file lastPathComponent];
        NSString *destPath = [NSString stringWithFormat:@"%@/%@",document,mapName];
        [FCFileManager copyItemAtPath:file toPath:destPath error:&err];
        if(err != nil){
            NSLog(@"shit");
        }
    }
    
    NSArray *files2 = [FCFileManager listFilesInDirectoryAtPath:document withExtension:@"mbtiles"];
    for(NSString *file2 in files2){
        NSLog(@"%@",file2);
    }*/
    
    _timeInToBackground = 0;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    _timeInToBackground = [[NSDate date] timeIntervalSinceReferenceDate];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    double now = [[NSDate date] timeIntervalSinceReferenceDate];
    
    if (now - _timeInToBackground >= 600) { // 10 minutes wait
        self.window = [[UIWindow alloc]init];
        self.window.frame = [UIScreen mainScreen].bounds;
        self.window.backgroundColor = [UIColor blackColor];
        self.window.rootViewController = [[YTNavigationController alloc]initWithCreateHomeViewController];
        [self.window makeKeyAndVisible];
        [[YTDBManager sharedManager] checkAndSwitchToNewDB];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end