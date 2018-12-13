//
//  OpenUDID_RN.m
//  OpenUDID_RN
//
//  initiated by Yann Lechelle (cofounder @Appsfire) on 8/28/11.
//  Copyright 2011 OpenUDID_RN.org
//
//  Initiators/root branches
//      iOS code: https://github.com/ylechelle/OpenUDID_RN
//      Android code: https://github.com/vieux/OpenUDID_RN
//
//  Contributors:
//      https://github.com/ylechelle/OpenUDID_RN/contributors
//

/*
 http://en.wikipedia.org/wiki/Zlib_License
 
 This software is provided 'as-is', without any express or implied
 warranty. In no event will the authors be held liable for any damages
 arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose,
 including commercial applications, and to alter it and redistribute it
 freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not
 claim that you wrote the original software. If you use this software
 in a product, an acknowledgment in the product documentation would be
 appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must not be
 misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source
 distribution.
 */

#if __has_feature(objc_arc)
#error This file uses the classic non-ARC retain/release model; hints below...
// to selectively compile this file as non-ARC, do as follows:
// https://img.skitch.com/20120717-g3ag5h9a6ehkgpmpjiuen3qpwp.png
#endif

#import "OpenUDID_RN.h"
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import <UIKit/UIPasteboard.h>
#import <UIKit/UIKit.h>
#else
#import <AppKit/NSPasteboard.h>
#endif

#define OpenUDID_RNLog(fmt, ...)
//#define OpenUDID_RNLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
//#define OpenUDID_RNLog(fmt, ...) NSLog((@"[Line %d] " fmt), __LINE__, ##__VA_ARGS__);

static NSString * kOpenUDID_RNSessionCache = nil;
static NSString * const kOpenUDID_RNKey = @"OpenUDID_RN";
static NSString * const kOpenUDID_RNSlotKey = @"OpenUDID_RN_slot";
static NSString * const kOpenUDID_RNAppUIDKey = @"OpenUDID_RN_appUID";
static NSString * const kOpenUDID_RNTSKey = @"OpenUDID_RN_createdTS";
static NSString * const kOpenUDID_RNOOTSKey = @"OpenUDID_RN_optOutTS";
static NSString * const kOpenUDID_RNDomain = @"org.OpenUDID_RN";
static NSString * const kOpenUDID_RNSlotPBPrefix = @"org.OpenUDID_RN.slot.";
static int const kOpenUDID_RNRedundancySlots = 100;

@interface OpenUDID_RN (Private)
+ (void) _setDict:(id)dict forPasteboard:(id)pboard;
+ (NSMutableDictionary*) _getDictFromPasteboard:(id)pboard;
+ (NSString*) _generateFreshOpenUDID_RN;
@end

@implementation OpenUDID_RN

// Archive a NSDictionary inside a pasteboard of a given type
// Convenience method to support iOS & Mac OS X
//
+ (void) _setDict:(id)dict forPasteboard:(id)pboard {
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    [pboard setData:[NSKeyedArchiver archivedDataWithRootObject:dict] forPasteboardType:kOpenUDID_RNDomain];
#else
    [pboard setData:[NSKeyedArchiver archivedDataWithRootObject:dict] forType:kOpenUDID_RNDomain];
#endif
}

// Retrieve an NSDictionary from a pasteboard of a given type
// Convenience method to support iOS & Mac OS X
//
+ (NSMutableDictionary*) _getDictFromPasteboard:(id)pboard {
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    id item = [pboard dataForPasteboardType:kOpenUDID_RNDomain];
#else
	id item = [pboard dataForType:kOpenUDID_RNDomain];
#endif
    if (item) {
        @try{
            item = [NSKeyedUnarchiver unarchiveObjectWithData:item];
        } @catch(NSException* e) {
            OpenUDID_RNLog(@"Unable to unarchive item %@ on pasteboard!", [pboard name]);
            item = nil;
        }
    }
    
    // return an instance of a MutableDictionary
    return [NSMutableDictionary dictionaryWithDictionary:(item == nil || [item isKindOfClass:[NSDictionary class]]) ? item : nil];
}

// Private method to create and return a new OpenUDID_RN
// Theoretically, this function is called once ever per application when calling [OpenUDID_RN value] for the first time.
// After that, the caching/pasteboard/redundancy mechanism inside [OpenUDID_RN value] returns a persistent and cross application OpenUDID_RN
//
+ (NSString*) _generateFreshOpenUDID_RN {
    
    NSString* _OpenUDID_RN = nil;
    
    // August 2011: One day, this may no longer be allowed in iOS. When that is, just comment this line out.
    // March 25th 2012: this day has come, let's remove this "outlawed" call...
#if TARGET_OS_IPHONE
    //    if([UIDevice instancesRespondToSelector:@selector(uniqueIdentifier)]){
    //        _OpenUDID_RN = [[UIDevice currentDevice] uniqueIdentifier];
    //    }
#endif
    // Next we generate a UUID.
    // UUIDs (Universally Unique Identifiers), also known as GUIDs (Globally Unique Identifiers) or IIDs
    // (Interface Identifiers), are 128-bit values guaranteed to be unique. A UUID is made unique over
    // both space and time by combining a value unique to the computer on which it was generated—usually the
    // Ethernet hardware address—and a value representing the number of 100-nanosecond intervals since
    // October 15, 1582 at 00:00:00.
    // We then hash this UUID with md5 to get 32 bytes, and then add 4 extra random bytes
    // Collision is possible of course, but unlikely and suitable for most industry needs (e.g. aggregate tracking)
    //
    if (_OpenUDID_RN==nil) {
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef cfstring = CFUUIDCreateString(kCFAllocatorDefault, uuid);
        const char *cStr = CFStringGetCStringPtr(cfstring,CFStringGetFastestEncoding(cfstring));
        unsigned char result[16];
        CC_MD5( cStr, strlen(cStr), result );
        CFRelease(uuid);
        
        _OpenUDID_RN = [NSString stringWithFormat:
                     @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%08x",
                     result[0], result[1], result[2], result[3],
                     result[4], result[5], result[6], result[7],
                     result[8], result[9], result[10], result[11],
                     result[12], result[13], result[14], result[15],
                     (NSUInteger)(arc4random() % NSUIntegerMax)];
    }
    
    // Call to other developers in the Open Source community:
    //
    // feel free to suggest better or alternative "UDID" generation code above.
    // NOTE that the goal is NOT to find a better hash method, but rather, find a decentralized (i.e. not web-based)
    // 160 bits / 20 bytes random string generator with the fewest possible collisions.
    //
    
    return _OpenUDID_RN;
}


// Main public method that returns the OpenUDID_RN
// This method will generate and store the OpenUDID_RN if it doesn't exist, typically the first time it is called
// It will return the null udid (forty zeros) if the user has somehow opted this app out (this is subject to 3rd party implementation)
// Otherwise, it will register the current app and return the OpenUDID_RN
//
+ (NSString*) value {
    return [OpenUDID_RN valueWithError:nil];
}

+ (NSString*) valueWithError:(NSError **)error {
    
    if (kOpenUDID_RNSessionCache!=nil) {
        if (error!=nil)
            *error = [NSError errorWithDomain:kOpenUDID_RNDomain
                                         code:kOpenUDID_RNErrorNone
                                     userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"OpenUDID_RN in cache from first call",@"description", nil]];
        return kOpenUDID_RNSessionCache;
    }
    
  	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // The AppUID will uniquely identify this app within the pastebins
    //
    NSString * appUID = (NSString *) [defaults objectForKey:kOpenUDID_RNAppUIDKey];
    if(appUID == nil)
    {
        // generate a new uuid and store it in user defaults
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        appUID = (NSString *) CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
    }
    
    NSString* OpenUDID_RN = nil;
    NSString* myRedundancySlotPBid = nil;
    NSDate* optedOutDate = nil;
    BOOL optedOut = NO;
    BOOL saveLocalDictToDefaults = NO;
    BOOL isCompromised = NO;
    
    // Do we have a local copy of the OpenUDID_RN dictionary?
    // This local copy contains a copy of the OpenUDID_RN, myRedundancySlotPBid (and unused in this block, the local bundleid, and the timestamp)
    //
    id localDict = [defaults objectForKey:kOpenUDID_RNKey];
    if ([localDict isKindOfClass:[NSDictionary class]]) {
        localDict = [NSMutableDictionary dictionaryWithDictionary:localDict]; // we might need to set/overwrite the redundancy slot
        OpenUDID_RN = [localDict objectForKey:kOpenUDID_RNKey];
        myRedundancySlotPBid = [localDict objectForKey:kOpenUDID_RNSlotKey];
        optedOutDate = [localDict objectForKey:kOpenUDID_RNOOTSKey];
        optedOut = optedOutDate!=nil;
        OpenUDID_RNLog(@"localDict = %@",localDict);
    }
    
    // Here we go through a sequence of slots, each of which being a UIPasteboard created by each participating app
    // The idea behind this is to both multiple and redundant representations of OpenUDID_RNs, as well as serve as placeholder for potential opt-out
    //
    NSString* availableSlotPBid = nil;
    NSMutableDictionary* frequencyDict = [NSMutableDictionary dictionaryWithCapacity:kOpenUDID_RNRedundancySlots];
    for (int n=0; n<kOpenUDID_RNRedundancySlots; n++) {
        NSString* slotPBid = [NSString stringWithFormat:@"%@%d",kOpenUDID_RNSlotPBPrefix,n];
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
        UIPasteboard* slotPB = [UIPasteboard pasteboardWithName:slotPBid create:NO];
#else
        NSPasteboard* slotPB = [NSPasteboard pasteboardWithName:slotPBid];
#endif
        OpenUDID_RNLog(@"SlotPB name = %@",slotPBid);
        if (slotPB==nil) {
            // assign availableSlotPBid to be the first one available
            if (availableSlotPBid==nil) availableSlotPBid = slotPBid;
        } else {
            NSDictionary* dict = [OpenUDID_RN _getDictFromPasteboard:slotPB];
            NSString* oudid = [dict objectForKey:kOpenUDID_RNKey];
            OpenUDID_RNLog(@"SlotPB dict = %@",dict);
            if (oudid==nil) {
                // availableSlotPBid could inside a non null slot where no oudid can be found
                if (availableSlotPBid==nil) availableSlotPBid = slotPBid;
            } else {
                // increment the frequency of this oudid key
                int count = [[frequencyDict valueForKey:oudid] intValue];
                [frequencyDict setObject:[NSNumber numberWithInt:++count] forKey:oudid];
            }
            // if we have a match with the app unique id,
            // then let's look if the external UIPasteboard representation marks this app as OptedOut
            NSString* gid = [dict objectForKey:kOpenUDID_RNAppUIDKey];
            if (gid!=nil && [gid isEqualToString:appUID]) {
                myRedundancySlotPBid = slotPBid;
                // the local dictionary is prime on the opt-out subject, so ignore if already opted-out locally
                if (optedOut) {
                    optedOutDate = [dict objectForKey:kOpenUDID_RNOOTSKey];
                    optedOut = optedOutDate!=nil;
                }
            }
        }
    }
    
    // sort the Frequency dict with highest occurence count of the same OpenUDID_RN (redundancy, failsafe)
    // highest is last in the list
    //
    NSArray* arrayOfUDIDs = [frequencyDict keysSortedByValueUsingSelector:@selector(compare:)];
    NSString* mostReliableOpenUDID_RN = (arrayOfUDIDs!=nil && [arrayOfUDIDs count]>0)? [arrayOfUDIDs lastObject] : nil;
    OpenUDID_RNLog(@"Freq Dict = %@\nMost reliable %@",frequencyDict,mostReliableOpenUDID_RN);
    
    // if OpenUDID_RN was not retrieved from the local preferences, then let's try to get it from the frequency dictionary above
    //
    if (OpenUDID_RN==nil) {
        if (mostReliableOpenUDID_RN==nil) {
            // this is the case where this app instance is likely to be the first one to use OpenUDID_RN on this device
            // we create the OpenUDID_RN, legacy or semi-random (i.e. most certainly unique)
            //
            OpenUDID_RN = [OpenUDID_RN _generateFreshOpenUDID_RN];
        } else {
            // or we leverage the OpenUDID_RN shared by other apps that have already gone through the process
            //
            OpenUDID_RN = mostReliableOpenUDID_RN;
        }
        // then we create a local representation
        //
        if (localDict==nil) {
            localDict = [NSMutableDictionary dictionaryWithCapacity:4];
            [localDict setObject:OpenUDID_RN forKey:kOpenUDID_RNKey];
            [localDict setObject:appUID forKey:kOpenUDID_RNAppUIDKey];
            [localDict setObject:[NSDate date] forKey:kOpenUDID_RNTSKey];
            if (optedOut) [localDict setObject:optedOutDate forKey:kOpenUDID_RNTSKey];
            saveLocalDictToDefaults = YES;
        }
    }
    else {
        // Sanity/tampering check
        //
        if (mostReliableOpenUDID_RN!=nil && ![mostReliableOpenUDID_RN isEqualToString:OpenUDID_RN])
            isCompromised = YES;
    }
    
    // Here we store in the available PB slot, if applicable
    //
    OpenUDID_RNLog(@"Available Slot %@ Existing Slot %@",availableSlotPBid,myRedundancySlotPBid);
    if (availableSlotPBid!=nil && (myRedundancySlotPBid==nil || [availableSlotPBid isEqualToString:myRedundancySlotPBid])) {
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
        UIPasteboard* slotPB = [UIPasteboard pasteboardWithName:availableSlotPBid create:YES];
        [slotPB setPersistent:YES];
#else
        NSPasteboard* slotPB = [NSPasteboard pasteboardWithName:availableSlotPBid];
#endif
        
        // save slotPBid to the defaults, and remember to save later
        //
        if (localDict) {
            [localDict setObject:availableSlotPBid forKey:kOpenUDID_RNSlotKey];
            saveLocalDictToDefaults = YES;
        }
        
        // Save the local dictionary to the corresponding UIPasteboard slot
        //
        if (OpenUDID_RN && localDict)
            [OpenUDID_RN _setDict:localDict forPasteboard:slotPB];
    }
    
    // Save the dictionary locally if applicable
    //
    if (localDict && saveLocalDictToDefaults)
        [defaults setObject:localDict forKey:kOpenUDID_RNKey];
    
    // If the UIPasteboard external representation marks this app as opted-out, then to respect privacy, we return the ZERO OpenUDID_RN, a sequence of 40 zeros...
    // This is a *new* case that developers have to deal with. Unlikely, statistically low, but still.
    // To circumvent this and maintain good tracking (conversion ratios, etc.), developers are invited to calculate how many of their users have opted-out from the full set of users.
    // This ratio will let them extrapolate convertion ratios more accurately.
    //
    if (optedOut) {
        if (error!=nil) *error = [NSError errorWithDomain:kOpenUDID_RNDomain
                                                     code:kOpenUDID_RNErrorOptedOut
                                                 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Application with unique id %@ is opted-out from OpenUDID_RN as of %@",appUID,optedOutDate],@"description", nil]];
        
        kOpenUDID_RNSessionCache = [[NSString stringWithFormat:@"%040x",0] retain];
        return kOpenUDID_RNSessionCache;
    }
    
    // return the well earned OpenUDID_RN!
    //
    if (error!=nil) {
        if (isCompromised)
            *error = [NSError errorWithDomain:kOpenUDID_RNDomain
                                         code:kOpenUDID_RNErrorCompromised
                                     userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Found a discrepancy between stored OpenUDID_RN (reliable) and redundant copies; one of the apps on the device is most likely corrupting the OpenUDID_RN protocol",@"description", nil]];
        else
            *error = [NSError errorWithDomain:kOpenUDID_RNDomain
                                         code:kOpenUDID_RNErrorNone
                                     userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"OpenUDID_RN succesfully retrieved",@"description", nil]];
    }
    kOpenUDID_RNSessionCache = [OpenUDID_RN retain];
    return kOpenUDID_RNSessionCache;
}

+ (void) setOptOut:(BOOL)optOutValue {
    
    // init call
    [OpenUDID_RN value];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // load the dictionary from local cache or create one
    id dict = [defaults objectForKey:kOpenUDID_RNKey];
    if ([dict isKindOfClass:[NSDictionary class]]) {
        dict = [NSMutableDictionary dictionaryWithDictionary:dict];
    } else {
        dict = [NSMutableDictionary dictionaryWithCapacity:2];
    }
    
    // set the opt-out date or remove key, according to parameter
    if (optOutValue)
        [dict setObject:[NSDate date] forKey:kOpenUDID_RNOOTSKey];
    else
        [dict removeObjectForKey:kOpenUDID_RNOOTSKey];
    
  	// store the dictionary locally
    [defaults setObject:dict forKey:kOpenUDID_RNKey];
    
    OpenUDID_RNLog(@"Local dict after opt-out = %@",dict);
    
    // reset memory cache 
    kOpenUDID_RNSessionCache = nil;
    
}

@end
