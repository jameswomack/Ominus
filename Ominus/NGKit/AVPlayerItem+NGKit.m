//
//  AVPlayerItem+NGKit.m
//  Ominus
//
//  Created by James Womack on 3/24/13.
//  Copyright (c) 2013 Noble Gesture. All rights reserved.
//

#import "AVPlayerItem+NGKit.h"

@implementation AVPlayerItem (NGKit)

@dynamic seconds;



#pragma mark —
#pragma mark Dynamic property implementations


- (NSTimeInterval)NGSeconds
{
    return NGTimeReal(self.duration);
}



@end
