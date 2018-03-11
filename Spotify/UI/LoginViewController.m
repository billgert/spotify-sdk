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

@property (nonatomic, strong) UIViewController *authViewController;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.spotifyManager.delegate = self;
}

- (IBAction)didTapLoginButton:(UIButton *)sender {
    [self startAuthenticationFlow];
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

#pragma mark - SpotifyManagerDelegate

- (void)spotifyManagerDidLogin:(SpotifyManager *)spotifyManager {
    if (self.authViewController) {
        [self.authViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        self.authViewController = nil;
    }
    [self performSegueWithIdentifier:@"showSongs" sender:spotifyManager];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showSongs"]) {
        SongsTableViewController *songsTableViewController = [segue destinationViewController];
        songsTableViewController.spotifyManager = (SpotifyManager *)sender;
    }
}

@end
