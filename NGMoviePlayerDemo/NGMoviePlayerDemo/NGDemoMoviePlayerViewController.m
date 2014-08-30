//
//  NGMoviePlayerViewController.m
//  NGMoviePlayerDemo
//
//  Created by Tretter Matthias on 13.03.12.
//  Copyright (c) 2012 NOUS Wissensmanagement GmbH. All rights reserved.
//

#import "NGDemoMoviePlayerViewController.h"
#import "MuSyncedMoviePlayer.h"

@interface NGDemoMoviePlayerViewController () {
    NSUInteger activeCount_;
}

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NGMoviePlayer *moviePlayer;
@property (nonatomic, strong) NGMoviePlayer *moviePlayer2;
@property (nonatomic, strong) PSPushPopPressView *pppView;
@property (nonatomic, strong) PSPushPopPressView *pppView2;

@end

@implementation NGDemoMoviePlayerViewController

@synthesize containerView = _containerView;
@synthesize moviePlayer = _moviePlayer;
@synthesize pppView = _pppView;

////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController
////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    NSString *thermalPath = [[NSBundle mainBundle] pathForResource:@"thermal-428806144" ofType:@"m4v"];
    self.moviePlayer = [[NGMoviePlayer alloc] initWithURL:[NSURL fileURLWithPath:thermalPath]];
    NSString *livePath = [[NSBundle mainBundle] pathForResource:@"live-428806144" ofType:@"m4v"];
    self.moviePlayer2 = [[MuSyncedMoviePlayer alloc] initWithURL:[NSURL fileURLWithPath:livePath] initialPlaybackTime:0 playerToSyncWith:self.moviePlayer];
    
    self.containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.containerView.backgroundColor = [UIColor underPageBackgroundColor];
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.pppView = [[PSPushPopPressView alloc] initWithFrame:CGRectMake(10.f, 10.f, self.containerView.bounds.size.width-20.f, self.containerView.bounds.size.height/2-20.f)];
    self.pppView.allowSingleTapSwitch = NO;
    self.pppView.pushPopPressViewDelegate = self;
    self.pppView.autoresizingMask = UIViewAutoresizingNone;
    
    self.moviePlayer.delegate = self;
    [self.moviePlayer addToSuperview:self.pppView withFrame:self.pppView.bounds];
    [self.containerView addSubview:self.pppView];
    
    
    self.pppView2 = [[PSPushPopPressView alloc] initWithFrame:CGRectMake(10.f, self.containerView.bounds.size.height/2, self.containerView.bounds.size.width-20.f, self.containerView.bounds.size.height/2-20.f)];
    self.pppView2.allowSingleTapSwitch = NO;
    self.pppView2.pushPopPressViewDelegate = self;
    self.pppView2.autoresizingMask = UIViewAutoresizingNone;
    
    self.moviePlayer2.delegate = self;
    [self.moviePlayer2 addToSuperview:self.pppView2 withFrame:self.pppView2.bounds];
    [self.containerView addSubview:self.pppView2];
    
    [self.view addSubview:self.containerView];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - NGMoviePlayer
////////////////////////////////////////////////////////////////////////

- (void)moviePlayer:(NGMoviePlayer *)moviePlayer didChangeControlStyle:(NGMoviePlayerControlStyle)controlStyle {
    if (controlStyle == NGMoviePlayerControlStyleInline) {
        [self.pppView moveToOriginalFrameAnimated:YES];
    } else {
        [self.pppView moveToFullscreenWindowAnimated:YES];
    }
}

- (void)moviePlayer:(NGMoviePlayer *)moviePlayer didChangePlaybackRate:(float)rate {
    NSLog(@"PlaybackRate chagned %f", rate);
}

- (void)moviePlayer:(NGMoviePlayer *)moviePlayer didFinishPlaybackOfURL:(NSURL *)URL {
    NSLog(@"Playbackfinished with Player: %@", moviePlayer);
}

- (void)moviePlayer:(NGMoviePlayer *)moviePlayer didChangeStatus:(AVPlayerStatus)playerStatus {
    NSLog(@"Status chaned: %ld", (long)playerStatus);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PSPushPopPressViewDelegate
///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)pushPopPressViewDidStartManipulation:(PSPushPopPressView *)pushPopPressView {
    if (activeCount_ == 0) {
        [UIView animateWithDuration:0.45f
                              delay:0.f
                            options:UIViewAnimationOptionBeginFromCurrentState 
                         animations:^{
                             // note that we can't just apply this transform to self.view, we would loose the
                             // already applied transforms (like rotation)
                             self.containerView.transform = CGAffineTransformMakeScale(0.95, 0.95);
                             pushPopPressView.alpha = 0.35f;
                         } completion:nil];
    }
    
    activeCount_++;
}

- (void)pushPopPressViewDidFinishManipulation:(PSPushPopPressView *)pushPopPressView {
    if (activeCount_ > 0) {
        activeCount_--;
        
        if (activeCount_ == 0) {
            [UIView animateWithDuration:0.45f delay:0.f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.containerView.transform = CGAffineTransformIdentity;
                pushPopPressView.alpha = 1.f;
            } completion:nil];
        }
    }
}

- (void)pushPopPressViewWillAnimateToOriginalFrame:(PSPushPopPressView *)pushPopPressView duration:(NSTimeInterval)duration {
    self.moviePlayer.view.controlStyle = NGMoviePlayerControlStyleInline;
}

- (void)pushPopPressViewDidAnimateToOriginalFrame:(PSPushPopPressView *)pushPopPressView {
    // update autoresizing mask to adapt to width only
    pushPopPressView.autoresizingMask = UIViewAutoresizingNone;
    
    if (self.moviePlayer.view.placeholderView.alpha == 0.f) {
        [self.moviePlayer.view setControlsVisible:YES animated:YES];
    }
}

- (void)pushPopPressViewWillAnimateToFullscreenWindowFrame:(PSPushPopPressView *)pushPopPressView duration:(NSTimeInterval)duration {
    self.moviePlayer.view.controlStyle = NGMoviePlayerControlStyleFullscreen;
}

- (void)pushPopPressViewDidAnimateToFullscreenWindowFrame:(PSPushPopPressView *)pushPopPressView {
    // update autoresizing mask to adapt to borders
    pushPopPressView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    if (self.moviePlayer.view.placeholderView.alpha == 0.f) {
        [self.moviePlayer.view setControlsVisible:YES animated:YES];    
    }
    
    [pushPopPressView layoutIfNeeded];
}

@end
