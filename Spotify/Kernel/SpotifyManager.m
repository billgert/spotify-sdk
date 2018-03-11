//
//  SpotifyManager.m
//  Spotify
//
//  Created by Patrik Billgert on 2018-03-11.
//  Copyright © 2018 Patrik Billgert. All rights reserved.
//

#import "SpotifyManager.h"

@interface SpotifyManager () <SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate>

@property (strong, nonatomic) SPTAuth *auth;
@property (strong, nonatomic) SPTAudioStreamingController *player;
@property (strong, nonatomic) NSString *currentTrackURI;

@end

@implementation SpotifyManager

- (instancetype)init {
    if (self = [super init]) {
        self.auth = [SPTAuth defaultInstance];
        self.auth.clientID = @"{CLIENT_ID}";
        self.auth.redirectURL = [NSURL URLWithString:@"{REDIRECT_URL}"];
        self.auth.sessionUserDefaultsKey = @"current session";
        self.auth.requestedScopes = @[SPTAuthStreamingScope, SPTAuthUserLibraryReadScope];
        
        self.player = [SPTAudioStreamingController sharedInstance];
        self.player.delegate = self;
        self.player.playbackDelegate = self;

        NSError *audioStreamingInitError;
        NSAssert([self.player startWithClientId:self.auth.clientID error:&audioStreamingInitError],
                 @"There was a problem starting the Spotify SDK: %@", audioStreamingInitError.description);
    }
    return self;
}

#pragma mark - Auth

- (BOOL)isSessionValid {
    return [self.auth.session isValid];
}

- (NSURL *)authenticationURL {
    return [self.auth spotifyWebAuthenticationURL];
}

- (BOOL)isValidURL:(NSURL *)url {
    return [self.auth canHandleURL:url];
}

- (void)createSessionWithURL:(NSURL *)url callback:(void (^)(NSError *error, SPTSession *session))callback {
    [self.auth handleAuthCallbackWithTriggeredAuthURL:url callback:callback];
}

#pragma mark - Player

- (void)login {
    [self.player loginWithAccessToken:self.auth.session.accessToken];
}

- (void)loginWithSession:(SPTSession *)session; {
    [self.player loginWithAccessToken:session.accessToken]; 
}

- (void)playTrack:(SPTTrack *)track {
    [self.player playSpotifyURI:track.uri.absoluteString startingWithIndex:0 startingWithPosition:0 callback:^(NSError *error) {
        if (error != nil) {
            NSLog(@"*** failed to play: %@", error);
            return;
        }
    }];
}

- (void)play {
    [self.player setIsPlaying:YES callback:nil];
}

- (void)pause {
    [self.player setIsPlaying:NO callback:nil];
}

- (BOOL)isPlaying {
    return self.player.playbackState.isPlaying;
}

- (BOOL)isCurrentTrack:(SPTTrack *)track {
    return [self.currentTrackURI isEqualToString:track.uri.absoluteString];
}

#pragma mark - User

- (void)getSavedTracks:(void (^)(NSError *error, NSArray<SPTSavedTrack*> *tracks))callback {
    [SPTYourMusic savedTracksForUserWithAccessToken:self.auth.session.accessToken callback:^(NSError *error, SPTListPage *object) {
        callback(error, object.items);
    }];
}

#pragma mark - SPTAudioStreamingDelegate

- (void)audioStreamingDidLogin:(SPTAudioStreamingController *)audioStreaming {
    if ([self.delegate respondsToSelector:@selector(spotifyManagerDidLogin:)]) {
        [self.delegate spotifyManagerDidLogin:self];
    }
}

#pragma mark - SPTAudioStreamingPlaybackDelegate

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangePlaybackStatus:(BOOL)isPlaying {
    if ([self.delegate respondsToSelector:@selector(spotifyManager:didChangePlaybackStatus:)]) {
        [self.delegate spotifyManager:self didChangePlaybackStatus:isPlaying];
    }
}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didStartPlayingTrack:(NSString *)trackUri {
    self.currentTrackURI = trackUri;
}

@end
