//
//  MuSyncedMoviePlayer.m
//  NGMoviePlayer
//
//  Created by teejay on 7/18/14.
//  Copyright (c) 2014 NOUS Wissensmanagement GmbH. All rights reserved.
//

#import "MuSyncedMoviePlayer.h"


@interface MuSyncedMoviePlayer ();

@property (ng_weak) NGMoviePlayer *syncedMoviePlayer;
@property NSArray *controlsToToggleHidden;
@end

@implementation MuSyncedMoviePlayer

- (id)initWithURL:(NSURL *)URL playerToSyncWith:(NGMoviePlayer *)syncedPlayer viewsToToggleDisplayOf:(NSArray *)array
{
    self = [super initWithURL:URL initialPlaybackTime:0];
    if (self) {
        _syncedMoviePlayer = syncedPlayer;
        _controlsToToggleHidden = array;
    }
    
    return self;
}

- (void)moviePlayerDidStartToPlay
{
    [self.syncedMoviePlayer play];
}

- (void)moviePlayerDidPausePlayback
{
    [self.syncedMoviePlayer pause];
}

- (void)moviePlayerDidResumePlayback
{
    [self.syncedMoviePlayer play];
}

- (void)moviePlayerDidUpdateCurrentPlaybackTime:(NSTimeInterval)currentPlaybackTime
{
    [self.syncedMoviePlayer setCurrentPlaybackTime:currentPlaybackTime];
}

- (void)moviePlayerWillShowControlsWithDuration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        [self.controlsToToggleHidden enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            [view setAlpha:1];
        }];
    }];
}

- (void)moviePlayerWillHideControlsWithDuration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        [self.controlsToToggleHidden enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            [view setAlpha:0];
        }];
    }];
}


@end
