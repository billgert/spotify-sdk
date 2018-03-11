//
//  SongsTableViewController.h
//  Spotify
//
//  Created by Patrik Billgert on 2018-03-11.
//  Copyright © 2018 Patrik Billgert. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SpotifyManager;

@interface SongsTableViewController : UITableViewController

@property (nonatomic, strong) SpotifyManager *spotifyManager;

@end