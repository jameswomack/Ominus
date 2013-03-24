//
//  NGMediaController.h
//  Ominus
//
//  Created by James Womack on 3/24/13.
//  Copyright (c) 2013 Noble Gesture. All rights reserved.
//

@interface NGMediaController : NSObject

#pragma mark Initializers
+ (NGMediaController *)wake;
+ (NGMediaController *)mainController;

@property (strong, nonatomic) AVPlayer *player;

@end
