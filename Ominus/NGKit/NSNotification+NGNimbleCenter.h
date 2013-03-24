//
//  NSNotification+NGNimbleCenter.h
//  Ominus
//
//  Created by James Womack on 3/24/13.
//  Copyright (c) 2013 Noble Gesture. All rights reserved.
//

@class NGNotificationHash;

@interface NSNotification (NGNimbleCenterAdditions)

#pragma mark Skipping unused parameters and intermediary steps in initialization
+ (NSNotification *)notificationWithName:(NSString *)name andHash:(NGNotificationHash *)hash;

#pragma mark Auto-self-posting notifications
+ (NSNotification *)notificationWithName:(NSString *)name andHash:(NGNotificationHash *)hash shouldAutoPost:(BOOL)shouldAutoPost;

#pragma mark Dynamic property declarations
@property (readonly, getter = NGHashObject) NGNotificationHash *hashObject;  // Prefer `hash` in a vaccuum but then there's NSObject::hash

@end
