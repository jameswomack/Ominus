//
//  AVPlayer+NGKit.h
//  Ominus
//
//  Created by James Womack on 3/24/13.
//  Copyright (c) 2013 Noble Gesture. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVPlayer (NGKit)

#pragma mark Dynamic property declarations
@property (readonly, getter = NGPlaying) BOOL playing;
@property (readonly, getter = NSStopped) BOOL stopped;
@property (readonly, getter = NGCurrentSeconds) NSTimeInterval currentSeconds;

@end
