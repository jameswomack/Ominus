//
//  NSObject+NGNimbleCenter.h
//  Ominus
//
//  Created by James Womack on 3/24/13.
//  Copyright (c) 2013 Noble Gesture. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NGNimbleCenterAdditions)

#pragma mark Skipping unused parameters and intermediary steps in initialization
- (void)observeName:(NSString *)name usingBlock:(void (^)(NSNotification *))block;

@end
