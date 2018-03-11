//
//  SpotifyManager.h
//  Spotify
//
//  Created by Patrik Billgert on 2018-03-11.
//  Copyright © 2018 Patrik Billgert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpotifyAuthentication/SpotifyAuthentication.h>
#import <SpotifyAudioPlayback/SpotifyAudioPlayback.h>
#import <SpotifyMetadata/SpotifyMetadata.h>

@class SpotifyManager;

@protocol SpotifyManagerDelegate <NSObject>

- (void)spotifyManagerDidLogin:(SpotifyManager *)spotifyManager;

@end

@interface SpotifyManager : NSObject

@property (nonatomic, weak) id <SpotifyManagerDelegate> delegate;

// Auth
- (BOOL)isSessionValid;
- (NSURL *)authenticationURL;
- (BOOL)isValidURL:(NSURL *)url;
- (void)createSessionWithURL:(NSURL *)url callback:(void (^)(NSError *error, SPTSession *session))callback;

// Player
- (void)login;
- (void)loginWithSession:(SPTSession *)session;
- (void)playURI:(NSString *)uri;

// User
- (void)getSavedTracks:(void (^)(NSError *error, NSArray<SPTSavedTrack*> *tracks))callback;

@end
