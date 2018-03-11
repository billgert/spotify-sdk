//
//  AppDelegate.m
//  Spotify
//
//  Created by Patrik Billgert on 2018-03-11.
//  Copyright © 2018 Patrik Billgert. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "SpotifyManager.h"

@interface AppDelegate ()

@property (nonatomic, strong) LoginViewController *loginViewController;
@property (nonatomic, strong) SpotifyManager *spotifyManager;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.spotifyManager = [SpotifyManager new];
    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    self.loginViewController = (LoginViewController *)navigationController.topViewController;
    self.loginViewController.spotifyManager = self.spotifyManager;
    
    return YES;
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    if ([self.spotifyManager isValidURL:url]) {
        [self.spotifyManager createSessionWithURL:url callback:^(NSError *error, SPTSession *session) {
            if (session) {
                [self.spotifyManager loginWithSession:session];
            }
        }];
        return YES;
    }
    return NO;
}

@end
