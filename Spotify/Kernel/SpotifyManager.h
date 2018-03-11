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

@optional
- (void)spotifyManagerDidLogin:(SpotifyManager *)spotifyManager;
- (void)spotifyManager:(SpotifyManager *)spotifyManager didChangePlaybackStatus:(BOOL)isPlaying;

@end

@interface SpotifyManager : NSObject

@property (weak, nonatomic) id <SpotifyManagerDelegate> delegate;

// Auth
- (BOOL)isSessionValid;
- (NSURL *)authenticationURL;
- (BOOL)isValidURL:(NSURL *)url;
- (void)createSessionWithURL:(NSURL *)url callback:(void (^)(NSError *error, SPTSession *session))callback;

// Player
- (void)login;
- (void)loginWithSession:(SPTSession *)session;
- (void)playTrack:(SPTTrack *)track;
- (void)play;
- (void)pause;
- (BOOL)isPlaying;
- (BOOL)isCurrentTrack:(SPTTrack *)track;

// User
- (void)getSavedTracks:(void (^)(NSError *error, NSArray<SPTSavedTrack*> *tracks))callback;

@end
