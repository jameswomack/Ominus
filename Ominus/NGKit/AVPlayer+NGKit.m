//
//  AVPlayer+NGKit.m
//  Ominus
//
//  Created by James Womack on 3/24/13.
//  Copyright (c) 2013 Noble Gesture. All rights reserved.
//

#import "AVPlayer+NGKit.h"

@implementation AVPlayer (NGKit)

@dynamic playing;



#pragma mark —
#pragma mark Dynamic property implementations


- (BOOL)playing
{
    return self.rate != 0.0;
}


- (BOOL)stopped
{
    return !self.playing;
}



@end
