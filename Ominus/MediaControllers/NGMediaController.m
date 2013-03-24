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
    NGNimbleCenterObserveName(NGReadyNamePath, ^(NSNotification *note) {
        if (note.hash.notificationType == NGNotificationTypePath)
        {            
            NSURL *url = [NSURL.alloc initFileURLWithPath:note.hash.path];
            
            AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:nil];
            
            NGNotificationHash *hash = [NGNotificationHash hashWithType:NGNotificationTypeURLAsset andObject:urlAsset];
            
            [NSNotification notificationWithName:NGReadyNameAssetURL andHash:hash shouldAutoPost:YES];
        }
    });
    
    NGNimbleCenterObserveName(NGReadyNameAssetURL, ^(NSNotification *note) {        
        AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:note.hash.urlAsset];
        
        if (self.player == nil)
        {
            self.player = [AVPlayer playerWithPlayerItem:item];
        }
        else
        {
            [self.player replaceCurrentItemWithPlayerItem:item];
        }
    });
}



#pragma mark —
#pragma mark Memory management


- (void)dealloc
{
    [NGNimbleCenter removeObserver:self];
}



@end
