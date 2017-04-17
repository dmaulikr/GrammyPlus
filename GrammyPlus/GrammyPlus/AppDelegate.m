//
//  AppDelegate.m
//  GrammyPlus
//
//  Created by 李灿 on 2017/4/16.
//  Copyright © 2017年 reverse. All rights reserved.
//

#import "AppDelegate.h"
#import "NXOAuth2.h"
@interface AppDelegate ()
@property(atomic) NSString *outgoingRedirect;
@property(atomic) NSString *incomingRedirect;
@property (atomic)NSString *token;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.outgoingRedirect=@"http://djp3.westmont.edu/classes/2015-coursera-live/redirect.php/myscheme/thing.com";
    self.incomingRedirect=@"myscheme://thing.com";
    [[NXOAuth2AccountStore sharedStore] setClientID:@"433cf33f53944d82aad51d96574c438a"
                                             secret:@"90ae82d5b63249d0985a3c58599a6165"
                                   authorizationURL:[NSURL URLWithString:@"https://api.instagram.com/oauth/authorize"]
                                           tokenURL:[NSURL URLWithString:@"https://api.instagram.com/oauth/access_token"]
                                        redirectURL:[NSURL URLWithString:self.outgoingRedirect]
                                     forAccountType:@"Instagram"];
    return YES;
}
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    NSLog(@"url %@",url);
    NSString *strURL=[url absoluteString];
    NSRange range=[strURL rangeOfString:@"code="];
    self.token=[strURL substringFromIndex:range.location+range.length];
    if([self.incomingRedirect containsString:[url scheme]]&&[self.incomingRedirect containsString:[url host]]){
        NSURL *constructed=[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",self.outgoingRedirect,[url query]]];
        NSLog(@"constructed %@",constructed);
        return [[NXOAuth2AccountStore sharedStore] handleRedirectURL:constructed];
    }else{
        return [[NXOAuth2AccountStore sharedStore] handleRedirectURL:url];
    }
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

-(NSString*)getToken{
    return self.token;
}
@end
