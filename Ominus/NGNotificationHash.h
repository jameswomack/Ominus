//
//  NGNotificationHash.h
//  Ominus
//
//  Created by James Womack on 3/24/13.
//  Copyright (c) 2013 Noble Gesture. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, NGNotificationType)
{
    NGNotificationTypePath = 7,
    NGNotificationTypeURLAsset,
    NGNotificationTypeSeconds,
    NGNotificationTypeSize,
    NGNotificationTypeCount = 3
};

NS_CLASS_AVAILABLE(10_7, 5_0)
@interface NGNotificationHash : NSObject

#pragma mark Core properties
@property (strong, nonatomic) id object;
@property NGNotificationType notificationType;
@property (strong, nonatomic) NSDictionary *metadata;

#pragma mark Preparing for transmission
@property (readonly) NSDictionary *wrapped;

#pragma mark NGNotificationType-dependent exception-raising dynamic properties
@property (readonly) AVURLAsset *urlAsset;
@property (readonly) NSString *path;
@property (readonly) NSTimeInterval seconds;

#pragma mark NGNotificationType-based initialization
+ (NGNotificationHash *)hashWithType:(NGNotificationType)type andObject:(id)object;
- (NGNotificationHash *)initWithHashWithType:(NGNotificationType)type andObject:(id)object;

@end
