//
//  Protocol.h
//  FCTSystem
//
//  Created by Jack.MT on 2017/3/18.
//  Copyright © 2017年 Jack.MT. All rights reserved.
//

#ifndef Protocol_h
#define Protocol_h


#endif /* Protocol_h */

typedef NS_ENUM(NSInteger)
{
    REPORTER_LEVEL    = 0,
    CRITICAL_LEVEL    = 1,
    INFO_LEVEL        = 2,
    DEBUG_LEVEL       = 3
}PublisherLevel;

//
#define kZMQEncoding        NSUTF8StringEncoding

#define kZMQ_JSONRPC            @"jsonrpc"
#define kZMQ_ID                 @"id"
#define kZMQ_Event              @"event"
#define kZMQ_Data               @"data"
#define kZMQ_Event_Data         @"event_data"
#define kZMQ_Error              @"error"
#define kZMQ_Result             @"result"
#define kZMQ_Function           @"function"
#define kZMQ_Params             @"params"
#define kZMQ_Method             @"method"
#define kZMQ_Args               @"args"
#define kZMQ_KWArgs             @"kwargs"

#define kFuncStatus             @"status"


@protocol MessageHandlerProtocol <NSObject>

- (id)handleMessage:(id)message;

@end
