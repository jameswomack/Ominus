//
//  WaveformImageVew.m
//  Ominus
//
//  Created by James Womack on 3/23/13.
//  Copyright (c) 2013 Noble Gesture. All rights reserved.
//

#import <CoreMedia/CoreMedia.h>

#import "WaveformImageView.h"

#define absX(x) (x<0?0-x:x)
#define minMaxX(x,mn,mx) (x<=mn?mn:(x>=mx?mx:x))
#define noiseFloor (-50.0)
#define decibel(amplitude) (20.0  *log10(absX(amplitude)/32767.0))
#define imgExt @"png"
#define imageToData(x) UIImagePNGRepresentation(x)


@interface WaveformImageView ()

- (void)establishInstanceLevelSharedInitializationTimeState;
- (void)establishObservation;
- (void)establishGestures;

@end




@implementation WaveformImageView



#pragma mark —
#pragma mark Modular initialization


- (void)establishInstanceLevelSharedInitializationTimeState
{
    [self establishGestures];
    
    [self establishObservation];
}

- (void)establishObservation
{    
    [self observeName:NGReadyNameAssetURL usingBlock:^(NSNotification *note) {
        self.urlAsset = note.hashObject.urlAsset;
        [self renderPNGAudioPictogram];
    }];
}


- (void)establishGestures
{
    self.userInteractionEnabled = self.multipleTouchEnabled = YES;
    
    UITapGestureRecognizer *doubleTap = [UITapGestureRecognizer.alloc initWithTarget:self action:@selector(play:)];
    
    NSArray *gestureRecognizers = @[doubleTap];
    
    self.gestureRecognizers = gestureRecognizers;
}



#pragma mark —
#pragma mark Initializers


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder]))
    {
        [self establishInstanceLevelSharedInitializationTimeState];
    }
    return self;
}



#pragma mark —
#pragma mark Gesture actions


- (void)play:(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded && (self.urlAsset))
    {        
        CGFloat positionX = [gesture locationInView:self].x;
        
        CGFloat width = self.frame.size.width;
        
        CGFloat positionXScaled = positionX / width;
        
        CGFloat position = NGTimeReal(self.urlAsset.duration) * positionXScaled;
        
        NGNotificationHash *hash = [NGNotificationHash hashWithType:NGNotificationTypeSeconds andObject:@(position)];
        
        [NSNotification notificationWithName:NGReadyNameSeconds andHash:hash shouldAutoPost:YES];
    }
}



#pragma mark —
#pragma mark Waveform drawing


- (UIImage *)audioImageLogGraph:(Float32 *)samples
                   normalizeMax:(Float32)normalizeMax
                    sampleCount:(NSInteger)sampleCount
                   channelCount:(NSInteger)channelCount
                    imageHeight:(float)imageHeight
{    
    CGSize imageSize = CGSizeMake(sampleCount, imageHeight);
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetAlpha(context,1.0);
    CGRect rect;
    rect.size = imageSize;
    rect.origin.x = 0;
    rect.origin.y = 0;
    
    CGColorRef leftcolor = [[UIColor whiteColor] CGColor];
    CGColorRef rightcolor = [[UIColor redColor] CGColor];
    
    CGContextFillRect(context, rect);
    
    CGContextSetLineWidth(context, 1.0);
    
    float halfGraphHeight = (imageHeight / 2) / (float) channelCount ;
    float centerLeft = halfGraphHeight;
    float centerRight = (halfGraphHeight*3) ;
    float sampleAdjustmentFactor = (imageHeight/ (float) channelCount) / (normalizeMax - noiseFloor) / 2;
    
    for (NSInteger intSample = 0; intSample < sampleCount; intSample ++)
    {
        Float32 left = *samples++;
        float pixels = (left - noiseFloor)  *sampleAdjustmentFactor;
        CGContextMoveToPoint(context, intSample, centerLeft-pixels);
        CGContextAddLineToPoint(context, intSample, centerLeft+pixels);
        CGContextSetStrokeColorWithColor(context, leftcolor);
        CGContextStrokePath(context);
        
        if (channelCount == 2)
        {
            Float32 right = *samples++;
            float pixels = (right - noiseFloor)  *sampleAdjustmentFactor;
            CGContextMoveToPoint(context, intSample, centerRight - pixels);
            CGContextAddLineToPoint(context, intSample, centerRight + pixels);
            CGContextSetStrokeColorWithColor(context, rightcolor);
            CGContextStrokePath(context);
        }
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    NGLog(@"%@",NSStringFromCGSize(newImage.size));
    
    return newImage;
}



- (void)renderPNGAudioPictogram
{    
    NSError  *error = nil;
    
    AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:self.urlAsset error:&error];
    
    AVAssetTrack *songTrack = [self.urlAsset.tracks objectAtIndex:0];
    
    NSDictionary *outputSettingsDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                                        //     [NSNumber numberWithInt:44100.0],AVSampleRateKey, /*Not Supported*/
                                        //     [NSNumber numberWithInt: 2],AVNumberOfChannelsKey,    /*Not Supported*/
                                        
                                        [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                        [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                        [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                        [NSNumber numberWithBool:NO],AVLinearPCMIsNonInterleaved,
                                        
                                        nil];
    
    
    AVAssetReaderTrackOutput *output = [[AVAssetReaderTrackOutput alloc] initWithTrack:songTrack outputSettings:outputSettingsDict];
    
    [reader addOutput:output];
    
    UInt32 sampleRate,channelCount;
    
    NSArray *formatDesc = songTrack.formatDescriptions;
    for(unsigned int i = 0; i < formatDesc.count; ++i)
    {
        CMAudioFormatDescriptionRef item = (__bridge CMAudioFormatDescriptionRef)[formatDesc objectAtIndex:i];
        const AudioStreamBasicDescription *fmtDesc = CMAudioFormatDescriptionGetStreamBasicDescription (item);
        if(fmtDesc)
        {
            sampleRate = fmtDesc->mSampleRate;
            channelCount = fmtDesc->mChannelsPerFrame;
        }
    }
    
    UInt32 bytesPerSample = 2  *channelCount;
    Float32 normalizeMax = noiseFloor;
    NSMutableData  *fullSongData = [[NSMutableData alloc] init];
    [reader startReading];
    
    UInt64 totalBytes = 0;
    
    Float64 totalLeft = 0;
    Float64 totalRight = 0;
    Float32 sampleTally = 0;
    
    NSInteger samplesPerPixel = sampleRate / 50;
    
    while (reader.status == AVAssetReaderStatusReading)
    {
        AVAssetReaderTrackOutput  *trackOutput = (AVAssetReaderTrackOutput *)[reader.outputs objectAtIndex:0];
        CMSampleBufferRef sampleBufferRef = [trackOutput copyNextSampleBuffer];
        
        if (sampleBufferRef)
        {
            CMBlockBufferRef blockBufferRef = CMSampleBufferGetDataBuffer(sampleBufferRef);
            
            size_t length = CMBlockBufferGetDataLength(blockBufferRef);
            totalBytes += length;
            
            
            NSMutableData  *data = [NSMutableData dataWithLength:length];
            CMBlockBufferCopyDataBytes(blockBufferRef, 0, length, data.mutableBytes);
            
            
            SInt16  *samples = (SInt16 *) data.mutableBytes;
            int sampleCount = length / bytesPerSample;
            for (int i = 0; i < sampleCount ; i ++) {
                
                Float32 left = (Float32) *samples++;
                left = decibel(left);
                left = minMaxX(left,noiseFloor,0);
                
                totalLeft  += left;
                
                
                
                Float32 right;
                if (channelCount == 2)
                {
                    right = (Float32) *samples++;
                    right = decibel(right);
                    right = minMaxX(right,noiseFloor,0);
                    
                    totalRight += right;
                }
                
                sampleTally++;
                
                if (sampleTally > samplesPerPixel)
                {
                    left  = totalLeft / sampleTally;
                    if (left > normalizeMax)
                    {
                        normalizeMax = left;
                    }
                    
                    [fullSongData appendBytes:&left length:sizeof(left)];
                    
                    if (channelCount==2) {
                        right = totalRight / sampleTally;
                        
                        
                        if (right > normalizeMax) {
                            normalizeMax = right;
                        }
                        
                        [fullSongData appendBytes:&right length:sizeof(right)];
                    }
                    
                    totalLeft   = 0;
                    totalRight  = 0;
                    sampleTally = 0;
                    
                }
            }
            
            CMSampleBufferInvalidate(sampleBufferRef);
            
            CFRelease(sampleBufferRef);
        }
    }
        
    if (reader.status == AVAssetReaderStatusFailed || reader.status == AVAssetReaderStatusUnknown)
    {
        assert(0);
        return;
    }
    else if (reader.status == AVAssetReaderStatusCompleted)
    {                
        UIImage *test = [self audioImageLogGraph:(Float32 *)fullSongData.bytes
                                    normalizeMax:normalizeMax
                                     sampleCount:fullSongData.length/(sizeof(Float32)*2)
                                    channelCount:2
                                     imageHeight:self.frame.size.height];
        
        if (test)
        {
            self.image = test;
        }
    }
}

@end