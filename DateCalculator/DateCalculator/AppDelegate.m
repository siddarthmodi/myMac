//
//  AppDelegate.m
//  DateCalculator
//
//  Created by Main Account on 12/6/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "DateCalculator.h"
#import "DateCalculator+LoggingAdditions.h"
#import <objc/message.h>
#import "DateCalculator+SpyAdditions.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    DateCalculator * calc = [[DateCalculator alloc] init];
    calc.hisAge = 34;
    calc.hisName = @"Ray";
    
    Class myClass = [calc class];
    Class superclass = class_getSuperclass(myClass);
    NSLog(@"Superclass of %@ is %@", NSStringFromClass(myClass), NSStringFromClass(superclass));
    
    SEL selector = @selector(shouldHeDateIfHerAgeIs:);
    NSLog(@"Selector: %@", NSStringFromSelector(selector));
    
    Method method = class_getInstanceMethod([calc class], @selector(hisName));
    NSLog(@"%d arguments", method_getNumberOfArguments(method));
    
    NSLog(@"Member of NSObject: %d", [calc isMemberOfClass:[NSObject class]]);
    NSLog(@"Kind of NSObject: %d", [calc isKindOfClass:[NSObject class]]);
    
    if ([calc respondsToSelector:@selector(hisName)]) {
        NSString *hisName = [calc performSelector:@selector(hisName) withObject:nil];
        NSLog(@"His name %@", hisName);
    }
    
    //NSString *hisName = [calc hisName];
    
    NSString *hisName = objc_msgSend(calc, @selector(hisName));
    
    BOOL shouldDate = ((const BOOL (*)(id, SEL, ...))objc_msgSend)(calc, @selector(shouldHeDateIfHerAgeIs:), 24);
    
    NSLog(@"His name: %@", hisName);
    
    [calc log];
    
    Method original = class_getInstanceMethod([DateCalculator class], @selector(shouldHeDateIfHerAgeIs:));
    Method replacement = class_getInstanceMethod([DateCalculator class], @selector(spy_shouldHeDateIfHerAgeIs:));
    method_exchangeImplementations(original, replacement);
    
    shouldDate = [calc shouldHeDateIfHerAgeIs:16];
    if (shouldDate) {
        NSLog(@"%@, it's OK to date Hayden!", calc.hisName);
    } else {
        NSLog(@"%@, you shouldn't date Hayden, you old man!", calc.hisName);
    }
    
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
