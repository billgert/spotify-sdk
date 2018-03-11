//
//  SongsTableViewController.m
//  Spotify
//
//  Created by Patrik Billgert on 2018-03-11.
//  Copyright © 2018 Patrik Billgert. All rights reserved.
//

#import "SongsTableViewController.h"
#import "PlayerViewController.h"
#import "SpotifyManager.h"

@interface SongsTableViewController ()

@property (nonatomic, strong) NSArray<SPTSavedTrack*> *tracks;

@end

@implementation SongsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tracks = [NSArray new];
    
    [self.spotifyManager getSavedTracks:^(NSError *error, NSArray<SPTSavedTrack *> *tracks) {
        if (tracks) {
            self.tracks = tracks;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tracks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SongCell" forIndexPath:indexPath];
    SPTSavedTrack *track = self.tracks[indexPath.row];
    cell.textLabel.text = track.name;
    cell.detailTextLabel.text = [[track.artists valueForKey:@"name"] componentsJoinedByString:@", "];;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SPTSavedTrack *track = self.tracks[indexPath.row];
    [self performSegueWithIdentifier:@"showPlayer" sender:track];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showPlayer"]) {
        PlayerViewController *playerViewController = [segue destinationViewController];
        playerViewController.spotifyManager = self.spotifyManager;
        playerViewController.track = (SPTSavedTrack *)sender;
    }
}

@end
