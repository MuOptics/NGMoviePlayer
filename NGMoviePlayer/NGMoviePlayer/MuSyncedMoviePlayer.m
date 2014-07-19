//
//  MuSyncedMoviePlayer.m
//  NGMoviePlayer
//
//  Created by teejay on 7/18/14.
//  Copyright (c) 2014 NOUS Wissensmanagement GmbH. All rights reserved.
//

#import "MuSyncedMoviePlayer.h"


@interface MuSyncedMoviePlayer ();

@property (weak) NGMoviePlayer *syncedMoviePlayer;

@end

@implementation MuSyncedMoviePlayer

- (id)initWithURL:(NSURL *)URL initialPlaybackTime:(NSTimeInterval)initialPlaybackTime playerToSyncWith:(NGMoviePlayer *)syncedPlayer
{
    self = [super initWithURL:URL initialPlaybackTime:initialPlaybackTime];
    if (self) {
        _syncedMoviePlayer = syncedPlayer;
    }
    
    return self;
}

- (void)moviePlayerDidStartToPlay {
    // do nothing here
    [self.syncedMoviePlayer play];
}

- (void)moviePlayerDidPausePlayback {
    // do nothing here
    [self.syncedMoviePlayer pause];
}

- (void)moviePlayerDidResumePlayback {
    // do nothing here
    [self.syncedMoviePlayer play];
}

- (void)moviePlayerDidUpdateCurrentPlaybackTime:(NSTimeInterval)currentPlaybackTime {
    // do nothing here
    if (self.isScrubbing) {
        [self.syncedMoviePlayer setCurrentPlaybackTime:currentPlaybackTime];
    }
}


@end
