//
//  NGMP3Bucket.m
//  Ominus
//
//  Created by James Womack on 3/23/13.
//  Copyright (c) 2013 Noble Gesture. All rights reserved.
//

#import "NGMP3Bucket.h"

@implementation NGMP3Bucket

+ (NSSet *)paths
{
    __block NSSet *paths;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *mp3Path = NGBundleAIFFPath(@"Searchin");
        paths = [NSSet setWithObject:mp3Path];
    });
    return paths;
}

@end
