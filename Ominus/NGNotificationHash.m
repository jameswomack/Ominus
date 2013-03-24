//
//  NGNotificationHash.m
//  Ominus
//
//  Created by James Womack on 3/24/13.
//  Copyright (c) 2013 Noble Gesture. All rights reserved.
//

#import <Foundation/NSMapTable.h>

#import "NGNotificationHash.h"

#define NGNotificationIDCastFailureTemplate @"Cast to %@ failed"
#define NGNotificationIDCastFailureMessenger(class) NGString(NGNotificationIDCastFailureTemplate, NSStringFromClass(class))

#define NGNotificationNoteTypeFailureTemplate @"Tried to cast when NGNotificationType was not %@"
#define NGNotificationNoteTypeFailureMessenger(type) NGString(NGNotificationNoteTypeFailureTemplate, NGStringFromNoteType(type))

#define NGNotificationNoteTypeClassFailureTemplate @"Class %@ doesn't match note type of %@"
#define NGNotificationNoteTypeClassFailureMessenger(class, type) NGString(NGNotificationNoteTypeClassFailureTemplate, NSStringFromClass(class), NGStringFromNoteType(type))

#define NGStringFromNoteType(EXP) NGString(@"%s", #EXP)



@interface NGNotificationHash ()

void *NSMapGet(NSMapTable *table, const void *key);
void NSMapInsert(NSMapTable *table, const void *key, const void *value);

+ (NSMapTable *)noteTypeTable;

- (void)assertNoteType:(NGNotificationType)type andClass:(Class)class;
- (void)classAssert:(Class)class;
- (void)noteTypeAssert:(NGNotificationType)type;

@end



@implementation NGNotificationHash

@dynamic wrapped, urlAsset, seconds;



#pragma mark —
#pragma mark NGNotificationType-based initialization


+ (NGNotificationHash *)hashWithType:(NGNotificationType)type andObject:(id)object
{
    return [NGNotificationHash.alloc initWithHashWithType:type andObject:object];
}


- (NGNotificationHash *)initWithHashWithType:(NGNotificationType)type andObject:(id)object
{
    if ((self = super.init))
    {
        self.notificationType = type;
        self.object = object;
        
        
    }
    return self;
}



#pragma mark —
#pragma mark NGNotificationAssertions


+ (NSMapTable *)noteTypeTable
{
    static NSMapTable *noteTypeTable;
    static NSPointerArray *noteTypeArray;
    static dispatch_once_t noteTypeTableOnceToken;
    
    dispatch_once(&noteTypeTableOnceToken, ^{
        noteTypeArray = [NSPointerArray.alloc initWithOptions:NSPointerFunctionsObjectPersonality];
        [noteTypeArray setCount:NGNotificationTypeSize];
        
        noteTypeTable = [NSMapTable.alloc initWithKeyOptions:NSPointerFunctionsIntegerPersonality valueOptions:NSPointerFunctionsObjectPersonality capacity:NGNotificationTypeCount];
        
        NSMapInsert(noteTypeTable, (void *)NGNotificationTypeURLAsset, AVURLAsset.class);
        NSMapInsert(noteTypeTable, (void *)NGNotificationTypePath, NSString.class);
        NSMapInsert(noteTypeTable, (void *)NGNotificationTypeSeconds, NSNumber.class);
    });
    
    return noteTypeTable;
}


- (void)assertNoteTypeToClassRelationship
{
    Class validClass = (Class)NSMapGet(NGNotificationHash.noteTypeTable, (void *)self.notificationType);
    
    NSAssert(($(self.object).class == validClass), NGNotificationNoteTypeClassFailureMessenger($(self.object).class, self.notificationType));
}


- (void)assertNoteType:(NGNotificationType)type andClass:(Class)class
{
    [self noteTypeAssert:type];
    [self classAssert:class];
}


- (void)classAssert:(Class)class
{
    NSAssert([self.object isKindOfClass:class], NGNotificationIDCastFailureMessenger(class));
}


- (void)noteTypeAssert:(NGNotificationType)type
{
    NSAssert((self.notificationType == type), NGNotificationNoteTypeFailureMessenger(type));
}


#pragma mark Preparing for transmission
- (NSDictionary *)wrapped
{
    return @{NGNotificationHashKey: self};
}


#pragma mark —
#pragma mark NGNotificationType-dependent exception-raising dynamic properties


- (AVURLAsset *)urlAsset
{
    [self assertNoteType:NGNotificationTypeURLAsset andClass:AVURLAsset.class];
    
    return (AVURLAsset *)self.object;
}


- (NSString *)path
{
    [self assertNoteType:NGNotificationTypePath andClass:NSString.class];
    
    return (NSString *)self.object;
}


- (CGFloat)seconds
{
    [self assertNoteType:NGNotificationTypeSeconds andClass:NSNumber.class];
    
    return ((NSNumber *)self.object).floatValue;
}


@end
