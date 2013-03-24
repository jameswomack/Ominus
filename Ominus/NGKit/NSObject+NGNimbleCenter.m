//
//  NSObject+NGNimbleCenter.m
//  Ominus
//
//  Created by James Womack on 3/24/13.
//  Copyright (c) 2013 Noble Gesture. All rights reserved.
//

#import "NSObject+NGNimbleCenter.h"


@implementation NSObject (NGNimbleCenterAdditions)



#pragma —
#pragma mark Skipping unused parameters and intermediary steps in initialization


- (void)observeName:(NSString *)name usingBlock:(void (^)(NSNotification *))block
{
    [NGNimbleCenter addObserverForName:name object:nil queue:NULL usingBlock:block];
}



@end
