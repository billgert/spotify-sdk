//
//  LoginViewController.m
//  Spotify
//
//  Created by Patrik Billgert on 2018-03-11.
//  Copyright © 2018 Patrik Billgert. All rights reserved.
//

#import "LoginViewController.h"
#import "SpotifyManager.h"
#import "SongsTableViewController.h"
#import <SafariServices/SafariServices.h>

@interface LoginViewController () <SpotifyManagerDelegate>

@property (strong, nonatomic) UIViewController *authViewController;

@end

@implementation LoginViewController

#pragma mark - Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.spotifyManager.delegate = self;
}

#pragma mark - Touches

- (IBAction)didTapLoginButton:(UIButton *)sender {
    [self startAuthenticationFlow];
}

#pragma mark - SpotifyManagerDelegate

- (void)spotifyManagerDidLogin:(SpotifyManager *)spotifyManager {
    if (self.authViewController) {
        [self.authViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        self.authViewController = nil;
    }
    [self performSegueWithIdentifier:@"showSongs" sender:nil];
}

#pragma mark - Helpers

- (void)startAuthenticationFlow {
    if ([self.spotifyManager isSessionValid]) {
        [self.spotifyManager login];
    } else {
        NSURL *authURL = [self.spotifyManager authenticationURL];
        self.authViewController = [[SFSafariViewController alloc] initWithURL:authURL];
        [self presentViewController:self.authViewController animated:YES completion:nil];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showSongs"]) {
        SongsTableViewController *songsTableViewController = [segue destinationViewController];
        songsTableViewController.spotifyManager = self.spotifyManager;
    }
}

@end
