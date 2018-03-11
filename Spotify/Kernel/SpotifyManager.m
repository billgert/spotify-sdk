//
//  SpotifyManager.m
//  Spotify
//
//  Created by Patrik Billgert on 2018-03-11.
//  Copyright © 2018 Patrik Billgert. All rights reserved.
//

#import "SpotifyManager.h"
#import <SpotifyAuthentication/SpotifyAuthentication.h>
#import <SpotifyAudioPlayback/SpotifyAudioPlayback.h>

@interface SpotifyManager () <SPTAudioStreamingDelegate>

@property (nonatomic, strong) SPTAuth *auth;
@property (nonatomic, strong) SPTAudioStreamingController *player;

@end

@implementation SpotifyManager

- (instancetype)init {
    if (self = [super init]) {
        self.auth = [SPTAuth defaultInstance];
        self.player = [SPTAudioStreamingController sharedInstance];
        
        // The client ID you got from the developer site
        self.auth.clientID = @"361f4baa4d6f4687815f06b86e08ff1e";
        
        // The redirect URL as you entered it at the developer site
        self.auth.redirectURL = [NSURL URLWithString:@"musiq-rn://auth"];
        
        // Setting the `sessionUserDefaultsKey` enables SPTAuth to automatically store the session object for future use.
        self.auth.sessionUserDefaultsKey = @"current session";
        
        // Set the scopes you need the user to authorize. `SPTAuthStreamingScope` is required for playing audio.
        self.auth.requestedScopes = @[SPTAuthStreamingScope];
        
        // Become the streaming controller delegate
        self.player.delegate = self;
        
        // Start up the streaming controller.
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

- (void)createSessionWithURL:(NSURL *)url completion:(void (^)(NSError *error, SPTSession *session))completion {
    [self.auth handleAuthCallbackWithTriggeredAuthURL:url callback:completion];
}

#pragma mark - Player

- (void)login {
    [self.player loginWithAccessToken:self.auth.session.accessToken];
}

- (void)loginWithSession:(SPTSession *)session; {
    [self.player loginWithAccessToken:session.accessToken]; 
}

- (void)playURI:(NSString *)uri {
    [self.player playSpotifyURI:uri startingWithIndex:0 startingWithPosition:0 callback:^(NSError *error) {
        if (error != nil) {
            NSLog(@"*** failed to play: %@", error);
            return;
        }
    }];
}

#pragma mark - SPTAudioStreamingDelegate

- (void)audioStreamingDidLogin:(SPTAudioStreamingController *)audioStreaming {
    if ([self.delegate respondsToSelector:@selector(spotifyManagerDidLogin:)]) {
        [self.delegate spotifyManagerDidLogin:self];
    }
}

@end
