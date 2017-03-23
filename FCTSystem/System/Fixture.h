//
//  MotionDevice.h
//  FCT(B282)
//
//  Created by Jack.MT on 16/8/13.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#include <CoreServices/CoreServices.h>

#ifndef MotionDevice_h
#define MotionDevice_h
void mycallback(
                ConstFSEventStreamRef streamRef,
                void *clientCallBackInfo,
                size_t numEvents,
                void *eventPaths,
                const FSEventStreamEventFlags eventFlags[],
                const FSEventStreamEventId eventIds[]);
#endif

@import JKFramework;

//#import "JKSerialDevice.h"

@interface Fixture : JKSerialDevice

-(BOOL)checkDBStart;

- (BOOL)runStartCommands;

- (BOOL)runEndCommands;

@end
