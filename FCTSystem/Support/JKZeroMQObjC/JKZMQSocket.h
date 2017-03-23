//
//  JKZMQSocket.h
//  JKZeroMQObjC
//
//  Created by Jack.MT on 2017/3/8.
//  Copyright © 2017年 Jack.MT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "zmq.h"

#import "JKZMQException.h"

@class JKZMQContext;

typedef NS_ENUM(NSInteger)
{
    JKZMQ_PAIR = ZMQ_PAIR,
    JKZMQ_PUB = ZMQ_PUB,
    JKZMQ_SUB = ZMQ_SUB,
    JKZMQ_REQ = ZMQ_REQ,
    JKZMQ_REP = ZMQ_REP,
    JKZMQ_DEALER = ZMQ_DEALER,
    JKZMQ_ROUTER = ZMQ_ROUTER,
    JKZMQ_PULL = ZMQ_PULL,
    JKZMQ_PUSH = ZMQ_PUSH,
    JKZMQ_XPUB = ZMQ_XPUB,
    JKZMQ_XSUB = ZMQ_XSUB,
    JKZMQ_STREAM = ZMQ_STREAM
}ZMQSocketType;
typedef int ZMQSocketOption;
typedef int ZMQMessageSendFlags;
typedef int ZMQMessageReceiveFlags;

@interface JKZMQSocket : NSObject {
    void *socket;
    JKZMQContext *_context;  // not retained
    NSString *endpoint;
    ZMQSocketType type;
    BOOL closed;
}
// Returns @"ZMQ_PUB" for ZMQ_PUB, for example.
+ (NSString *)nameForSocketType:(ZMQSocketType)type;

// Create a socket using -[ZMQContext socketWithType:].
@property(readonly, assign) JKZMQContext *context;
@property(readonly) ZMQSocketType type;

@property(readonly) void *socket;

- (void)close;
// KVOable.
@property(readonly, getter=isClosed) BOOL closed;
@property(readonly, copy) NSString *endpoint;

#pragma mark Socket Options
- (BOOL)setData:(NSData *)data forOption:(ZMQSocketOption)option;
- (NSData *)dataForOption:(ZMQSocketOption)option;

#pragma mark Endpoint Configuration
- (BOOL)bindToEndpoint:(NSString *)endpoint;
- (BOOL)connectToEndpoint:(NSString *)endpoint;

#pragma mark Communication
- (BOOL)sendData:(NSData *)messageData withFlags:(ZMQMessageSendFlags)flags;
- (NSData *)receiveDataWithFlags:(ZMQMessageReceiveFlags)flags;

- (BOOL)sendMessage:(NSString *)message withEncoding:(NSStringEncoding )encoding andFlags:(ZMQMessageSendFlags)flags;
- (BOOL)sendMessage:(NSString *)message withFlags:(ZMQMessageSendFlags)flags;
- (NSString *)receiveMessageWithFlags:(ZMQMessageReceiveFlags)flags;
- (NSString *)receiveMessageWithEncoding:(NSStringEncoding)encoding andFlags:(ZMQMessageReceiveFlags)flags;

- (NSString *)error;

#pragma mark Polling
- (void)getPollItem:(zmq_pollitem_t *)outItem forEvents:(short)events;
@end
