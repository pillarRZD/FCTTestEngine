//
//  JKZMQContext.h
//  JKZeroMQObjC
//
//  Created by Jack.MT on 2017/3/8.
//  Copyright © 2017年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKZMQSocket.h"  // ZMQSocketType
#import "JKZMQException.h"
#import <libkern/OSAtomic.h>

/* Special polling timeout values. */
#define ZMQPollTimeoutNever (-1)
#define ZMQPollTimeoutNow   (0)

@interface JKZMQContext : NSObject {
    void *context;
    NSMutableArray *sockets;
    NSLock *socketsLock;
    BOOL terminated;
}
+ (void)getZMQVersionMajor:(int *)major minor:(int *)minor patch:(int *)patch;

/* Polling */
// Generic poll interface.
+ (int)pollWithItems:(zmq_pollitem_t *)ioItems count:(int)itemCount
    timeoutAfterUsec:(long)usec;

// Creates a ZMQContext using |threadCount| threads for I/O.
- (id)initWithIOThreads:(NSUInteger)threadCount;

- (JKZMQSocket *)socketWithType:(ZMQSocketType)type;
// Sockets associated with this context.
@property(readonly, retain) NSArray *sockets;

// Closes all associated sockets.
- (void)closeSockets;

// Initiates termination. All associated sockets will be shut down.
- (void)terminate;

// YES if termination has been initiated.
// KVOable.
@property(readonly, getter=isTerminated)
BOOL terminated;
@end
