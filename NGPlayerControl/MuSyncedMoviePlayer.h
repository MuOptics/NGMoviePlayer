//
//  MuSyncedMoviePlayer.h
//  NGMoviePlayer
//
//  Created by teejay on 7/18/14.
//  Copyright (c) 2014 NOUS Wissensmanagement GmbH. All rights reserved.
//

#import "NGMoviePlayer.h"

@interface MuSyncedMoviePlayer : NGMoviePlayer

- (id)initWithURL:(NSURL *)URL playerToSyncWith:(NGMoviePlayer *)syncedPlayer viewsToToggleDisplayOf:(NSArray *)array;

@end
