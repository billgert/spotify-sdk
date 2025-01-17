//
//  PlayerViewController.h
//  Spotify
//
//  Created by Patrik Billgert on 2018-03-11.
//  Copyright © 2018 Patrik Billgert. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SpotifyManager, SPTTrack;

@interface PlayerViewController : UIViewController

@property (strong, nonatomic) SpotifyManager *spotifyManager;
@property (strong, nonatomic) SPTTrack *track;

@end
