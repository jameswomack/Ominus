//
//  AVPlayerItem+NGKit.h
//  Ominus
//
//  Created by James Womack on 3/24/13.
//  Copyright (c) 2013 Noble Gesture. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVPlayerItem (NGKit)

#pragma mark Dynamic property declarations
@property (readonly, getter = NGSeconds) NSTimeInterval seconds;

@end
