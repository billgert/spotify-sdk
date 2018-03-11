//
//  SpotifyManager.h
//  Spotify
//
//  Created by Patrik Billgert on 2018-03-11.
//  Copyright © 2018 Patrik Billgert. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SpotifyManager, SPTSession;

@protocol SpotifyManagerDelegate <NSObject>

- (void)spotifyManagerDidLogin:(SpotifyManager *)spotifyManager;

@end

@interface SpotifyManager : NSObject

@property (nonatomic, weak) id <SpotifyManagerDelegate> delegate;

// Auth
- (BOOL)isSessionValid;
- (NSURL *)authenticationURL;
- (BOOL)isValidURL:(NSURL *)url;
- (void)createSessionWithURL:(NSURL *)url completion:(void (^)(NSError *error, SPTSession *session))completion;

// Player
- (void)login;
- (void)loginWithSession:(SPTSession *)session;
- (void)playURI:(NSString *)uri;
    
@end
