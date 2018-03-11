//
//  PlayerViewController.m
//  Spotify
//
//  Created by Patrik Billgert on 2018-03-11.
//  Copyright © 2018 Patrik Billgert. All rights reserved.
//

#import "PlayerViewController.h"
#import "SpotifyManager.h"

@interface PlayerViewController () <SpotifyManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *toggleButton;

@end

@implementation PlayerViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.track.name;
    
    self.spotifyManager.delegate = self;
    
    if (![self.spotifyManager isCurrentTrack:self.track]) {
        [self.spotifyManager playTrack:self.track];
    }
    
    [self updateToggleButtonTitle:[self.spotifyManager isPlaying]];
}

#pragma mark - Touches

- (IBAction)toggle:(UIButton *)sender {
    if ([self.spotifyManager isPlaying]) {
        [self.spotifyManager pause];
    } else {
        [self.spotifyManager play];
    }
}

#pragma mark - SpotifyManagerDelegate

- (void)spotifyManager:(SpotifyManager *)spotifyManager didChangePlaybackStatus:(BOOL)isPlaying {
    [self updateToggleButtonTitle:isPlaying];
}

#pragma mark - Helpers

- (void)updateToggleButtonTitle:(BOOL)isPlaying {
    NSString *title = isPlaying ? @"PAUSE" : @"PLAY";
    [self.toggleButton setTitle:title forState:UIControlStateNormal];
}

@end
