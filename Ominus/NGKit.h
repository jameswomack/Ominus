//
//  NGKit.h
//  Ominus
//
//  Created by James Womack on 3/24/13.
//  Copyright (c) 2013 Noble Gesture. All rights reserved.
//


#import "NSNotification+NGNimbleCenter.h"
#import "NSObject+NGNimbleCenter.h"
#import "NGNotificationHash.h"
#import "AVPlayer+NGKit.h"



#pragma mark —
#pragma mark Device & OS make, model, configuration, sexual orientation

#define NGDeviceiPad [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad



#pragma mark —
#pragma mark Conventions for notifying readers of properties' nature

// Comment in the header next to dynamic properties please



#pragma mark —
#pragma mark Wrapping & casting objects, useful for `id`s in particular

#define $(object) ((NSObject *)object)
#define NGDollar $ // $-prefixed defines don't appear in method navigator
#define $$(object, class) ((class *)object)
#define NGDollar2 $$



#pragma mark —
#pragma mark Logging

#define NGLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)



#pragma mark —
#pragma mark General purpose NSString operations

#define NGString(fmt,...) [NSString stringWithFormat:fmt,__VA_ARGS__]



#pragma mark —
#pragma mark NSBundle operations

#define NGBundle NSBundle.mainBundle
#define NGBundlePath(name, extension) [NGBundle pathForResource:name ofType:extension]
#define NGBundleMP3Path(mp3Name) NGBundlePath(mp3Name, @"mp3")
#define NGBundleAIFFPath(aiffName) NGBundlePath(aiffName, @"aiff")
#define NGPathDefault [NGBundle.bundlePath stringByAppendingPathComponent:@"Untitled"]



#pragma mark —
#pragma mark NSNotificationCenter

#define NGNimbleCenter NSNotificationCenter.defaultCenter
#define NGNotificationHashKey @"hash"

#define NGNimbleCenterObserveName(name, block) [NGNimbleCenter addObserverForName:name object:nil queue:NULL usingBlock:block];

#define NGReadyNameTemplate @"NG%@Ready"
#define NGReadyNamer(nameComponent) NGString(NGReadyNameTemplate, nameComponent)
#define NGReadyNamePath NGReadyNamer(@"Path")
#define NGReadyNameAssetURL NGReadyNamer(@"AssetURL")
#define NGReadyNameSeconds NGReadyNamer(@"Seconds")


#pragma mark —
#pragma mark UITableView

#define NGEditingStyleIsDelete(editingStyle) editingStyle == UITableViewCellEditingStyleDelete
#define NGEditingStyleIsInsert(editingStyle) editingStyle == UITableViewCellEditingStyleInsert



#pragma mark —
#pragma mark NGNonsense

// TODO - Spell check defines by splitting preprocessor strings
// TODO - Generate NG(X)Key values by splitting preprocessor strings

#define NGHarlemShake() \
    unsigned long long soundID = kSystemSoundID_Vibrate; \
    UInt32 flag = 0; \
    AudioServicesSetProperty(kAudioServicesPropertyCompletePlaybackIfAppDies, sizeof(UInt32),&soundID,sizeof(UInt32), &flag); \
    AudioServicesPlaySystemSound(soundID)

#define NGChampollionKey @"ÑGÇhâmpōłłïôń"
#define NGEncyclopediaGalacticaKey @"NGEncyclopediaGalactica"
#define NGSexualMammalsKey @"NGSexualMammals"
#define NGCosmosKeys @[NGChampollionKey, NGEncyclopediaGalacticaKey, NGSexualMammalsKey] // ¡Carl Sagan FRVR!


