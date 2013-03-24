//
//  NSNotification+NGNimbleCenter.m
//  Ominus
//
//  Created by James Womack on 3/24/13.
//  Copyright (c) 2013 Noble Gesture. All rights reserved.
//

#import "NSNotification+NGNimbleCenter.h"


@implementation NSNotification (NGNimbleCenterAdditions)

@dynamic hashObject;



#pragma mark -
#pragma mark Skipping unused parameters and intermediary steps in initialization


+ (NSNotification *)notificationWithName:(NSString *)name andHash:(NGNotificationHash *)hash
{
    return [self notificationWithName:name andHash:hash shouldAutoPost:YES];
}


#pragma mark -
#pragma mark Auto-self-posting notifications
+ (NSNotification *)notificationWithName:(NSString *)name andHash:(NGNotificationHash *)hash shouldAutoPost:(BOOL)shouldAutoPost
{
    NSNotification *note = [self notificationWithName:name object:nil userInfo:hash.wrapped];
    
    if (shouldAutoPost)
    {
        [NGNimbleCenter postNotification:note];
    }
    
    return note;
}



#pragma mark -
#pragma mark Dynamic property implementations


- (NGNotificationHash *)NGHashObject
{
    return self.userInfo[NGNotificationHashKey];
}



@end
