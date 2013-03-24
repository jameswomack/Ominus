//
//  WaveformImageVew.h
//  Ominus
//
//  Created by James Womack on 3/23/13.
//  Copyright (c) 2013 Noble Gesture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaveformImageVew : UIImageView

#pragma mark Waveform drawing
- (void)renderPNGAudioPictogram;

@property (nonatomic, strong) AVURLAsset *urlAsset;

@end
