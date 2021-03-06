//
//  NGMediaController.m
//  Ominus
//
//  Created by James Womack on 3/24/13.
//  Copyright (c) 2013 Noble Gesture. All rights reserved.
//

#import "NGMediaController.h"



@implementation NGMediaController



#pragma mark —
#pragma mark Initializers


+ (NGMediaController *)wake
{
    return self.mainController;
}


+ (NGMediaController *)mainController
{
    static NGMediaController *mainController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainController = NGMediaController.new;
    });
    return mainController;
}


- (NGMediaController *)init
{
    if ((self = super.init))
    {
        [self establishObservation];
    }
    return self;
}



#pragma mark —
#pragma mark Modular initialization


- (void)establishObservation
{
    [self observeName:NGReadyNamePath usingBlock:^(NSNotification *note) {
        NSURL *url = [NSURL.alloc initFileURLWithPath:note.hashObject.path];
        
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:nil];
        
        NGNotificationHash *hash = [NGNotificationHash hashWithType:NGNotificationTypeURLAsset andObject:urlAsset];
        
        [NSNotification notificationWithName:NGReadyNameAssetURL andHash:hash shouldAutoPost:YES];
    }];
    
    [self observeName:NGReadyNameAssetURL usingBlock:^(NSNotification *note) {
        AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:note.hashObject.urlAsset];
        
        if (self.player == nil)
        {
            self.player = [AVPlayer playerWithPlayerItem:item];
        }
        else
        {
            [self.player replaceCurrentItemWithPlayerItem:item];
        }
    }];
    
    [self observeName:NGReadyNameSeconds usingBlock:^(NSNotification *note) {
        NSTimeInterval secondsRequested = note.hashObject.seconds;
        
        [self.player seekToTime:CMTimeMakeWithSeconds(secondsRequested, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            if (finished)
            {
                self.player.playing ? [self.player pause] : [self.player play];
            }
        }];        
    }];
}



#pragma mark —
#pragma mark Memory management


- (void)dealloc
{
    [NGNimbleCenter removeObserver:self];
}



@end
